package com.tinyrpg.lookup
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.utils.ByteArray;

	/**
	 * Singleton class which provides lookup functions relating to {@link TinyMon}s.
	 * 
	 * The mon data is stored in the Monsters.xml file.
	 * 
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
		public static const MON_FAX_MACHINE		: String = 'FAX MACHINE';
		public static const MON_ACE_OF_SPADES 	: String = 'ACE OF SPADES';
		public static const MON_FOUR_OF_CLUBS	: String = 'FOUR OF CLUBS';
		public static const MON_HUMAN_GAGNON	: String = 'GAGNON';
		public static const MON_HUMAN_MARUSKA	: String = 'MARUSKA';
		public static const MON_HUMAN_ALEX		: String = 'ALEX';
		public static const MON_HUMAN_BILL		: String = 'BILL';
		public static const MON_HUMAN_BRENTON	: String = 'BRENTON';
		public static const MON_HUMAN_CHRIS		: String = 'CHRIS';
		public static const MON_HUMAN_DAVE		: String = 'DAVE';
		public static const MON_HUMAN_STARK		: String = 'STARK';
		public static const MON_HUMAN_JASON		: String = 'JASON';
		public static const MON_HUMAN_KRISTI	: String = 'KRISTI';
		public static const MON_HUMAN_CLEGG		: String = 'CLEGG';
		public static const MON_HUMAN_ZIGGY		: String = 'ZIGGY';
		public static const MON_HUMAN_RACHEL	: String = 'RACHEL';
		public static const MON_HUMAN_RALPH		: String = 'RALPH';
		public static const MON_HUMAN_RON		: String = 'RON';
		public static const MON_HUMAN_QUINN		: String = 'QUINN';
		public static const MON_HUMAN_YULIA		: String = 'YULIA';
		
		private static var instance : TinyMonLookup = new TinyMonLookup;
		
		private var monData : XML;
		
		public function TinyMonLookup() : void
		{ 
		
		}
		
		/**
		 * Initializes the XML data
		 */
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
		
		/**
		 * Returns the XML for a mon with the given name, either regular name or human name.
		 */
		public function getMonXMLByName( monName : String, monHumanName : String = null ) : XML
		{
			if ( monHumanName )
			{
				TinyLogManager.log( 'getMonXMLByName: ' + monHumanName, this );
				return this.monData.MON.( HUMAN.toUpperCase() == monHumanName.toUpperCase() )[ 0 ];
			}
			else
			{
				TinyLogManager.log( 'getMonXMLByName: ' + monName, this );
				var monXML : XML = this.monData.MON.( NAME.toUpperCase() == monName.toUpperCase() )[ 0 ];	
			}
			
			return null;
		}
		
		/**
		 * Returns a {@link TinyMon} with a given name.
		 * 
		 * @param	monName		The name of the requested mon.
		 * @param	level		The level the mon should be at.
		 * @param	evolved		Whether or not the mon should be in the evolved state. 
		 */
		public function getMonByName( monName : String, level : uint = 5, evolved : Boolean = false ) : TinyMon
		{
			TinyLogManager.log( 'getMonByName: ' + monName, this );
			
			var monXML : XML = this.monData.MON.( NAME.toUpperCase() == monName.toUpperCase() )[ 0 ];
			
			if ( monXML ) return new TinyMon( monXML, level, evolved );
			return null;
		} 
		
		/**
		 * Returns the mon with a given human name.
		 * 
		 * @param	humanName	The human name of the requested mon.
		 * @param	level		The level the mon should be at.
		 * @param	evolved		Whether or not the mon should be in the evolved state. 
		 */
		public function getMonByHuman( humanName : String, level : uint = 5, evolved : Boolean = false ) : TinyMon
		{
			TinyLogManager.log( 'getMonByHuman: ' + humanName, this );
			
			var monXML : XML = this.monData.MON.( HUMAN.toUpperCase() == humanName.toUpperCase() )[ 0 ];
			
			if ( monXML ) return new TinyMon( monXML, level, evolved );
			return null;
		}	
		
		/**
		 * Returns the singleton instance.
		 */
		public static function getInstance() : TinyMonLookup
		{
			return instance;
		}	
	}
}
