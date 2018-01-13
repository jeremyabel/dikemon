package com.tinyrpg.managers 
{
	import com.tinyrpg.core.TinyFieldMap;
	import com.tinyrpg.data.TinyAppSettings;
	import com.tinyrpg.data.TinyFieldMapObjectWarp;
	import com.tinyrpg.data.TinyPlayerSpriteState;
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.events.TinyFieldMapEvent;	
	import com.tinyrpg.misc.TinySpriteConfig;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	/**
	 * @author jeremyabel
	 */
	public class TinyMapManager extends EventDispatcher
	{
		private static var instance : TinyMapManager = new TinyMapManager();
		
		private var m_currentMap : TinyFieldMap;
		private var warpObjectInProgress : TinyFieldMapObjectWarp;
		
		public var playerSprite : TinyWalkSprite;
		public var playerSpriteState : TinyPlayerSpriteState;
		public var mapContainer : Sprite;
		
		public function TinyMapManager() : void
		{
			this.mapContainer = new Sprite();
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
			
			// Stop all player sprite movement
			if ( this.playerSprite ) 
			{
				this.playerSprite.stopMovement();
			}
			
			if ( this.m_currentMap ) 
			{
				this.m_currentMap.addEventListener( TinyFieldMapEvent.HIDE_COMPLETE, this.onWarpHideComplete );
				this.m_currentMap.hide();
			}
			else
			{
				this.onWarpHideComplete();
			}
		}
		
		private function onWarpHideComplete( event : TinyFieldMapEvent = null ) : void
		{
			if ( event ) TinyLogManager.log( 'onWarpHideComplete', this );
			else TinyLogManager.log( 'onWarpHideComplete: skipped, no previous map', this );
			
			// Clean up and remove the previous map if there is one
			if ( this.m_currentMap )
			{
				this.m_currentMap.removeEventListener( TinyFieldMapEvent.HIDE_COMPLETE, this.onWarpHideComplete );
				this.mapContainer.removeChild( this.currentMap );
				this.m_currentMap = null;
			} 
			
			// Set the new current map using the data from the warp object
			this.currentMap = new TinyFieldMap( this.warpObjectInProgress.targetMapName );
			
			// Add the player sprite to the map with the correct facing
			this.addPlayerSprite( this.warpObjectInProgress.destinationFacing );
			
			// Find the destination warp object
			var destinationWarpObject : DisplayObject = this.currentMap.getMapObjectByName( this.warpObjectInProgress.targetWarpName );
			
			// Move the player sprite to the destination warp
			this.playerSprite.setPosition( destinationWarpObject.x, destinationWarpObject.y );
			
			// Show the current map
			this.m_currentMap.addEventListener( TinyFieldMapEvent.SHOW_COMPLETE, this.onWarpShowComplete );
			this.m_currentMap.show();
		}
		
		private function onWarpShowComplete( event : TinyFieldMapEvent ) : void
		{
			TinyLogManager.log( 'onWarpShowComplete', this );
			
			// Clean up
			this.m_currentMap.removeEventListener( TinyFieldMapEvent.SHOW_COMPLETE, this.onWarpShowComplete );
			
			// Move the player forward one step if required by the warp object
			if ( this.warpObjectInProgress.stepForwardAfterWarp )
			{
				// Disable map object collision while taking the first step 
				this.playerSpriteState.objectCollisionEnabled = false;
				
				// Move forward one step
				this.playerSprite.addEventListener( TinyFieldMapEvent.STEP_COMPLETE, this.onWarpStepForwardComplete );
				this.playerSprite.takeStep(); 
			}
			else 
			{
				// Otherwise give control to the player
				TinyInputManager.getInstance().setTarget( this.playerSprite );				
			}
			
			this.warpObjectInProgress = null;
		}
		
		private function onWarpStepForwardComplete( event : TinyFieldMapEvent ) : void
		{
			TinyLogManager.log( 'onWarpStepForwardComplete', this );
			
			this.playerSprite.removeEventListener( TinyFieldMapEvent.STEP_COMPLETE, this.onWarpStepForwardComplete );
			
			// Give control to the player
			TinyInputManager.getInstance().setTarget( this.playerSprite );
			
			// Re-enable map object collision
			this.playerSpriteState.objectCollisionEnabled = true;
		}

		public function addPlayerSprite( initialFacing : String = 'DOWN' ) : void
		{
			this.playerSprite = new TinyWalkSprite( TinySpriteConfig.PLAYER_1, initialFacing, true, true );
			this.playerSpriteState = new TinyPlayerSpriteState( playerSprite );
			
			this.m_currentMap.mapUserObjects.addChild( this.playerSprite );			
		}
		
		public function updateCamera( x : int, y : int ) : void
		{
			this.m_currentMap.x = -x + ( 160 / 2 ) - 8;
			this.m_currentMap.y = -y + ( 144 / 2 ) - 8;
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