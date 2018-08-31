package ch.nectoria.ui;

import luxe.Entity;
import luxe.Sprite;
import luxe.Text;
import luxe.Vector;
import luxe.Color;
import luxe.components.sprite.SpriteAnimation;
import phoenix.Batcher;
import phoenix.Camera;
import phoenix.Texture.FilterType;

/**
 * ...
 * @author Alexandre Bianchi
 */
class MessageBox extends Entity
{
	private var batcher:Batcher;
	private var boxSprite:Sprite;
	private var boxAnim:SpriteAnimation;
	private var textSprite:Text;
	private var typewriter:String = "";
	private var message:String;
	private var lines:Array<String>;
	private var characterIndex:UInt = 0;
	private var positionText:Int = 0;
	private var numberLine:UInt = 1;
	private var page:UInt = 0;
	public var isShown:Bool = false;
	private var paused:Bool = false;
	private var textTick:UInt = 0;
	private var _onComplete:Dynamic;
	private var _onCompleteParams:Array <Dynamic>;
	private static inline var TEXT_SPEED:UInt = 1;

	public function new ()
	{
		super();
		batcher = new Batcher(Luxe.renderer, 'messageBox_batcher');
		batcher.view = new Camera();
		batcher.layer = 12;

		boxAnim = new SpriteAnimation({name: "anim"});
		var anim_data = Luxe.resources.json('assets/graphics/ui/messagebox.json');

		boxSprite = new Sprite({
			batcher: batcher,
			size: new Vector(Luxe.screen.width, Luxe.screen.width * (48/256)),
			texture: Luxe.resources.texture('assets/graphics/ui/messagebox.png'),
			centered: false,
			visible: false,
			parent: this
		});

		boxSprite.texture.filter_min = boxSprite.texture.filter_mag = FilterType.nearest;

		boxSprite.add(boxAnim);

		boxAnim.add_from_json_object(anim_data.asset.json);
		boxAnim.animation = 'callToAction';
		boxAnim.play();

		textSprite = new Text({
			text : "No Text",
			point_size : 24,
			pos : new Vector(25, 25),
			sdf : true,
			color : new Color(0, 0, 0, 1).rgb(0x000000),
			batcher: batcher,
			visible: false,
			parent: this
		});

		Luxe.renderer.add_batch(batcher);
	}

	public function show(text:String):Void
	{
		isShown = true;

		message = text;
		lines = message.split('*');
		textSprite.visible = true;
		boxSprite.visible = true;

		NP.frozenPlayer = true;
	}

	override public function update(dt:Float)
	{
		super.update(dt);

		if (isShown) {
			Luxe.next(function() {
				typewriterEffect();
			});

			if (Luxe.input.inputpressed('interact'))
			{
				this.resume();
			}
		}
	}

	private function typewriterEffect():Void {

		textSprite.text = typewriter;
		var char:String = message.charAt(positionText);

		if (textTick == 0 && !paused && positionText < message.length)
		{
			textTick = TEXT_SPEED;

			if (char == '*')
			{
				// New line.
				if (numberLine == 4)
				{
					// There is more dialog. Show the indicator and wait.
					paused = true;
				}
				else
				{
					typewriter = typewriter.substring(0, positionText);
					typewriter += '\n';
					numberLine++;
					positionText++;
				}
			}
			else
			{
				if (positionText < message.length)
				{
					typewriter += message.charAt(positionText);
					positionText++;
				}
			}
		}
		else if (positionText >= message.length)
		{
			paused = true;
		}
		else
		{
			textTick--;
		}
	}

	public function resume():Void
	{
		if (paused)
		{
			if (positionText >= message.length)
			{
				this.close();
			}
			else
			{
				typewriter = "";
				positionText++;
				numberLine = 0;
				page++;
				paused = false;
				textTick = 0;
			}
		}
		else
		{
			//Skip typewriter effect
			var size = 0;
			typewriter = "";

			for (i in 0...lines.length)
			{
				if (lines[i] != null)
				{
					if (i <= 3+4*page)
					{
						size += lines[i].length + 1;

						if (i >= 0+4*page)
						{
							typewriter += lines[i];
							typewriter += '\n';
						}
					}
				}
			}

			positionText = --size;
			numberLine = 0;
			paused = true;
			textTick = 0;
		}
	}

	/**
     * Defines a function which will be called when the dialog finishes   
     * @param   handler     The function you would like to be called   
     * @param   parameters      Parameters you would like to pass to the handler function when it is called   
     */
    public function onComplete(handler:Dynamic, parameters:Array <Dynamic> = null):Void
	{
		_onComplete = handler;

        if (parameters == null) {

            _onCompleteParams = [];

        } else {

            _onCompleteParams = parameters;

        }
    }

	public function close():Void
	{
		Luxe.next(function() {
			isShown = false;
		});

		textSprite.text = "";
		typewriter = "";
		characterIndex = 0;
		positionText = 0;
		page = 0;
		numberLine = 1;
		textSprite.visible = false;
		boxSprite.visible = false;
		paused = false;

		if(_onComplete != null)
		{
			Reflect.callMethod(_onComplete, _onComplete, _onCompleteParams);
		}

		NP.frozenPlayer = false;
	}
}