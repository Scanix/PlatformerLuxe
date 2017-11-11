package ch.nectoria.manager;

import luxe.Sprite;
import luxe.Vector;
import luxe.Vector.Vec;
import phoenix.Texture.FilterType;

/**
 * ...
 * @author Alexandre Bianchi, Scanix
 */
class BackgroundManager
{
	private var backgroundsList:Array<Sprite>;
	
	public function new() 
	{
		backgroundsList = new Array<Sprite>();
		
		var initialPos = new Vector();
		initialPos.copy_from(new Vector(Luxe.camera.pos.x - 50, Luxe.camera.pos.y));
		
		for (i in 0...3)
		{
			backgroundsList.push(createBackground(initialPos));
			initialPos.x += backgroundsList[0].size.x;
		}
	}
	
	private function createBackground(pos:Vector):Sprite
	{
		var _pos = new Vector();
		_pos.copy_from(pos);
		
		var texture = Luxe.resources.texture("assets/graphics/bg.png");
		texture.filter_mag = texture.filter_min = FilterType.nearest;
		
		var sprite = new Sprite({
			name: "background-" + backgroundsList.length,
			texture: texture,
			size: new Vector(165, 220),
			pos: _pos,
			centered: false
		});
		
		return sprite;
	}
	
	public function update()
	{
		for (background in backgroundsList)
		{
			if (Luxe.camera.world_point_to_screen(background.pos).x + background.size.x < 0)
			{
				var furthestBackgroundX:Float = background.pos.x;
				
				for (_b in backgroundsList)
				{
					if (background != _b)
					{
						furthestBackgroundX = Math.max(furthestBackgroundX, _b.pos.x);
					}
				}
				
				background.pos.x = furthestBackgroundX + background.size.x;
			}
		}
	}
}