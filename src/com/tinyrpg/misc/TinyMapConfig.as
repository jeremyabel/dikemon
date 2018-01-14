package com.tinyrpg.misc 
{
	import com.tinyrpg.display.TinyMapMovieClip;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.display.maps.*;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author jeremyabel
	 */
	public class TinyMapConfig 
	{
		// Town
		[Embed(source='../../../../bin/xml/Events/Town/Town.xml', mimeType='application/octet-stream')] 					public static const Town_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Town/TownHouse1.xml', mimeType='application/octet-stream')] 				public static const TownHouse1_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Town/TownHouse2.xml', mimeType='application/octet-stream')] 				public static const TownHouse2_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Town/TownHousePlayerFloor1.xml', mimeType='application/octet-stream')] 	public static const TownHousePlayerFloor1_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Town/TownHousePlayerFloor2.xml', mimeType='application/octet-stream')] 	public static const TownHousePlayerFloor2_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Town/TownHouseProf.xml', mimeType='application/octet-stream')] 			public static const TownHouseProf_Events_XML : Class;
		
		// City
		[Embed(source='../../../../bin/xml/Events/City/City.xml', mimeType='application/octet-stream')] 					public static const City_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/City/CityBoat.xml', mimeType='application/octet-stream')] 				public static const CityBoat_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/City/CityCenter.xml', mimeType='application/octet-stream')] 				public static const CityCenter_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/City/CityHouse1.xml', mimeType='application/octet-stream')] 				public static const CityHouse1_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/City/CityHouse2.xml', mimeType='application/octet-stream')] 				public static const CityHouse2_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/City/CityHouse3.xml', mimeType='application/octet-stream')] 				public static const CityHouse3_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/City/CityMart.xml', mimeType='application/octet-stream')] 				public static const CityMart_Events_XML : Class;
		
		// Office
		[Embed(source='../../../../bin/xml/Events/Office/OfficeReception.xml', mimeType='application/octet-stream')] 		public static const OfficeReception_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Office/OfficeFloor2.xml', mimeType='application/octet-stream')] 			public static const OfficeFloor2_Events_XML : Class;
		[Embed(source='../../../../bin/xml/Events/Office/OfficeFloor3.xml', mimeType='application/octet-stream')] 			public static const OfficeFloor3_Events_XML : Class;
		
		// Misc
		[Embed(source='../../../../bin/xml/Events/Misc/Route29.xml', mimeType='application/octet-stream')] 					public static const Route29_Events_XML : Class;
		
		public function TinyMapConfig() : void { }
		
		public static function getMapFromName( mapName : String ) : TinyMapMovieClip 
		{
			TinyLogManager.log( 'getMapFromName: ' + mapName, TinyMapConfig );
			
			switch ( mapName.toUpperCase() ) 
			{
				// City
				case 'CITY': 					return new MapCity;
				case 'CITYBOAT':				return new MapCityBoat;
				case 'CITYDIKECENTER':			return new MapCityDikecenter;
				case 'CITYDIKEMART':			return new MapCityDikemart;
				case 'CITYHOUSE1':				return new MapCityHouse1;
				case 'CITYHOUSE2':				return new MapCityHouse2;
				case 'CITYHOUSE3':				return new MapCityHouse3;
				
				// City: Office
				case 'OFFICERECEPTION':			return new MapOfficeReception;
				case 'OFFICEFLOOR2':			return new MapOfficeFloor2;
				case 'OFFICEFLOOR3':			return new MapOfficeFloor3;
				
				// Town
				case 'TOWN':					return new MapTown;
				case 'TOWNHOUSE1':				return new MapTownHouse1;
				case 'TOWNHOUSE2':				return new MapTownHouse2;
				case 'TOWNHOUSEPLAYERFLOOR1':	return new MapTownHousePlayerFloor1;
				case 'TOWNHOUSEPLAYERFLOOR2':	return new MapTownHousePlayerFloor2;
				case 'TOWNHOUSEPROFESSOR':		return new MapTownHouseProfessor;
				
				// Island: Lake				
				case 'ISLANDLAKEENTRANCE':		return new MapIslandLakeEntrance;
				case 'ISLANDLAKECAVE':			return new MapIslandLakeCave;
				case 'ISLANDLAKE':				return new MapIslandLake;
				
				// Island: Cave
				case 'ISLANDCAVEENTRANCE':		return new MapIslandCaveEntrance;
				case 'ISLANDCAVESIDE':			return new MapIslandCaveSide;
				case 'ISLANDCAVE':				return new MapIslandCave;
				
				// Island: Forest
				case 'ISLANDFORESTENTRANCE':	return new MapIslandForestEntrance;
				case 'ISLANDFOREST':			return new MapIslandForest;
				
				// Island: Boat
				case 'ISLANDBOATEXIT':			return new MapIslandBoatExit; 
				
				// Misc
				case 'ROUTE29':					return new MapRoute29;
				
				default:						return new MapTownHousePlayerFloor2;
			}
		}
	}
}
