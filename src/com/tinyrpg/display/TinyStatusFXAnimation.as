package com.tinyrpg.display 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.tinyrpg.utils.TinyLogManager; 

	/**
	 * Class which provides a sprite-based animation which is played when a mon is affected
	 * by a status effect and is prevented from using a normal move. 
	 * 
	 * For example: the "spinning birds" animation used when a mon is affected by Confusion. 
	 *
	 * @author jeremyabel
	 */
	public class TinyStatusFXAnimation extends Sprite 
	{
		private var statusFXSprite : TinyFXSprite;
		private var isEnemy : Boolean;
		private var currentFrame : int = 0;
		
		public var length 			: int;
		public var isPlaying		: Boolean;
		
		/**
		 * @param	name		The name of the status effect animation.
		 * @param	isEnemy		Whether or not the animation is called by the enemy mon.
		 */
		public function TinyStatusFXAnimation( name : String, isEnemy : Boolean )
		{
			this.isEnemy = isEnemy;
			
			// Make status FX sprite
			this.statusFXSprite = TinyFXSprite.newFromStatusEffect( name, this.isEnemy );
			this.length = this.statusFXSprite.length;
			
			// Add 'em up
			this.addChild( this.statusFXSprite );
		}
		
		/**
		 * Plays the status effect animation.
		 * When the animation is complete, a COMPLETE event will be emitted.
		 */
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
