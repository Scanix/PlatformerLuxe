
package ch.nectoria;

/**
 * The types of entity
 */
enum EntityTypes
{
    Player; Enemy; Neutral;
}

/**
 * The types of collectible
 */
enum CollectibleTypes
{
    None; Item; Badge;
}

/**
 * The types of BattleEntities a MoveAction affects.
 */
@:enum abstract MoveAffectionTypes(Int) from Int to Int
{
    /**  */
    var None = value(0);
    /** Targets the user of the MoveAction */
    var Self = value(1);
    var Ally = value(2);
    var Other = value(3);
    var Custom = value(4);

    static inline function value(index:Int) return 1 << index; 
} 