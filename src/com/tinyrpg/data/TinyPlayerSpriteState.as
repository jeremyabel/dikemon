package com.tinyrpg.data 
{	
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.events.TinyFieldMapEvent;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.utils.TinyLogManager;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyPlayerSpriteState 
	{
		public var objectCollisionEnabled : Boolean = true;
		
		private var walkSprite : TinyWalkSprite;
		private var lastWarpHit : TinyFieldMapObjectWarp = null;
		
		public function TinyPlayerSpriteState( walkSprite : TinyWalkSprite ) : void 
		{
			this.walkSprite = walkSprite;
			this.walkSprite.addEventListener( TinyFieldMapEvent.OBJECT_HIT, this.onHitObject );
			this.walkSprite.addEventListener( TinyFieldMapEvent.NOTHING_HIT, this.onHitNothing );
		}
		
		public function destroy() : void
		{
			this.walkSprite.removeEventListener( TinyFieldMapEvent.OBJECT_HIT, this.onHitObject );
			this.walkSprite.removeEventListener( TinyFieldMapEvent.NOTHING_HIT, this.onHitNothing );
		}
		
		private function onHitObject( event : TinyFieldMapEvent ) : void
		{
			if ( !this.objectCollisionEnabled ) return;
			
			var hitObject : * = event.param;
			
			if ( hitObject is TinyFieldMapObject )
			{
				if ( hitObject is TinyFieldMapObjectTrigger )
				{
					this.onHitTrigger( hitObject as TinyFieldMapObjectTrigger ); 
					return;
				}
				
				if ( hitObject is TinyFieldMapObjectWarp )
				{
					this.onHitWarp( hitObject as TinyFieldMapObjectWarp );
					return;
				}
			}
		}
		
		private function onHitNothing( event : TinyFieldMapEvent ) : void
		{
			this.lastWarpHit = null;
		}
		
		private function onHitWarp( warpObject : TinyFieldMapObjectWarp ) : void
		{
			TinyLogManager.log( 'onHitWarp: ' + warpObject.targetMapName, this );
			
			if ( this.lastWarpHit )
			{	
				// If this warp has been hit twice and the sprite's facing matches the required warp facing, trigger the warp
				if ( this.lastWarpHit.targetMapName == warpObject.targetMapName && this.walkSprite.currentDirection == this.lastWarpHit.requiredFacing )
				{
					TinyLogManager.log( 'current facing matches warp facing', this );
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
					TinyLogManager.log( 'triggered instant warp', this );
					TinyMapManager.getInstance().warp( warpObject );
					return;
				}
				
				TinyLogManager.log( 'waiting for warp', this );
				
				// Didn't trigger an instant warp, so save this warp object so it can be triggered if it is hit twice.
				this.lastWarpHit = warpObject;
			}
		}
		
		private function onHitTrigger( triggerObject : TinyFieldMapObjectTrigger ) : void
		{
			
		}
		
		public function clearLastWarp() : void
		{
			this.lastWarpHit = null;
		}
	}
}
