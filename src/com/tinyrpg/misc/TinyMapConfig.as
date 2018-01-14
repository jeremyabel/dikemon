package com.tinyrpg.misc 
{
	import com.tinyrpg.display.TinyMapMovieClip;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.display.maps.*;

	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author jeremyabel
	 */
	public class TinyMapConfig 
	{
		private static const MAP_CITY					: String = 'CITY';
		private static const MAP_CITYBOAT				: String = 'CITYBOAT';
		private static const MAP_CITYDIKECENTER			: String = 'CITYDIKECENTER';
		private static const MAP_CITYDIKEMART			: String = 'CITYDIKEMART';
		private static const MAP_CITYHOUSE1				: String = 'CITYHOUSE1';
		private static const MAP_CITYHOUSE2				: String = 'CITYHOUSE2';
		private static const MAP_CITYHOUSE3				: String = 'CITYHOUSE3';
		private static const MAP_OFFICERECEPTION		: String = 'OFFICERECEPTION';
		private static const MAP_OFFICEFLOOR2			: String = 'OFFICEFLOOR2';
		private static const MAP_OFFICEFLOOR3			: String = 'OFFICEFLOOR3';
		private static const MAP_TOWN					: String = 'TOWN';
		private static const MAP_TOWNHOUSE1				: String = 'TOWNHOUSE1';
		private static const MAP_TOWNHOUSE2				: String = 'TOWNHOUSE2';
		private static const MAP_TOWNHOUSEPLAYERFLOOR1	: String = 'TOWNHOUSEPLAYERFLOOR1';
		private static const MAP_TOWNHOUSEPLAYERFLOOR2	: String = 'TOWNHOUSEPLAYERFLOOR2';
		private static const MAP_TOWNHOUSEPROFESSOR		: String = 'TOWNHOUSEPROFESSOR';
		private static const MAP_ISLANDLAKEENTRANCE		: String = 'ISLANDLAKEENTRANCE';
		private static const MAP_ISLANDLAKECAVE			: String = 'ISLANDLAKECAVE';
		private static const MAP_ISLANDLAKE				: String = 'ISLANDLAKE';
		private static const MAP_ISLANDCAVEENTRANCE		: String = 'ISLANDCAVEENTRANCE';
		private static const MAP_ISLANDCAVESIDE			: String = 'ISLANDCAVESIDE';
		private static const MAP_ISLANDCAVE				: String = 'ISLANDCAVE';
		private static const MAP_ISLANDFORESTENTRANCE	: String = 'ISLANDFORESTENTRANCE';
		private static const MAP_ISLANDFOREST			: String = 'ISLANDFOREST';
		private static const MAP_ISLANDBOATEXIT			: String = 'ISLANDBOATEXIT';
		private static const MAP_ROUTE29				: String = 'ROUTE29';
		
		// City
		[Embed(source='../../../../bin/xml/Events/City/City.xml', mimeType='application/octet-stream')] 					public static const City_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/City/CityBoat.xml', mimeType='application/octet-stream')] 				public static const CityBoat_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/City/CityCenter.xml', mimeType='application/octet-stream')] 				public static const CityDikecenter_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/City/CityMart.xml', mimeType='application/octet-stream')] 				public static const CityDikemart_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/City/CityHouse1.xml', mimeType='application/octet-stream')] 				public static const CityHouse1_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/City/CityHouse2.xml', mimeType='application/octet-stream')] 				public static const CityHouse2_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/City/CityHouse3.xml', mimeType='application/octet-stream')] 				public static const CityHouse3_Events_XML : Class;
		
		// Office
		[Embed(source='../../../../bin/xml/Events/Office/OfficeReception.xml', mimeType='application/octet-stream')] 		public static const OfficeReception_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Office/OfficeFloor2.xml', mimeType='application/octet-stream')] 			public static const OfficeFloor2_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Office/OfficeFloor3.xml', mimeType='application/octet-stream')] 			public static const OfficeFloor3_Events_XML : Class;
		
		// Town
		[Embed(source='../../../../bin/xml/Events/Town/Town.xml', mimeType='application/octet-stream')] 					public static const Town_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Town/TownHouse1.xml', mimeType='application/octet-stream')] 				public static const TownHouse1_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Town/TownHouse2.xml', mimeType='application/octet-stream')] 				public static const TownHouse2_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Town/TownHousePlayerFloor1.xml', mimeType='application/octet-stream')] 	public static const TownHousePlayerFloor1_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Town/TownHousePlayerFloor2.xml', mimeType='application/octet-stream')] 	public static const TownHousePlayerFloor2_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Town/TownHouseProf.xml', mimeType='application/octet-stream')] 			public static const TownHouseProf_Events_XML : Class;
		
		// Island: Lake
		[Embed(source='../../../../bin/xml/Events/Island/IslandLakeEntrance.xml', mimeType='application/octet-stream')] 	public static const IslandLakeEntrance_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Island/IslandLakeCave.xml', mimeType='application/octet-stream')] 		public static const IslandLakeCave_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Island/IslandLake.xml', mimeType='application/octet-stream')] 			public static const IslandLake_Events_XML : Class;
		
		// Island: Cave
		[Embed(source='../../../../bin/xml/Events/Island/IslandCaveEntrance.xml', mimeType='application/octet-stream')] 	public static const IslandCaveEntrance_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Island/IslandCaveSide.xml', mimeType='application/octet-stream')] 		public static const IslandCaveSide_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Island/IslandCave.xml', mimeType='application/octet-stream')] 			public static const IslandCave_Events_XML : Class;
		
		// Island: Forest
		[Embed(source='../../../../bin/xml/Events/Island/IslandForestEntrance.xml', mimeType='application/octet-stream')] 	public static const IslandForestEntrance_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Island/IslandForest.xml', mimeType='application/octet-stream')] 			public static const IslandForest_Events_XML : Class;
		
		// Island: Boat
		[Embed(source='../../../../bin/xml/Events/Island/IslandBoatExit.xml', mimeType='application/octet-stream')] 		public static const IslandBoatExit_Events_XML : Class;
		
		// Misc
		[Embed(source='../../../../bin/xml/Events/Misc/Route29.xml', mimeType='application/octet-stream')] 					public static const Route29_Events_XML : Class;
		
		public function TinyMapConfig() : void { }
		
		public static function getMapFromName( mapName : String ) : TinyMapMovieClip 
		{
			TinyLogManager.log( 'getMapFromName: ' + mapName, TinyMapConfig );
			
			switch ( mapName.toUpperCase() ) 
			{
				// City
				case MAP_CITY: 					return new MapCity;
				case MAP_CITYBOAT:				return new MapCityBoat;
				case MAP_CITYDIKECENTER: 		return new MapCityDikecenter;
				case MAP_CITYDIKEMART: 			return new MapCityDikemart;
				case MAP_CITYHOUSE1: 			return new MapCityHouse1;
				case MAP_CITYHOUSE2: 			return new MapCityHouse2;
				case MAP_CITYHOUSE3: 			return new MapCityHouse3;
				
				// Office
				case MAP_OFFICERECEPTION:		return new MapOfficeReception;
				case MAP_OFFICEFLOOR2:			return new MapOfficeFloor2;
				case MAP_OFFICEFLOOR3:			return new MapOfficeFloor3;
				
				// Town
				case MAP_TOWN:					return new MapTown;
				case MAP_TOWNHOUSE1:			return new MapTownHouse1;
				case MAP_TOWNHOUSE2:			return new MapTownHouse2;
				case MAP_TOWNHOUSEPLAYERFLOOR1:	return new MapTownHousePlayerFloor1;
				case MAP_TOWNHOUSEPLAYERFLOOR2:	return new MapTownHousePlayerFloor2;
				case MAP_TOWNHOUSEPROFESSOR:	return new MapTownHouseProfessor;
				
				// Island: Lake	
				case MAP_ISLANDLAKEENTRANCE:	return new MapIslandLakeEntrance;
				case MAP_ISLANDLAKECAVE:		return new MapIslandLakeCave;
				case MAP_ISLANDLAKE:			return new MapIslandLake;
				
				// Island: Cave
				case MAP_ISLANDCAVEENTRANCE:	return new MapIslandCaveEntrance;
				case MAP_ISLANDCAVESIDE:		return new MapIslandCaveSide;
				case MAP_ISLANDCAVE:			return new MapIslandCave;
				
				// Island: Forest
				case MAP_ISLANDFORESTENTRANCE:	return new MapIslandForestEntrance;
				case MAP_ISLANDFOREST:			return new MapIslandForest;
				
				// Island: Boat
				case MAP_ISLANDBOATEXIT:		return new MapIslandBoatExit; 
				
				// Misc
				case MAP_ROUTE29:				return new MapRoute29;
				
				default:						return new MapTownHousePlayerFloor2;
			}
		}
	
		public static function getMapEventXMLFromName( mapName : String ) : XML
		{
			TinyLogManager.log( 'getMapEventXMLFromName: ' + mapName, TinyMapConfig );
				
				var newXMLBytes : ByteArray;
				
				switch ( mapName.toUpperCase() )
				{
					// City
					case MAP_CITY: 					newXMLBytes = City_Events_XML as ByteArray; break;
					case MAP_CITYBOAT:				newXMLBytes = CityBoat_Events_XML as ByteArray; break;
					case MAP_CITYDIKECENTER: 		newXMLBytes = CityDikecenter_Events_XML as ByteArray; break;
					case MAP_CITYDIKEMART: 			newXMLBytes = CityDikemart_Events_XML as ByteArray; break;
					case MAP_CITYHOUSE1: 			newXMLBytes = CityHouse1_Events_XML as ByteArray; break;
					case MAP_CITYHOUSE2: 			newXMLBytes = CityHouse2_Events_XML as ByteArray; break;
					case MAP_CITYHOUSE3: 			newXMLBytes = CityHouse3_Events_XML as ByteArray; break;
					
					// Office
					case MAP_OFFICERECEPTION:		newXMLBytes = OfficeReception_Events_XML as ByteArray; break;
					case MAP_OFFICEFLOOR2:			newXMLBytes = OfficeFloor2_Events_XML as ByteArray; break;
					case MAP_OFFICEFLOOR3:			newXMLBytes = OfficeFloor3_Events_XML as ByteArray; break;
					
					// Town
					case MAP_TOWN:					newXMLBytes = Town_Events_XML as ByteArray; break;
					case MAP_TOWNHOUSE1:			newXMLBytes = TownHouse1_Events_XML as ByteArray; break;
					case MAP_TOWNHOUSE2:			newXMLBytes = TownHouse2_Events_XML as ByteArray; break;
					case MAP_TOWNHOUSEPLAYERFLOOR1:	newXMLBytes = TownHousePlayerFloor1_Events_XML as ByteArray; break;
					case MAP_TOWNHOUSEPLAYERFLOOR2:	newXMLBytes = TownHousePlayerFloor2_Events_XML as ByteArray; break;
					case MAP_TOWNHOUSEPROFESSOR:	newXMLBytes = TownHouseProf_Events_XML as ByteArray; break;
					
					// Island: Lake	
					case MAP_ISLANDLAKEENTRANCE:	newXMLBytes = IslandLakeEntrance_Events_XML as ByteArray; break;
					case MAP_ISLANDLAKECAVE:		newXMLBytes = IslandLakeCave_Events_XML as ByteArray; break;
					case MAP_ISLANDLAKE:			newXMLBytes = IslandLake_Events_XML as ByteArray; break;
					
					// Island: Cave
					case MAP_ISLANDCAVEENTRANCE:	newXMLBytes = IslandCaveEntrance_Events_XML as ByteArray; break;
					case MAP_ISLANDCAVESIDE:		newXMLBytes = IslandCaveSide_Events_XML as ByteArray; break;
					case MAP_ISLANDCAVE:			newXMLBytes = IslandCave_Events_XML as ByteArray; break;
					
					// Island: Forest
					case MAP_ISLANDFORESTENTRANCE:	newXMLBytes = IslandForestEntrance_Events_XML as ByteArray; break;
					case MAP_ISLANDFOREST:			newXMLBytes = IslandForest_Events_XML as ByteArray; break;
					
					// Island: Boat
					case MAP_ISLANDBOATEXIT:		newXMLBytes = IslandBoatExit_Events_XML as ByteArray; break;
					
					// Misc
					case MAP_ROUTE29:				newXMLBytes = Route29_Events_XML as ByteArray; break;
					
					default: 						newXMLBytes = TownHousePlayerFloor2_Events_XML as ByteArray; break;
				}
				
				var string : String = newXMLBytes.readUTFBytes( newXMLBytes.length );			
				return new XML( string );
		}
	}
}
