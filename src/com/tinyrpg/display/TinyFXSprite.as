package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.Sound;

	import com.tinyrpg.data.TinyBallThrowResult;
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.data.TinyMoveFXSpriteFrameInfo;
	import com.tinyrpg.lookup.TinyMoveFXLookup;
	import com.tinyrpg.lookup.TinyStatusFXLookup;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * Display class which provides a means of displaying and playing back a spritesheet
	 * battle move fx animation.
	 * 
	 * These fx sprites are generated from the original Gen 3 game and are packed into 
	 * spritesheets using the TexturePacker program. The layout of each spritesheet is
	 * specified in an accompanying XML file. This class handles reading that XML file
	 * and animating each frame of the spritesheet by copying the area specified in the
	 * XML data from the spritesheet to a destination bitmap. 
	 * 
	 * @author jeremyabel
	 */
	public class TinyFXSprite extends Sprite 
	{
		private static const clearRect : Rectangle = new Rectangle( 0, 0, 160, 144 );
		
		private var playerBitmap	: Bitmap;
		private var sourceData		: BitmapData;
		private var xmlData			: XML;
		private var frameData		: Array = [];
		private var skipFrames		: int = 2;
		private var sound	 		: Sound;
		
		public var currentFrame		: int;
		public var length 			: int;
		public var isPlaying		: Boolean;
		public var trace			: Boolean = false;

		/**
		 * Creates a spritesheet fx animation from a given source bitmap and XML data.
		 */
		public function TinyFXSprite( sourceBitmap : BitmapData, xmlData : XML )
		{
			this.sourceData = sourceBitmap;
			this.xmlData = xmlData;
			
			// Get frame info from each xml child
			for each ( var spriteFrame : XML in this.xmlData.children() )
			{
				this.frameData.push( TinyMoveFXSpriteFrameInfo.newFromXML( spriteFrame ) );
			}
			
			this.length = this.frameData.length;
		}

		/**
		 * Creates a battle move fx animation for a given move.
		 */
		public static function newFromMoveData( move : TinyMoveData, isEnemy : Boolean ) : TinyFXSprite
		{
			var sourceData : BitmapData = TinyMoveFXLookup.getMoveFXSprite( move.name, isEnemy );
			var xmlData : XML = TinyMoveFXLookup.getMoveFXXML( move.name, isEnemy );
			var sprite : TinyFXSprite = new TinyFXSprite( sourceData, xmlData );
			sprite.y = TinyMoveFXLookup.getMoveAdjustY( move.name, isEnemy );
			sprite.sound = TinyMoveFXLookup.getMoveSFX( move.name );
			
			return sprite; 	
		}
		
		/**
		 * Creates a status effect fx animation for a given status effect.
		 */
		public static function newFromStatusEffect( statusName : String, isEnemy : Boolean ) : TinyFXSprite
		{
			var sourceData : BitmapData = TinyStatusFXLookup.getStatusFXSprite( statusName, isEnemy );
			var xmlData : XML = TinyStatusFXLookup.getStatusFXXML( statusName, isEnemy );
			var sprite : TinyFXSprite = new TinyFXSprite( sourceData, xmlData );
			sprite.sound = TinyStatusFXLookup.getStatusSFX( statusName );
			
			return sprite;
		}
		
		/**
		 * Creates a ball throw fx animation for a given ball phase. 
		 * Valid ball phases are specified in {@link TinyBallFXAnimation}.
		 */
		public static function newFromBallThrowPhase( ballPhase : String, isUltra : Boolean ) : TinyFXSprite
		{
			var sourceData : BitmapData = TinyBallFXAnimation.getBallFXSprite( ballPhase, isUltra );
			var xmlData : XML = TinyBallFXAnimation.getBallFXXML( ballPhase );
			var sprite : TinyFXSprite = new TinyFXSprite( sourceData, xmlData );
			sprite.sound = TinyBallFXAnimation.getBallSFX( ballPhase );
			
			return sprite;
		}
		
		/**
		 * Begins playing the fx sprite animation, along with any audio.
		 * When playback is complete, a COMPLETE event will be dispatched.
		 */
		public function play() : void
		{
			this.isPlaying = true;
			
			// Reset frame counter		
			this.currentFrame  = 0;
			
			// Play sound
			if ( this.sound ) 
			{
				this.sound.play();
			}
					
			// Get the current frame's info
			var currentFrameInfo : TinyMoveFXSpriteFrameInfo = this.frameData[ this.currentFrame ] as TinyMoveFXSpriteFrameInfo;
			
			// Initialize the player bitmap if this is the first time that play() has been called
			if ( !this.playerBitmap ) 
			{
				// Prep bitmap
				this.playerBitmap = new Bitmap( new BitmapData( 160, 144, true, 0x00000000 ) );
				this.playerBitmap.x =
				this.playerBitmap.y = 0;
				
				// Add 'em up
				this.addChild( this.playerBitmap );
			} 
			
			// Copy first frame
			this.playerBitmap.bitmapData.copyPixels( this.sourceData, currentFrameInfo.copyRect, currentFrameInfo.destPoint );
		
			// Only animate if we need to
			if ( this.length > 1 ) 
			{ 
				if ( this.hasEventListener( Event.ENTER_FRAME ) ) 
				{
					this.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
				}
				
				this.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			}
		}
		
		
		protected function onEnterFrame( event : Event ) : void
		{	
			// Clear the previous frame
			if ( this.currentFrame > 0 ) this.playerBitmap.bitmapData.fillRect( clearRect, 0x00000000 );
			
			// Get current frame's info
			var currentFrameInfo : TinyMoveFXSpriteFrameInfo = this.frameData[ this.currentFrame  ] as TinyMoveFXSpriteFrameInfo;
			
			// Log frame info, if requested
			if ( this.trace ) TinyLogManager.log( this.currentFrame .toString() + ': ' + currentFrameInfo.toString(), this );
			
			// Copy pixels from source to player bitmap
			this.playerBitmap.bitmapData.copyPixels( this.sourceData, currentFrameInfo.copyRect, currentFrameInfo.destPoint );
			this.currentFrame = Math.min( this.currentFrame + this.skipFrames, this.length - 1 );
			
			// Check if the animation is over. If so, clean up
			if ( this.currentFrame  == this.length - 1 ) 
			{ 
				this.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
				this.dispatchEvent( new Event( Event.COMPLETE ) );
				this.isPlaying = false;
				
				this.removeChild( this.playerBitmap );
				this.playerBitmap.bitmapData.dispose();
				this.playerBitmap = null;
			}
		}
	}
}