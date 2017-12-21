package com.tinyrpg.display 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.tinyrpg.utils.TinyLogManager; 

	/**
	 * @author jeremyabel
	 */
	public class TinyStatusFXAnimation extends Sprite 
	{
		private var statusFXSprite : TinyFXSprite;
		private var isEnemy : Boolean;
		private var currentFrame : int = 0;
		
		public var length 			: int;
		public var isPlaying		: Boolean;
		
		public function TinyStatusFXAnimation( name : String, isEnemy : Boolean )
		{
			this.isEnemy = isEnemy;
			
			// Make status FX sprite
			this.statusFXSprite = TinyFXSprite.newFromStatusEffect( name, this.isEnemy );
			this.length = this.statusFXSprite.length;
			
			// Add 'em up
			this.addChild( this.statusFXSprite );
		}
		
		public function play() : void
		{
			TinyLogManager.log('play', this);
			
			// Reset counters
			this.currentFrame = 0;
			
			// Play!
			this.statusFXSprite.play();
			this.addEventListener( Event.ENTER_FRAME, this.onEnterFrame );
		}
		
		protected function onEnterFrame( event : Event ) : void
		{
			this.currentFrame++;
			
			// Clean up if the sprite animation is done
			if ( !this.statusFXSprite.isPlaying )
			{
				this.removeEventListener( Event.ENTER_FRAME, this.onEnterFrame );
				this.dispatchEvent( new Event( Event.COMPLETE ) );	
			}
		}
	}
}
