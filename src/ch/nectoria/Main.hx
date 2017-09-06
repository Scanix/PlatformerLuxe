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
	
	override function config(config:luxe.GameConfig) {
		
		config.window.title = 'LuxePlatformer';
        config.window.width = 1280;
        config.window.height = 720;
        config.window.fullscreen = false;

        config.preload.textures.push({ id:'assets/shaders/level.png' });
        config.preload.textures.push({ id:'assets/shaders/luxe.png' });
        config.preload.textures.push({ id:'assets/shaders/distort.png' });

        config.preload.shaders.push({ id:'hue', frag_id:'assets/shaders/huechange.glsl', vert_id:'default' });
        config.preload.shaders.push({ id:'gray-tilt', frag_id:'assets/shaders/gray_tilt_shift.glsl', vert_id:'default' });
        config.preload.shaders.push({ id:'distort', frag_id:'assets/shaders/distort.glsl', vert_id:'default' });

        return config;

    } //config

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
			{ id : "assets/tilemap.png" },
			{ id : "assets/graphics/object/door_0.png" },
			{ id : "assets/graphics/props/house_0.png" }
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

		fade.out( 0.5, function()
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
