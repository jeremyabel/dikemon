package com.tinyrpg.display 
{
	import com.greensock.TweenMax;
	import com.greensock.TimelineMax;
	import com.greensock.easing.SteppedEase;
	import com.tinyrpg.events.TinyGameEvent;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.BlendMode;
	import flash.display.Sprite;

	/**
	 * Display class which provides a full-screen solid sprite for various fade-out effects.
	 * 
	 * Used during map transitions and battle transistions. 
	 * {@link TinyGameManager} manages the timing of battle transitions. 
	 * {@link TinyMapManager} manages the timing of map transitions. 
	 * 
	 * @author jeremyabel
	 */
	public class TinyFadeTransitionOverlay extends Sprite 
	{
		private var speed : int;
		private var whiteBacking : Sprite;
		private var blackBacking : Sprite;
		
		public function TinyFadeTransitionOverlay( speed : int = 6 ) : void
		{
			this.speed = speed;
			
			this.whiteBacking = new Sprite();
			this.whiteBacking.graphics.beginFill( 0xFFFFFF );
			this.whiteBacking.graphics.drawRect( 0, 0, 160, 144 );
			this.whiteBacking.graphics.endFill();
			this.whiteBacking.blendMode = BlendMode.ADD;
			this.whiteBacking.alpha = 0;
			
			this.blackBacking = new Sprite();
			this.blackBacking.graphics.beginFill( 0x252525 );
			this.blackBacking.graphics.drawRect( 0, 0, 160, 144 );
			this.blackBacking.graphics.endFill();
			this.blackBacking.blendMode = BlendMode.MULTIPLY;
			this.blackBacking.alpha = 0;
			
			this.addChild( this.whiteBacking );
			this.addChild( this.blackBacking );
		}
		
		public function setWhiteAlpha( value : uint ) : void
		{
			TinyLogManager.log( 'setWhiteAlpha: ' + value, this );
			this.whiteBacking.alpha = value;
		}
		
		public function setBlackAlpha( value : uint ) : void
		{
			TinyLogManager.log( 'setBlackAlpha: ' + value, this );
			this.blackBacking.alpha = value;
		}
		
		public function setWhiteNormalBlending() : void
		{
			TinyLogManager.log( 'setWhiteNormalBlending', this );
			this.whiteBacking.blendMode = BlendMode.NORMAL;
		}
		
		public function setBlackNormalBlending() : void
		{
			TinyLogManager.log( 'setBlackNormalBlending', this );
			this.blackBacking.blendMode = BlendMode.NORMAL;
		}
		
		public function fadeOutToWhite( speed : uint = 6, delay : uint = 0 ) : void
		{
			TinyLogManager.log( 'fadeOutToWhite', this );
			this.tween( this.whiteBacking, 1, speed, delay );
		}
		
		public function fadeInFromWhite( speed : uint = 6, delay : uint = 0 ) : void
		{
			TinyLogManager.log( 'fadeInFromWhite', this );
			this.tween( this.whiteBacking, 0, speed, delay );
		}
		
		public function fadeOutToBlack( speed : uint = 6, delay : uint = 0 ) : void
		{
			TinyLogManager.log( 'fadeOutToBlack', this );
			this.tween( this.blackBacking, 1, speed, delay );
		}
		
		public function fadeInFromBlack( speed : uint = 6, delay : uint = 0 ) : void
		{
			TinyLogManager.log( 'fadeInFromBlack', this );
			this.tween( this.blackBacking, 0, speed, delay );
		}
		
		private function tween( object : Sprite, alpha : int, speed : uint = 6, delay : int = 0 ) : void
		{
			TweenMax.to( object, speed, { 
				alpha: alpha, 
				delay: delay,
				ease: SteppedEase.create( Math.min( speed / 2, 4 ) ), 
				useFrames: true,
				onStart: this.onFadeStart,
				onComplete: alpha == 0 ? this.onFadeInComplete : this.onFadeOutComplete
			});
		}
		
		private function onFadeStart() : void
		{
			TinyLogManager.log( 'onFadeStart', this );
			
			// Reset blend modes for both the white and black backing sprites
			this.whiteBacking.blendMode = BlendMode.ADD;
			this.blackBacking.blendMode = BlendMode.MULTIPLY;
		}
		
		private function onFadeOutComplete() : void
		{
			TinyLogManager.log( 'onFadeOutComplete', this );
			this.dispatchEvent( new TinyGameEvent( TinyGameEvent.FADE_OUT_COMPLETE ) );
		}
		
		private function onFadeInComplete() : void
		{
			TinyLogManager.log( 'onFadeInComplete', this );
			this.dispatchEvent( new TinyGameEvent( TinyGameEvent.FADE_IN_COMPLETE ) );
		}
		
		public function fadeBattleIn() : void 
		{
			TinyLogManager.log( 'fadeBattleIn', this );
			
			var battleInTimeline : TimelineMax = new TimelineMax({
				onComplete: this.onBattleInComplete,
				repeat: 2,
				useFrames: true,
				tweens: [
					TweenMax.to( this.whiteBacking, 6, {
						alpha: 0.7,
						ease: SteppedEase.create( 3 ), 
						repeat: 1,
						yoyo: true
					}),
					
					TweenMax.to( this.blackBacking, 6, {
						alpha: 0.85,
						ease: SteppedEase.create( 3 ), 
						repeat: 1,
						yoyo: true
					})
				]
			});
		}
		
		private function onBattleInComplete() : void
		{
			TinyLogManager.log( 'onBattleInComplete', this );		
			this.dispatchEvent( new TinyGameEvent( TinyGameEvent.BATTLE_IN_COMPLETE ) );
		}
	}
}
