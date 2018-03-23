package ch.nectoria.manager;

import luxe.Particles;
import luxe.Scene;
import luxe.Sprite;
import luxe.importers.tiled.TiledObjectGroup.TiledObject;
import luxe.options.ParticleOptions.ParticleEmitterOptions;
import phoenix.Color.ColorHSV;
import phoenix.Vector;

/**
 * ...
 * @author Alexandre Bianchi, Scanix
 */
class ParticlesManager
{
	private var emitterList:Array<Sprite> = [];
	private var particlesSys:ParticleSystem;
	private var emitter:ParticleEmitter;

	var startColour:ColorHSV = new ColorHSV(60, 1, 0.5, 1);
	var endColour:ColorHSV = new ColorHSV(0, 1, 0.5, 0);

	var blend_src:Int;
	var blend_dst:Int;

	public function new ()
	{
		particlesSys = new ParticleSystem({name: 'particles'});
	}

	public function addParticlesByName(scene:Scene, obj:TiledObject):Void {
		switch (obj.name) {
			case 'smoke':
				loadFromJSON(obj, Luxe.resources.json('assets/graphics/particles/smoke.json'));

			default :
				trace("unknow type: " + obj.name);
		}

	}

	public function addParticlesByJSON(particles:ParticleEmitterOptions, pos:Vector):Void {
		particlesSys.add_emitter(particles);
		emitter = particlesSys.get('prototyping');
		emitter.init();
		emitter.pos.copy_from(pos);
	}

	public function loadFromJSON(obj:TiledObject, json:Dynamic) {
		// grab loaded particle values
		json = json.asset.json;
		startColour = new ColorHSV(json.start_color.h, json.start_color.s, json.start_color.v, json.start_color.a);
		endColour = new ColorHSV(json.end_color.h, json.end_color.s, json.end_color.v, json.end_color.a);
		var loaded:ParticleEmitterOptions = {
			name: "prototyping",
			emit_time: json.emit_time,
			emit_count: json.emit_count,
			direction: json.direction,
			direction_random: json.direction_random,
			speed: json.speed,
			speed_random: json.speed_random,
			end_speed: json.end_speed,
			life: json.life,
			life_random: json.life_random,
			rotation: json.zrotation,
			rotation_random: json.rotation_random,
			end_rotation: json.end_rotation,
			end_rotation_random: json.end_rotation_random,
			rotation_offset: json.rotation_offset,
			pos_offset: new Vector(json.pos_offset.x, json.pos_offset.y),
			pos_random: new Vector(json.pos_random.x, json.pos_random.y),
			gravity: new Vector(json.gravity.x, json.gravity.y),
			start_size: new Vector(json.start_size.x, json.start_size.y),
			start_size_random: new Vector(json.start_size_random.x, json.start_size_random.y),
			end_size: new Vector(json.end_size.x, json.end_size.y),
			end_size_random: new Vector(json.end_size_random.x, json.end_size_random.y),
			start_color: startColour,
			end_color: endColour,
			depth: 1
		};
		blend_src = json.blend_src;
		blend_dst = json.blend_dst;

		addParticlesByJSON(loaded, new Vector(obj.pos.x + 8, obj.pos.y));
	} // loadFromJSON

	public function destroy() {
		particlesSys.destroy();
	}
}