package ch.nectoria.sequences;

import ch.nectoria.actions.MoveAction;

enum SequenceBranch
{
    None; Start; End; Main; Success; Failed; Interruption; Miss;
}

class Sequence
{
	private var interruptionHandler:Dynamic = null

	public var action(default, null):MoveAction = null;
}