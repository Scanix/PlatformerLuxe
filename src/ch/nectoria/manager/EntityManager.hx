package ch.nectoria.manager;

import ch.nectoria.entities.NPC;

import luxe.Sprite;
import luxe.Scene;
import luxe.importers.tiled.TiledObjectGroup.TiledObject;

/**
 * ...
 * @author Alexandre Bianchi, Scanix
 */
class EntityManager
{
	private var entityList:Array<Sprite> = [];

	public function new ()
	{

	}

	public static function addEntity(scene:Scene, obj:TiledObject):Void {
		trace(obj.name);

		switch (obj.name) {
			case 'mrMoustache':
				scene.add(new NPC(obj));

			case 'Shadow':

			//Luxe.scene.add(new Enemy(obj));
			default :
				trace("unknow type: " + obj.type);
		}

	}
}