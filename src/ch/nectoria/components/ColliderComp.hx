package ch.nectoria.components;

import luxe.Component;
import luxe.Input;

import luxe.collision.Collision;

class ColliderComp extends Component
{

//	private var actor:Player;
	private var collidable:interfaces.ICollidable;

	//************OVERRIDES*************

	override public function onadded():Void
	{

		collidable = cast entity;
	}

	override public function update(dt:Float):Void
	{
		//level collisnios

		var c_array = Collision.shapeWithShapes(collidable.shape,Reg.level_shape_list);
		for (c in c_array) collidable.pos.add(c.separation);

		//entity collisions
		for (col_entity in Reg.collidable_list)
		{
			if (col_entity == collidable) continue;

			var c = Collision.shapeWithShape(collidable.shape,col_entity.shape);

			if (c != null)
			{
				if (col_entity.on_pc_collision(entity == Reg.player))
				{
					collidable.pos.add(c.separation);
				}

			}

		}
	}

}
