package ch.nectoria.states;

import ch.nectoria.NP;
import ch.nectoria.manager.BackgroundManager;
import ch.nectoria.manager.EntityManager;
import ch.nectoria.ui.MessageBox;
import ch.nectoria.manager.ParticlesManager;
import ch.nectoria.components.LazyCameraFollow;
import ch.nectoria.entities.Player;
import ch.nectoria.entities.Door;
import ch.nectoria.entities.Sign;
import ch.nectoria.entities.PlayerClient;
import ch.nectoria.client.Client;

import luxe.Entity;
import luxe.States;
import luxe.Scene;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.tween.Actuate;
import luxe.tween.easing.Linear;
import luxe.importers.tiled.TiledMap;
import luxe.collision.shapes.Polygon;
import luxe.collision.data.ShapeCollision;
import luxe.components.sprite.SpriteAnimation;
import phoenix.Texture.FilterType;

class GameState extends State
{

	private var gameScene:Scene;
	var clients: Map<String, PlayerClient>;
	private var player:Player;
	private var tilemap:TiledMap;
	private var tilemapFront:TiledMap;
	private var map_scale:Int = 1;
	private var backgroundManager:BackgroundManager;
	private var particlesManager:ParticlesManager;

	private var currentLvl:String;

	public var messageBox:Entity;

	var anim : SpriteAnimation;

	//Test for webSocket
	var socket : js.html.WebSocket;
	var open: Bool = false;

	public function new (_name:String)
	{

		super({ name:_name });
		gameScene = new Scene('game');

		clients = new Map<String, PlayerClient>();
      	trace("5- world created");
	}//new

	private function getLevelData(id:String):String
	{
		var level:String = "assets/maps/" + id + "/level.tmx";

		if (id != null)
		{
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

		var port = 3456;
		socket = new js.html.WebSocket("ws://test.nectoria.com:"+port);

		// start updating only AFTER we know there is a connection
		socket.onopen = function(event:Dynamic) {
			trace("6 - worldSocket open");
			open = true;
		}

		socket.onmessage = function(event:Dynamic) {
			addClient(event.data);
		}

		loadLevel(currentLvl);
	}//onenter

	public function send(data:Dynamic) {
		socket.send(data);
	}

	override function onremoved() {
		socket.close();
	}

	function levelColision()
	{
		var bounds = tilemap.layer('collide').bounds_fitted();
		var tris = tilemap.layer('collideSlope').bounds_fitted();

		for (bound in bounds)
		{
			bound.x *= tilemap.tile_width;
			bound.y *= tilemap.tile_height;
			bound.w *= tilemap.tile_width;
			bound.h *= tilemap.tile_height;
			NP.level_shape_list.push(Polygon.rectangle(bound.x, bound.y, bound.w, bound.h, false));
		}

		for (bound in tris)
		{
			var vertices:Array<Vector> = new Array<Vector>();

			bound.x *= tilemap.tile_width;
			bound.y *= tilemap.tile_height;
			bound.w *= tilemap.tile_width;
			bound.h *= tilemap.tile_height;

			vertices.push(new Vector(0, 16));
			vertices.push(new Vector(16, 0));
			vertices.push(new Vector(16, 16));

			NP.level_shape_list.push(new Polygon(bound.x, bound.y, vertices));
		}

	} //create_map_collision

	private function loadLevel(id:String):Void
	{
		//for (a in NP.actor_list) a.destroy();
		for (a in NP.entity_shape_list) cast(a, Sprite).destroy();

		NP.actor_list = [];
		NP.entity_shape_list = [];
		NP.level_shape_list = [];

		//Destroy Manager
		if (tilemap != null) {
			tilemap.destroy();
			tilemapFront.destroy();
		}

		if (backgroundManager != null) {
			backgroundManager.destroy();
		}

		if (particlesManager != null) {
			particlesManager.destroy();
		}

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

		tilemap.display({ scale:map_scale, filter:FilterType.nearest, depth:2 });

		//Create BackGround
		backgroundManager = new BackgroundManager(tilemap.tiledmap_data.properties["background"]);
		//Particles
		particlesManager = new ParticlesManager();

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
						EntityManager.addEntity(gameScene, _object);

					case 241:
						particlesManager.addParticlesByName(gameScene, _object);

					default:
						trace("unknow type: " + _object.gid + " , name : " + _object.name);
				}
			}
		}

		//And create the visual
		player = new Player(NP.posPlayer.clone());
		player.add(new Client({ name: "client" }));

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

		levelColision();
		Main.fade.up(.5, function() {
			NP.frozenPlayer = false;
		});
	}//loadLevel

	public function switchLevel(xTo:Int, yTo:Int, levelTo:String):Void {
		if (currentLvl == levelTo) {
			player.pos.x = xTo;
			player.pos.y = yTo;
		} else {
			currentLvl = levelTo;
			NP.posPlayer.x = xTo;
			NP.posPlayer.y = yTo;
			NP.frozenPlayer = true;
			Main.fade.out(.5, function() {
				loadLevel(currentLvl);
			});
		}
	}

	function ontrigger(collisions:Array<ShapeCollision>)
	{

	} //ontrigger

	public function addClient(cIdPos:String) {
		var arr = cIdPos.split("///");
		var pId = NP.player.get("client").cId;

		// id///pos///alive
		if (arr[2]=="true" && NP.player != null) 
		{
			if (pId!= "" && arr[0] != pId  &&  clients.get(arr[0]) == null) 
			{
				trace("new client");
				var sprite:PlayerClient = new PlayerClient(new Vector(0,0), arr[0]);
				clients.set(arr[0], sprite);
			} 
			else 
			{
				if (clients.get(arr[0])!=null) 
				{
					clients.get(arr[0]).vx = Utilities.vectorFromString(arr[1]).x - clients.get(arr[0]).pos.x;
					clients.get(arr[0]).vy = Utilities.vectorFromString(arr[1]).y - clients.get(arr[0]).pos.y;
					Actuate.tween(clients.get(arr[0]).pos, .1, {x: Utilities.vectorFromString(arr[1]).x, y: Utilities.vectorFromString(arr[1]).y}).ease(Linear.easeNone);
				}
			}
		} 
		else //Sprite is dead 
		{ 
			if (clients.get(arr[0])!=null) 
			{
				clients.get(arr[0]).destroy();
				clients.remove(arr[0]);
			}
		}
	}

	override function update(dt:Float)
	{
#if debug
		NP.drawDebug();
#end
		if (open) send("WORLDUPDATE");
		backgroundManager.update();
	} //update

}
