package com.tinyrpg.display 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	import com.tinyrpg.display.itemfx.*;
	import com.tinyrpg.media.sfx.itemfx.*;
	
	import com.tinyrpg.data.TinyBallThrowResult;
	import com.tinyrpg.utils.TinyLogManager; 

	/**
	 * @author jeremyabel
	 */
	public class TinyBallFXAnimation extends Sprite 
	{
		private var ballFXSprite : TinyFXSprite;
		private var currentFrame : int = 0;
		
		public static const BALL_PHASE_OPEN 	: String = 'BALL_PHASE_OPEN';
		public static const BALL_PHASE_CLOSE 	: String = 'BALL_PHASE_CLOSE';
		public static const BALL_PHASE_WOBBLE	: String = 'BALL_PHASE_WOBBLE';
		public static const BALL_PHASE_BURST	: String = 'BALL_PHASE_BURST';
		public static const BALL_PHASE_REJECT	: String = 'BALL_PHASE_REJECT';
		
		public var length 		: int;
		public var isPlaying	: Boolean;
		
		[Embed(source='../../../../bin/xml/ItemFX/pokeball_open.xml', mimeType='application/octet-stream')] public static const XML_Ball_Open : Class;
		[Embed(source='../../../../bin/xml/ItemFX/pokeball_close.xml', mimeType='application/octet-stream')] public static const XML_Ball_Close : Class;
		[Embed(source='../../../../bin/xml/ItemFX/pokeball_wobble.xml', mimeType='application/octet-stream')] public static const XML_Ball_Wobble : Class;
		[Embed(source='../../../../bin/xml/ItemFX/pokeball_burst.xml', mimeType='application/octet-stream')] public static const XML_Ball_Burst : Class;
		[Embed(source='../../../../bin/xml/ItemFX/pokeball_reject.xml', mimeType='application/octet-stream')] public static const XML_Ball_Reject : Class;
		
		
		public function TinyBallFXAnimation( ballPhase : String, isUltra : Boolean )
		{
			// Make status FX sprite
			this.ballFXSprite = TinyFXSprite.newFromBallThrowPhase( ballPhase, isUltra );
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
		
		
		public static function getBallFXXML( ballPhase : String ) : XML
		{
			var newXMLBytes : ByteArray;
			
			switch ( ballPhase ) 
			{
				default:
				case BALL_PHASE_OPEN	: newXMLBytes = new XML_Ball_Open as ByteArray; break;
				case BALL_PHASE_CLOSE	: newXMLBytes = new XML_Ball_Close as ByteArray; break;
				case BALL_PHASE_WOBBLE	: newXMLBytes = new XML_Ball_Wobble as ByteArray; break;
				case BALL_PHASE_BURST	: newXMLBytes = new XML_Ball_Burst as ByteArray; break;
				case BALL_PHASE_REJECT	: newXMLBytes = new XML_Ball_Reject as ByteArray; break;
			}

			var string : String = newXMLBytes.readUTFBytes( newXMLBytes.length );			
			return new XML( string );
		}
		
		
		public static function getBallFXSprite( ballPhase : String, isUltra : Boolean ) : BitmapData
		{	
			var newSprite : BitmapData;
			
			switch ( ballPhase )
			{
				default:
				case BALL_PHASE_OPEN	: newSprite = isUltra ? new BallOpenUltra : new BallOpenRegular; break;
				case BALL_PHASE_CLOSE	: newSprite = isUltra ? new BallCloseUltra : new BallCloseRegular; break;
				case BALL_PHASE_WOBBLE	: newSprite = isUltra ? new BallWobbleUltra : new BallWobbleRegular; break;
				case BALL_PHASE_BURST	: newSprite = isUltra ? new BallBurstUltra : new BallBurstRegular; break;
				case BALL_PHASE_REJECT	: newSprite = isUltra ? new BallRejectUltra : new BallRejectRegular; break;
			}
			
			return newSprite;
		}
		
		
		public static function getBallSFX( ballPhase : String ) : Sound
		{
			switch( ballPhase )
			{
				default:
				case BALL_PHASE_OPEN	: return new SFXBallOpen as Sound; break;
				case BALL_PHASE_CLOSE	: return new SFXBallClose as Sound; break;
				case BALL_PHASE_WOBBLE	: return new SFXBallWobble as Sound; break;
				case BALL_PHASE_BURST	: return new SFXBallBurst as Sound; break;
				case BALL_PHASE_REJECT	: return new SFXBallReject as Sound; break;
			}
		}
	}
}