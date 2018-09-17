package com.tinyrpg.core 
{	
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyCollisionData;
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
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyPlayerFieldState extends EventDispatcher
	{
		public var objectCollisionEnabled : Boolean = true;
		
		private var walkSprite 			: TinyWalkSprite;
		private var lastWarpHit 		: TinyFieldMapObjectWarp = null;
		private var stepsSinceEncounter : int = 0;
		private var repelStepCounter	: int = 0;
		
		public function TinyPlayerFieldState( walkSprite : TinyWalkSprite ) : void 
		{
			this.walkSprite = walkSprite;
			this.walkSprite.addEventListener( TinyFieldMapEvent.JUMP_HIT, this.onHitJump );
			this.walkSprite.addEventListener( TinyFieldMapEvent.GRASS_HIT, this.onHitGrass );
			this.walkSprite.addEventListener( TinyFieldMapEvent.OBJECT_HIT, this.onHitObject );
			this.walkSprite.addEventListener( TinyFieldMapEvent.NOTHING_HIT, this.onHitNothing );
		}
		
		
		/**
		 * Prepares object for destruction by removing all event listeners.
		 */	
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
			
			this.incrementStepCounter();
			
			var hitObject : * = event.param.object;
			var isSightbox : Boolean = event.param.isSightbox;
						
			if ( hitObject is TinyFieldMapObject )
			{
				// Hit trigger object
				if ( hitObject is TinyFieldMapObjectTrigger )
				{
					this.onHitTrigger( hitObject as TinyFieldMapObjectTrigger, event.param.fromAcceptKeypress ); 
					return;
				}
				
				// Hit warp object
				if ( hitObject is TinyFieldMapObjectWarp )
				{
					this.onHitWarp( hitObject as TinyFieldMapObjectWarp );
					return;
				}
			
				// Hit NPC object
				if ( hitObject is TinyFieldMapObjectNPC ) 
				{
					var npcObject : TinyFieldMapObjectNPC = hitObject as TinyFieldMapObjectNPC;
					
					if ( npcObject.isTrainer && isSightbox )
					{ 
						this.onHitSightbox( npcObject );
					} 
					else
					{
						this.onHitNPC( npcObject, event.param.fromAcceptKeypress );
					}
				}
			}
		}
		
		
		/**
		 * Handler for collisions with the JUMP layer. The JUMP layer is only traversable in one direction, 
		 * and it triggers a 3-step jump animation over a ledge.
		 * 
		 * @param	event	the {@link TinyFieldMapEvent} instance
		 */
		private function onHitJump( event : TinyFieldMapEvent ) : void
		{
			TinyLogManager.log( 'onHitJump: ' + event.param.object.name, this );
			
			this.incrementStepCounter();
	
			// Only allow a jump if the player is facing the right direction
			switch ( event.param.object.name )
			{
				case 'jumpU': if ( this.walkSprite.currentDirection != TinyWalkSprite.UP ) return; break;
				case 'jumpD': if ( this.walkSprite.currentDirection != TinyWalkSprite.DOWN ) return; break;
				case 'jumpL': if ( this.walkSprite.currentDirection != TinyWalkSprite.LEFT ) return; break;
				case 'jumpR': if ( this.walkSprite.currentDirection != TinyWalkSprite.RIGHT ) return; break;
			}
			
			// Remove player control during the jump
			TinyInputManager.getInstance().setTarget( null );
	
			// Take 3 steps in the current direction
			this.walkSprite.addEventListener( TinyFieldMapEvent.STEP_COMPLETE, this.onJumpComplete );
			this.walkSprite.takeSteps( 3 );
			this.walkSprite.playJump();
			this.walkSprite.showJumpShadow();
		}
		
		
		/**
		 * Function that is called when the jump movement is complete. Removes the jump shadow sprite and 
		 * returns control to the player. 
		 * 
		 * @param	event	the {@link TinyFieldMapEvent} instance
		 */
		private function onJumpComplete( event : TinyFieldMapEvent ) : void 
		{
			TinyLogManager.log( 'onJumpComplete', this );
			
			// Cleanup
			this.walkSprite.removeEventListener( TinyFieldMapEvent.STEP_COMPLETE, this.onJumpComplete );
			this.walkSprite.hideJumpShadow();
			
			// Return player control
			TinyInputManager.getInstance().setTarget( this.walkSprite );
		}
		
		
		/**
		 * Handler for collisions with the GRASS layer. GRASS is traversable in all directions, but it has the 
		 * potential to trigger a random encounter.
		 * 
		 * @param	event	the {@link TinyFieldMapEvent} instance
		 */
		private function onHitGrass( event : TinyFieldMapEvent ) : void 
		{
			this.incrementStepCounter();
			
			// Check for map object collisions
			var objectCollision : TinyCollisionData = TinyMapManager.getInstance().currentMap.checkObjectCollision( this.walkSprite.movementBox );
			
			// Disregard any grass collision events that intersect with object collisions. This prevents
			// the player from possibly triggering a battle while stepping into a trigger event tile.
			if ( objectCollision.hit ) {
				TinyLogManager.log( 'object tile hit, disregarding grass collision', this );
				return;
			}
				
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
		
		
		/**
		 * Handler for steps which collide with {@link TinyFieldMapObjectWarp} objects. These are single-tile objects which are
		 * traversable in all directions, and trigger a map transition.
		 * 
		 * @param	warpObject	the {@link TinyFieldMapObjectWarp} warp object that was hit
		 */		
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
		
		
		/**
		 * Handler for steps which collide with {@link TinyFieldMapObjectNPC} objects. NPCs are not traversable in any direction. 
		 * 
		 * @param 	npcObject			the {@link TinyFieldMapObjectNPC} object that was hit
		 * @param 	fromAcceptKeypress	uhhhh I forget
		 */
		private function onHitNPC( npcObject : TinyFieldMapObjectNPC, fromAcceptKeypress : Boolean ) : void
		{
			TinyLogManager.log( 'onHitNPC: ' + npcObject.npcName, this );
			
			this.incrementStepCounter();
			
			// Exit if an accept keypress is required and none was found
			if ( !fromAcceptKeypress ) return;
			
			// Disable random spinning so the npc doesn't change orientation while talking to the player
			npcObject.enableSpin = false;
			
			// Set the NPC to face the player
			npcObject.setFacingFromPlayerFacing( this.walkSprite.currentDirection );
			
			// Play the NPC's event
			TinyMapManager.getInstance().startEventByName( npcObject.eventName );
		}
		
		
		/**
		 * Handler for steps which collide with {@link TinyFieldMapObjectNPC} trainer sightboxes.
		 * 
		 * @param 	trainerObject		the {@link TinyFieldMapObjectNPC} object that was hit
		 */
		private function onHitSightbox( trainerObject : TinyFieldMapObjectNPC ) : void
		{
			TinyLogManager.log( 'onHitTrainer: ' + trainerObject.npcName, this );
			
			this.incrementStepCounter();
			
			// Disable random spinning so the trainer doesn't change orientation while talking to the player
			trainerObject.enableSpin = false;
			
			// Play the trainer's encounter event
			TinyMapManager.getInstance().startEventByName( trainerObject.encounterName );
		}
		
		
		/**
		 * Handler for steps which collide with {@link TinyFieldMapObjectTrigger} objects. Triggers are traversable in all directions
		 * and can execute an event when they are hit.
		 * 
		 * @param 	triggerObject		the {@link TinyFieldMapObjectTrigger} object that was hit
		 * @param	fromAcceptKeypress	uhhhh I forget
		 */
		private function onHitTrigger( triggerObject : TinyFieldMapObjectTrigger, fromAcceptKeypress : Boolean ) : void
		{
			TinyLogManager.log( 'onHitTrigger: ' + triggerObject.eventName, this );
			
			this.incrementStepCounter();
			
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
			TinyMapManager.getInstance().startEventByName( triggerObject.eventName, triggerObject.isGlobal );
		}
		
		
		/**
		 * Handler for steps which collide with nothing.
		 * 
		 * @param 	event	the {@link TinyFieldMapEvent} instance
		 */
		private function onHitNothing( event : TinyFieldMapEvent ) : void
		{
			this.incrementStepCounter();
			this.clearLastWarp();
		}
	
		
		public function clearLastWarp() : void
		{
			this.lastWarpHit = null;
		}
		
		
		public function incrementStepCounter() : void
		{
			this.stepsSinceEncounter++;
			TinyGameManager.getInstance().playerTrainer.incrementRepelCounter();
		}
		
		
		public function resetStepsSinceEncounter() : void
		{
			TinyLogManager.log( 'resetStepsSinceEncounter', this );
			this.stepsSinceEncounter = 0;
		}
	}
}
