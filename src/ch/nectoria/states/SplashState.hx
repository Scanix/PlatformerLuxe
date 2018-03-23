package ch.nectoria.states;

import luxe.States;
import luxe.Text;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;

class SplashState extends State
{

	private var splashImage:Sprite;
	private var versionText:Text;
	private var background:Sprite;

	public function new (_name:String)
	{
		super({ name:_name });
	}//new

	override function init()
	{
	}//init

	override function onenter<T>(_value:T)
	{
		var image = Luxe.resources.texture('assets/graphics/splash/scanixgames.png');
		background = new Sprite(
		{
			name : 'background',
			centered : false,
			size : Luxe.screen.size,
			color : new Color(1, 1, 1, 1)
		});
		versionText = new Text(
		{
			text : "Version Alpha 0.6.0\nNectoProject on Luxe Engine\nServer version",
			point_size : 18,
			pos : new Vector(0, 0),
			sdf : true,
			color : new Color(0, 0, 0, 1).rgb(0x000000)
		});
		splashImage = new Sprite(
		{
			name: 'splashImage',
			texture: image,
			pos : new Vector(Luxe.screen.mid.x, Luxe.screen.mid.y),
			color : new Color(1, 1, 1, 1)
		});
		Main.fade.up(2.5, function()
		{
			Main.fade.out(1, function()
			{
				machine.set('game_state');
			});
		});
	}

	override function onleave<T>(_value:T)
	{
		background.destroy();
		versionText.destroy();
		splashImage.destroy();
	} //onleave

}
