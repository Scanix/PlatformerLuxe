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

	override function config(config:luxe.GameConfig)
	{

		config.window.title = 'LuxePlatformer';
		config.window.width = 1280;
		config.window.height = 720;
		config.window.fullscreen = false;

		return config;

	} //config

	override function ready()
	{
		//FIX FRAMERATE
		Luxe.core.fixed_frame_time = 1 / 60;
		Luxe.fixed_frame_time = 1 / 60;
		
		// load the parcel
		var parcel = new Parcel(
		{
			textures : [
			{ id : "assets/graphics/entity/player32.png" },
			{ id : "assets/graphics/entity/npc1.png" },
			{ id : "assets/graphics/entity/enemy_shadow.png" },
			{ id : "assets/graphics/splash/scanixgames.png" },
			{ id : "assets/graphics/tilemap.png" },
			{ id : "assets/tilemap.png" },
			{ id : "assets/graphics/bg.png" },
			{ id : "assets/graphics/object/door_0.png" },
			{ id : "assets/graphics/props/house_0.png" },
			{ id : "assets/graphics/entity/interactionSign.png" },
			{ id : "assets/graphics/object/sign.png" },
			{ id : "assets/graphics/ui/messagebox.png" },
			],
			texts : [
			{ id : "assets/maps/corcelles/level.tmx" },
			{ id : "assets/maps/house01/level.tmx" }
			],
			jsons:[ 
			{ id:'assets/anim.json' },
			{ id:'assets/graphics/object/chest.json' },
			{ id:'assets/graphics/ui/messagebox.json' }
			]
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

		fade.out( 0.5, function()
		{
			machine.set('splash_state');
		});
	}//assetsLoaded

	override function onkeyup(e:KeyEvent)
	{
		if (e.keycode == Key.escape)
			Luxe.shutdown();
		#if debug
		if (e.keycode == Key.key_p)
			Luxe.showConsole(!Luxe.debug.visible);
		#end
	}

	override function update(dt:Float)
	{
	}
}
