package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import com.tinyrpg.display.OverworldChars;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyWalkSpriteSheet extends Sprite 
	{
		private var frontIdle	 : Bitmap;
		private var backIdle	 : Bitmap;
		private var sideIdle	 : Bitmap;
		private var frontStep	 : Bitmap;
		private var backStep	 : Bitmap;
		private var sideStep 	 : Bitmap;
		private var spriteHolder : Sprite;

		public function TinyWalkSpriteSheet( id : int )
		{
			this.spriteHolder = new Sprite();
			this.addChild( this.spriteHolder );
			
			var overworldCharData = new OverworldChars(); 
			
			var frontIdleBitmapData : BitmapData = new BitmapData( 16, 16 );
			var backIdleBitmapData  : BitmapData = new BitmapData( 16, 16 );
			var sideIdleBitmapData  : BitmapData = new BitmapData( 16, 16 );
			var frontStepBitmapData : BitmapData = new BitmapData( 16, 16 );
			var backStepBitmapData  : BitmapData = new BitmapData( 16, 16 );
			var sideStepBitmapData  : BitmapData = new BitmapData( 16, 16 );
			
			var bitmapDataArray : Array = [
				frontIdleBitmapData,
				backIdleBitmapData,
				sideIdleBitmapData,
				frontStepBitmapData,
				backStepBitmapData,
				sideStepBitmapData 
			];
			
			var bitmapArray : Array = [
			 	this.frontIdle,
				this.backIdle,
				this.sideIdle,
				this.frontStep,
				this.backStep,
				this.sideStep 
			];
			
			var currentX : uint = ( id % 8 ) * 16;
			var currentY : uint = Math.floor( id / 8 ) * 16;
			var copyRect : Rectangle = new Rectangle( currentX, currentY, 16, 16 );
			var destPoint : Point = new Point( 0, 0 );
			
			for ( var i : uint = 0; i < bitmapDataArray.length; i++ ) 
			{
				bitmapDataArray[ i ].copyPixels( overworldCharData, copyRect, destPoint );
				bitmapArray[ i ] = new Bitmap( bitmapDataArray[ i ] );
				bitmapArray[ i ].x = bitmapArray[ i ].y = -8;
				bitmapArray[ i ].x += i * 16;
				this.spriteHolder.addChild( bitmapArray[ i ] );
				
				currentX = ( currentX + 16 ) % 128;
				currentY = currentX == 0 ? currentY + 16 : currentY;
				copyRect = new Rectangle( currentX, currentY, 16, 16 );
			}
		}
		
//		public function play(playSpeed : int = 2) : void
//		{
//			this.isPlaying = true;
//			this.speed = playSpeed;
//				
//			//TinyLogManager.log('play: ' + this.speed, this);
//			
//			// Reset counters			
//			this.currentAFrame = 0;
//			this.currentBFrame = 0;
//			
//			// Make rectangle to copy with
//			var copyRect : Rectangle = new Rectangle(this.currentBFrame * this.tileSize, 0, this.tileSize, this.tileSize);
//			
//			// Make sure we don't copy what doesn't exist
//			copyRect.height = Math.min( this.tileSize, this.sourceData.height );
//			
//			if ( !this.playerBitmap ) 
//			{
//				// Prep bitmap
//				this.playerBitmap = new Bitmap(new BitmapData(this.tileSize, copyRect.height));
//				this.playerBitmap.x =
//				this.playerBitmap.y = -int(this.tileSize / 2);
//				
//				// Copy first frame
//				this.playerBitmap.bitmapData.copyPixels(this.sourceData, copyRect, new Point(0, 0));
//				// Add 'em up
//				this.addChild(this.playerBitmap);
//			} else {
//				// Copy first frame
//				this.playerBitmap.bitmapData.copyPixels(this.sourceData, copyRect, new Point(0, 0));
//			}
//			
//			// Only animate if we need to
//			if ( this.length > 1 ) 
//			{ 
//				if ( this.hasEventListener( Event.ENTER_FRAME ) ) 
//				{
//					this.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
//				}
//				
//				this.addEventListener( Event.ENTER_FRAME, onEnterFrame );
//			}
//		}
//		
//		public function playAndRemove( speed : int = 2 ) : void
//		{
//			this.play( speed );
//			this.remove = true;
//		}
//		
//		public function stopAndRemove() : void
//		{
//			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
//			this.isPlaying = false;
//			
//			if (this.playerBitmap) {
//				this.removeChild(this.playerBitmap);
//				this.playerBitmap.bitmapData.dispose();
//				this.playerBitmap = null;
//			}
//		}
//
//		protected function onEnterFrame(event : Event) : void
//		{
//			// Copy source pixels to viewing area
//			if (this.currentAFrame % this.speed == 0) 
//			{
//				var copyRect : Rectangle = new Rectangle(this.currentBFrame * this.tileSize, 0, this.tileSize, this.tileSize);
//			
//				// Make sure we don't copy what doesn't exist
//				copyRect.height = Math.min( this.tileSize, this.sourceData.height );
//				
//				this.playerBitmap.bitmapData.copyPixels(this.sourceData, copyRect, new Point(0, 0));
//				this.currentBFrame++;
//				
//				if (this.trace) TinyLogManager.log( this.currentBFrame.toString(), this );
//			}
//			
//			this.currentAFrame++;
//			
//			
//			// Check if animation is over. If so, clean up, or loop
//			if ( this.currentBFrame - 1 >= int( this.length / this.speed ) ) 
//			{ 
//				if ( this.loopAnim ) {
//					this.currentAFrame = 0;
//					this.currentBFrame = 0;
//				} else {
//					this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
//					this.dispatchEvent(new Event(Event.COMPLETE));
//					this.isPlaying = false;
//					
//					// Remove if necessary
//					if ( this.remove ) {
//						this.removeChild(this.playerBitmap);
//						this.playerBitmap.bitmapData.dispose();
//						this.playerBitmap = null;
//						this.remove = false;
//					}
//				}
//			}
//		}
	}
}
