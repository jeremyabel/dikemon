package com.tinyrpg.managers
{	
	import com.tinyrpg.battle.TinyBattleMon;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.data.TinyFieldMapObjectWarp;
	import com.tinyrpg.display.TinyFadeTransitionOverlay;
	import com.tinyrpg.events.TinyBattleEvent;
	import com.tinyrpg.events.TinyFieldMapEvent;
	import com.tinyrpg.events.TinyGameEvent;
	import com.tinyrpg.misc.TinySpriteConfig;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.display.Sprite;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyGameManager extends Sprite 
	{
		private static var instance : TinyGameManager = new TinyGameManager();
		
		public var gameContainer 	: Sprite;
		public var playerTrainer 	: TinyTrainer;
		 
		private var currentBattle 	: TinyBattleMon;
		private var fadeTransition 	: TinyFadeTransitionOverlay;
		
		public function TinyGameManager() : void
		{
			this.gameContainer = new Sprite();
			this.fadeTransition = new TinyFadeTransitionOverlay();
			
			// Add the map to the main game container sprite
			this.gameContainer.addChild( TinyMapManager.getInstance() );
			
			// Add 'em up
			this.addChild( this.gameContainer );
			this.addChild( this.fadeTransition );
		}

		// Singleton
		public static function getInstance() : TinyGameManager
		{
			return instance;
		}
		
		public function initWithTestData() : void
		{
			TinyLogManager.log( 'initWithTestData', this );
			this.playerTrainer = TinyTrainer.newFromTestData();
		}
			
		public function gotoMap( warpObject : TinyFieldMapObjectWarp ) : void
		{
			TinyLogManager.log( 'gotoMap: ' + warpObject.targetMapName, this );
			TinyMapManager.getInstance().warp( warpObject );
		}
		
		public function doWildBattle( enemyMon : TinyMon ) : void
		{
			TinyLogManager.log( 'doWildBattle: ' + enemyMon.name, this );
			this.currentBattle = new TinyBattleMon( this.playerTrainer, enemyMon );
			this.startBattle();
		}
		
		public function doTrainerBattle( enemyTrainer : TinyTrainer ) : void
		{
			TinyLogManager.log( 'doTrainerBattle: ' + enemyTrainer.name, this );
			this.currentBattle = new TinyBattleMon( this.playerTrainer, null, enemyTrainer );
			this.startBattle();
		}
		
		private function startBattle() : void
		{
			TinyLogManager.log( 'startBattle', this );
						
			// Remove player control
			TinyInputManager.getInstance().setTarget( null );
			
			// Play the 3x fade pulse animation 
			this.fadeTransition.addEventListener( TinyGameEvent.BATTLE_IN_COMPLETE, this.onBattleInComplete );
			this.fadeTransition.fadeBattleIn();
		}
		
		private function onBattleInComplete( event : TinyGameEvent ) : void
		{
			TinyLogManager.log( 'onBattleInComplete', this );
			
			// Cleanup
			this.fadeTransition.removeEventListener( TinyGameEvent.BATTLE_IN_COMPLETE, this.onBattleInComplete );
			 
			// Add the current battle and start it
			this.gameContainer.addChild( this.currentBattle );			
			this.currentBattle.startBattle();
			
			// Listen for the battle to be complete
			this.currentBattle.addEventListener( TinyBattleEvent.BATTLE_COMPLETE, this.onBattleComplete );
		}
		
		private function onBattleComplete( event : TinyBattleEvent ) : void
		{
			TinyLogManager.log( 'onBattleComplete', this );
			
			// Cleanup
			this.currentBattle.removeEventListener( TinyBattleEvent.BATTLE_COMPLETE, this.onBattleComplete );
			
			// Play fade-out white transition
			this.fadeTransition.addEventListener( TinyGameEvent.FADE_OUT_COMPLETE, this.onBattleOutComplete );
			this.fadeTransition.fadeOutToWhite( 20 );
		}
		
		private function onBattleOutComplete( event : TinyGameEvent ) : void
		{
			TinyLogManager.log( 'onBattleOutComplete', this );
			
			// Cleanup
			this.fadeTransition.removeEventListener( TinyGameEvent.FADE_OUT_COMPLETE, this.onBattleOutComplete );
			
			// Remove the battle from the display list
			this.gameContainer.removeChild( this.currentBattle );
			this.currentBattle = null;
			
			// Fade in the map
			this.fadeTransition.addEventListener( TinyGameEvent.FADE_IN_COMPLETE, this.onMapInComplete );
			this.fadeTransition.fadeInFromWhite( 5 );
		}
		
		private function onMapInComplete( event : TinyGameEvent ) : void
		{
			TinyLogManager.log( 'onMapInComplete', this );
			
			TinyMapManager.getInstance().onBattleComplete();
		}
	}
}