package ch.nectoria.entities;

import ch.nectoria.interfaces.ICollidable;
import ch.nectoria.states.GameState;
import luxe.Vector;
import luxe.importers.tiled.TiledObjectGroup.TiledObject;
import luxe.options.SpriteOptions;
import luxe.Sprite;
import luxe.tilemaps.Tilemap.Tileset;
import phoenix.Texture.FilterType;
import phoenix.Texture.ClampType;
import phoenix.Shader;
import luxe.collision.Collision;
import luxe.collision.shapes.Shape;
import luxe.collision.shapes.Polygon;
import luxe.tween.Actuate;

/**
 * ...
 * @author Alexandre Bianchi
 */
class Door extends Sprite implements ICollidable
{
	public var tileset:Tileset;
	public var hitBox:Shape;
	public var levelTo(default,null):String;
	public var xTo(default,null):Int;
	public var yTo(default,null):Int;

	public function new(object:TiledObject)
	{
		super({pos: new Vector(object.pos.x + 16, object.pos.y - 32)});
		hitBox = Polygon.rectangle(pos.x - 16, pos.y, 16, 32, false);

		levelTo = object.properties["level"];
		xTo = Std.parseInt(object.properties["xTo"])*16 + 8;
		yTo = Std.parseInt(object.properties["yTo"]) * 16;

		depth = 2.0;

		texture = Luxe.resources.texture('assets/graphics/object/door_0.png');
		texture.filter_min = texture.filter_mag = FilterType.nearest;
		texture.width = 32;

		size = new Vector(16, 32);
		centered = false;

		origin = new Vector(16, 0);
		
		NP.entity_shape_list.push(this);
	}

	override function update(dt:Float)
	{
		super.update(dt);
	} //update

	public function on_player_collision(is_player:Bool):Void
	{
		if (is_player)
		{
			if (Luxe.input.inputdown('jump'))
			{
				NP.frozenPlayer = true;
				Actuate.tween(this.rotation, .5, {y: (Math.PI / 3)}).onComplete(switchLevel);
				//rotation = rotation.multiply(new luxe.Quaternion().setFromEuler(new luxe.Vector(0, -2, 0).radians()));
			}
		}
	}
	
	public function switchLevel():Void {
		var game:GameState = cast(Main.machine.current_state, GameState);
		game.switchLevel(xTo, yTo, levelTo);
	}

	public function handleInput():Void
	{

	}
}