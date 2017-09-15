package ch.nectoria.entities;

import luxe.importers.tiled.TiledObjectGroup.TiledObject;

/**
 * ...
 * @author Alexandre Bianchi, Scanix
 */
class EntityManager
{
	private var entityList:Array<Dynamic> = [];

	public function new() 
	{
		
	}
	
	public static function addEntity(obj:TiledObject){
		trace(obj.name);
        switch (obj.name) {
            case 'mrMoustache':
                Luxe.scene.add(new NPC(obj));
            case 'Shadow':
                //Luxe.scene.add(new Enemy(obj));
            default :
                trace("unknow type: " + obj.type);
        }

    }
}