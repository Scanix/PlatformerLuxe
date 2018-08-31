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
import ch.nectoria.collectibles.items.Item;

import luxe.Entity;
import luxe.States;
import luxe.Scene;
import luxe.Sprite;
import luxe.Vector;
import luxe.importers.tiled.TiledMap;
import luxe.collision.shapes.Polygon;
import luxe.collision.data.ShapeCollision;
import luxe.components.sprite.SpriteAnimation;
import phoenix.Texture.FilterType;

class GameState extends State
{

	private var gameScene:Scene;
	private var player:Player;
	private var tilemap:TiledMap;
	private var tilemapFront:TiledMap;
	private var map_scale: Int = 1;
	private var backgroundManager:BackgroundManager;
	private var particlesManager:ParticlesManager;

	private var currentLvl:String;

	public var messageBox:Entity;

	private var anim:SpriteAnimation;

	private var itemTest:Item;

	public function new (_name:String)
	{

		super({ name:_name });
		gameScene = new Scene('game');

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

		loadLevel(currentLvl);
	}//onenter

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
		cleanUp();

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

					case 0:
						particlesManager.addParticlesByName(gameScene, _object);

					default:
						trace("unknow type: " + _object.gid + " , name : " + _object.name);
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

		levelColision();
		Main.fade.up(.5, function() {
			NP.frozenPlayer = false;
		});
	}//loadLevel

	public function switchLevel(xTo:Int, yTo:Int, levelTo:String):Void 
	{
		if (currentLvl == levelTo) {
			NP.posPlayer.x = xTo;
			NP.posPlayer.y = yTo;
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

	private function cleanUp():Void
	{
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
	}

	public function goOnCombat():Void 
	{
		machine.set('fight_state');
	}

	function ontrigger(collisions:Array<ShapeCollision>)
	{

	} //ontrigger

	override function update(dt:Float) {
		backgroundManager.update();
	}

	override function onrender() {
#if debug
		NP.drawDebug();
		backgroundManager.debug();
		if (Luxe.input.inputdown('tp'))
		{
			NP.posPlayer.x = 100;
			NP.posPlayer.y = 100;
			NP.player.hitBoxPhys.position = NP.posPlayer.clone();
		}
		if (Luxe.input.inputdown('state'))
		{
			goOnCombat();
		}
		Luxe.draw.text({
			immediate: true,
			pos: new luxe.Vector(10, 25),
			point_size: 14,
			batcher: Main.debugBatcher,
			depth: 1,
			text: ' vx : ' + NP.player.vx + ' vy : ' + NP.player.vy,
		});
#end
	}//onrender

	override function onleave<T>(_value:T)
	{
		cleanUp();
	} //onleave

}
