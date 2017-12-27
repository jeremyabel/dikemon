package com.tinyrpg.display 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	import com.tinyrpg.display.itemfx.*;
	import com.tinyrpg.utils.TinyLogManager; 

	/**
	 * @author jeremyabel
	 */
	public class TinyBallFXAnimation extends Sprite 
	{
		private var ballFXSprite : TinyFXSprite;
		private var currentFrame : int = 0;
		
		public var length 			: int;
		public var isPlaying		: Boolean;
		
		[Embed(source='../../../../bin/xml/ItemFX/pokeball_reject.xml', mimeType='application/octet-stream')] public static const XML_Ball_Reject : Class;
		
		public function TinyBallFXAnimation( rejected : Boolean, isUltra : Boolean = false, numShakes : int = 0 )
		{
			// Make status FX sprite
			this.ballFXSprite = TinyFXSprite.newFromBallThrow( rejected, isUltra, numShakes );
			this.length = this.ballFXSprite.length;
			
			// Add 'em up
			this.addChild( this.ballFXSprite );
		}
		
		public function play() : void
		{
			TinyLogManager.log('play', this);
			
			// Reset counters
			this.currentFrame = 0;
			
			// Play!
			this.ballFXSprite.play();
			this.addEventListener( Event.ENTER_FRAME, this.onEnterFrame );
		}
		
		protected function onEnterFrame( event : Event ) : void
		{
			this.currentFrame++;
			
			// Clean up if the sprite animation is done
			if ( !this.ballFXSprite.isPlaying )
			{
				this.removeEventListener( Event.ENTER_FRAME, this.onEnterFrame );
				this.dispatchEvent( new Event( Event.COMPLETE ) );	
			}
		}
		
		public static function getBallFXXML( rejected : Boolean, numShakes : int = 0 ) : XML
		{
			var newXMLBytes : ByteArray; 
			
//			if ( rejected )
//			{
				newXMLBytes = new XML_Ball_Reject as ByteArray;
//			}
			 
			var string : String = newXMLBytes.readUTFBytes( newXMLBytes.length );			
			return new XML( string );
		}
		
		public static function getBallFXSprite( rejected : Boolean, isUltra : Boolean = false, numShakes : int = 0 ) : BitmapData
		{	
			var newSprite : BitmapData;
			
			if ( rejected )
			{
				newSprite = isUltra ? new BallRejectUltra : new BallRejectRegular;
			}
			
			return newSprite;
		}
	}
}