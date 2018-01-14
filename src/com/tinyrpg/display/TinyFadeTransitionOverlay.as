package com.tinyrpg.display 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.SteppedEase;
	import com.tinyrpg.events.TinyGameEvent;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.BlendMode;
	import flash.display.Sprite;

	/**
	 * @author jeremyabel
	 */
	public class TinyFadeTransitionOverlay extends Sprite 
	{
		private var speed : int;
		
		public function TinyFadeTransitionOverlay( speed : int = 6 ) : void
		{
			this.graphics.beginFill( 0xFFFFFF );
			this.graphics.drawRect( 0, 0, 160, 144 );
			this.graphics.endFill();
			this.blendMode = BlendMode.ADD;
			this.alpha = 0;
			this.speed = speed;
		}
		
		public function fadeOut() : void
		{
			TinyLogManager.log( 'fadeOut', this );
			
			TweenLite.to( this, this.speed, { 
				alpha: 1, 
				ease: SteppedEase.create( this.speed / 2 ), 
				useFrames: true,
				onComplete: this.onFadeOutComplete 
			});
		}
		
		public function fadeIn() : void
		{
			TinyLogManager.log( 'fadeIn', this );
			
			TweenLite.to( this, this.speed, { 
				alpha: 0, 
				ease: SteppedEase.create( this.speed / 2 ), 
				useFrames: true,
				onComplete: this.onFadeInComplete 
			});
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
	}
}
