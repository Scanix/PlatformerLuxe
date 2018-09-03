package ch.nectoria.actions;

import ch.nectoria.sequences.Sequence;

class MoveAction extends BattleAction
{
	public var moveSequence(default, null):Sequence = null;

	public function new(user:NPC)
	{
		super(user);
	}
}