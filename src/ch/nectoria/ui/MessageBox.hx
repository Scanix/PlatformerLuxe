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
	public var isShown:Bool = false;

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
		
		textSprite.text = text;
		textSprite.visible = true;
		boxSprite.visible = true;
		
		NP.frozenPlayer = true;
	}
	
	override public function update(dt:Float) 
	{
		super.update(dt);
		
		if (isShown) {
			trace("salut");
			if (Luxe.input.inputreleased('jump'))
			{
				this.close();
			}
		} else {
			trace("pas là");
		}
	}
	
	public function close():Void
	{
		isShown = false;
		
		textSprite.text = "";
		textSprite.visible = false;
		boxSprite.visible = false;
		
		NP.frozenPlayer = false;
	}
	
}