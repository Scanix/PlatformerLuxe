package ch.nectoria.entities;

import ch.nectoria.states.GameState;
import ch.nectoria.ui.MessageBox;
import ch.nectoria.interfaces.ICollidable;

import luxe.Sprite;
import luxe.Vector;
import luxe.importers.tiled.TiledObjectGroup.TiledObject;
import luxe.collision.shapes.Polygon;
import luxe.components.sprite.SpriteAnimation;
import phoenix.Texture.FilterType;

/**
 * ...
 * @author Alexandre Bianchi, Scanix
 */

/**
 * The types of Move a NPC perform.
 */
@:enum abstract NPCMoveTypes(Int) from Int to Int
{
    var Idle = value(0);
    var Walking = value(1);
    var Running = value(2);

    static inline function value(index:Int) return 1 << index; 
} 

class NPC extends Physics
{
	public var text:String;

	private var anim:SpriteAnimation;
	private var isFrozen:Bool = false;
	private var speechBubble:Sprite;

	public function new (object:TiledObject)
	{
		super(new Vector(object.pos.x + 16, object.pos.y - 32));

		//Animations & Graphics
		texture = Luxe.resources.texture("assets/graphics/entity/npc1.png");
		texture.filter_min = texture.filter_mag = FilterType.nearest;
		size = new Vector(16, 32);
		depth = 3.0;
		hitBox = Polygon.rectangle(pos.x, pos.y, 15, 24);
		hitBoxPhys = Polygon.rectangle(pos.x, pos.y, 8, 24);

		var anim_object = Luxe.resources.json('assets/anim.json');
		anim = this.add(new SpriteAnimation({ name: 'SpriteAnimation' }));
		anim.add_from_json_object(anim_object.asset.json);
		anim.animation = 'idle';
		anim.play();

		text = object.properties["text"];

		speed = .3;

		//speechBubble
		var image = Luxe.resources.texture('assets/graphics/entity/speechBubble.png');
		image.filter_min = image.filter_mag = FilterType.nearest;

		_add_child(speechBubble = new Sprite({
			name: 'speechBubble',
			texture: image,
			pos: new Vector(this.pos.x, this.pos.y),
			size: new Vector(16, 16),
			depth: 5,
			visible: false
		}));
	}

	override public function on_player_collision(is_player:Bool):Void
	{
		if (Luxe.input.inputpressed('interact'))
		{
			showDialog();
		}
	}

	public function showDialog():Void {
		var game:GameState = cast(Main.machine.current_state, GameState);
		var e:MessageBox = cast(game.messageBox, MessageBox);
		e.onComplete(function() {
			isFrozen = false;
		});

		if (!e.isShown) {
			e.show(text);
			isFrozen = true;
		}
	}

	override function update(dt:Float)
	{
		if(!isFrozen)
		{
			if (!hasCollideRight) {
				moveRight();
			} else if (!hasCollideLeft) {
				moveLeft();
			}
		}

		if (vx != 0)
		{
			if (anim.animation != 'walk')
			{
				anim.animation = 'walk';
			}
		}
		else if (vy > 1)
		{
			//spPlayer.play("fall");
		}
		else if (vy < -1)
		{
			anim.animation = 'jump';
		}
		else if(isFrozen)
		{
			if (anim.animation != 'talk')
			{
				anim.animation = 'talk';
			}
		}

		speechBubble.pos.x = this.pos.x;
		speechBubble.pos.y = this.pos.y - 16;

		if (interactWithPlayer && !isFrozen) {
			speechBubble.visible = true;
		} else {
			speechBubble.visible = false;
		}

		super.update(dt);
	}

	public function moveLeft():Void
	{
		vx -= speed;

		if (collideRight)
		{
			collideRight = false;
		}

		this.flipx = true;
	}
	public function moveRight():Void
	{
		vx += speed;

		if (collideLeft)
		{
			collideLeft = false;
		}

		this.flipx = false;
	}
}