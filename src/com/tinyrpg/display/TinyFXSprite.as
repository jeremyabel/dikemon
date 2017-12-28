package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.Sound;

	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.data.TinyMoveFXSpriteFrameInfo;
	import com.tinyrpg.misc.TinyBallThrowResult;
	import com.tinyrpg.misc.TinyMoveFXConfig;
	import com.tinyrpg.misc.TinyStatusFXConfig;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyFXSprite extends Sprite 
	{
		private static const clearRect : Rectangle = new Rectangle( 0, 0, 160, 144 );
		
		private var playerBitmap	: Bitmap;
		private var sourceData		: BitmapData;
		private var xmlData			: XML;
		private var currentAFrame	: uint;
		private var currentBFrame	: uint;
		private var frameData		: Array = [];
		private var skipFrames		: int = 2;
		private var sound	 		: Sound;
		
		public var length 			: int;
		public var isPlaying		: Boolean;
		public var trace			: Boolean = false;
		
		public function get currentFrame() : int { return this.currentBFrame; }
				
				
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


		public static function newFromMoveData( move : TinyMoveData, isEnemy : Boolean ) : TinyFXSprite
		{
			var sourceData : BitmapData = TinyMoveFXConfig.getMoveFXSprite( move.name, isEnemy );
			var xmlData : XML = TinyMoveFXConfig.getMoveFXXML( move.name, isEnemy );
			var sprite : TinyFXSprite = new TinyFXSprite( sourceData, xmlData );
			sprite.y = TinyMoveFXConfig.getMoveAdjustY( move.name, isEnemy );
			sprite.sound = TinyMoveFXConfig.getMoveSFX( move.name );
			
			return sprite; 	
		}
		
		
		public static function newFromStatusEffect( statusName : String, isEnemy : Boolean ) : TinyFXSprite
		{
			var sourceData : BitmapData = TinyStatusFXConfig.getStatusFXSprite( statusName, isEnemy );
			var xmlData : XML = TinyStatusFXConfig.getStatusFXXML( statusName, isEnemy );
			var sprite : TinyFXSprite = new TinyFXSprite( sourceData, xmlData );
			sprite.sound = TinyStatusFXConfig.getStatusSFX( statusName );
			
			return sprite;
		}
		
		
		public static function newFromBallThrowPhase( ballPhase : String, isUltra : Boolean ) : TinyFXSprite
		{
			var sourceData : BitmapData = TinyBallFXAnimation.getBallFXSprite( ballPhase, isUltra );
			var xmlData : XML = TinyBallFXAnimation.getBallFXXML( ballPhase );
			var sprite : TinyFXSprite = new TinyFXSprite( sourceData, xmlData );
			sprite.sound = TinyBallFXAnimation.getBallSFX( ballPhase );
			
			return sprite;
		}
		
		
		public function play() : void
		{
			this.isPlaying = true;
			
			// Reset frame counters			
			this.currentAFrame = 0;
			this.currentBFrame = 0;
			
			// Play sound
			if ( this.sound ) 
			{
				this.sound.play();
			}
					
			// Get the current frame's info
			var currentFrameInfo : TinyMoveFXSpriteFrameInfo = this.frameData[ this.currentBFrame ] as TinyMoveFXSpriteFrameInfo;
			
			// Initialize the player bitmap if this is the first time that play() has been called
			if ( !this.playerBitmap ) 
			{
				// Prep bitmap
				this.playerBitmap = new Bitmap( new BitmapData( 160, 144 ) );
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
			this.playerBitmap.bitmapData.fillRect( clearRect, 0x00000000 );
			
			// Get current frame's info
			var currentFrameInfo : TinyMoveFXSpriteFrameInfo = this.frameData[ this.currentBFrame ] as TinyMoveFXSpriteFrameInfo;
			
			// Copy pixels from source to player bitmap
			this.playerBitmap.bitmapData.copyPixels( this.sourceData, currentFrameInfo.copyRect, currentFrameInfo.destPoint );
			this.currentBFrame = Math.min( this.currentBFrame + this.skipFrames, this.length - 1 );
			this.currentAFrame = Math.min( this.currentBFrame + this.skipFrames, this.length - 1 );
			
			// Log frame info, if requested
			if ( this.trace ) TinyLogManager.log( this.currentBFrame.toString() + ': ' + currentFrameInfo.toString(), this );
			
			// Check if animation is over. If so, clean up
			if ( this.currentBFrame == this.length - 1 ) 
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