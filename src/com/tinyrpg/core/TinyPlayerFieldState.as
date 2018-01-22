package com.tinyrpg.core 
{	
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyFieldMapObject;
	import com.tinyrpg.data.TinyFieldMapObjectTrigger;
	import com.tinyrpg.data.TinyFieldMapObjectWarp;
	import com.tinyrpg.data.TinyFieldMapObjectNPC;
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.events.TinyFieldMapEvent;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.events.EventDispatcher;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyPlayerFieldState extends EventDispatcher
	{
		public var objectCollisionEnabled : Boolean = true;
		
		private var walkSprite : TinyWalkSprite;
		private var lastWarpHit : TinyFieldMapObjectWarp = null;
		private var stepsSinceEncounter : int = 0;
		
		public function TinyPlayerFieldState( walkSprite : TinyWalkSprite ) : void 
		{
			this.walkSprite = walkSprite;
			this.walkSprite.addEventListener( TinyFieldMapEvent.JUMP_HIT, this.onHitJump );
			this.walkSprite.addEventListener( TinyFieldMapEvent.GRASS_HIT, this.onHitGrass );
			this.walkSprite.addEventListener( TinyFieldMapEvent.OBJECT_HIT, this.onHitObject );
			this.walkSprite.addEventListener( TinyFieldMapEvent.NOTHING_HIT, this.onHitNothing );
		}
		
		public function destroy() : void
		{
			this.walkSprite.removeEventListener( TinyFieldMapEvent.JUMP_HIT, this.onHitJump );
			this.walkSprite.removeEventListener( TinyFieldMapEvent.GRASS_HIT, this.onHitGrass );
			this.walkSprite.removeEventListener( TinyFieldMapEvent.OBJECT_HIT, this.onHitObject );
			this.walkSprite.removeEventListener( TinyFieldMapEvent.NOTHING_HIT, this.onHitNothing );
		}
		
		private function onHitObject( event : TinyFieldMapEvent ) : void
		{
			if ( !this.objectCollisionEnabled ) return;
			
			this.stepsSinceEncounter++;
			
			var hitObject : * = event.param.object;
			
			if ( hitObject is TinyFieldMapObject )
			{
				if ( hitObject is TinyFieldMapObjectTrigger )
				{
					this.onHitTrigger( hitObject as TinyFieldMapObjectTrigger, event.param.fromAcceptKeypress ); 
					return;
				}
				
				if ( hitObject is TinyFieldMapObjectWarp )
				{
					this.onHitWarp( hitObject as TinyFieldMapObjectWarp );
					return;
				}
			
				if ( hitObject is TinyFieldMapObjectNPC ) 
				{
					this.onHitNPC( hitObject as TinyFieldMapObjectNPC, event.param.fromAcceptKeypress );
					return;
				}
			}
		}
		
		private function onHitJump( event : TinyFieldMapEvent ) : void
		{
			TinyLogManager.log( 'onHitJump: ' + event.param.object.name, this );
			
			this.stepsSinceEncounter++;
			
			var jumpTileIncrement : uint = 2; 
			var jumpTargetX : int = this.walkSprite.x;
			var jumpTargetY : int = this.walkSprite.y;
			
			// Get the player's post-jump location according to what sort of tile they're trying to jump from
			switch ( event.param.object.name )
			{
				case 'jumpU': jumpTargetY -= 16 * jumpTileIncrement; break;
				case 'jumpD': jumpTargetY += 16 * jumpTileIncrement; break;
				case 'jumpL': jumpTargetX -= 16 * jumpTileIncrement; break;
				case 'jumpR': jumpTargetX += 16 * jumpTileIncrement; break;
			}
		}
		
		private function onHitGrass( event : TinyFieldMapEvent ) : void 
		{
			this.stepsSinceEncounter++;
			
			// Wait until the step counter is at least 5 before trying to spawn an encounter.
			// This prevents encounter-locking after battles and when entering a map. 
			if ( this.stepsSinceEncounter <= 5 ) return;
			
			// See if an encounter happens
			var encounterMon : TinyMon = TinyMapManager.getInstance().currentMap.tryWildEncounter();
			
			// Begin encounter if there is one
			if ( encounterMon )
			{
				TinyLogManager.log( 'onHitGrass: encountered ' + encounterMon.name + '!', this );
				TinyGameManager.getInstance().doWildBattle( encounterMon );
				this.walkSprite.stop();
			}
			else
			{
				TinyLogManager.log( 'onHitGrass: no encounter', this );
			}
		}
		
		private function onHitNothing( event : TinyFieldMapEvent ) : void
		{
			this.stepsSinceEncounter++;
			this.clearLastWarp();
		}
				
		private function onHitWarp( warpObject : TinyFieldMapObjectWarp ) : void
		{
			TinyLogManager.log( 'onHitWarp: ' + warpObject.targetMapName, this );
			
			if ( this.lastWarpHit )
			{	
				// If this warp has been hit twice and the sprite's facing matches the required warp facing, trigger the warp
				if ( this.lastWarpHit.targetMapName == warpObject.targetMapName && this.walkSprite.currentDirection == this.lastWarpHit.requiredFacing )
				{
					TinyLogManager.log( 'onHitWarp: current facing matches warp facing', this );
					TinyMapManager.getInstance().warp( this.lastWarpHit );
					this.lastWarpHit = null;
					return;
				}
			
				// Overwrite the last warp object
				this.lastWarpHit = warpObject;
			}
			else 
			{	
				// Triggered an instant warp, go there immediately
				if ( warpObject.instant ) 
				{
					TinyLogManager.log( 'onHitWarp: triggered instant warp', this );
					TinyMapManager.getInstance().warp( warpObject );
					return;
				}
				
				TinyLogManager.log( 'onHitWarp: waiting for warp', this );
				
				// Didn't trigger an instant warp, so save this warp object so it can be triggered if it is hit twice.
				this.lastWarpHit = warpObject;
			}
		}
		
		private function onHitNPC( npcObject : TinyFieldMapObjectNPC, fromAcceptKeypress : Boolean ) : void
		{
			TinyLogManager.log( 'onHitNPC: ' + npcObject.npcName, this );
			
			this.stepsSinceEncounter++;
			
			// Exit if an accept keypress is required and none was found
			if ( !fromAcceptKeypress ) return;
			
			// Set the NPC to face the player
			npcObject.setFacingFromPlayerFacing( this.walkSprite.currentDirection );
		}
		
		private function onHitTrigger( triggerObject : TinyFieldMapObjectTrigger, fromAcceptKeypress : Boolean ) : void
		{
			TinyLogManager.log( 'onHitTrigger: ' + triggerObject.eventName, this );
			
			this.stepsSinceEncounter++;
			
			// If there is a required facing, check it before executing the event
			if ( triggerObject.requiredFacing )
			{
				// If the facing doesn't match, exit
				if ( this.walkSprite.currentDirection != triggerObject.requiredFacing ) 
				{
					TinyLogManager.log( 'onHitTrigger: current facing does not match trigger facing', this );
					return;
				}
				
				TinyLogManager.log( 'onHitTrigger: current facing matches trigger facing', this );
			}
			
			// Exit if an accept keypress is required and none was found
			if ( triggerObject.requireAcceptKeypress && !fromAcceptKeypress ) return;
			
			// Good to go: play the event
			TinyMapManager.getInstance().startEventByName( triggerObject.eventName );
		}
		
		public function clearLastWarp() : void
		{
			this.lastWarpHit = null;
		}
		
		public function resetStepsSinceEncounter() : void
		{
			TinyLogManager.log( 'resetStepsSinceEncounter', this );
			this.stepsSinceEncounter = 0;
		}
		
	}
}
