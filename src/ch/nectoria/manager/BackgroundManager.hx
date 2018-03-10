package ch.nectoria.manager;

import luxe.Sprite;
import luxe.Vector;
import phoenix.Texture.FilterType;

/**
 * ...
 * 	@author Alexandre Bianchi, Scanix
 */
class BackgroundManager
{
	private var backgroundsList:Array<Sprite>;
	private var parallaxEffect:Float;
	private var offset:Int;
	private var backgroundImage:String;

	public function new (_backgroundImage:String)
	{
		backgroundImage = _backgroundImage;
		backgroundsList = new Array<Sprite>();
		offset = 0;

		var initialPos = new Vector();
		initialPos.copy_from(new Vector(0, 0));

		if (backgroundImage != "none") {
			for (i in 0...3)
			{
				backgroundsList.push(createBackground(initialPos));
				initialPos.x += backgroundsList[0].size.x-1;
			}
		}
	}

	private function createBackground(pos:Vector):Sprite
	{
		var _pos = new Vector();
		_pos.copy_from(pos);

		var texture = Luxe.resources.texture("assets/graphics/background/" + backgroundImage + ".png");
		texture.filter_mag = texture.filter_min = FilterType.nearest;

		var sprite = new Sprite({
			name: "background-" + backgroundsList.length,
			texture: texture,
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

		backgroundsList = [];
	}

	public function update()
	{
		if (backgroundsList.length > 0) {
			if (Luxe.camera.world_point_to_screen(backgroundsList[1].pos).x < 0)
			{
				offset++;
			} else if (Luxe.camera.world_point_to_screen(backgroundsList[2].pos).x > Luxe.screen.width) {
				offset--;
			}

			for (background in backgroundsList)
			{
				background.pos.x = (offset * (background.size.x)) + (backgroundsList.indexOf(background) * background.size.x) + (Luxe.camera.pos.x * 0.3);

#if debug
				Luxe.draw.rectangle(
				{
					depth:100,
					x : background.pos.x, y : background.pos.y,
					w : background.size.x,
					h : background.size.y,
					immediate:true,
					color:new Color(1, 1, 0, 1)
				});
				Luxe.draw.text(
				{
					depth:102,
					color : new Color(1, 1, 1, 1),
					pos : new Vector().copy_from(background.pos),
					point_size : 10,
					align : TextAlign.center,
					immediate: true,
					text : background.name
				});
#end
			}
		}
	}
}