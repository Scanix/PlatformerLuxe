package ch.nectoria.entities;

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

/**
 * ...
 * @author Alexandre Bianchi
 */
class Door extends Sprite
{
	public var tileset:Tileset;
	public var hitBox:Shape;
	
	public function new(object:TiledObject)
	{
		super({pos: new Vector(object.pos.x + 16, object.pos.y - 32)});
		hitBox = Polygon.rectangle(pos.x,pos.y,16,32);
		
		texture = Luxe.resources.texture('assets/graphics/object/door_0.png');
		texture.filter_min = texture.filter_mag = FilterType.nearest;
		texture.width = 32;
		
		size = new Vector(16, 32);
		centered = false;
		
		origin = new Vector(16, 0);
	}
	
	override function update(dt:Float)
	{
		/*if (Collision.shapeWithShapes(this.hitBox, NP.actor_list).length > 0){
			trace("yo!");
		}*/
		rotation = rotation.multiply(new luxe.Quaternion().setFromEuler(new luxe.Vector(0, 5, 0).radians()));

		super.update(dt);
	} //update

}