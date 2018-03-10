package ch.nectoria;

import ch.nectoria.entities.Player;
import ch.nectoria.entities.Physics;
import ch.nectoria.interfaces.ICollidable;

import luxe.Color;
import luxe.Vector;
import luxe.collision.shapes.Polygon;

/**
 * ...
 * @author Bianchi Alexandre
 */
class NP
{
	//Level
	public static var currentLvl:String = 'corcelles';
	public static var levels:Array<String> = ["level0", "level1"];

	//Player
	public static var currentPlayerHealth:Int = 1;
	public static var maxPlayerHealth:Int = 3;
	public static var deadPlayer:Bool = false;
	public static var posPlayer:Vector = new Vector(120, 100);
	public static var frozenPlayer:Bool = false;
	public static var player:Player;

	//HUD
	public static var currentCoinsCount:Int = 0;
	public static var displayingMessage:Bool = false;

	//Collisions
	public static var actor_list:Array<Physics> = [];
	public static var level_shape_list:Array<luxe.collision.shapes.Shape> = [];
	public static var entity_shape_list:Array<ICollidable> = [];

	public static function drawDebug():Void
	{
		for(shape in level_shape_list)   draw_collider_polygon(cast shape, new Color(0, 1, 0, 1));

		for(shape in entity_shape_list)   draw_collider_polygon(cast shape.hitBox, new Color(0, 0, 1, 1));

		for(shape in actor_list)   draw_collider_polygon(cast shape.hitBoxPhys, new Color(1, 0, 0, 1));
	}

	public static function draw_collider_polygon(poly:Polygon, col:Color)
	{
		var geom = Luxe.draw.poly(
		{
			solid:false,
			close:true,
			depth:100,
			points:poly.vertices,
			immediate:true,
			color:col
		});
		geom.transform.pos.copy_from(poly.position);
	}

	//global access
	//public static var objectsSprite:Spritemap = new Spritemap("graphics/tilemap.png", 16, 16);
}
