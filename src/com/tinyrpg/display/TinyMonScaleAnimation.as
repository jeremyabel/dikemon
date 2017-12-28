package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.tinyrpg.utils.TinyLogManager;
	
		
	/**
	 * @author jeremyabel
	 */
	public class TinyMonScaleAnimation
	{
		private static const MON_SIZE : int = 56;
		private static const BORDER_SIZE : int = 4;
		
		public static function drawScale1( srcBitmap : Bitmap, destBitmap : Bitmap ) : void 
		{
			clearBitmap( destBitmap );
			
			drawGridAtIndex( 1,  srcBitmap, 27, destBitmap );
			drawGridAtIndex( 6,  srcBitmap, 28, destBitmap );
			drawGridAtIndex( 31, srcBitmap, 33, destBitmap );
			drawGridAtIndex( 36, srcBitmap, 34, destBitmap );
		}
		
		public static function drawScale2( srcBitmap : Bitmap, destBitmap : Bitmap ) : void
		{
			clearBitmap( destBitmap );
			
			drawGridAtIndex( 1,  srcBitmap, 14, destBitmap );
			drawGridAtIndex( 3,  srcBitmap, 15, destBitmap );
			drawGridAtIndex( 4,  srcBitmap, 16, destBitmap );
			drawGridAtIndex( 6,  srcBitmap, 17, destBitmap );
			
			drawGridAtIndex( 13, srcBitmap, 20, destBitmap );
			drawGridAtIndex( 15, srcBitmap, 21, destBitmap );
			drawGridAtIndex( 16, srcBitmap, 22, destBitmap );
			drawGridAtIndex( 18, srcBitmap, 23, destBitmap );
			
			drawGridAtIndex( 19, srcBitmap, 26, destBitmap );
			drawGridAtIndex( 21, srcBitmap, 27, destBitmap );
			drawGridAtIndex( 22, srcBitmap, 28, destBitmap );
			drawGridAtIndex( 24, srcBitmap, 29, destBitmap );
			
			drawGridAtIndex( 31, srcBitmap, 32, destBitmap );
			drawGridAtIndex( 33, srcBitmap, 33, destBitmap );
			drawGridAtIndex( 34, srcBitmap, 34, destBitmap );
			drawGridAtIndex( 36, srcBitmap, 35, destBitmap );
		}
		
		public static function drawGridAtIndex( srcIndex : int, srcBitmap : Bitmap, destIndex : int, destBitmap : Bitmap ) : void
		{
			var srcX : int = 8 * ( ( srcIndex - 1 ) % 6 );
			var srcY : int = 8 * Math.floor( ( srcIndex - 1 ) / 6 );
			var srcW : int = 8;
			var srcH : int = 8;
			
			var destX : int = 8 * ( ( destIndex - 1 ) % 6 );
			var destY : int = 8 * Math.floor( ( destIndex - 1 ) / 6 );
			
			// Compensate for border
			srcX += BORDER_SIZE;
			srcY += BORDER_SIZE;
			destX += BORDER_SIZE;
			destY += BORDER_SIZE;
	
			// Adjust top border
			if ( isTopBorder( srcIndex ) )
			{
				srcY -= BORDER_SIZE;
				srcH += BORDER_SIZE;
				destY -= BORDER_SIZE;
			}
			
			// Adjust bottom border
			if ( isBottomBorder( srcIndex ) )
			{	
				srcH += BORDER_SIZE;
			}
			
			// Adjust left border
			if ( isLeftBorder( srcIndex ) )
			{
				srcX -= BORDER_SIZE;
				srcW += BORDER_SIZE;
				destX -= BORDER_SIZE;
			}
			
			// Adjust right border
			if ( isRightBorder( srcIndex ) )
			{
				srcW += BORDER_SIZE;
			}
	
			// Copy grid segment to destination the bitmap				
			var srcRect : Rectangle = new Rectangle( srcX, srcY, srcW, srcH );
			var destPoint : Point = new Point( destX, destY );
			destBitmap.bitmapData.copyPixels( srcBitmap.bitmapData, srcRect, destPoint );
		}
		
		private static function isTopBorder( index : int ) : Boolean
		{
			if ( index <= 6 ) return true;
			return false;
		}
		
		private static function isBottomBorder( index : int ) : Boolean
		{
			if ( index >= 31 ) return true;
			return false;
		}
		
		private static function isLeftBorder( index : int ) : Boolean
		{
			if ( ( index - 1 ) % 6 == 0 ) return true;
			return false;
		}
		
		private static function isRightBorder( index : int ) : Boolean
		{
			if ( index % 6 == 0 ) return true;
			return false;
		}
		
		private static function clearBitmap( bitmap : Bitmap ) : void
		{
			var clearRect = new Rectangle( 0, 0, MON_SIZE, MON_SIZE );
			bitmap.bitmapData.fillRect( clearRect, 0xFFFFFFFF );
		}
	}
}