package ch.nectoria;

import ch.nectoria.states.SplashState;
import ch.nectoria.states.GameState;
import ch.nectoria.components.Fader;

import luxe.Camera.SizeMode;
import luxe.Vector;
import luxe.GameConfig;
import luxe.Input;
import luxe.States;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.Color;
import phoenix.Camera;
import phoenix.Batcher;

class Main extends luxe.Game
{

	public static var machine : States;
	public static var fade:Fader;
	private static var debugBatcher:Batcher;
#if windows
	private var capture: LuxeGifCapture;
#end

	override function config(config:luxe.GameConfig)
	{
		config.window.title = 'LuxePlatformer';
		config.window.width = 1280;
		config.window.height = 720;
		config.window.true_fullscreen = false;
		config.window.fullscreen = false;
		return config;
	} //config

	override function ready()
	{
		//FIX FRAMERATE
		Luxe.core.fixed_frame_time = 1 / 60;
		Luxe.fixed_frame_time = 1 / 60;
		Luxe.camera.size = new Vector(1280, 720);
		Luxe.camera.size_mode = SizeMode.fit;
		//Debug Hxcpp
#if (debug && windows)
		new debugger.HaxeRemote(true, "localhost");
#end
		//Create DebugBatcher
#if debug
		debugBatcher = new Batcher(Luxe.renderer, 'debug_batcher');
		debugBatcher.view = new Camera();
		debugBatcher.layer = 11;
		Luxe.renderer.add_batch(debugBatcher);
#end
		// load the parcel
		var parcel = new Parcel({
			textures : [
			{ id : "assets/graphics/entity/player32.png" },
			{ id : "assets/graphics/entity/npc1.png" },
			{ id : "assets/graphics/entity/enemy_shadow.png" },
			{ id : "assets/graphics/splash/scanixgames.png" },
			{ id : "assets/graphics/tilemap.png" },
			{ id : "assets/tilemap.png" },
			{ id : "assets/graphics/background/snow_1.png" },
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
			{ id:'assets/graphics/ui/messagebox.json' },
			{ id:'assets/graphics/particles/smoke.json' }
			]
		});
		// show a loading bar
		new ParcelProgress(
		{
			parcel      : parcel,
			background  : new Color(1, 1, 1, 0.85),
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
		Luxe.input.bind_key('interact', Key.key_x);

		machine = new States({name:'statemachine'});
		machine.add(new SplashState('splash_state'));
		machine.add(new GameState('game_state'));
		//machine.add(new FightState('fight_state'));
		
		Luxe.camera.zoom = 1;
		fade = Luxe.camera.add(new Fader({ name:'fade' }));
		fade.out(0.5, function()
		{
			machine.set('splash_state');
		});
	}//assetsLoaded

	override function onkeyup(e:KeyEvent)
	{
		if (e.keycode == Key.escape)
			Luxe.shutdown();

		if (e.keycode == Key.key_o) {
			switch (Luxe.camera.size_mode) {
				case fit:
					Luxe.camera.size_mode = SizeMode.cover;

				case cover:
					Luxe.camera.size_mode = SizeMode.contain;

				case contain:
					Luxe.camera.size_mode = SizeMode.fit;
			}
		}

#if debug

		if (e.keycode == Key.key_p)
			Luxe.showConsole(!Luxe.debug.visible);

#end
	}

	override function onrender() {
#if debug
		Luxe.draw.text({
			immediate: true,
			pos: new luxe.Vector(10, 10),
			point_size: 14,
			batcher: debugBatcher,
			depth: 1,
			text: 'FPS : ' + Math.round(1.0/Luxe.debug.dt_average),
		});
#end
	}
}
