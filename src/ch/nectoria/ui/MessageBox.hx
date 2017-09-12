package ch.nectoria.ui;
import luxe.Entity;
import luxe.Sprite;
import luxe.Text;
import luxe.Vector;
import luxe.components.sprite.SpriteAnimation;
import phoenix.Batcher;
import phoenix.Camera;
import phoenix.Texture.FilterType;
import luxe.Color;

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
	private var characterIndex:UInt = 0;
	private var positionText:Int = 0;
	private var numberLine:UInt = 1;
	public var isShown:Bool = false;
	private var paused:Bool = false;
	
	private var textTick:UInt = 0;
	private static inline var TEXT_SPEED:UInt = 1;

	public function new() 
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
			visible: false
		});
		
		boxSprite.texture.filter_min = boxSprite.texture.filter_mag = FilterType.nearest;
		
		boxSprite.add(boxAnim);
		
		boxAnim.add_from_json_object( anim_data.asset.json );
		boxAnim.animation = 'callToAction';
		boxAnim.play();
		
		textSprite = new Text({
			text : "No Text",
			point_size : 24,
			pos : new Vector(25, 25),
			sdf : true,
			color : new Color(0, 0, 0, 1).rgb(0x000000),
			batcher: batcher,
			visible: false
		});
		
		Luxe.renderer.add_batch(batcher);
	}
	
	public function show(text:String):Void
	{
		isShown = true;
		
		message = text;
		textSprite.visible = true;
		boxSprite.visible = true;
		
		NP.frozenPlayer = true;
	}
	
	override public function update(dt:Float) 
	{
		super.update(dt);
		
		if (isShown) {
			Luxe.next(function() {typewriterEffect(); });
			if (Luxe.input.inputpressed('jump'))
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
				trace(char);
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
				paused = false;
				textTick = 0;
			}
		}
	}
	
	public function close():Void
	{
		Luxe.next(function() {isShown = false; });
		
		textSprite.text = "";
		typewriter = "";
		characterIndex = 0;
		positionText = 0;
		numberLine = 1;
		textSprite.visible = false;
		boxSprite.visible = false;
		paused = false;
		
		NP.frozenPlayer = false;
	}
	
}