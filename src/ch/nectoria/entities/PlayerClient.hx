package ch.nectoria.entities;

import luxe.Sprite;
import luxe.Vector;
import luxe.Text;
import luxe.Color;
import luxe.components.sprite.SpriteAnimation;
import phoenix.Texture.FilterType;

class PlayerClient extends Sprite
{
	private var anim:SpriteAnimation;
	private var nameLabel:Text;
	public var vx:Float;
	public var vy:Float;

	public function new (pos:Vector, pId:String):Void
	{
		super({pos:pos});

		texture = Luxe.resources.texture('assets/graphics/entity/player32.png');
		texture.filter_min = texture.filter_mag = FilterType.nearest;
		size = new Vector(16, 32);
		depth = 3.0;

		var anim_object = Luxe.resources.json('assets/anim.json');
		anim = this.add(new SpriteAnimation({ name: 'SpriteAnimation' }));
		anim.add_from_json_object(anim_object.asset.json);

		name = 'player' + pId;

		anim.animation = 'idle';
		anim.play();

		_add_child(nameLabel = new Text(
		{
			text : pId,
			point_size : 9,
			pos : new Vector(this.pos.x, this.pos.y - 20),
			sdf : true,
			color : new Color(1, 1, 1, 1).rgb(0xffffff)
		}));
	}

	override function update(dt:Float)
	{
		if (vx != 0)
		{
			if (anim.animation != 'walk')
			{
				anim.animation = 'walk';
			}

			if (vx < 0) {
				this.flipx = true;
			} else {
				this.flipx = false;
			}
		}
		else if (vy > 1)
		{
			//spPlayer.play("fall");
		}
		else if (vy < -1)
		{
			anim.animation = "jump";
		}
		else
		{
			anim.animation = "idle";
		}

		nameLabel.pos.x = this.pos.x;
		nameLabel.pos.y = this.pos.y - 20;
	} //update

	public function playWalk():Void
	{
		anim.animation = 'walk';
	}
}
