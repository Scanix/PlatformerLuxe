package ch.nectoria.entities;

import ch.nectoria.interfaces.ICollidable;

import luxe.Sprite;
import luxe.Vector;
import luxe.collision.shapes.Shape;
import luxe.collision.shapes.Polygon;
import luxe.collision.Collision;
import luxe.utils.Maths;

class Physics extends Sprite implements ICollidable
{

	public var vx:Float = 0.0;
	public var vy:Float = 0.0;
	public var speed:Float = 1.0;
	public var maxVx:Float = 10.0;
	public var maxVy:Float = 10.0;
	public var friction:Float = .7;
	public var inAir:Bool = true;
	public var collideLeft:Bool = false;
	public var collideRight:Bool = false;
	public var collideAbove:Bool = false;
	public var collideBelow:Bool = false;
	public var hasCollideRight:Bool = false;
	public var hasCollideLeft:Bool = false;
	public var gravity:Float = 0.5;

	public var hitBox:Shape;
	public var hitBoxPhys:Shape;

	public function new (pos:Vector)
	{
		super(
		{
			pos: pos
		});

		hitBox = Polygon.rectangle(pos.x, pos.y, 8, 23);
		hitBoxPhys = Polygon.rectangle(pos.x, pos.y, 8, 23);

		texture = Luxe.resources.texture('assets/graphics/entity/player32.png');

		NP.actor_list.push(this);
		NP.entity_shape_list.push(this);
	}

	override function update(dt:Float)
	{
		//Movement
		if (vx > maxVx)
		{
			vx = maxVx;
		}

		if (vx < -maxVx)
		{
			vx = -maxVx;
		}

		if (vy > maxVy)
		{
			vy = maxVy;
		}

		if (vy < -maxVy)
		{
			vy = -maxVy;
		}

		if ((vx > 0 && vx < 0.1) || (vx < 0 && vx > -0.1))
		{
			vx = 0.0;
		}

		if ((vy > 0 && vy < 0.2) || (vy < 0 && vy > -0.2))
		{
			vy = 0.0;
		}

		vx *= friction;
		var i:Int = 0;

		while (i < Math.abs(vx))
		{
			var offsetX:Float;

			if (vx > 0)
			{
				offsetX = 1*speed;
			}
			else if (vx < 0)
			{
				offsetX = -1*speed;
			}
			else
			{
				offsetX = 0;
			}

			hitBoxPhys.position.x += offsetX;
			i ++;
		}

		var i2:Int = 0;

		while (i2 < Math.abs(vy))
		{
			var offsetY:Int;

			if (vy > 0)
			{
				offsetY = 1;
			}
			else if (vy < 0)
			{
				offsetY = -1;
			}
			else
			{
				offsetY = 0;
			}

			hitBoxPhys.position.y += offsetY;
			i2++;
		}

		if (inAir)
		{
			vy += gravity;
		}

		var c_array = Collision.shapeWithShapes(hitBoxPhys, NP.level_shape_list);

		if (c_array.length == 0)
		{
			collideRight = false;
			collideLeft = false;
			inAir = true;
			collideAbove = false;
			collideBelow = false;
		}

		//Check collision
		for (c in c_array)
		{
			if(c.shape1 != c.shape2)
			{
				hitBoxPhys.position.x += c.separationX;
				hitBoxPhys.position.y += c.separationY;

				if (c.unitVectorX < 0)
				{
					vx = 0;
					collideLeft = false;
					collideRight = true;
					hasCollideRight = true;
					hasCollideLeft = false;
				}

				if (c.unitVectorX > 0)
				{
					vx = 0;
					collideLeft = true;
					collideRight = false;
					hasCollideRight = false;
					hasCollideLeft = true;
				}

				if (c.unitVectorY != 0 && Maths.sign(c.unitVectorY) != Maths.sign(vy))
				{
					vy = 0;

					if (c.unitVectorY < 0)
					{
						inAir = false;
						collideBelow = true;
					}
				}
				else
				{
					inAir = true;
				}
			}
		}

		//Update position and show it
		pos.x = hitBoxPhys.position.x;
		pos.y = hitBoxPhys.position.y - 4;
		hitBox.x = pos.x;
		hitBox.y = pos.y;
	}

	public function on_player_collision(is_pc:Bool):Void {
	}
}
