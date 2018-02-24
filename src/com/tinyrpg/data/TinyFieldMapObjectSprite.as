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
	 * @author jeremyabel
	 */
	public class TinyFieldMapObjectSprite extends TinyFieldMapObject
	{
		public var spriteName : String;
		public var spriteType : String;
		public var startVisible : Boolean = false;
		
		public function TinyFieldMapObjectSprite() : void 
		{
						
		}
		
		override public function dataReady() : void
		{
			var spriteBitmap : Bitmap;
			var replacedSpriteName : String = this.spriteName;
			
			if ( spriteName == 'PLAYER' )
			{
				if ( TinyGameManager.getInstance().playerTrainer )
				{
					replacedSpriteName = TinyGameManager.getInstance().playerTrainer.name;
				}
				else 
				{
					replacedSpriteName = 'ANDY';
				}
			}
			
			if ( spriteName == 'RIVAL' )
			{
				if ( TinyGameManager.getInstance().playerTrainer )
				{
					replacedSpriteName = TinyNameLookup.getRivalNameForPlayerName( TinyGameManager.getInstance().playerTrainer.name );
				}
				else
				{
					replacedSpriteName = 'RACHEL';
				}
			}
			
			switch ( this.spriteType )
			{
				case 'TRAINER': spriteBitmap = new Bitmap( TinySpriteLookup.getTrainerSprite( replacedSpriteName ) ); break;
				case 'MONSTER': spriteBitmap = new Bitmap( TinySpriteLookup.getMonsterSprite( replacedSpriteName ) ); break;
			}
			
			spriteBitmap.x -= Math.floor( spriteBitmap.width / 2 ) - 8;
			spriteBitmap.y -= Math.floor( spriteBitmap.height / 2 ) - 8;
			
			this.addChild( spriteBitmap );
			this.visible = this.startVisible;
			
			super.dataReady();
		}
		
		public function fadeIn() : void
		{
			TinyLogManager.log( 'fadeIn', this );
			
			this.alpha = 0;
			this.visible = true;
			this.tweenAlpha( 1 );
		}
		
		public function fadeOut() : void 
		{
			TinyLogManager.log( 'fadeOut', this );
			
			this.alpha = 1;
			this.visible = true;
			this.tweenAlpha( 0 );
		}
		
		private function tweenAlpha( targetAlpha : uint ) : void
		{
			TweenMax.to( this, 20, { 
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
