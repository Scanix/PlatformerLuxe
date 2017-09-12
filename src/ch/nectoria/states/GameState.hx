package ch.nectoria.states;

import ch.nectoria.ui.MessageBox;
import luxe.Entity;
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
	
	private var currentLvl:String;
	
	public var messageBox:Entity;

	var anim : SpriteAnimation;

	public function new(_name:String)
	{

		super({ name:_name });
		gameScene = new Scene('game');

	}//new

	private function getLevelData(id:String):String
	{
		trace(id);
		var level:String = "assets/maps/" + id + "/level.tmx";
		if (id != null)
		{
			trace("mince");
			return level;
		}
		else {
			return "assets/maps/corcelles/level.tmx";
		}
	}//getLevelData

	override function onenter<T>(_value:T)
	{
		Luxe.camera.zoom = 5;

		Luxe.events.listen('simulation.triggers.collide', ontrigger);
		
		messageBox = new MessageBox();

		loadLevel(currentLvl);
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

	private function loadLevel(id:String):Void
	{
		for (a in NP.actor_list) a.destroy();
		for (a in NP.entity_shape_list) cast(a, Sprite).destroy();
		NP.actor_list = [];
		NP.entity_shape_list = [];
		NP.level_shape_list = [];

		var level:String = getLevelData(id);
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
					gameScene.add(new Sign(_object));
					case 240:
					//entityList.addEntity(object);
					default:
						trace("unknow type: " + _object.type);
				}
			}
		}

		//And create the visual
		player = new Player(NP.posPlayer.clone());
		NP.player = player;
		
		if (tilemap.total_width > Luxe.screen.h) {
			player.add(new LazyCameraFollow("lazyCamera", "static", "follow", new Vector(tilemap.total_width, tilemap.total_height)));
		} else {
			player.add(new LazyCameraFollow("lazyCamera", "static", "static", new Vector(tilemap.total_width, tilemap.total_height)));
		}

		//Create seconde part of the map
		tilemapFront.remove_layer("background");
		tilemapFront.remove_layer("collide");
		tilemapFront.remove_layer("between");
		tilemapFront.remove_layer("objects");
		tilemapFront.display({ scale:map_scale, filter:FilterType.nearest, depth:3 });
		
		trace(NP.entity_shape_list);
		
		levelColision();
		Main.fade.up(.5, function() {NP.frozenPlayer = false;});
	}//loadLevel

	var teleport_disabled: Bool = false;
	
	public function switchLevel(xTo:Int, yTo:Int, levelTo:String):Void {
		if (currentLvl == levelTo) {
			player.pos.x = xTo;
			player.pos.y = yTo;
		} else {
			currentLvl = levelTo;
			NP.posPlayer.x = xTo;
			NP.posPlayer.y = yTo;
			NP.frozenPlayer = true;
			tilemap.destroy();
			tilemapFront.destroy();
			Main.fade.out(.5, function() {loadLevel(currentLvl); });
		}
	}

	function ontrigger(collisions:Array<ShapeCollision>)
	{

	} //ontrigger

	override function update(dt:Float)
	{
		#if debug
		NP.drawDebug();
		#end
	} //update

}
