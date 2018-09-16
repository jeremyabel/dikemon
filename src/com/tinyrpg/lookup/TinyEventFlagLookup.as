package com.tinyrpg.lookup
{
	import com.tinyrpg.data.TinyEventFlag;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.utils.ByteArray;
	
	/**
	 * Singleton class which keeps track of the {@link TinyEventFlag}s used by the game.
	 * 
	 * The list of flags is specified in the Flags.xml file.
	 * 
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
		
		/**
		 * Restores the flag states from a given JSON array.
		 * Used when loading save game data.
		 */
		public function restoreFromJSON( jsonArray : Array ) : void
		{
			TinyLogManager.log( 'restoreFromJSON', this );
			
			for each ( var jsonObject : Object in jsonArray )
			{
				this.getFlagByName( jsonObject.name ).value = jsonObject.value;
			}
		}
		
		/**
		 * Returns a JSON array of all flag states.
		 * Used when writing save game data.
		 */
		public function toJSON() : Array
		{
			var jsonArray : Array = [];
			
			for each ( var flag : TinyEventFlag in this.eventFlags )
			{
				jsonArray.push( flag.toJSON() );
			}
			
			return jsonArray;
		}
		
		/**
		 * Returns the flag with a given target name, or null if no flag is found.
		 */
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
		
		/**
		 * Returns the singleton instance.
		 */
		public static function getInstance() : TinyEventFlagLookup
		{
			return instance;
		}		
	}
}
