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
	 * Class which provides a sprite with basic spritesheet animation.
	 * Tiles are required to be square and run horizontally only!
	 * 
	 * Used for simple manually-created effects like the battle intro whirl
	 * and the mon summon poof.
	 * 
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
		
		/**
		 * @param	bitmapData	The spritesheet bitmap data.
		 * @param	tileSize	The size of a single frame. Tiles are assumed to be square.
		 * @param	loop		Whether or not the spritesheet animation should loop.
		 * @param	speed		The playback framerate divisor. Defaults to 2 = update sprite frame every 2 game frames.  
		 */
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
		
		/**
		 * Returns a new {@link TinySpriteSheet}, using a cropped portion of a given source bitmap.
		 * 
		 * @param	sourceBitmapData	The spritesheet source bitmap data.
		 * @param	sourceRect			The rectangle to use for cropping the source bitmap.
		 * @param	tileSize			The size of a single frame. Tiles are assumed to be square.
		 * @param	length				The number of frames in the spritesheet animation.
		 * @param	loop				Whether or not the spritesheet animation should loop.
		 * @param	speed				The playback framerate divisor. Defaults to 2 = update sprite frame every 2 game frames.
		 */
		public static function newFromBitmapCopy(sourceBitmapData : BitmapData, sourceRect : Rectangle, tileSize : uint, length : uint, loop : Boolean = false, speed : uint = 2, side : Boolean = false) : TinySpriteSheet
		{
			var copyBitmap : BitmapData = new BitmapData(tileSize * length, tileSize);
			copyBitmap.copyPixels(sourceBitmapData, sourceRect, new Point(0, 0));
			
			return new TinySpriteSheet(copyBitmap, tileSize, loop, speed, side);
		}
		
		/**
		 * Returns the length of the spritesheet animation, in frames.
		 */
		public function get length() : int
		{
			return int( this.sourceData.width / this.tileSize ) * this.speed;
		}
		
		/**
		 * Begins playback of the spritesheet animation at a given speed.
		 * 
		 * @param	speed	The playback framerate divisor. Defaults to 2 = update sprite frame every 2 game frames.
		 */
		public function play( playSpeed : int = 2 ) : void
		{
			this.isPlaying = true;
			this.speed = playSpeed;
				
			// Reset counters			
			this.currentAFrame = 0;
			this.currentBFrame = 0;
			
			// Make rectangle to copy with
			var copyRect : Rectangle = new Rectangle(this.currentBFrame * this.tileSize, 0, this.tileSize, this.tileSize);
			
			// Make sure we don't copy what doesn't exist
			copyRect.height = Math.min( this.tileSize, this.sourceData.height );
			
			if ( !this.playerBitmap ) 
			{
				// Prep bitmap
				this.playerBitmap = new Bitmap(new BitmapData(this.tileSize, copyRect.height));
				this.playerBitmap.x =
				this.playerBitmap.y = -int(this.tileSize / 2);
								// Copy first frame
				this.playerBitmap.bitmapData.copyPixels(this.sourceData, copyRect, new Point(0, 0));
				
				// Add 'em up
				this.addChild(this.playerBitmap);
			} 
			else 
			{
				// Copy first frame
				this.playerBitmap.bitmapData.copyPixels(this.sourceData, copyRect, new Point(0, 0));			}
			
			// Only animate if we need to
			if ( this.length > 1 ) 
			{ 
				if (this.hasEventListener(Event.ENTER_FRAME)) 
				{
					this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
				
				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		/**
		 * Play the spritesheet animation at a given speed, removing it after it is complete.
		 * 
		 * @param	speed	The playback framerate divisor. Defaults to 2 = update sprite frame every 2 game frames.
		 */
		public function playAndRemove( speed : int = 2 ) : void
		{
			this.play(speed);
			this.remove = true;
		}
		
		/**
		 * Stops the spritesheet animation and removes the bitmap data.
		 */
		public function stopAndRemove() : void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.isPlaying = false;
			
			if (this.playerBitmap) 
			{
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
			
				// Make sure we don't copy past the bounds of the source data
				copyRect.height = Math.min( this.tileSize, this.sourceData.height );
				
				this.playerBitmap.bitmapData.copyPixels(this.sourceData, copyRect, new Point(0, 0));
				this.currentBFrame++;
				
				if (this.trace) TinyLogManager.log( this.currentBFrame.toString(), this );
			}
			
			this.currentAFrame++;
			
			// Check if animation is over. If so, clean up, or loop
			if ( this.currentBFrame - 1 >= int( this.length / this.speed ) ) 
			{ 
				if ( this.loopAnim ) 
				{
					// If the animation is set to loop, just reset the frame counters
					this.currentAFrame = 0;
					this.currentBFrame = 0;
				} 
				else 
				{
					// No loop, so clean up and emit the COMPLETE event
					this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					this.dispatchEvent(new Event(Event.COMPLETE));
					this.isPlaying = false;
					
					// Remove the bitmap if necessary
					if ( this.remove ) 
					{
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
