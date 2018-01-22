package com.tinyrpg.data
{
	import flash.geom.Point;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyPositionXMLData extends Point 
	{
		public var gridX : int;
		public var gridY : int;
		
		public function TinyPositionXMLData() : void { }	
		
		public static function newFromXML( xmlData : XMLList ) : TinyPositionXMLData
		{
			var newPositionData : TinyPositionXMLData = new TinyPositionXMLData;
			
			// Get position coordinates
			newPositionData.x = int( xmlData.child( 'X' ) );
			newPositionData.y = int( xmlData.child( 'Y' ) );
			
			newPositionData.gridX = int( xmlData.child( 'X' ) );
			newPositionData.gridY = int( xmlData.child( 'Y' ) );
			
			// Adjust coordinates for tile data
			if ( xmlData.attribute( 'tiles' ) )
			{
				newPositionData.x *= 16;
				newPositionData.y *= 16;
			}
			
			return newPositionData;
		}
	}
}