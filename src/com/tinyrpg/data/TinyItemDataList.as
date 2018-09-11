package com.tinyrpg.data 
{
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.utils.ByteArray;

	/**
	 * Singleton class which contains the list of items in the game.
	 * 
	 * Contains functions for finding an item by name and recreating
	 * an item from a serialized JSON object.
	 *  
	 * @author jeremyabel
	 */
	public class TinyItemDataList 
	{
		private static var instance : TinyItemDataList = new TinyItemDataList();
		public var itemList : Array = [];

		[Embed(source='../../../../bin/xml/Items.xml', mimeType='application/octet-stream')]
		public var Item_Data : Class;
				
		public function TinyItemDataList() : void
		{
			// Get item XML data
			var byteArray : ByteArray = ( new this.Item_Data() ) as ByteArray;
			var string : String = byteArray.readUTFBytes( byteArray.length );
			var itemXMLData : XML = new XML( string );
			
			// Add each item to the array
			for each ( var itemData : XML in itemXMLData.children() ) 
			{
				var newItem : TinyItem = TinyItem.newFromXML( itemData );
				this.itemList.push( newItem );
			}
		}
		
		/**
		 * Returns an item from a serialized JSON object which contains the item's
		 * name and its quantity.
		 */
		public function newItemFromJSON( jsonObject : Object ) : TinyItem
		{
			TinyLogManager.log( 'newItemFromJSON: ' + jsonObject.name, TinyItemDataList );
			
			var newItem : TinyItem = this.getItemByName( jsonObject.name );
			newItem.quantity = jsonObject.quantity;
			
			return newItem; 
		}
		
		/**
		 * Returns an item with a given name, if it exists. 
		 */
		public function getItemByName( targetName : String ) : TinyItem
		{
			TinyLogManager.log( 'getItemByName: ' + targetName, this );
			
			// Find function
			var findFunction : Function = function( item : *, index : int, array : Array ) : Boolean
			{ 
				index; 
				array; 
				
				return ( TinyItem( item ).name.toUpperCase() == targetName.toUpperCase() ); 
			};
				
			return this.itemList.filter( findFunction )[ 0 ];
		}
		
		public function getItemByOriginalName( targetName : String ) : TinyItem
		{
			TinyLogManager.log( 'getItemByOriginalName: ' + targetName, this );
			
			// Find function
			var findFunction : Function = function( item : *, index : int, array : Array ) : Boolean
			{ 
				index; 
				array; 
				
				return ( TinyItem( item ).originalName.toUpperCase() == targetName.toUpperCase() ); 
			};
				
			return this.itemList.filter( findFunction )[ 0 ];
		}
		
		/**
		 * Returns the singleton instance.
		 */
		public static function getInstance() : TinyItemDataList
		{
			return instance;
		}
	}
}
