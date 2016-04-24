package ch.nectoria.states;

import luxe.States;
import luxe.Scene;
import luxe.Sprite;
import ch.nectoria.NP;
import luxe.importers.tiled.TiledMap;
import phoenix.Texture.FilterType;
import ch.nectoria.components.LazyCameraFollow;
import ch.nectoria.entities.Player;
import luxe.collision.shapes.*;
import luxe.collision.data.ShapeCollision;
import luxe.Vector;
import luxe.utils.Maths;
import luxe.components.sprite.SpriteAnimation;
import luxe.Quaternion;

class GameState extends State {

  private var gameScene:Scene;
  private var player:Player;
  private var tilemap:TiledMap;
  private var map_scale: Int = 1;
  private var spawn_pos:Vector;

  var anim : SpriteAnimation;

  public function new(_name:String) {

    super({ name:_name });
    gameScene = new Scene('game');

  }//new

  private function getLevelData(id:String):String {
		var level:String = "assets/maps/" + id + "/level.tmx";
		if (level != null) {
      return level;
    } else {
      return 'can\'t load level';
    }
	}//getLevelData

  override function onenter<T>(_value:T) {
    Luxe.camera.zoom = 5;

    Luxe.events.listen('simulation.triggers.collide', ontrigger);

    loadLevel();
    levelColision();
  }//onenter

  function levelColision() {

        var bounds = tilemap.layer('collide').bounds_fitted();
        for(bound in bounds) {
            bound.x *= tilemap.tile_width;
            bound.y *= tilemap.tile_height;
            bound.w *= tilemap.tile_width;
            bound.h *= tilemap.tile_height;
            NP.level_shape_list.push(Polygon.rectangle(bound.x, bound.y, bound.w, bound.h, false));
        }

  } //create_map_collision

  private function loadLevel():Void {
    for(a in NP.actor_list) a.destroy();
		NP.actor_list = [];
		NP.level_shape_list = [];

    var level:String = getLevelData(NP.currentLvl);
		trace("Loading level: " + level);

    tilemap = new TiledMap({
      format: 'tmx',
			tiled_file_data: Luxe.resources.text(level).asset.text
		});

    //Luxe.camera.bounds = tilemap.bounds;

    tilemap.display({ scale:map_scale, filter:FilterType.nearest });

    spawn_pos = new Vector(100, 100);

    var textPlayer = Luxe.resources.texture('assets/graphics/entity/player32.png');
    textPlayer.filter_min = textPlayer.filter_mag = FilterType.nearest;

    //And create the visual
    player = new Player(spawn_pos.clone());

    player.add(new LazyCameraFollow());

    Main.fade.up();
  }//loadLevel

  var teleport_disabled: Bool = false;

  function ontrigger(collisions:Array<ShapeCollision>) {

  } //ontrigger

  override function update(dt:Float) {
    //NP.drawDebug();
  } //update


}
