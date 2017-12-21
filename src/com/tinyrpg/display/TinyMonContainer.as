package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.SteppedEase;
	
	import com.tinyrpg.display.SummonPoofSheet;
	import com.tinyrpg.display.TinySpriteSheet;
	import com.tinyrpg.utils.TinyColor;
	import com.tinyrpg.utils.TinyFourColorPalette;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyMonContainer extends Sprite implements IShowHideObject
	{
		public var monBitmap : Bitmap;
		public var palette : TinyFourColorPalette;
		
		private var monMask : Sprite;
		private var rightFacing : Boolean;
		private var m_monCenterSprite : Sprite;
		private var m_summonPoof : TinySpriteSheet; 
		
		public function TinyMonContainer( bitmap : Bitmap, rightFacing : Boolean = false )
		{			
			this.rightFacing = rightFacing;
			
			// Make empty palette
			this.palette = new TinyFourColorPalette();
			
			// Make summon poof effect
			this.m_summonPoof = new TinySpriteSheet( new SummonPoofSheet(), 48, false, 3 );
			this.m_summonPoof.visible = false;
			this.m_summonPoof.x = 
			this.m_summonPoof.y = 28;
			
			this.m_monCenterSprite = new Sprite();
			this.m_monCenterSprite.x = 28; 
			this.m_monCenterSprite.y = 28;
			this.m_monCenterSprite.cacheAsBitmap = true;
			
			// Make mon bitmap
			this.monBitmap = new Bitmap( bitmap.bitmapData.clone() );
			this.monBitmap.cacheAsBitmap = true;
			this.monBitmap.visible = false;
			this.monBitmap.scaleX = this.rightFacing ? -1 : 1;
			this.monBitmap.x = this.rightFacing ? 28 : -28;
			this.monBitmap.y = -28; 
			
			// Make mon mask
			this.monMask = new Sprite();
			this.monMask.graphics.beginFill( 0x0000FF );
			this.monMask.graphics.drawRect( 0, 0, 56, 56 );
			this.monMask.graphics.endFill();
			this.monMask.cacheAsBitmap = true;
			
			// Set mask
			this.m_monCenterSprite.mask = this.monMask; 
			
			// Add 'em up
			this.m_monCenterSprite.addChild( this.monBitmap );
			this.addChild( this.monMask );
			this.addChild( this.m_monCenterSprite );
			this.addChild( this.m_summonPoof );
			
			// Set mon bitmap
			this.setMonBitmap( bitmap );
		}
		
		public function show() : void
		{
			this.monBitmap.visible = true;
		}
		
		public function hide() : void
		{
			this.monBitmap.visible = false;
		}
		
		public function setMonBitmap( bitmap : Bitmap ) : void
		{
			TinyLogManager.log('setMonBitmap', this);
			
			if ( this.monBitmap ) 
			{
				this.m_monCenterSprite.removeChild( this.monBitmap );
			}
			
			this.m_monCenterSprite.y = 28;
			
			this.monBitmap = new Bitmap( bitmap.bitmapData.clone() );
			this.monBitmap.cacheAsBitmap = true;
			this.monBitmap.visible = false;
			this.monBitmap.scaleX = this.rightFacing ? -1 : 1;
			this.monBitmap.x = this.rightFacing ? 28 : -28;
			this.monBitmap.y = -28;
			
			// Get palette colors
			for ( var y : int = 0; y < this.monBitmap.height; y++ )
			{
				for ( var x : int = 0; x < this.monBitmap.width; x++ )
				{
					var color : TinyColor = TinyColor.newFromHex32( this.monBitmap.bitmapData.getPixel32( x, y ) );
					
					if ( color.a > 128 && !this.palette.contains( color ) && !this.palette.isFull() )
					{
						this.palette.addColor( color );
						
						// Exit early if palette is complete		
						if ( this.palette.isFull() ) break;
					}
				}
				
				// Exit early if palette is complete
				if ( this.palette.isFull() ) break;
			}
			
			while ( !this.palette.isFull() ) {
				var color : TinyColor = TinyColor.newFromHex32( 0 );
				this.palette.addColor( color );
			}
						
			// Sort palette by luminance
			this.palette.sort();
			
			this.m_monCenterSprite.addChild(this.monBitmap);
		}
		
		public function playSummonPoof() : void
		{
			TinyLogManager.log('playSummonPoof', this);
			
			this.monBitmap.visible = false;
			m_summonPoof.visible = true;
			
			m_summonPoof.play( 3 );
			
			TweenLite.delayedCall( m_summonPoof.length / 3, this.scaleInMon, null, true );	
			TweenLite.delayedCall( m_summonPoof.length, this.onSummonPoofComplete, null, true );
		}
		
		private function scaleInMon() : void
		{
			this.monBitmap.visible = true;
			
			this.m_monCenterSprite.scaleX = 
			this.m_monCenterSprite.scaleY = 0.5;
			
			TweenLite.to( this.m_monCenterSprite, 0.3, { scaleX: 1.0, scaleY: 1.0 });
		}
		
		public function scaleOutMon() : void
		{
			TweenLite.to( m_monCenterSprite, 0.3, { scaleX: 0.5, scaleY: 0.5, onComplete: this.onScaleOutComplete });
		}
		
		private function onScaleOutComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onScaleOutComplete', this);
			
			this.monBitmap.visible = false;
			
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}

		private function onSummonPoofComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onSummonPoofComplete', this);
			m_summonPoof.visible = false;
			
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		public function playPlayerAttack() : void
		{
			TinyLogManager.log('playPlayerAttack', this);	
			TweenMax.to( this.monBitmap, 0.12, { x: -28 + 7, ease: Cubic.easeIn, roundProps:['x'], yoyo: true, repeat: 1, onComplete: this.onPlayerAttackComplete } );
		}
		
		public function onPlayerAttackComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onPlayerAttackComplete', this);
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		public function playEnemyAttack() : void
		{
			TinyLogManager.log('playEnemyAttack', this);
			TweenMax.to( this.monBitmap, 0.12, { x: -28 - 7, ease: Cubic.easeIn, roundProps:['x'], yoyo: true, repeat: 1, onComplete: this.onEnemyAttackComplete } );
		}
		
		private function onEnemyAttackComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onEnemyAttackComplete', this);
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		public function playEnemyHitFlash() : void
		{
			TinyLogManager.log('playEnemyHitFlash', this);
			
			this.alpha = 0;
			TweenMax.to( this, 3, { alpha: 1, delay: 3, ease: SteppedEase.create(1), yoyo: true, repeat: 6, useFrames: true, onComplete: this.onEnemyHitFlashComplete } );
		}
		
		private function onEnemyHitFlashComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onEnemyHitFlashComplete', this);
			this.dispatchEvent( new Event(Event.COMPLETE) );	
		}
		
		public function playFaint() : void
		{
			TinyLogManager.log('playFaint', this);
			TweenLite.to( this.m_monCenterSprite, 0.3, { y: 28 + 56, ease: Cubic.easeIn, roundProps:['y'], onComplete: this.onPlayFaintComplete } );	
		}

		public function onPlayFaintComplete() : void
		{
			TinyLogManager.log('onPlayFaintComplete', this);
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
	}
}
