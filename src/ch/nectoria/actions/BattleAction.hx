package ch.nectoria.actions;

import ch.nectoria.entities.NPC;

/**
 * @autor Alexandre Bianchi, Scanix
 */
class BattleAction 
{
	/**
	 * The name of the action.
	 */
	public var name:String = "Action";
	
	/**
	 * Cost of action point.
	 */
	public var cost:int = 0;

	/**
	 * The base damage of an action.
	 */
	public var baseDamage = 0;

	/**
	 * The user of an action
	 */
	public var user(default, null):NPC= null;

	public function new(_user:NPC)
	{
		setUser(_user);
	}

	public function setUser(_user:NPC):Void
	{
		user = _user;
	}
}