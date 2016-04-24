package ch.nectoria.entities;

import luxe.Sprite;
import luxe.Vector;
import luxe.components.sprite.SpriteAnimation;
import ch.nectoria.states.GameState;
import luxe.collision.shapes.Polygon;

class Player extends Physics {

	public var speed:Float = 1.0;
	public var jumpSpeed:Float = 7.0;
	public var climbing:Bool = false;
	public var hasKey:Bool = false;

  private var anim:SpriteAnimation;

  public function new(pos:Vector):Void {
		super(pos);

    texture = Luxe.resources.texture('assets/graphics/entity/player32.png');
    size = new Vector(16,32);

    var anim_object = Luxe.resources.json('assets/anim.json');
    anim = this.add(new SpriteAnimation({ name: 'SpriteAnimation' }));
    anim.add_from_json_object( anim_object.asset.json );

    anim.animation = 'idle';
    anim.play();
	}

  override function update(dt:Float) {
    apply_input(dt);

    if (vx != 0) {
      if(anim.animation != 'walk') {
          anim.animation = 'walk';
      }
		} else if (vy > 1) {
			//spPlayer.play("fall");
		} else if (vy < -1) {
			anim.animation = "jump";
		} else {
			anim.animation = "idle";
		}

    super.update(dt);
  } //update

  function apply_input(dt:Float) {
  if( Luxe.input.inputdown('jump') && !inAir /*&& /*collideBelow*/)
		{
			this.jump();
		}
		if( Luxe.input.inputdown('left') && !collideLeft)
		{
			this.moveLeft();
		}
		if( Luxe.input.inputdown('right') && !collideRight)
		{
			this.moveRight();
		}
  } //update_input

  public function jump():Void
	{
		vy -= jumpSpeed;
		inAir = true;
	}
	public function moveLeft():Void
	{
		vx -= speed;
		if(collideRight)
		{
			collideRight = false;
		}
		this.flipx = true;
	}
	public function moveRight():Void
	{
		vx += speed;
		if(collideLeft)
		{
			collideLeft = false;
		}
		this.flipx = false;
	}
}
