package ch.nectoria.entities;

import luxe.Vector;
import luxe.importers.tiled.TiledObjectGroup.TiledObject;
import luxe.options.SpriteOptions;
import luxe.Sprite;
import luxe.tilemaps.Tilemap.Tileset;
import phoenix.Texture.FilterType;
import phoenix.Texture.ClampType;
import phoenix.Shader;

/**
 * ...
 * @author Alexandre Bianchi
 */
class Door extends Sprite
{
	public var tileset:Tileset;
	public function new(object:TiledObject)
	{
		super({pos: new Vector(object.pos.x, object.pos.y)});
		
		tileset = new Tileset({texture:Luxe.resources.texture('assets/graphics/tilemap.png'), tile_height:32, tile_width:32, name:"general"});
		texture = Luxe.resources.texture('assets/graphics/tilemap.png');
		texture.filter_min = texture.filter_mag = FilterType.nearest;
		texture.width = 32;
	}

}