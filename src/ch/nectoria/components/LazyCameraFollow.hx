package ch.nectoria.components;

import luxe.Component;
import luxe.utils.Maths;
import luxe.Vector;
import luxe.Rectangle;
import phoenix.Quaternion;

class LazyCameraFollow extends Component
{
	override public function onadded():Void
	{
		Luxe.camera.center.copy_from(pos);
	}

	override public function update(dt:Float):Void
	{
		var camX = entity.pos.x;
		var camY = 180 - 40;

		trace(entity.pos.y);

		Luxe.camera.focus(new Vector(camX, camY), dt);
	}
}
