package com.tinyrpg.data 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.SteppedEase;
	
	import com.tinyrpg.lookup.TinyNameLookup;
	import com.tinyrpg.lookup.TinySpriteLookup;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	/**
	 * Class which represents a sprite graphic placed on the map. 
	 * 
	 * Used during the intro cutscene to show the big character and mon sprites,
	 * and also to show some specific larger movable objects on the field map.
	 * 
	 * @author jeremyabel
	 */
	public class TinyFieldMapObjectSprite extends TinyFieldMapObject
	{
		// The name of the sprite to display
		public var spriteName : String;
		
		// The type of sprite to display, either "TRAINER", "MONSTER", or "OBJECT"
		public var spriteType : String;
		
		// Whether or not the sprite is visible when it is created
		public var startVisible : Boolean = false;
		
		public function TinyFieldMapObjectSprite() : void { }
		
		override public function dataReady() : void
		{
			var spriteBitmap : Bitmap;
			var replacedSpriteName : String = this.spriteName;
			
			// Replace sprite name "PLAYER" with the current player's trainer name 
			if ( spriteName == 'PLAYER' )
			{
				// TODO: Make dynamic
				replacedSpriteName = 'ANDY'; // Default player name
				
				if ( TinyGameManager.getInstance().playerTrainer ) {
					replacedSpriteName = TinyGameManager.getInstance().playerTrainer.name;
				}
			}
			
			// Replace sprite name "RIVAL" with the current player's rival name
			if ( spriteName == 'RIVAL' )
			{
				// TODO: Make dynamic
				replacedSpriteName = 'RACHEL'; // Default rival name
				
				if ( TinyGameManager.getInstance().playerTrainer ) {
					replacedSpriteName = TinyNameLookup.getRivalNameForPlayerName( TinyGameManager.getInstance().playerTrainer.name );
				}
			}
			
			// Create the sprite
			switch ( this.spriteType )
			{
				case 'TRAINER': spriteBitmap = new Bitmap( TinySpriteLookup.getTrainerSprite( replacedSpriteName ) ); break;
				case 'MONSTER': spriteBitmap = new Bitmap( TinySpriteLookup.getMonsterSprite( replacedSpriteName ) ); break;
				case 'OBJECT':  spriteBitmap = new Bitmap( TinySpriteLookup.getObjectSprite(  replacedSpriteName ) ); break;
			}
			
			// Place the sprite's origin in the center
			spriteBitmap.x -= Math.floor( spriteBitmap.width / 2 ) - 8;
			spriteBitmap.y -= Math.floor( spriteBitmap.height / 2 ) - 8;
			
			this.addChild( spriteBitmap );
			this.visible = this.startVisible;
			
			super.dataReady();
		}
		
		/**
		 * Fade the sprite in with an optional duration value, in frames.
		 */
		public function fadeIn( duration : uint = 20 ) : void
		{
			TinyLogManager.log( 'fadeIn', this );
			
			this.alpha = 0;
			this.visible = true;
			this.tweenAlpha( 1, duration );
		}
		
		/**
		 * Fade the sprite out with an optional duration value, in frames.
		 */
		public function fadeOut( duration : uint = 20 ) : void 
		{
			TinyLogManager.log( 'fadeOut', this );
			
			this.alpha = 1;
			this.visible = true;
			this.tweenAlpha( 0, duration );
		}
		
		private function tweenAlpha( targetAlpha : uint, duration : uint = 20 ) : void
		{
			TweenMax.to( this, duration, { 
				alpha: targetAlpha, 
				ease: SteppedEase.create( 4 ), 
				useFrames: true,
				onComplete: this.onAlphaTweenComplete
			});
		}
		
		private function onAlphaTweenComplete() : void
		{
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}
