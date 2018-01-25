package com.tinyrpg.lookup
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.utils.ByteArray;

	/**
	 * @author jeremyabel
	 */
	public class TinyMonLookup
	{
		[Embed(source='../../../../bin/xml/Monsters.xml', mimeType='application/octet-stream')]
		private static const XML_Monsters : Class;
		
		public static const MON_BOX 			: String = 'BOX';
		public static const MON_BUCKET			: String = 'BUCKET';
		public static const MON_SHORTS_KID		: String = 'SHORTS KID';
		public static const MON_EGG				: String = 'EGG';
		public static const MON_SHOE			: String = 'SHOE';
		public static const MON_TALL_GRASS		: String = 'TALL GRASS';
		public static const MON_COMPUTER		: String = 'COMPUTER';
		public static const MON_ACE_OF_SPADES 	: String = 'ACE OF SPADES';
		public static const MON_FOUR_OF_CLUBS	: String = 'FOUR OF CLUBS';
		
		private static var instance : TinyMonLookup = new TinyMonLookup;
		
		private var monData : XML;
		
		public function TinyMonLookup() : void
		{ 
		
		}
		
		public function initMonsterData() : void
		{
			TinyLogManager.log( 'initMonsterData', this );
			
			// Get monster data from XML if it doesn't exist already
			if ( !this.monData )
			{
				var byteArray : ByteArray = ( new XML_Monsters() ) as ByteArray;
				var string : String = byteArray.readUTFBytes( byteArray.length );
				this.monData = new XML( string );
			}
		}

		public static function getInstance() : TinyMonLookup
		{
			return instance;
		}		
		
		public function getMonByName( monName : String, level : uint = 5 ) : TinyMon
		{
			TinyLogManager.log( 'getMonByName: ' + monName, this );
			
			var monXML : XML = this.monData.MON.( NAME.toUpperCase() == monName.toUpperCase() )[ 0 ];
			
			if ( monXML ) return new TinyMon( monXML, level );
			return null;
		}
		
	}
}
