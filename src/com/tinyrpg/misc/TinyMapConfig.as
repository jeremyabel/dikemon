package com.tinyrpg.misc 
{
	import com.tinyrpg.display.TinyMapMovieClip;
	import com.tinyrpg.display.maps.Map_Andy_Entrance;
	import com.tinyrpg.display.maps.Map_Andy_Room;
	import com.tinyrpg.display.maps.Map_Asa_River;
	import com.tinyrpg.display.maps.Map_Computer_Room;
	import com.tinyrpg.display.maps.Map_Fair;
	import com.tinyrpg.display.maps.Map_Fair_Entrance;
	import com.tinyrpg.display.maps.Map_Fish_Antechamber;
	import com.tinyrpg.display.maps.Map_Fish_Chamber;
	import com.tinyrpg.display.maps.Map_Fish_Pre_Antechamber;
	import com.tinyrpg.display.maps.Map_Forest;
	import com.tinyrpg.display.maps.Map_Megan_Room;
	import com.tinyrpg.display.maps.Map_Rachel_Farm;
	import com.tinyrpg.maps.TinyCastleMap;
	import com.tinyrpg.maps.TinyLoungeMap;
	import com.tinyrpg.maps.TinyRalphRedRoomMap;
	import com.tinyrpg.maps.TinyRonBaseMap;
	import com.tinyrpg.maps.TinyWeirdPlaceMap;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author jeremyabel
	 */
	public class TinyMapConfig 
	{
		public function TinyMapConfig() : void
		{
				
		}
		
		public static function getMapFromName(mapName : String) : TinyMapMovieClip 
		{
			TinyLogManager.log('getMapFromName: ' + mapName, TinyMapConfig);
			
			var returnMap : TinyMapMovieClip;
			switch (mapName.toUpperCase()) 
			{
				case 'MAP_ANDY_ENTRANCE':
					returnMap = new Map_Andy_Entrance;
					break;
				case 'MAP_ANDY_ROOM':
					returnMap = new Map_Andy_Room;
					break;
				case 'MAP_ASA_RIVER':
					returnMap = new Map_Asa_River;
					break;
				case 'MAP_CASTLE_ENTRANCE':
					returnMap = new TinyCastleMap;
					break;
				case 'MAP_COMPUTER_ROOM':
					returnMap = new Map_Computer_Room;
					break;
				case 'MAP_FISH_PRE_ANTECHAMBER':
					returnMap = new Map_Fish_Pre_Antechamber;
					break;
				case 'MAP_FISH_ANTECHAMBER':
					returnMap = new Map_Fish_Antechamber;
					break;
				case 'MAP_FISH_CHAMBER':
					returnMap = new Map_Fish_Chamber;
					break;
				case 'MAP_FAIR':
					returnMap = new Map_Fair;
					break;
				case 'MAP_FAIR_ENTRANCE':
					returnMap = new Map_Fair_Entrance;
					break;
				case 'MAP_FOREST':
					returnMap = new Map_Forest;
					break;
				case 'MAP_LOUNGE':
					returnMap = new TinyLoungeMap;
					break;
				case 'MAP_MEGAN_ROOM':
					returnMap = new Map_Megan_Room;
					break;
				case 'MAP_RACHEL_FARM':
					returnMap = new Map_Rachel_Farm;
					break;
				case 'MAP_RALPH_RED_ROOM':
					returnMap = new TinyRalphRedRoomMap;
					break;
				case 'MAP_RON_BASE':
					returnMap = new TinyRonBaseMap;
					break;
				case 'MAP_WEIRD_PLACE':
					returnMap = new TinyWeirdPlaceMap;
					break;
			}
			return returnMap;
		}
		
		public static function getMapNameFromClip(mapClip : TinyMapMovieClip) : String
		{
			var mapName : String = getQualifiedClassName(mapClip).split('::')[1];
			TinyLogManager.log('getMapNameFromClip: ' + mapName, TinyMapConfig);
			
			// Correct some map names
			if (mapName == 'TinyCastleMap')  mapName = 'Map_Castle_Entrance';
			if (mapName == 'TinyLoungeMap')  mapName = 'Map_Lounge';
			if (mapName == 'TinyRonBaseMap') mapName = 'Map_Ron_Base';
			if (mapName == 'TinyWeirdPlaceMap') mapName = 'Map_Weird_Place';
			if (mapName == 'TinyRalphRedRoomMap') mapName = 'Map_Ralph_Red_Room';
			
			return mapName;
		}
	}
	
}
