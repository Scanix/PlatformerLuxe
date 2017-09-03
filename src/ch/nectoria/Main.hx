package ch.nectoria;

import luxe.GameConfig;
import luxe.Input;
import luxe.States;
import ch.nectoria.states.SplashState;
import ch.nectoria.states.GameState;
import ch.nectoria.components.Fader;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.Color;

class Main extends luxe.Game
{

	public static var machine : States;
	public static var fade:Fader;

	override function ready()
	{
		// load the parcel
		var parcel = new Parcel(
		{
			textures : [
			{ id : "assets/graphics/entity/player32.png" },
			{ id : "assets/graphics/entity/npc1.png" },
			{ id : "assets/graphics/entity/enemy_shadow.png" },
			{ id : "assets/graphics/splash/scanixgames.png" },
			{ id : "assets/graphics/tilemap.png" },
			{ id : "assets/tilemap.png" }
			],
			texts : [
			{ id : "assets/maps/corcelles/level.tmx" },
			{ id : "assets/maps/house01/level.tmx" }
			],
			jsons:[ { id:'assets/anim.json' } ]
		});

		// show a loading bar
		new ParcelProgress(
		{
			parcel      : parcel,
			background  : new Color(1,1,1,0.85),
			oncomplete  : assetsLoaded
		});

		// start loading!
		parcel.load();
	}//ready

	private function assetsLoaded(_)
	{
		Luxe.input.bind_key('jump', Key.space);
		Luxe.input.bind_key('jump', Key.key_w);
		Luxe.input.bind_key('jump', Key.up);
		Luxe.input.bind_key('left', Key.key_a);
		Luxe.input.bind_key('left', Key.left);
		Luxe.input.bind_key('right', Key.key_d);
		Luxe.input.bind_key('right', Key.right);

		machine = new States({name:'statemachine'});
		machine.add(new SplashState('splash_state'));
		machine.add(new GameState('game_state'));
		//machine.add(new FightState('fight_state'));

		Luxe.camera.zoom = 1;
		fade = Luxe.camera.add(new Fader({ name:'fade' }));

		fade.out( function()
		{
			machine.set('splash_state');
		});
	}//assetsLoaded

	override function onkeyup(e:KeyEvent)
	{
		if (e.keycode == Key.escape)
			Luxe.shutdown();
	}

	override function update(dt:Float)
	{
	}
}
