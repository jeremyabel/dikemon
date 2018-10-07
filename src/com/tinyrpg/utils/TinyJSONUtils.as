package com.tinyrpg.utils 
{
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyItemDataList;
	import com.tinyrpg.data.TinyFieldMapObjectWarp;
	
	import flash.geom.Point;
	
	/**
	 * Class which contains static functions for serializing various game structures to JSON.
	 * 
	 * Used for generating save game data.
	 * 
	 * @author jeremyabel
	 */
	public class TinyJSONUtils 
	{
		public static function monSquadToJSONArray( squad : Array ) : Array
		{
			var monJSONArray : Array = [];
			
			for each ( var mon : TinyMon in squad ) 
			{
				monJSONArray.push( mon.toJSON() );
			}
			
			return monJSONArray;
		}
		
		
		public static function inventoryToJSONArray( inventory : Array ) : Array
		{
			var inventoryJSONArray : Array = [];
			
			for each ( var item : TinyItem in inventory )
			{
				inventoryJSONArray.push( item.toJSON() );
			}
			
			return inventoryJSONArray;
		}
		
		
		public static function pointToJSON( point : Point ) : Object
		{
			var jsonObject : Object = {};
			
			jsonObject.x = point.x;
			jsonObject.y = point.y;
			
			return jsonObject;			
		}
		
		
		public static function parseMonSquadJSON( jsonArray : Array ) : Array
		{
			var squad : Array = [];
			
			for each ( var jsonObject : Object in jsonArray ) 
			{
				squad.push( TinyMon.newFromJSON( jsonObject ) );
			}
			
			return squad;
		}
		
		
		public static function parseInventoryJSON( jsonArray : Array ) : Array
		{
			var inventory : Array = [];
			
			for each ( var jsonObject : Object in jsonArray ) 
			{
				inventory.push( TinyItemDataList.getInstance().newItemFromJSON( jsonObject ) );
			}
			
			return inventory;
		}
		
		
		public static function parseWarpObjectJSON( jsonObject : Object ) : TinyFieldMapObjectWarp
		{
			var warpObject : TinyFieldMapObjectWarp = new TinyFieldMapObjectWarp();
			
			warpObject.targetMapName = jsonObject.currentMap;
			warpObject.useGridPos = true;
			warpObject.gridPosX = jsonObject.position.x;
			warpObject.gridPosY = jsonObject.position.y; 
			warpObject.destinationFacing = 'DOWN';
			
			return warpObject;
		}
	}
}