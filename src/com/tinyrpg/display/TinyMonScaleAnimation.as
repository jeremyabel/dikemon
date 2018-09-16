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
	 * Class which handles the "scale-in / out" animation played when a mon is summoned 
	 * or returned to their ball.
	 * 
	 * The animation itself emulates the Gameboy Color's fake sprite scale effect, which 
	 * simulates scaling by drawing specific 8x8 pieces of a mon in two stages. This works
	 * by dividing a mon's 48x48 sprite into a 6x6 grid and copying specific source cells to 
	 * specific destination cells. The animation works by copying cells from the source 
	 * grid onto a destination grid. The source grid is shown below:
	 * 
	 *	+----+----+----+----+----+----+
	 *	| 1  | 2  | 3  | 4  | 5  | 6  |
	 *	+----+----+----+----+----+----+
	 *	| 7  | 8  | 9  | 10 | 11 | 12 |
	 *	+----+----+----+----+----+----+
	 *	| 13 | 14 | 15 | 16 | 17 | 18 |
	 *	+----+----+----+----+----+----+
	 *	| 19 | 20 | 21 | 22 | 23 | 24 |
	 *	+----+----+----+----+----+----+
	 *	| 25 | 26 | 27 | 28 | 29 | 30 |
	 *	+----+----+----+----+----+----+
	 *	| 31 | 32 | 33 | 34 | 35 | 36 |
	 *	+----+----+----+----+----+----+ 
	 * 
	 * @author jeremyabel
	 */
	public class TinyMonScaleAnimation
	{
		private static const MON_SIZE : int = 56;
		private static const BORDER_SIZE : int = 4;
		
		/**
		 * Draws the first scale grid using a given source bitmap to a given destination bitmap.
		 * The source grid is drawn to the destination grid as follows:
		 * 
		 * +----+----+----+----+----+----+
		 * |    |    |    |    |    |    |
		 * +----+----+----+----+----+----+
		 * |    |    |    |    |    |    |
		 * +----+----+----+----+----+----+
		 * |    |    | 1  | 6  |    |    |
		 * +----+----+----+----+----+----+
		 * |    |    | 31 | 36 |    |    |
		 * +----+----+----+----+----+----+
		 * |    |    |    |    |    |    |
		 * +----+----+----+----+----+----+
		 * |    |    |    |    |    |    |
		 * +----+----+----+----+----+----+
		 */
		public static function drawScale1( srcBitmap : Bitmap, destBitmap : Bitmap ) : void 
		{
			clearBitmap( destBitmap );
			
			drawGridAtIndex( 1,  srcBitmap, 27, destBitmap );
			drawGridAtIndex( 6,  srcBitmap, 28, destBitmap );
			drawGridAtIndex( 31, srcBitmap, 33, destBitmap );
			drawGridAtIndex( 36, srcBitmap, 34, destBitmap );
		}
		
		/**
		 * Draws the second scale grid using a given source bitmap to a given destination bitmap.
		 * The source grid is drawn to the destination grid as follows:
		 * 
		 * +----+----+----+----+----+----+
		 * |    |    |    |    |    |    |
		 * +----+----+----+----+----+----+
		 * |    | 1  | 3  | 4  | 6  |    |
		 * +----+----+----+----+----+----+
		 * |    | 13 | 15 | 16 | 18 |    |
		 * +----+----+----+----+----+----+
		 * |    | 19 | 21 | 22 | 24 |    |
		 * +----+----+----+----+----+----+
		 * |    | 31 | 33 | 34 | 36 |    |
		 * +----+----+----+----+----+----+
		 * |    |    |    |    |    |    |
		 * +----+----+----+----+----+----+
		 */
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
		
		/**
		 * Copies a grid cell from a given source index to a given destination index.
		 * 
		 * @param	scrIndex	Index in the source grid to copy from.
		 * @param	srcBitmap	Bitmap to copy from.	
		 * @param	destIndex	Index in the destination grid to copy to.
		 * @param	destBitap	Bitmap to copy to.
		 */
		private static function drawGridAtIndex( srcIndex : int, srcBitmap : Bitmap, destIndex : int, destBitmap : Bitmap ) : void
		{
			// Calculate the source rectangle from the source index
			var srcX : int = 8 * ( ( srcIndex - 1 ) % 6 );
			var srcY : int = 8 * Math.floor( ( srcIndex - 1 ) / 6 );
			var srcW : int = 8;
			var srcH : int = 8;
			
			// Calculate the destination origin point from the destination index
			var destX : int = 8 * ( ( destIndex - 1 ) % 6 );
			var destY : int = 8 * Math.floor( ( destIndex - 1 ) / 6 );
			
			// The grid is for a 48x48 sprite split into a 6x6 grid, but the actual mon sprites are 56x56 due to an added
			// 4-pixel border around the entire sprite. This needs to be taken into account when calculating the grid
			// coordinates.
			
			// Compensate for border
			srcX += BORDER_SIZE;
			srcY += BORDER_SIZE;
			destX += BORDER_SIZE;
			destY += BORDER_SIZE;
	
			// Adjust the top border
			if ( srcIndex <= 6 )
			{
				srcY -= BORDER_SIZE;
				srcH += BORDER_SIZE;
				destY -= BORDER_SIZE;
			}
			
			// Adjust the bottom border
			if ( srcIndex >= 31 )
			{	
				srcH += BORDER_SIZE;
			}
			
			// Adjust the left border
			if ( ( srcIndex - 1 ) % 6 == 0 )
			{
				srcX -= BORDER_SIZE;
				srcW += BORDER_SIZE;
				destX -= BORDER_SIZE;
			}
			
			// Adjust the right border
			if ( srcIndex % 6 == 0 )
			{
				srcW += BORDER_SIZE;
			}
	
			// Copy grid segment to destination the bitmap				
			var srcRect : Rectangle = new Rectangle( srcX, srcY, srcW, srcH );
			var destPoint : Point = new Point( destX, destY );
			destBitmap.bitmapData.copyPixels( srcBitmap.bitmapData, srcRect, destPoint );
		}
	
		private static function clearBitmap( bitmap : Bitmap ) : void
		{
			var clearRect = new Rectangle( 0, 0, MON_SIZE, MON_SIZE );
			bitmap.bitmapData.fillRect( clearRect, 0xFFFFFFFF );
		}
	}
}