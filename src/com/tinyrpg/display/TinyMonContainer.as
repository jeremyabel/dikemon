package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.SteppedEase;
	
	import com.tinyrpg.display.SummonPoofSheet;
	import com.tinyrpg.display.TinySpriteSheet;
	import com.tinyrpg.display.TinyMonScaleAnimation;
	import com.tinyrpg.utils.TinyColor;
	import com.tinyrpg.utils.TinyFourColorPalette;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * Display class for a single mon sprite shown in battle. 
	 * 
	 * This class handles displaying and animating the mon at all times 
	 * in battle, from summoning, fainting, attacking and healing.
	 *  
	 * @author jeremyabel
	 */
	public class TinyMonContainer extends Sprite implements IShowHideObject
	{
		// The source mon bitmap
		public var monBitmap : Bitmap;
		
		// A special bitmap shown only when playing the scaling effect used when summoning or recalling a mon.
		public var monScaleBitmap : Bitmap;
		
		// The mon's color palette, used for optimising color transforms during move fx animations.
		public var palette : TinyFourColorPalette;
		
		private var monMask : Sprite;
		private var rightFacing : Boolean;
		private var m_monCenterSprite : Sprite;
		private var m_summonPoof : TinySpriteSheet; 
		
		private const MON_SIZE : int = 56;
		private const HALF_MON_SIZE : int = 28;
		
		/**
		 * Creates a new mon display sprite with a given bitmap. 
		 * 
		 * @param	bitmap			The mon bitmap to display.
		 * @param	rightFacing		Whether or not the mon should be flipped to face to the right.
		 */
		public function TinyMonContainer( bitmap : Bitmap, rightFacing : Boolean = false )
		{			
			this.rightFacing = rightFacing;
			
			// Make empty palette
			this.palette = new TinyFourColorPalette();
			
			// Make summon poof effect
			this.m_summonPoof = new TinySpriteSheet( new SummonPoofSheet(), 48, false, 3 );
			this.m_summonPoof.visible = false;
			this.m_summonPoof.x = 
			this.m_summonPoof.y = HALF_MON_SIZE;
			
			this.m_monCenterSprite = new Sprite();
			this.m_monCenterSprite.x = HALF_MON_SIZE; 
			this.m_monCenterSprite.y = HALF_MON_SIZE;
			this.m_monCenterSprite.cacheAsBitmap = true;
			
			// Make mon bitmap
			this.monBitmap = new Bitmap( bitmap.bitmapData.clone() );
			this.monBitmap.cacheAsBitmap = true;
			this.monBitmap.visible = false;
			this.monBitmap.scaleX = this.rightFacing ? -1 : 1;
			this.monBitmap.x = this.rightFacing ? HALF_MON_SIZE : -HALF_MON_SIZE;
			this.monBitmap.y = -HALF_MON_SIZE; 
			
			this.monScaleBitmap = new Bitmap( new BitmapData( MON_SIZE, MON_SIZE, false ) );
			this.monScaleBitmap.cacheAsBitmap = true;
			this.monScaleBitmap.visible = false;
			this.monScaleBitmap.scaleX = this.rightFacing ? -1 : 1;
			this.monScaleBitmap.x = this.rightFacing ? HALF_MON_SIZE : -HALF_MON_SIZE;
			this.monScaleBitmap.y = -HALF_MON_SIZE;
			
			// Make mon mask
			this.monMask = new Sprite();
			this.monMask.graphics.beginFill( 0x0000FF );
			this.monMask.graphics.drawRect( 0, 0, MON_SIZE, MON_SIZE );
			this.monMask.graphics.endFill();
			this.monMask.cacheAsBitmap = true;
			
			// Set mask
			this.m_monCenterSprite.mask = this.monMask; 
			
			// Add 'em up
			this.m_monCenterSprite.addChild( this.monBitmap );
			this.m_monCenterSprite.addChild( this.monScaleBitmap );
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
		
		/**
		 * Sets the bitmap to be shown by the mon display.
		 */
		public function setMonBitmap( bitmap : Bitmap ) : void
		{
			TinyLogManager.log('setMonBitmap', this);
			
			if ( this.monBitmap ) 
			{
				this.m_monCenterSprite.removeChild( this.monBitmap );
			}
			
			this.m_monCenterSprite.y = HALF_MON_SIZE;
			
			this.monBitmap = new Bitmap( bitmap.bitmapData.clone() );
			this.monBitmap.cacheAsBitmap = true;
			this.monBitmap.visible = false;
			this.monBitmap.scaleX = this.rightFacing ? -1 : 1;
			this.monBitmap.x = this.rightFacing ? HALF_MON_SIZE : -HALF_MON_SIZE;
			this.monBitmap.y = -HALF_MON_SIZE;
			
			// Get palette colors. Traverse the entire bitmap, adding the first 4 unique colors found to
			// a TinyFourColorPalette object. Once the palette is full, the search is stopped.
			for ( var y : int = 0; y < this.monBitmap.height; y++ )
			{
				for ( var x : int = 0; x < this.monBitmap.width; x++ )
				{
					var color : TinyColor = TinyColor.newFromHex32( this.monBitmap.bitmapData.getPixel32( x, y ) );
					
					// Ignore colors with low alpha and repeated colors
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
			
			// Fill any empty slots in the palette with black
			while ( !this.palette.isFull() ) 
			{
				var black : TinyColor = TinyColor.newFromHex32( 0 );
				this.palette.addColor( black );
			}
						
			// Sort palette by luminance
			this.palette.sort();
			
			this.m_monCenterSprite.addChild(this.monBitmap);
		}
		
		/**
		 * Plays the summoning poof effect, which consists of a spritesheet poof animation,
		 * and a grid-based scaling effect applied to the mon as it emerges from its ball.
		 * Dispatches a COMPLETE event when the animation is done.
		 */
		public function playSummonPoof() : void
		{
			TinyLogManager.log('playSummonPoof', this);
			
			this.monBitmap.visible = false;
			m_summonPoof.visible = true;
			
			m_summonPoof.play( 3 );
				
			TweenLite.delayedCall( m_summonPoof.length / 3, this.scaleInMon, null, true );	
			TweenLite.delayedCall( m_summonPoof.length, this.onSummonPoofComplete, null, true );
		}
		
		private function onSummonPoofComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onSummonPoofComplete', this);
			m_summonPoof.visible = false;
			
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		/**
		 * Plays the mon's 2-frame scale-in effect.
		 * Used when summoning a mon from its ball.
		 * Dispatches a COMPLETE event when the animation is done.
		 */
		private function scaleInMon() : void
		{
			this.monBitmap.visible = false;
			this.monScaleBitmap.visible = true;
			
			TinyMonScaleAnimation.drawScale1( this.monBitmap, this.monScaleBitmap );
				
			TweenLite.delayedCall( 0.10, TinyMonScaleAnimation.drawScale2, [ this.monBitmap, this.monScaleBitmap ] );
			TweenLite.delayedCall( 0.15, this.onScaleInComplete );
		}

		private function onScaleInComplete() : void
		{
			TinyLogManager.log('onScaleInComplete', this);
			
			// Hide the scale effect bitmap and show the full mon
			this.monBitmap.visible = true;
			this.monScaleBitmap.visible = false;
		}
		
		/**
		 * Plays the mon's 2-frame scale-out effect.
		 * Used when returning a mon to its ball.
		 * Dispatches a COMPLETE event when the animation is done.
		 */
		public function scaleOutMon() : void
		{
			this.monBitmap.visible = false;
			this.monScaleBitmap.visible = true;
			
			TinyMonScaleAnimation.drawScale2( this.monBitmap, this.monScaleBitmap );
				
			TweenLite.delayedCall( 0.10, TinyMonScaleAnimation.drawScale1, [ this.monBitmap, this.monScaleBitmap ] );
			TweenLite.delayedCall( 0.20, this.onScaleOutComplete );
		}
		
		private function onScaleOutComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onScaleOutComplete', this);
			
			// Hide both the mon and the scale effect bitmap
			this.monBitmap.visible = false;
			this.monScaleBitmap.visible = false;
			
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		/**
		 * Plays the mon's player attack animation, which consists of a quick forward nudge movement to the right. 
		 * Dispatches a COMPLETE event when the animation is done.
		 */
		public function playPlayerAttack() : void
		{
			TinyLogManager.log('playPlayerAttack', this);
			TweenMax.to( this.monBitmap, 0.12, { 
				x: HALF_MON_SIZE + 7, 
				ease: Cubic.easeIn, 
				roundProps:['x'], 
				yoyo: true, 
				repeat: 1, 
				onComplete: this.onPlayerAttackComplete 
			});
		}
		
		public function onPlayerAttackComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onPlayerAttackComplete', this);
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		/**
		 * Plays the mon's enemy attack animation, which consists of a quick forward nudge movement to the left.
		 * Dispatches a COMPLETE event when the animation is done.
		 */
		public function playEnemyAttack() : void
		{
			TinyLogManager.log('playEnemyAttack', this);
			TweenMax.to( this.monBitmap, 0.12, { 
				x: -HALF_MON_SIZE - 7, 
				ease: Cubic.easeIn, 
				roundProps:['x'], 
				yoyo: true, 
				repeat: 1, 
				onComplete: this.onEnemyAttackComplete 
			});
		}
		
		private function onEnemyAttackComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onEnemyAttackComplete', this);
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		/**
		 * Plays the player heal animation, which consists of a little jump upwards.
		 * Dispatches a COMPLETE event when the animation is done.
		 */
		public function playPlayerHeal() : void
		{
			TinyLogManager.log( 'playPlayerHeal', this );
			TweenMax.to( this, 0.12, { 
				y: "-5", 
				ease: Cubic.easeIn, 
				roundProps:['y'], 
				yoyo: true, 
				repeat: 5, 
				onComplete: this.onPlayerHealComplete 
			});
		}
		
		private function onPlayerHealComplete() : void
		{
			TinyLogManager.log( 'onPlayerHealComplete', this );
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		/**
		 * Plays the hitstun flash animation.
		 * Dispatches a COMPLETE event when the animation is done. 
		 */
		public function playEnemyHitFlash() : void
		{
			TinyLogManager.log('playEnemyHitFlash', this);
			
			this.alpha = 0;
			TweenMax.to( this, 3, { 
				alpha: 1, 
				delay: 3, 
				ease: SteppedEase.create(1), 
				yoyo: true, 
				repeat: 6, 
				useFrames: true, 
				onComplete: this.onEnemyHitFlashComplete 
			});
		}
		
		private function onEnemyHitFlashComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onEnemyHitFlashComplete', this);
			this.dispatchEvent( new Event(Event.COMPLETE) );	
		}
		
		/**
		 * Plays the faint animation, which consists of the mon bitmap being dropped off the screen.
		 * Dispatches a COMPLETE event when the animation is done. 
		 */
		public function playFaint() : void
		{
			TinyLogManager.log('playFaint', this);
			
			TweenLite.to( this.m_monCenterSprite, 0.3, { 
				y: HALF_MON_SIZE + MON_SIZE, 
				ease: Cubic.easeIn, 
				roundProps:['y'], 
				onComplete: this.onPlayFaintComplete 
			});	
		}

		public function onPlayFaintComplete() : void
		{
			TinyLogManager.log('onPlayFaintComplete', this);
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
	}
}
