
package ch.nectoria.collectibles;

import ch.nectoria.Enumerations;

import phoenix.Texture;

/**
 * ...
 * @author Alexandre Bianchi, Scanix
 */

class Collectible 
{

    /**
     * The name of the collectible
     */
    public var name(default, default):String = "Item";

    /**
     * The description of the collectible
     */
    public var description(default, null):String = "N/A";

    /**
     * The texture of the collectible
     */
    public var texture(default, null):Texture = null;

    /**
     * The type of collectible
     */
    public var collectibleType(default, null):CollectibleTypes = CollectibleTypes.None;

    public function new(){}

}