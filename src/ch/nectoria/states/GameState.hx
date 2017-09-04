package ch.nectoria.states;

import luxe.States;
import luxe.Scene;
import luxe.Sprite;
import ch.nectoria.NP;
import ch.nectoria.entities.*;
import luxe.importers.tiled.TiledMap;
import luxe.importers.tiled.TiledMapData;
import luxe.importers.tiled.TiledObjectGroup.TiledObject;
import phoenix.Texture.FilterType;
import ch.nectoria.components.LazyCameraFollow;
import luxe.collision.shapes.*;
import luxe.collision.data.ShapeCollision;
import luxe.Vector;
import luxe.utils.Maths;
import luxe.components.sprite.SpriteAnimation;
import luxe.Quaternion;

class GameState extends State
{

	private var gameScene:Scene;
	private var player:Player;
	private var tilemap:TiledMap;
	private var tilemapFront:TiledMap;
	private var map_scale: Int = 1;
	private var spawn_pos:Vector;

	var anim : SpriteAnimation;

	public function new(_name:String)
	{

		super({ name:_name });
		gameScene = new Scene('game');

	}//new

	private function getLevelData(id:String):String
	{
		var level:String = "assets/maps/" + id + "/level.tmx";
		if (level != null)
		{
			return level;
		}
		else {
			return 'can\'t load level';
		}
	}//getLevelData

	override function onenter<T>(_value:T)
	{
		Luxe.camera.zoom = 5;

		Luxe.events.listen('simulation.triggers.collide', ontrigger);

		loadLevel();
		levelColision();
	}//onenter

	function levelColision()
	{

		var bounds = tilemap.layer('collide').bounds_fitted();
		for (bound in bounds)
		{
			bound.x *= tilemap.tile_width;
			bound.y *= tilemap.tile_height;
			bound.w *= tilemap.tile_width;
			bound.h *= tilemap.tile_height;
			NP.level_shape_list.push(Polygon.rectangle(bound.x, bound.y, bound.w, bound.h, false));
		}

	} //create_map_collision

	private function loadLevel():Void
	{
		for (a in NP.actor_list) a.destroy();
		NP.actor_list = [];
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

		player.add(new LazyCameraFollow());

		//Create seconde part of the map
		tilemapFront.remove_layer("background");
		tilemapFront.remove_layer("collide");
		tilemapFront.remove_layer("between");
		tilemapFront.remove_layer("objects");
		tilemapFront.display({ scale:map_scale, filter:FilterType.nearest });

		Main.fade.up();
	}//loadLevel

	var teleport_disabled: Bool = false;

	function ontrigger(collisions:Array<ShapeCollision>)
	{

	} //ontrigger

	override function update(dt:Float)
	{
		//NP.drawDebug();
	} //update

}
