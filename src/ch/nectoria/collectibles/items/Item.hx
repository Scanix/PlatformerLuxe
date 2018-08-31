package ch.nectoria.collectibles.items;

import ch.nectoria.Enumerations;

/**
 * The item categories
 */
enum ItemCategories
{
    Standard; Key;
}

class Item extends Collectible
{
    /**
     * The description of the collectible
     */
    public var itemCategory(default, null):ItemCategories = ItemCategories.Standard;

    public function new()
    {
        super();
        collectibleType = CollectibleTypes.Item;
    }
}