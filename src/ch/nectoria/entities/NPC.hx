package ch.nectoria.entities;

import ch.nectoria.states.GameState;
import ch.nectoria.ui.MessageBox;

import luxe.Vector;
import luxe.importers.tiled.TiledObjectGroup.TiledObject;
import luxe.collision.shapes.Polygon;
import luxe.components.sprite.SpriteAnimation;
import phoenix.Texture.FilterType;

/**
 * ...
 * @author Alexandre Bianchi, Scanix
 */
class NPC extends Physics
{
	public var text:String;

	private var anim:SpriteAnimation;

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
	}

	override public function on_player_collision(is_player:Bool):Void
	{
		if (is_player)
		{
			if (Luxe.input.inputpressed('jump'))
			{
				var game:GameState = cast(Main.machine.current_state, GameState);
				var e:MessageBox = cast(game.messageBox, MessageBox);

				if (!e.isShown) {
					e.show(text);
				}
			}
		}
	}

	public function showDialog():Void {
		var game:GameState = cast(Main.machine.current_state, GameState);
		var e:MessageBox = cast(game.messageBox, MessageBox);

		if (!e.isShown) {
			e.show(text);
		}
	}

	override function update(dt:Float)
	{
		if (!NP.frozenPlayer) {
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
		else
		{
			anim.animation = 'talk';
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