package com.tinyrpg.data 
{
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.utils.ByteArray;

	/**
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
		
		// Singleton
		public static function getInstance() : TinyItemDataList
		{
			return instance;
		}
	}
}
