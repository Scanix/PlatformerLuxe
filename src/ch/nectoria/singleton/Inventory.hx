package ch.nectoria.singleton;

import ch.nectoria.collectibles.items.Item;

class Inventory {

  	// read-only property
	public static var instance(default, null):Inventory = new Inventory();

	/**
	 * The max number of coins that can be held at a time
	 */
	public static inline var MAX_COINS:UInt = 999;

	// #region Item Related Fields

	private static inline var MAX_ITEMS = 10;
	private static inline var MAX_KEYITEMS = 20;

	/**
	 * The Player's Item inventory.
	 */
	private var items(default, null):List<Item> = new List<Item>();

	/**
	 * The key items the Player possesses.
	 */
	private var keyItems(default, null):List<Item> = new List<Item>();

	// #endregion
	
	private function new () {}  // private constructor

	// #region Item Method

	/**
	 * Adding an item to the inventory
	 * @param Item The item to add
	 */
	public function addItem(Item item):Void
	{
		if(item.itemCategory == Item.ItemCategories.KeyItem)
		{
			
		}
	}

	// #endregion
}