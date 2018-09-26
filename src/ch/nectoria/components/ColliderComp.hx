package ch.nectoria.components;

import ch.nectoria.interfaces.ICollidable;

import luxe.Component;
import luxe.collision.Collision;

class ColliderComp extends Component
{
	private var collidable:ICollidable;

	//************OVERRIDES*************

	override public function onadded():Void
	{
		collidable = cast entity;
	}

	override public function update(dt:Float):Void
	{
		//entity collisions
		for (col_entity in NP.entity_shape_list)
		{
			if (col_entity == collidable) continue;

			var c = Collision.shapeWithShape(collidable.hitBox, col_entity.hitBox);

			if (c != null)
			{
				if (entity == NP.player) {
					col_entity.interactWithPlayer = true;
					col_entity.on_player_collision(entity == NP.player);
				}

				break;
			} else {
				col_entity.interactWithPlayer = false;
			}

		}
	}

}
