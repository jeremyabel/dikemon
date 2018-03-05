package com.tinyrpg.lookup
{
	import com.tinyrpg.data.TinyEventFlag;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.utils.ByteArray;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyEventFlagLookup 
	{
		[Embed(source='../../../../bin/xml/Flags.xml', mimeType='application/octet-stream')]
		public static const Flags_XML : Class;
		
		private static var instance : TinyEventFlagLookup = new TinyEventFlagLookup;
		
		private var eventFlagXML 	: XML;
		private var eventFlags 		: Array = []; 
		
		public function TinyEventFlagLookup() : void
		{
			TinyLogManager.log('init', this);
			
			// Get flag XML data
			var byteArray : ByteArray = ( new Flags_XML() ) as ByteArray;
			this.eventFlagXML = new XML( byteArray.readUTFBytes( byteArray.length ) );
			
			// Add each flag to the array
			for each ( var flagXML : XML in this.eventFlagXML.children() ) 
			{
				var newFlag : TinyEventFlag = new TinyEventFlag( flagXML.text() ); 
				this.eventFlags.push( newFlag );
				
				TinyLogManager.log( 'add event flag: ' + newFlag.name + ', ' + newFlag.value, this );
			}			
		}
		
		
		public function restoreFromJSON( jsonObject : Object ) : void
		{
			TinyLogManager.log( 'restoreFromJSON', this );
		}
		
		
		public function toJSON() : Array
		{
			var jsonArray : Array = [];
			
			for each ( var flag : TinyEventFlag in this.eventFlags )
			{
				jsonArray.push( flag.toJSON() );
			}
			
			return jsonArray;
		}
		
		
		public function getFlagByName( targetName : String ) : TinyEventFlag
		{
			TinyLogManager.log( 'getFlagByName: ' + targetName, TinyEventFlagLookup );
			
			var findFunction : Function = function( item : *, index : int, array : Array ) : Boolean
			{ 
				index; 
				array; 
				
				return ( ( item as TinyEventFlag ).name.toUpperCase() == targetName.toUpperCase() ); 
			};
				
			return this.eventFlags.filter( findFunction )[ 0 ];			
		}
		
		
		public static function getInstance() : TinyEventFlagLookup
		{
			return instance;
		}		
	}
}
