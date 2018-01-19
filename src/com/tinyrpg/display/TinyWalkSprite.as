package com.tinyrpg.display 
{
	import com.greensock.TweenMax;
	import com.greensock.TimelineMax;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.RoundPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.tinyrpg.core.TinyFieldMap;
	import com.tinyrpg.data.TinyFieldMapObject;
	import com.tinyrpg.display.misc.GrassOverlay;
	import com.tinyrpg.events.TinyFieldMapEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.misc.TinySpriteConfig;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
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
		private var grassOverlay : Bitmap;
		private var prevX : int;
		private var prevY : int;

		public var hitBox : Sprite;
		public var movementBox : Sprite;
		public var hasCollidedWithWall : Boolean;
		public var hasCollidedWithGrass : Boolean;
		public var hasCollidedWithObject : Boolean;
		public var hasCollidedWithJump : Boolean;
		public var hasCollidedWithDisable : Boolean;
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
			
			this.grassOverlay = new Bitmap( new GrassOverlay() );
			this.grassOverlay.x = -8;
			this.grassOverlay.y = -12;
			this.grassOverlay.visible = false;
			
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
			this.addChild( this.grassOverlay );
			this.addChild( this.hitBox );
			this.addChild( this.movementBox );

			// Wait for control
			this.addEventListener( TinyInputEvent.CONTROL_ADDED, onControlAdded );
		}

		protected function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log( 'onControlAdded', this );
			
			this.hasControl = true;
			
			// Add input events
			TinyInputManager.getInstance().addEventListener( TinyInputEvent.ACCEPT, 		this.onAcceptPressed );
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
			
			// Remove input events
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.ACCEPT, 		this.onAcceptPressed );
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.ARROW_UP, 	this.startWalking );
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.ARROW_DOWN, 	this.startWalking );
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.ARROW_LEFT, 	this.startWalking );
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.ARROW_RIGHT, this.startWalking );
			
			// Listen for when control is returned
			this.removeEventListener( TinyInputEvent.CONTROL_REMOVED, this.onControlRemoved );
			this.addEventListener( TinyInputEvent.CONTROL_ADDED, this.onControlAdded );
		}
		
		protected function onAcceptPressed( event : TinyInputEvent = null ) : void
		{
			if ( !this.isPlayer || !this.hasControl ) return;
			
			TinyLogManager.log( 'onAcceptPressed', this );
			
			// Check for collisions on the tile directly in front 
			this.checkObjectCollision( true, true );
		}
		
		public function startWalking( event : TinyInputEvent = null ) : void
		{
			if ( this.spritesheet.isWalking ) return;
			
			// Start walking in the desired direction 			
			this.spritesheet.startWalking( TinyInputManager.getInstance().getCurrentArrowKey() );
			this.currentDirection = this.spritesheet.facing;
			this.updateMovementHitbox();
			
			// Check wall collisions and clear flag if nothing is found
			this.hasCollidedWithWall = TinyMapManager.getInstance().currentMap.checkWallCollision( this.movementBox ).hit;
			
			// Check for grass collisions against the regular hitbox but do not show the grass overlay yet
			this.hasCollidedWithGrass = this.checkGrassCollision( false );
			
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
		
		public function stopWalking() : void
		{
			TinyLogManager.log( 'stopWalking', this );
			
			// Reset the latest tween so no movement happens
			if ( this.movementTimeline )
			{
				this.movementTimeline.getActive()[ 0 ].time( 0 );
				this.onMovementComplete();
			}
			
			// Reset the spritesheet
			this.spritesheet.isWalking = false;
			this.spritesheet.reset();
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
			
			// Get the correct movement direction and amount depending on what direction key is active.
			// The parameter is set with a string to enable the tween to use relative distances.
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
	
			this.prevX = this.x;
			this.prevY = this.y;
			
			this.currentDirection = facing;
			this.spritesheet.setFacing( this.currentDirection );
			this.updateMovementHitbox();
			
			// Check collision before every movement
			this.hasCollidedWithWall = TinyMapManager.getInstance().currentMap.checkWallCollision( this.movementBox ).hit;
			this.hasCollidedWithJump = this.checkJumpCollision();
			this.hasCollidedWithGrass = this.checkGrassCollision();
			this.hasCollidedWithObject = this.checkObjectCollision();
			
			// Show the grass overlay for a few frames if a grass collision is detected
			if ( this.hasCollidedWithGrass )
			{
				this.grassOverlay.visible = true;
				this.spritesheet.setGrassVisible( true );
				TweenMax.delayedCall( 11, this.hideGrassOverlay, null, true );
			}
			else
			{
				this.spritesheet.setGrassVisible( false );
			}
				
			// Force an early timeline completion if this sprite has collided with something
			if ( this.hasCollidedWithWall || this.hasCollidedWithObject || this.hasCollidedWithJump ) 
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
			// Clean up the movement timeline
			if ( this.movementTimeline )
			{
				this.movementTimeline.kill();
				this.movementTimeline.clear();
				this.movementTimeline = null;
			}
	
			// Update grass overlay visibility			
			this.grassOverlay.visible = false;
			
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
		
			// Update the grass tile offsets if required		
			if ( this.hasCollidedWithGrass )
			{
				this.spritesheet.updateGrassOffset( this.x - this.prevX, this.y - this.prevY );
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
		
		public function checkObjectCollision( useMovementHitbox : Boolean = false, fromAcceptKeypress : Boolean = false ) : Boolean
		{
			// Emit collision events depending on if an object has been hit by the player
			if ( this.isPlayer && this.hasControl )
			{
				// Get the desired hitbox to test with
				var hitboxToUse : DisplayObject = useMovementHitbox ? this.movementBox : this.hitBox;
				
				// Check for map object collisions
				var objectCollision = TinyMapManager.getInstance().currentMap.checkObjectCollision( hitboxToUse );
				
				// Dispatch relevant collision events and return a boolean value indicating if anything has been hit
				if ( objectCollision.hit ) 
				{
					this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.OBJECT_HIT, { 
						object: objectCollision.object,
						fromAcceptKeypress: fromAcceptKeypress
					}));
					
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
		
		public function checkJumpCollision() : Boolean 
		{
			// Emit collision events depending on if a jump has been hit by the player
			if ( this.isPlayer && this.hasControl )
			{
				var jumpCollision = TinyMapManager.getInstance().currentMap.checkJumpCollision( this.movementBox );
				
				if ( jumpCollision.hit )
				{
					this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.JUMP_HIT, { 
						object: jumpCollision.object
					}));
					
					return true;
				}
			}
			
			return false;
		}
		
		public function checkGrassCollision( useMovementHitbox : Boolean = true ) : Boolean
		{
			// Get the desired hitbox to test with
			var hitboxToUse : DisplayObject = useMovementHitbox ? this.movementBox : this.hitBox;
				
			// Emit collision events depending on if some grass has been hit by the any NPC
			var grassCollision = TinyMapManager.getInstance().currentMap.checkGrassCollision( hitboxToUse );
			
			if ( grassCollision.hit )
			{
				this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.GRASS_HIT, { 
					object: grassCollision.object
				}));
				
				return true;
			}
			
			return false;
		}
		
		public function checkDisableCollision() : Boolean
		{
			// Prevent player movement in a specific direction if this tile has been hit
			if ( this.isPlayer && this.hasControl )
			{
				var disableCollision = TinyMapManager.getInstance().currentMap.checkDisableCollision( this.movementBox );
				
				if ( disableCollision.hit )
				{
					switch ( disableCollision.object.name )
					{
						case 'disableU': return this.currentDirection == UP;
						case 'disableD': return this.currentDirection == DOWN;
						case 'disableL': return this.currentDirection == LEFT;
						case 'disableR': return this.currentDirection == RIGHT;
					}
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
			this.updateMovementHitbox();
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
		
		protected function hideGrassOverlay() : void
		{
			this.grassOverlay.visible = false;
		}
	}
}
		