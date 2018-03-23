package ch.nectoria.components;

import luxe.Sprite;
import luxe.Color;
import phoenix.Batcher;
import phoenix.Camera;

class Fader extends luxe.Component
{

	public var overlay: Sprite;
	public static var faderBatcher:Batcher;

	override function init()
	{
		faderBatcher = new Batcher(Luxe.renderer, 'fader_batcher');
		faderBatcher.view = new Camera();
		faderBatcher.layer = 10;
		Luxe.renderer.add_batch(faderBatcher);

		overlay = new Sprite(
		{
			size: Luxe.screen.size,
			color: new Color(0, 0, 0, 0),
			centered: false,
			batcher: faderBatcher,
			name: "FaderEntity",
			depth:99
		});
	}

	public function out(?t=0.15, ?fn:Void->Void)
	{
		overlay.color.tween(t, {a:1}).onComplete(fn);
	}

	public function up(?t=0.15, ?fn:Void->Void)
	{
		overlay.color.tween(t, {a:0}).onComplete(fn);
	}

}
