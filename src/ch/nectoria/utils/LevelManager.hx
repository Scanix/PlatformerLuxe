package ch.nectoria.utils;
import ch.nectoria.entities.Player;

/**
 * ...
 * @author ...
 */
class LevelManager 
{
	
	// Level Info
	private var currentLvl:String;
	private var mapWidth:Int;
	private var mapHeight:Int;
	private var savedPlayer:Player;
	// Switch Level
	private var nextLevel:String;

	public function new() 
	{
		
	}
	
	private function loadLevel():Void
	{
		for (a in NP.actor_list) {
			if (a.name != "player") 
			{ 
				a.destroy();
			} else {
				savedPlayer = NP.player;
			}
		}
		
		NP.actor_list = [];
		NP.actor_list.push(savedPlayer);
		NP.level_shape_list = [];

		var level:String = getLevelData(NP.currentLvl);
		trace("Loading level: " + level);

		tilemap = new TiledMap({
			format: 'tmx',
			tiled_file_data: Luxe.resources.text(level).asset.text
		});

		tilemapFront = new TiledMap({
			format: 'tmx',
			tiled_file_data: Luxe.resources.text(level).asset.text
		});

		//Luxe.camera.bounds = tilemap.bounds;
		tilemap.display({ scale:map_scale, filter:FilterType.nearest });

		// Load for objects
		for (_group in tilemap.tiledmap_data.object_groups)
		{
			for (_object in _group.objects)
			{
				switch (_object.gid)
				{
					case 254:
					//add(new Coin(object.x, object.y));
					case 107:
					gameScene.add(new Door(_object));
					case 35:
					//add(new Chest(object));
					case 39:
					//add(new Sign(object));
					case 240:
					//entityList.addEntity(object);
					default:
						trace("unknow type: " + _object.type);
				}
			}
		}

		spawn_pos = new Vector(120, 100);

		//And create the visual
		player = new Player(spawn_pos.clone());
		NP.player = player;

		//Create seconde part of the map
		tilemapFront.remove_layer("background");
		tilemapFront.remove_layer("collide");
		tilemapFront.remove_layer("between");
		tilemapFront.remove_layer("objects");
		tilemapFront.display({ scale:map_scale, filter:FilterType.nearest, depth:3 });

		Main.fade.up();
	}//loadLevel
	
	public function switchLevel(xTo:Int, yTo:Int, levelTo:String):Void {
		if (currentLvl == levelTo) {
			player.x = xTo;
			player.y = yTo;
		} else {
			currentLvl = levelTo;
			NP.player.pos.x = xTo;
			NP.player.pos.y = yTo;
			NP.frozenPlayer = true;
		}
	}
}