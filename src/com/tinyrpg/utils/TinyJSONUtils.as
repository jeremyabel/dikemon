package com.tinyrpg.utils 
{
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyMon;
	
	import flash.geom.Point;
	
	/**
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
	}
}