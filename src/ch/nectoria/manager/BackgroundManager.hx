package ch.nectoria.manager;

import luxe.Sprite;
import luxe.Vector;
import luxe.Vector.Vec;
import luxe.Color;
import luxe.Text.TextAlign;
import phoenix.Texture.FilterType;

/**
 * ...
 * @author Alexandre Bianchi, Scanix
 */
class BackgroundManager
{
	/**
	 * @
	 */
	private var backgroundsList:Array<Sprite>;
	private var parallaxEffect:Float;
	private var offset:Int;
	
	public function new(/*parEffect:Float*/) 
	{
		backgroundsList = new Array<Sprite>();
		offset = 0;
		
		var initialPos = new Vector();
		initialPos.copy_from(new Vector(0, 0));
		
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
	
	public function destroy() {
		for (background in backgroundsList)
		{
			background.destroy();
		}
	}
	
	public function update()
	{ 
		if (Luxe.camera.world_point_to_screen(backgroundsList[1].pos).x < 0)
		{
			offset++;
		} else if (Luxe.camera.world_point_to_screen(backgroundsList[1].pos).x + Luxe.screen.width - backgroundsList[1].size.x > Luxe.screen.width) {
			offset--;
		}
		for (background in backgroundsList)
		{
			background.pos.x = (offset * (background.size.x)) + (backgroundsList.indexOf(background) * background.size.x) + (NP.player.pos.x * 0.3);
			
			Luxe.draw.rectangle(
			{
				depth:100,
				x : background.pos.x, y : background.pos.y,
				w : background.size.x,
				h : background.size.y,
				immediate:true,
				color:new Color(1,1,0,1)
			});
			Luxe.draw.text(
			{
				color : new Color(1,1,1,1),
				pos : background.pos,
				point_size : 24,
				align : TextAlign.center,
				text : "some text \n indeed"
			});
		}
	}
}