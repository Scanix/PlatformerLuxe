package ch.nectoria.entities;

import ch.nectoria.interfaces.ICollidable;
import ch.nectoria.ui.MessageBox;
import luxe.collision.shapes.Shape;
import luxe.importers.tiled.TiledObjectGroup.TiledObject;
import luxe.options.SpriteOptions;
import luxe.Sprite;
import luxe.collision.shapes.Polygon;
import phoenix.Texture.FilterType;
import luxe.Vector;
import ch.nectoria.states.GameState;

/**
 * ...
 * @author Alexandre Bianchi
 */
class Sign extends Sprite implements ICollidable 
{
	public var hitBox:Shape;
	public var text:String;

	public function new(object:TiledObject) 
	{
		super({pos: new Vector(object.pos.x, object.pos.y-16)});
		
		hitBox = Polygon.rectangle(pos.x, pos.y, 16, 16, false);
		texture = Luxe.resources.texture('assets/graphics/object/sign.png');
		texture.filter_min = texture.filter_mag = FilterType.nearest;
		texture.width = 16;
		depth = 2.0;
		
		size = new Vector(16, 16);
		centered = false;
		
		text = object.properties["text"];
		
		NP.entity_shape_list.push(this);
	}
	
	public function on_player_collision(is_player:Bool):Void 
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
	
}