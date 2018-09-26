package ch.nectoria.interfaces;

import luxe.collision.shapes.Shape;

interface ICollidable
{

	public var pos(get, set):luxe.Vector;
	public var hitBox:luxe.collision.shapes.Shape;
	public var events:luxe.Events;
	public var interactWithPlayer:Bool;

	public function on_player_collision(is_player:Bool):Void;
}
