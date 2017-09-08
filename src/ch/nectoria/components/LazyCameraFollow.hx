package ch.nectoria.components;

import luxe.Component;
import luxe.utils.Maths;
import luxe.Vector;
import luxe.Rectangle;
import phoenix.Quaternion;

class LazyCameraFollow extends Component
{
	public var _state:String;
	public var _behaviour:String;
	public var _tilemapSize:Vector;
	
	public function new(name:String, state:String, behaviour:String, tilemapSize:Vector) 
	{
		super({ name: name });
		
		_state = state;
		_behaviour = behaviour;
		_tilemapSize = tilemapSize;
	}
	
	override public function onadded():Void
	{
		Luxe.camera.center.copy_from(pos);
	}

	override public function update(dt:Float):Void
	{
		var camX;
		var camY;
		
		if (_behaviour == "static") {
			camX = _tilemapSize.x /2;//Luxe.screen.width / 2;
			camY = _tilemapSize.y / 2;//Luxe.screen.height / 2;
		} else {
			camX = entity.pos.x;
			camY = 180 - 40;
		}

		Luxe.camera.focus(new Vector(camX, camY), dt);
		/*Luxe.camera.rotation = Luxe.camera.rotation.multiply(new luxe.Quaternion().setFromEuler(new luxe.Vector(0, 0, 5).radians()));
		
		if (Luxe.camera.zoom < 50) {
			Luxe.camera.zoom += 2;
		} else if (Luxe.camera.zoom > 50) {
			Luxe.camera.zoom -= 2;
		}*/
	}
}
