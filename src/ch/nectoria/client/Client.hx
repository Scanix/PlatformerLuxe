package ch.nectoria.client;

import ch.nectoria.entities.PlayerClient;

import luxe.Component;
import phoenix.Vector;

//This component handles communication with the client
class Client extends Component {
	var cId:String = ""; //client ID
	var oldPos:Vector;

	// TODO: 1- implement websocket on non-js targets
	// TODO: 2- rewrite class so that ip,port can be passed on creation
#if js

	var socket : js.html.WebSocket;
	override function onadded() {
		var r = ~/^html/g;
#if heroku
		//link to your server
		socket = new js.html.WebSocket("ws://luxe-net-test.herokuapp.com");
#else
		var port = 3456;
		socket = new js.html.WebSocket("ws://test.nectoria.com:"+port);
#end
		oldPos = new Vector(0, 0);
		// start updating only AFTER we know there is a connection
		socket.onopen = function(event:Dynamic) {
			socket.send("QUERYID");
			trace("2- client queryied ID");
		}

		socket.onmessage = function(event:Dynamic) {
			if (cId != "") {
				trace(event.data);
			} else { //The first data we receive should be this client id
				trace(event.data);
				cId=event.data;
				entity.name = entity.name+cId;
				//var t = cast(Luxe.scene.get("nameLabel"), luxe.Text);
				//t.text = "You are: "+cId;
				trace("3 -" + entity.name + " connected");
			}
		}


	} //ready

	public function send(data:Dynamic) {
		socket.send(data);
	}

	override function update(dt:Float) {
		if (cId!="" /*&& !oldPos.equals(this.pos)*/) { //only send position if  we are connected
			// FIXME: Using tween, oldPos and newPos matched, can't avoid sending position even if it has not changed
			// CHECK: if using fixed_step physics, update and fixed update could be out of sync?

			socket.send(""+entity.pos);
			//trace("sent: "+this.pos);
			oldPos.copy_from(entity.pos);
		}

	} //update

#else
	// other targets code goes here
#end

	override function onremoved() {
		socket.close();
	}
}