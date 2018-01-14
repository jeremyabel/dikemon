package com.tinyrpg.display 
{
	import com.greensock.TweenMax;
	import com.greensock.TimelineMax;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.RoundPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.tinyrpg.core.TinyFieldMap;
	import com.tinyrpg.data.TinyFieldMapObject;
	import com.tinyrpg.events.TinyFieldMapEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.misc.TinySpriteConfig;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyWalkSprite extends Sprite
	{
		public static var LEFT : String = 'LEFT';
		public static var RIGHT : String = 'RIGHT';
		public static var UP : String = 'UP';
		public static var DOWN : String = 'DOWN';
		public static var MOVEMENT_SPEED : uint = 7;

		private var spritesheet : TinyWalkSpriteSheet;
		private var movementTimeline : TimelineMax;

		public var hitBox : Sprite;
		public var movementBox : Sprite;
		public var hasCollidedWithWall : Boolean;
		public var hasCollidedWithObject : Boolean;
		public var lockToCamera : Boolean;
		public var isPlayer : Boolean;
		public var currentDirection : String;
		public var hasControl : Boolean = false;

		public function TinyWalkSprite( id : uint, initialFacing : String = 'DOWN', lockToCamera : Boolean = false, isPlayer : Boolean = false ) : void
		{
			TweenPlugin.activate( [ RoundPropsPlugin ] );
			
			this.currentDirection = initialFacing;
			this.spritesheet = new TinyWalkSpriteSheet( id, this.currentDirection );
			this.lockToCamera = lockToCamera;
			this.isPlayer = isPlayer;
			
			this.hitBox = new Sprite;
			this.hitBox.name = 'hitBox_' + name;
			this.hitBox.graphics.beginFill( 0xFF00FF, 0.25 );
			this.hitBox.graphics.drawRect( -8, -8, 16, 16 );
			this.hitBox.graphics.endFill();
			this.hitBox.visible = false;
			
			this.movementBox = new Sprite;
			this.movementBox.name = 'movementBox_' + name;
			this.movementBox.graphics.beginFill( 0x00FFFF, 0.25 );
			this.movementBox.graphics.drawRect( -8, -8, 16, 16 );
			this.movementBox.graphics.endFill();
			this.movementBox.visible = false;
			
			// Add 'em up
			this.addChild( this.spritesheet );
			this.addChild( this.hitBox );
			this.addChild( this.movementBox );

			// Wait for control
			this.addEventListener( TinyInputEvent.CONTROL_ADDED, onControlAdded );
		}

		protected function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log( 'onControlAdded', this );
			
			this.hasControl = true;
			
			// Add arrow events
			TinyInputManager.getInstance().addEventListener( TinyInputEvent.ARROW_UP, 		this.startWalking );
			TinyInputManager.getInstance().addEventListener( TinyInputEvent.ARROW_DOWN, 	this.startWalking );
			TinyInputManager.getInstance().addEventListener( TinyInputEvent.ARROW_LEFT, 	this.startWalking );
			TinyInputManager.getInstance().addEventListener( TinyInputEvent.ARROW_RIGHT, 	this.startWalking );
			
			// Listen for when control is removed
			this.addEventListener( TinyInputEvent.CONTROL_REMOVED, this.onControlRemoved );
			this.removeEventListener( TinyInputEvent.CONTROL_ADDED, this.onControlAdded );
		}

		protected function onControlRemoved( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onControlRemoved', this );
			
			this.hasControl = false;
			
			// Remove arrow events
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.ARROW_UP, 	this.startWalking );
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.ARROW_DOWN, 	this.startWalking );
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.ARROW_LEFT, 	this.startWalking );
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.ARROW_RIGHT, this.startWalking );
			
			// Listen for when control is returned
			this.removeEventListener( TinyInputEvent.CONTROL_REMOVED, this.onControlRemoved );
			this.addEventListener( TinyInputEvent.CONTROL_ADDED, this.onControlAdded );
		}
		
		public function startWalking( event : TinyInputEvent = null ) : void
		{
			if ( this.spritesheet.isWalking ) return;
			
			// Start walking in the desired direction 			
			this.spritesheet.startWalking( TinyInputManager.getInstance().getCurrentArrowKey() );
			this.updateMovementHitbox();
			
			// Check collision and clear flag if nothing is found
			this.hasCollidedWithWall = TinyMapManager.getInstance().currentMap.checkWallCollision( this.movementBox ).hit;
				
			// If the player is already facing the direction they want to walk in, start walking immediately. 
			// Otherwise, wait a few frames to enable the player to change the character's facing with a short
			// tap of a directional arrow.			
			if ( this.spritesheet.keepDirection ) 
			{
				this.checkArrowInputs();				
			}
			else 
			{
				TweenMax.delayedCall( TinyWalkSprite.MOVEMENT_SPEED, this.checkArrowInputs, null, true );
			}
		}
		
		protected function checkArrowInputs() : void
		{
			if ( this.isPlayer && !this.hasControl ) return;
			
			var arrowKey : String = TinyInputManager.getInstance().getCurrentArrowKey();
			
			// If an arrow key is being held down, move the sprite by one tile in that direction, 
			// otherwise stop walking.
			if ( arrowKey ) 
			{
				this.onMovementAdvanced( arrowKey );
	
				// Check the input state again in a few frames
				TweenMax.delayedCall( TinyWalkSprite.MOVEMENT_SPEED, this.checkArrowInputs, null, true );				
			}
			else 
			{
				this.spritesheet.isWalking = false;
				this.spritesheet.reset();
			}
		}
		
		protected function onMovementAdvanced( facing : String ) : void
		{
			// Create a linear tween for moving this sprite around
			var movementEaseOptions : Object = { 
				ease: Linear.easeNone,
				onStart: this.onMovementStart,
				onStartParams: [ facing ],
				onUpdate: this.onMovementUpdate,
				roundProps: [ 'x', 'y' ]
			};
			
			// Get the correct movement direction and amount depending on what direction key is active
			switch ( facing )
			{
				case TinyWalkSprite.UP: 	movementEaseOptions.y = "-16"; break;		
				case TinyWalkSprite.DOWN:	movementEaseOptions.y = "+16"; break;
				case TinyWalkSprite.LEFT:	movementEaseOptions.x = "-16"; break;
				case TinyWalkSprite.RIGHT:	movementEaseOptions.x = "+16"; break;
			}
			
			if ( this.movementTimeline == null ) 
			{
				this.movementTimeline = new TimelineMax({
					useFrames: true,
					onComplete: this.onMovementComplete
				});
				
				this.movementTimeline.autoRemoveChildren = true;
			}
			
			// Tween the sprite
			this.movementTimeline.add( TweenMax.to( this, TinyWalkSprite.MOVEMENT_SPEED, movementEaseOptions ) );
		}

		protected function onMovementStart( facing : String ) : void
		{	
			if ( this.isPlayer && !this.hasControl ) return;
			
			this.currentDirection = facing;
			this.spritesheet.setFacing( this.currentDirection );
			this.updateMovementHitbox();
			
			// Check collision before every movement
			this.hasCollidedWithWall = TinyMapManager.getInstance().currentMap.checkWallCollision( this.movementBox ).hit;
			this.hasCollidedWithObject = this.checkObjectCollision();
				
			// Force an early timeline completion if this sprite has collided with something
			if ( this.hasCollidedWithWall || this.hasCollidedWithObject ) 
			{
				// Reset the latest tween so no movement happens
				if ( this.movementTimeline )
				{
					this.movementTimeline.getActive()[ 0 ].time( 0 );
					this.onMovementComplete();
				}
			}
			else
			{
				this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.MOVE_START ) );
			}
		}
		
		protected function onMovementComplete( event : Event = null ) : void
		{
			// Reset the movement hitbox position
			this.movementBox.x = 0;
			this.movementBox.y = 0;
			
			// Clean up the movement timeline
			if ( this.movementTimeline )
			{
				this.movementTimeline.kill();
				this.movementTimeline.clear();
				this.movementTimeline = null;
			}
			
			// Check for map object collisions
			this.checkObjectCollision();
				
			// Emit move complete event
			this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.MOVE_COMPLETE ) );
		}

		protected function onMovementUpdate( event : Event = null ) : void
		{
			// Update the camera if it needs to track this sprite's movements	
			if ( this.lockToCamera )
			{
				TinyMapManager.getInstance().updateCamera( this.x, this.y );				
			}
		}
		
		protected function updateMovementHitbox() : void
		{
			// Reset the movement hitbox position
			this.movementBox.x = 0;
			this.movementBox.y = 0;
			
			// Position the movement hitbox according to the facing direction
			switch ( this.spritesheet.facing )
			{
				case TinyWalkSprite.UP:		this.movementBox.y -= 16; break;
				case TinyWalkSprite.DOWN:	this.movementBox.y += 16; break;
				case TinyWalkSprite.LEFT:	this.movementBox.x -= 16; break;
				case TinyWalkSprite.RIGHT:	this.movementBox.x += 16; break;
			}
		}
		
		public function checkObjectCollision() : Boolean
		{
			// Emit collision events depending on if an object has been hit by the player
			if ( this.isPlayer && this.hasControl )
			{
				// Check for map object collisions
				var objectCollision = TinyMapManager.getInstance().currentMap.checkObjectCollision( this.hitBox );
				
				if ( objectCollision.hit ) 
				{
					this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.OBJECT_HIT, objectCollision.object ) );
					
					var hitObject : TinyFieldMapObject = objectCollision.object as TinyFieldMapObject;
					return hitObject.isBlocking( this );					
				} 
				else 
				{
					this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.NOTHING_HIT ) );
					return false;
				}
			}
			
			return false;
		}
		
		public function setPositionOnGrid( x : int, y : int ) : void
		{
			this.x = 8 + 16 * x;
			this.y = 8 + 16 * y;
			
			if ( this.lockToCamera )
			{
				TinyMapManager.getInstance().updateCamera( this.x, this.y );
			}
		}
		
		public function setPosition( x : int, y : int ) : void
		{
			this.x = 8 + x;
			this.y = 8 + y;
			
			if ( this.lockToCamera )
			{
				TinyMapManager.getInstance().updateCamera( this.x, this.y );
			}
		}
		
		public function takeStep() : void
		{
			this.spritesheet.startWalking( this.currentDirection );
			this.onMovementAdvanced( this.currentDirection );
			this.addEventListener( TinyFieldMapEvent.MOVE_COMPLETE, this.onStepComplete );
		}
		
		protected function onStepComplete( event : TinyFieldMapEvent ) : void
		{
			this.removeEventListener( TinyFieldMapEvent.MOVE_COMPLETE, this.onStepComplete );
			this.spritesheet.isWalking = false;
			this.spritesheet.reset();
			
			this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.STEP_COMPLETE ) );
		}
	}
}
		