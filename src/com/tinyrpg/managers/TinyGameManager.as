package com.tinyrpg.managers
{	
	import com.tinyrpg.battle.TinyBattle;
	import com.tinyrpg.battle.TinyBattleResult;
	import com.tinyrpg.core.TinyConfig;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.data.TinyFieldMapObjectWarp;
	import com.tinyrpg.display.TinyFadeTransitionOverlay;
	import com.tinyrpg.events.TinyFieldMapEvent;
	import com.tinyrpg.events.TinyGameEvent;
	import com.tinyrpg.lookup.TinySpriteLookup;
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
		 
		private var currentBattle 	: TinyBattle;
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
			this.playerTrainer = TinyTrainer.newFromStarterData( TinyConfig.PLAYER_NAME );
		}
			
		public function gotoMap( warpObject : TinyFieldMapObjectWarp ) : void
		{
			TinyLogManager.log( 'gotoMap: ' + warpObject.targetMapName, this );
			TinyMapManager.getInstance().warp( warpObject );
		}
		
		public function doWildBattle( enemyMon : TinyMon ) : void
		{
			TinyLogManager.log( 'doWildBattle: ' + enemyMon.name, this );
			this.currentBattle = new TinyBattle( this.playerTrainer, enemyMon );
			this.startBattle();
		}
		
		public function doTrainerBattle( enemyTrainer : TinyTrainer, allowGameOver : Boolean = true ) : void
		{
			TinyLogManager.log( 'doTrainerBattle: ' + enemyTrainer.name, this );
			this.currentBattle = new TinyBattle( this.playerTrainer, null, enemyTrainer, allowGameOver );
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
			this.currentBattle.addEventListener( TinyGameEvent.BATTLE_COMPLETE, this.onBattleComplete );
		}
		
		private function onBattleComplete( event : TinyGameEvent ) : void
		{
			TinyLogManager.log( 'onBattleComplete: ' + event.param.value, this );
			
			// Cleanup
			this.currentBattle.removeEventListener( TinyGameEvent.BATTLE_COMPLETE, this.onBattleComplete );
			
			// If the player lost the battle and the battle allows a game over, do the game over.
			// Battles always allow a game over unless they are specific event battles.
			if ( event.param.value == TinyBattleResult.RESULT_LOSE && this.currentBattle.allowGameOver )
			{
				// Play fade-out black transition then go to game over
				this.fadeTransition.addEventListener( TinyGameEvent.FADE_OUT_COMPLETE, this.onBattleOutCompleteToGameOver );
				this.fadeTransition.fadeOutToBlack( 20, 6 );
			}
			else 
			{
				// Play fade-out white transition
				this.fadeTransition.addEventListener( TinyGameEvent.FADE_OUT_COMPLETE, this.onBattleOutComplete );
				this.fadeTransition.fadeOutToWhite( 20 );
			}
		}
		
		private function onBattleOutCompleteToGameOver( event : TinyGameEvent ) : void
		{
			TinyLogManager.log( 'onBattleOutCompleteToGameOver', this );
			
			// Remove the battle from the display list
			this.gameContainer.removeChild( this.currentBattle );
			
			// Cleanup
			this.fadeTransition.removeEventListener( TinyGameEvent.FADE_OUT_COMPLETE, this.onBattleOutCompleteToGameOver );
			this.currentBattle = null;
			
			// A game over warps the player back to the nearest Dikécenter
			var gameOverWarp : TinyFieldMapObjectWarp = new TinyFieldMapObjectWarp()
			gameOverWarp.targetMapName = TinyMapManager.getInstance().currentMap.gameoverMapName;
			gameOverWarp.targetWarpName = 'warpGameover';
			gameOverWarp.postFadeSequenceName = 'gameover';
			gameOverWarp.destinationFacing = 'UP'; 
			gameOverWarp.fromGameOver = true;
			this.gotoMap( gameOverWarp );
			
			// Clear the black transition overlay immediately, since it would conflict with the MapManager's overlay			
			this.fadeTransition.setBlackAlpha( 0 );
		}
		
		private function onBattleOutComplete( event : TinyGameEvent ) : void
		{
			TinyLogManager.log( 'onBattleOutComplete', this );
			
			// Cleanup
			this.fadeTransition.removeEventListener( TinyGameEvent.FADE_OUT_COMPLETE, this.onBattleOutComplete );
			
			// Remove the battle from the display list
			this.gameContainer.removeChild( this.currentBattle );
			
			// Adjust fade-in handling based on whether or not the battle was a trainer battle or not. Trainer battles need
			// to continue running their host event sequence, whereas wild battles return control to the player immediately.
			if ( this.currentBattle.m_isWildEncounter ) 
			{
				this.fadeTransition.addEventListener( TinyGameEvent.FADE_IN_COMPLETE, this.onMapInCompleteFromWildBattle );
			}
			else
			{
				this.fadeTransition.addEventListener( TinyGameEvent.FADE_IN_COMPLETE, this.onMapInCompleteFromTrainerBattle );
			}
			
			// Fade in the map
			this.fadeTransition.fadeInFromWhite( 5 );
		}
		
		private function onMapInCompleteFromWildBattle( event : TinyGameEvent ) : void
		{
			TinyLogManager.log( 'onMapInCompleteFromWildBattle', this );
			
			// Return control to the player
			TinyMapManager.getInstance().onBattleComplete( this.currentBattle.result, false );
			
			this.currentBattle = null;
		}
		
		private function onMapInCompleteFromTrainerBattle( event : TinyGameEvent ) : void
		{
			TinyLogManager.log( 'onMapInCompleteFromTrainerBattle', this );
			
			// Return control to the player
			TinyMapManager.getInstance().onBattleComplete( this.currentBattle.result, true );
			
			this.currentBattle = null;
		}
	}
}