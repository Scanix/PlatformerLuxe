package ch.nectoria.components;

import luxe.Sprite;
import luxe.Color;

class Fader extends luxe.Component {

    var overlay: Sprite;

    override function init() {
        overlay = new Sprite({
            size: Luxe.screen.size,
            color: new Color(0,0,0,0),
            centered: false,
            depth:99
        });
    }

    public function out(?t=0.15,?fn:Void->Void) {
        overlay.color.tween(t, {a:1}).onComplete(fn);
    }

    public function up(?t=0.15,?fn:Void->Void) {
        overlay.color.tween(t, {a:0}).onComplete(fn);
    }

    override function ondestroy() {
        overlay.destroy( );
    }

}
