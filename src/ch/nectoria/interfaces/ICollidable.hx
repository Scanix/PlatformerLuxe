package ch.nectoria.interfaces;

interface ICollidable {

	public var pos(get,set):luxe.Vector;
	public var shape:luxe.collision.shapes.Shape;
	public var events:luxe.Events;

	public function on_pc_collision(is_pc:Bool):Bool;
}
