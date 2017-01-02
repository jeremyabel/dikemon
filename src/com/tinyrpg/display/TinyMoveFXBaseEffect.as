package com.tinyrpg.display 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * @author jeremyabel
	 */
	public class TinyMoveFXBaseEffect 
	{
		public static const AREA_PLAYER				: String = 'PLAYER';
		public static const AREA_ENEMY 				: String = 'ENEMY'; 
		public static const AREA_BOTH				: String = 'BOTH';
		
		public var origBitmapData : BitmapData;
		
		protected var type : String;
		protected var area : String;
			
		protected function getAreaRectangles( area : String ) : Object
		{
			var areaRects : Object = new Object();
			
			areaRects[ 'mon' ] = new Object();
			areaRects[ 'stat' ] = new Object();
			
			switch ( area )
			{
				case AREA_PLAYER:
				{
					areaRects[ 'mon' ][ 'player' ]  = new Rectangle( 0, 50, 76, 48 );
					areaRects[ 'mon' ][ 'enemy' ]   = null;
					areaRects[ 'stat' ][ 'player' ] = new Rectangle( 76, 58, 112, 40 );
					areaRects[ 'stat' ][ 'enemy' ]  = null;
					break;
				}
				
				case AREA_ENEMY:
				{
					areaRects[ 'mon' ][ 'player' ]  = null;
					areaRects[ 'mon' ][ 'enemy' ]   = new Rectangle( 86, 0, 74, 56 );
					areaRects[ 'stat' ][ 'player' ] = null;
					areaRects[ 'stat' ][ 'enemy' ]  = new Rectangle( 0, 0, 86, 40 );
					break;
				}
				
				case AREA_BOTH:
				{
					areaRects[ 'mon' ][ 'player' ]  = new Rectangle( 0, 50, 76, 48 );
					areaRects[ 'stat' ][ 'player' ] = new Rectangle( 76, 58, 112, 40 );
					areaRects[ 'mon' ][ 'enemy' ]   = new Rectangle( 86, 0, 74, 56 );
					areaRects[ 'stat' ][ 'enemy' ]  = new Rectangle( 0, 0, 86, 40 );	
					break;
				}
			}
			
			return areaRects;
		}
	}
}
