package com.tinyrpg.managers 
{
	import com.tinyrpg.core.TinyFieldMap;
	import com.tinyrpg.core.TinyPlayerFieldState;
	import com.tinyrpg.data.TinyFieldMapObjectWarp;
	import com.tinyrpg.display.TinyFadeTransitionOverlay;
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.events.TinyBattleEvent;	
	import com.tinyrpg.events.TinyFieldMapEvent;
	import com.tinyrpg.events.TinyGameEvent;	
	import com.tinyrpg.misc.TinySpriteConfig;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	/**
	 * @author jeremyabel
	 */
	public class TinyMapManager extends Sprite
	{
		private static var instance : TinyMapManager = new TinyMapManager();
		
		private var m_currentMap : TinyFieldMap;
		private var fadeTransition : TinyFadeTransitionOverlay;
		private var warpObjectInProgress : TinyFieldMapObjectWarp;
		
		public var playerSprite : TinyWalkSprite;
		public var playerFieldState : TinyPlayerFieldState;
		public var mapContainer : Sprite;
		public var mapEventContainer : Sprite;
		
		public function TinyMapManager() : void
		{
			this.mapContainer = new Sprite();
			this.mapEventContainer = new Sprite();
			this.fadeTransition = new TinyFadeTransitionOverlay();
			
			// Add 'em up
			this.addChild( this.mapContainer );
			this.addChild( this.mapEventContainer );
			this.addChild( this.fadeTransition );
		}

		// Singleton
		public static function getInstance() : TinyMapManager
		{
			return instance;
		}
		
		public function warp( warpObject : TinyFieldMapObjectWarp ) : void
		{
			TinyLogManager.log( 'warpToMap: ' + warpObject.targetMapName, this );
			
			this.warpObjectInProgress = warpObject;
			
			// Remove player control
			TinyInputManager.getInstance().setTarget( null );
			
			// Fade out the current map, if there is one
			if ( this.m_currentMap ) 
			{
				this.fadeTransition.addEventListener( TinyGameEvent.FADE_OUT_COMPLETE, this.onWarpHideComplete );
				this.fadeTransition.fadeOutToWhite();
			}
			else
			{
				this.onWarpHideComplete();
			}
		}
		
		private function onWarpHideComplete( event : TinyGameEvent = null ) : void
		{
			if ( event ) TinyLogManager.log( 'onWarpHideComplete', this );
			else TinyLogManager.log( 'onWarpHideComplete: skipped, no previous map', this );
			
			// Clean up
			this.fadeTransition.removeEventListener( TinyGameEvent.FADE_OUT_COMPLETE, this.onWarpHideComplete );
			
			// Remove the previous map if there is one
			if ( this.m_currentMap )
			{
				this.mapContainer.removeChild( this.currentMap );
				this.m_currentMap = null;
			} 
			
			// Set the new current map using the data from the warp object
			this.currentMap = new TinyFieldMap( this.warpObjectInProgress.targetMapName );
			
			// Add the player sprite to the map with the correct facing
			this.addPlayerSprite( this.warpObjectInProgress.destinationFacing );
			
			// Find the destination warp object
			var destinationWarpObject : DisplayObject = this.currentMap.getMapObjectByName( this.warpObjectInProgress.targetWarpName );
			TinyLogManager.log( 'warp destination: ' + this.warpObjectInProgress.targetWarpName, this );
			
			// Move the player sprite to the destination warp
			this.playerSprite.setPosition( destinationWarpObject.x, destinationWarpObject.y );
			
			// Fade in the new current map
			this.fadeTransition.addEventListener( TinyGameEvent.FADE_IN_COMPLETE, this.onWarpShowComplete );
			this.fadeTransition.fadeInFromWhite();
		}
		
		private function onWarpShowComplete( event : TinyGameEvent = null ) : void
		{
			TinyLogManager.log( 'onWarpShowComplete', this );
			
			// Clean up
			this.fadeTransition.removeEventListener( TinyGameEvent.FADE_IN_COMPLETE, this.onWarpShowComplete );
			
			// Reset player step counter
			this.playerFieldState.resetStepsSinceEncounter();
			
			// Move the player forward one step if required by the warp object
			if ( this.warpObjectInProgress.stepForwardAfterWarp )
			{
				// Disable map object collision while taking the first step
				this.playerFieldState.objectCollisionEnabled = false;
				
				// Move forward one step
				this.playerSprite.addEventListener( TinyFieldMapEvent.STEP_COMPLETE, this.onWarpStepForwardComplete );
				this.playerSprite.takeStep(); 
			}
			else 
			{
				// Otherwise give control to the player immediately
				TinyInputManager.getInstance().setTarget( this.playerSprite );
			}
			
			this.warpObjectInProgress = null;
		}
		
		private function onWarpStepForwardComplete( event : TinyFieldMapEvent ) : void
		{
			TinyLogManager.log( 'onWarpStepForwardComplete', this );
			
			// Clean up
			this.playerSprite.removeEventListener( TinyFieldMapEvent.STEP_COMPLETE, this.onWarpStepForwardComplete );
			
			// Give control to the player
			TinyInputManager.getInstance().setTarget( this.playerSprite );
			
			// Re-enable map object collision
			this.playerFieldState.objectCollisionEnabled = true;
			this.playerFieldState.clearLastWarp();
		}

		public function addPlayerSprite( initialFacing : String = 'DOWN' ) : void
		{
			if ( this.playerFieldState ) this.playerFieldState.destroy();
			
			this.playerFieldState = null;
			this.playerSprite = null;
			
			this.playerSprite = new TinyWalkSprite( TinySpriteConfig.PLAYER_1, initialFacing, true, true );
			this.playerFieldState = new TinyPlayerFieldState( playerSprite );
			
			this.m_currentMap.mapUserObjects.addChild( this.playerSprite );			
		}
		
		public function updateCamera( x : int, y : int ) : void
		{
			this.m_currentMap.x = -x + ( 160 / 2 ) - 8;
			this.m_currentMap.y = -y + ( 144 / 2 ) - 8;
		}
		
		public function startEventByName( eventName : String ) : void
		{
			TinyLogManager.log( 'startEventByName: ' + eventName, this );
			
			this.playerSprite.stopWalking();
			
			// Remove player control
			TinyInputManager.getInstance().setTarget( null );
			
			// Start the event
			this.m_currentMap.addEventListener( TinyFieldMapEvent.EVENT_COMPLETE, this.onEventComplete );
			this.m_currentMap.startEventByName( eventName );
		}
		
		private function onEventComplete( event : TinyFieldMapEvent ) : void
		{
			TinyLogManager.log( 'onEventComplete', this );
			
			// Clean up
			this.m_currentMap.removeEventListener( TinyFieldMapEvent.EVENT_COMPLETE, this.onEventComplete );
			
			// Return control to the player
			TinyInputManager.getInstance().setTarget( this.playerSprite );
		}
		
		public function onBattleComplete() : void
		{
			TinyLogManager.log( 'onBattleComplete', this );
			
			// Reset player step counter
			this.playerFieldState.resetStepsSinceEncounter();
			
			// Return control to the player
			TinyInputManager.getInstance().setTarget( this.playerSprite );
		}
		
		public function set currentMap( value : TinyFieldMap ) : void
		{
			TinyLogManager.log( 'set currentMap', this );
			this.m_currentMap = value;
			this.mapContainer.addChild( this.m_currentMap );
		}
		
		public function get currentMap() : TinyFieldMap
		{
			return this.m_currentMap;
		}
		
	}
}