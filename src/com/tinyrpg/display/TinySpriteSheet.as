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
	public class TinySpriteSheet extends Sprite 
	{
		private var playerBitmap	: Bitmap;
		private var sourceData		: BitmapData;
		private var tileSize 		: uint;
		private var currentAFrame	: uint;
		private var currentBFrame	: uint;
		private var defaultSpeed	: uint;
		private var remove 			: Boolean;
		
		public var speed 			: uint;
		public var loopAnim			: Boolean;
		public var isPlaying		: Boolean;
		public var side				: Boolean;
		public var trace			: Boolean = false;

		public function TinySpriteSheet(bitmapData : BitmapData, tileSize : uint, loop : Boolean = false, speed : uint = 2, side : Boolean = false)
		{
			// Set properties
			this.tileSize = tileSize;
			this.sourceData = bitmapData;
			this.speed = speed;
			this.defaultSpeed = speed;
			this.loopAnim = loop;
			this.side = side;
		}
		
		public static function newFromBitmapCopy(sourceBitmapData : BitmapData, sourceRect : Rectangle, tileSize : uint, length : uint, loop : Boolean = false, speed : uint = 2, side : Boolean = false) : TinySpriteSheet
		{
			var copyBitmap : BitmapData = new BitmapData(tileSize * length, tileSize);
			copyBitmap.copyPixels(sourceBitmapData, sourceRect, new Point(0, 0));
			
			return new TinySpriteSheet(copyBitmap, tileSize, loop, speed, side);
		}
		
		public function get length() : int
		{
			return int(this.sourceData.width / this.tileSize) * this.speed;
		}
		
		public function play(playSpeed : int = 2) : void
		{
			this.isPlaying = true;
			this.speed = playSpeed;
				
			//TinyLogManager.log('play: ' + this.speed, this);
			
			// Reset counters			
			this.currentAFrame = 0;
			this.currentBFrame = 0;
			
			// Make rectangle to copy with
			var copyRect : Rectangle = new Rectangle(this.currentBFrame * this.tileSize, 0, this.tileSize, this.tileSize);
			
			// Make sure we don't copy what doesn't exist
			copyRect.height = Math.min( this.tileSize, this.sourceData.height );
			
			if (!this.playerBitmap) 
			{
				// Prep bitmap
				this.playerBitmap = new Bitmap(new BitmapData(this.tileSize, copyRect.height));
				this.playerBitmap.x =
				this.playerBitmap.y = -int(this.tileSize / 2);
								// Copy first frame
				this.playerBitmap.bitmapData.copyPixels(this.sourceData, copyRect, new Point(0, 0));
				// Add 'em up
				this.addChild(this.playerBitmap);
			} else {
				// Copy first frame
				this.playerBitmap.bitmapData.copyPixels(this.sourceData, copyRect, new Point(0, 0));			}
			
			// Only animate if we need to
			if (this.length > 1) { 
				if (this.hasEventListener(Event.ENTER_FRAME)) {
					this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		public function playAndRemove(speed : int = 2) : void
		{
			this.play(speed);
			this.remove = true;
		}
		
		public function stopAndRemove() : void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.isPlaying = false;
			
			if (this.playerBitmap) {
				this.removeChild(this.playerBitmap);
				this.playerBitmap.bitmapData.dispose();
				this.playerBitmap = null;
			}
		}

		protected function onEnterFrame(event : Event) : void
		{
			// Copy source pixels to viewing area
			if (this.currentAFrame % this.speed == 0) 
			{
				var copyRect : Rectangle = new Rectangle(this.currentBFrame * this.tileSize, 0, this.tileSize, this.tileSize);
			
				// Make sure we don't copy what doesn't exist
				copyRect.height = Math.min( this.tileSize, this.sourceData.height );
				
				this.playerBitmap.bitmapData.copyPixels(this.sourceData, copyRect, new Point(0, 0));
				this.currentBFrame++;
				
				if (this.trace) TinyLogManager.log( this.currentBFrame.toString(), this );
			}
			
			this.currentAFrame++;
			
			
			// Check if animation is over. If so, clean up, or loop
			if ( this.currentBFrame - 1 >= int( this.length / this.speed ) ) 
			{ 
				if ( this.loopAnim ) {
					this.currentAFrame = 0;
					this.currentBFrame = 0;
				} else {
					this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					this.dispatchEvent(new Event(Event.COMPLETE));
					this.isPlaying = false;
					
					// Remove if necessary
					if ( this.remove ) {
						this.removeChild(this.playerBitmap);
						this.playerBitmap.bitmapData.dispose();
						this.playerBitmap = null;
						this.remove = false;
					}
				}
			}
		}
	}
}
