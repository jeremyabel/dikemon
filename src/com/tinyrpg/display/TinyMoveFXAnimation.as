package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	import com.tinyrpg.battle.TinyBattleMon;	
	import com.tinyrpg.battle.TinyBattlePalette;
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.utils.TinyLogManager; 

	/**
	 * @author jeremyabel
	 */
	public class TinyMoveFXAnimation extends Sprite 
	{
		private var moveFXSprite : TinyMoveFXSprite;
		private var battleScreenBitmap : Bitmap;
		private var battleScreenBitmapCopy : Bitmap;
		private var battleScreenCapture : BitmapData;
		private var isEnemy : Boolean;
		private var shakeEffect : TinyMoveFXScreenShake;
		private var invertEffects : Array = [];
		private var currentInvertIndex : int = 0;
		private var currentFrame : int = 0;
		private var palette : TinyBattlePalette;
		private var paletteEffect : TinyMoveFXPaletteEffect;
		private var distortionEffect : TinyMoveFXDistortionEffect;
		private var bgColor : uint = 0xFFFFFFFF;
		private var bgFillSprite : Sprite;
		
		public var length 			: int;
		public var isPlaying		: Boolean;
		public var trace			: Boolean = false;
		
		public function TinyMoveFXAnimation( move : TinyMoveData, isEnemy : Boolean, palette : TinyBattlePalette, trace : Boolean = false )
		{
			this.isEnemy = isEnemy;
			this.palette = palette;
			this.trace = trace;
			
			if ( this.trace )
			{
				TinyLogManager.log('===================== MOVE FX ANIMATION: ' + move.name + ' ======================', this);
				TinyLogManager.log('Screen Shake: ' + move.fxScreenShake, this);
				TinyLogManager.log('Screen Inverts: ' + move.fxScreenInverts, this);
				TinyLogManager.log('Anim Distortion: ' + move.fxAnimDistortion, this);
				TinyLogManager.log('Palette Effect: ' + move.fxPaletteEffect, this);
			}
				
			// Make screen shake effect, if there is any
			if ( move.fxScreenShake.length ) 
			{
				this.shakeEffect = TinyMoveFXScreenShake.newFromString( move.fxScreenShake );
			}
			
			// Make screen invert effects, if there are any
			if ( move.fxScreenInverts.length )
			{
				var regex : RegExp = /(\d+,\s\d+)/;
				var invertStrings : Array = move.fxScreenInverts.split( regex );
				for ( var i : int = 1; i < invertStrings.length; i += 2 )
				{
					this.invertEffects.push( TinyMoveFXScreenInvert.newFromString( invertStrings[ i ], this.palette ) ); 
				}
			}
			
			// Make palette effect, if there is one
			if ( move.fxPaletteEffect )
			{
				this.paletteEffect = TinyMoveFXPaletteEffect.newFromString( move.fxPaletteEffect );
			}
			
			// Make distortion effect, if there is one
			if ( move.fxAnimDistortion )
			{
				this.distortionEffect = TinyMoveFXDistortionEffect.newFromString( move.fxAnimDistortion );
			}
			
			// Make battle screen capture bitmap
			this.battleScreenCapture = new BitmapData( 160, 144, true, 0x00000000 );
			this.battleScreenBitmap = new Bitmap( this.battleScreenCapture );
			
			// Make move FX sprite
			this.moveFXSprite = TinyMoveFXSprite.newFromMoveData( move, this.isEnemy );
			this.length = this.moveFXSprite.length;
			
			// Make BG fill sprite
			this.bgFillSprite = new Sprite();
			this.bgFillSprite.graphics.beginFill( 0xFFFFFFFF );
			this.bgFillSprite.graphics.drawRect( 0, 0, 160, 98 );
			this.bgFillSprite.graphics.endFill();
						
			// Add 'em up
			this.addChild( this.bgFillSprite );
			this.addChild( this.battleScreenBitmap );
			this.addChild( this.moveFXSprite );
		}
		
		public function captureBattleBitmap( battle : TinyBattleMon ) : void
		{
			TinyLogManager.log('captureBattleBitmap', this);
			
			// Draw the battle sprite to the bitmap
			this.battleScreenCapture.draw( battle, null, null, null, new Rectangle(0, 0, 160, 144 ) );
			
			// Save a copy to restore before applying any effects each frame
			this.battleScreenBitmapCopy = new Bitmap( this.battleScreenCapture.clone() );
		}
		
		public function setBattlePalette( palette : TinyBattlePalette ) : void
		{
			TinyLogManager.log('setBattlePalette', this);
			
			// Set palette for invert effects	
			for each ( var invertEffect : TinyMoveFXScreenInvert in this.invertEffects )
			{
				invertEffect.setBattlePalette( palette );
			}
			
			// Set palette for palette effect
			if ( this.paletteEffect )
			{
				this.paletteEffect.generateCyclePalettes( palette );
			}
		}

		public function play() : void
		{
			TinyLogManager.log('play', this);
			
			// Set original bitmap data for any invert effects
			for each ( var invertEffect : TinyMoveFXScreenInvert in this.invertEffects )
			{
				invertEffect.setOriginalBitmapData( this.battleScreenBitmap.bitmapData );
			}
			
			// Set original bitmap data for the palette effect
			if ( this.paletteEffect )
			{
				this.paletteEffect.origBitmapData = this.battleScreenBitmap.bitmapData.clone();
			}
			
			// Set original bitmap data for the distortion effect
			if ( this.distortionEffect )
			{
				this.distortionEffect.origBitmapData = this.battleScreenBitmap.bitmapData.clone();
			}
			
			// Reset counters
			this.currentFrame = 0;
			this.currentInvertIndex = 0;
			
			// Play!
			this.moveFXSprite.play();
			this.addEventListener( Event.ENTER_FRAME, this.onEnterFrame );
		}
		
		protected function onEnterFrame( event : Event ) : void
		{
			this.currentFrame++;
			
			// Copy the original bitmap to restore the pre-effected state
			this.battleScreenBitmap.bitmapData.copyPixels( this.battleScreenBitmapCopy.bitmapData, new Rectangle( 0, 0, 160, 144 ), new Point( 0, 0 ) );
			
			this.isPlaying = this.moveFXSprite.isPlaying;
			
			// Do any screen inverts
			if ( this.invertEffects.length )
			{
				var currentInvert : TinyMoveFXScreenInvert = this.invertEffects[ this.currentInvertIndex ];
				if ( this.currentFrame * 2 >= currentInvert.startFrame && this.currentFrame * 2 <= currentInvert.endFrame )
				{
					currentInvert.execute( this.currentFrame, this.battleScreenBitmap );
					this.setBGColor( 0xFF000000 );
				}
				else 
				{
					this.setBGColor( 0xFFFFFFFF );
				}
				
				// Advance to next invert in the sequence if we're at the end of the current one				
				if ( currentFrame * 2 >= currentInvert.endFrame ) 
				{
					this.currentInvertIndex = Math.min( this.currentInvertIndex + 1, this.invertEffects.length - 1 );
				}
			}
			else 
			{
				this.setBGColor( 0xFFFFFFFF );
			}
			
			// Do any palette effects
			if ( this.paletteEffect )
			{
				this.paletteEffect.execute( this.battleScreenBitmap, this.currentFrame );
			}
			
			// Do any distortion effects
			if ( this.distortionEffect )
			{
				this.distortionEffect.execute( this.battleScreenBitmap, this.bgColor, this.currentFrame );
			}
			
			// Do any screen shakes
			if ( this.shakeEffect )
			{
				this.shakeEffect.execute( this.currentFrame, this.battleScreenBitmap );
			}
			
			// Clean up if the sprite animation is done
			if ( !this.moveFXSprite.isPlaying )
			{
				this.removeEventListener( Event.ENTER_FRAME, this.onEnterFrame );
				this.dispatchEvent( new Event( Event.COMPLETE ) );	
			}
		}
		
		private function setBGColor( color : uint ) : void
		{
			this.bgColor = color;
			this.bgFillSprite.graphics.beginFill( this.bgColor );
			this.bgFillSprite.graphics.drawRect( 0, 0, 160, 98 );
			this.bgFillSprite.graphics.endFill();
		}
	}
}
