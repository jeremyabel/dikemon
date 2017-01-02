package com.tinyrpg.data 
{
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.events.TinyItemEvent;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.events.EventDispatcher;

	public class TinyInventory extends EventDispatcher
	{
		public var gold		 : int; 
		public var inventory : Array;
		
		private var ITEM_LIMIT : uint;
		
		public function TinyInventory(itemLimit : uint = 10) 
		{
			this.ITEM_LIMIT = itemLimit;
			this.inventory  = new Array();
		}

		public function addItem(item : TinyItem) : void
		{
			TinyLogManager.log('addItem: ' + item.name, this);
			
			item.itemID = this.inventory.length;
			
			if (this.inventory.length >= this.ITEM_LIMIT) {
				this.dispatchEvent(new TinyItemEvent(TinyItemEvent.INVENTORY_FULL));
				TinyLogManager.log('item addition failed', this);	
			} else {
				this.inventory.push(item);
				this.dispatchEvent(new TinyItemEvent(TinyItemEvent.ITEM_ADDED));
				TinyLogManager.log('item added succesfully', this);
			}
			
			this.enumerateInventory();
		}
		
		public function removeItem(item : TinyItem) : void
		{
			TinyLogManager.log('removeItem: ' + item.name, this);

			// Returns -1 if item is not found
			var targetItem : TinyItem = this.getItemByID(item.itemID);
			var itemIndex : int = this.inventory.indexOf(targetItem);
			
			// Throw error if the specified item is not found
			if (itemIndex < 0) { 
				this.dispatchEvent(new TinyItemEvent(TinyItemEvent.ITEM_NOT_FOUND));
				TinyLogManager.log('item remove failed', this);
			} else {
				this.inventory.splice(itemIndex, 1);				this.dispatchEvent(new TinyItemEvent(TinyItemEvent.ITEM_REMOVED));
				TinyLogManager.log('item removed succesfully', this);
			}
			
			this.enumerateInventory();
		}
		
		public function enumerateInventory() : void
		{
			trace('_');			for each (var item : TinyItem in this.inventory) {
				trace(item.name);
			}
			trace('_');
		}
		
		public function get length() : int
		{
			return this.inventory.length;
		}
		
		public function hasItemNamed(itemName : String) : Boolean
		{
			// Find function
			var findFunction : Function = function(item : *, index : int, array : Array) : Boolean
				{ index; array; return (TinyItem(item).name == itemName); };
			
			// Search for character
			return this.inventory.filter(findFunction).length > 0;
		}
		
		public function getItemByID(targetID : int) : TinyItem
		{
			// Find function
			var findFunction : Function = function(item : *, index : int, array : Array) : Boolean
				{ index; array; return (TinyItem(item).itemID == targetID); };
			
			// Search for character
			return this.inventory.filter(findFunction)[0];
		}
	}
}
