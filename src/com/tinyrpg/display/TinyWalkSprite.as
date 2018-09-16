package com.tinyrpg.display 
{
	import com.greensock.TweenMax;
	import com.greensock.TimelineMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.RoundPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import com.tinyrpg.core.TinyFieldMap;
	import com.tinyrpg.data.TinyCollisionData;
	import com.tinyrpg.data.TinyFieldMapObject;
	import com.tinyrpg.display.misc.GrassOverlay;
	import com.tinyrpg.display.misc.JumpShadow;
	import com.tinyrpg.events.TinyFieldMapEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.lookup.TinySpriteLookup;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * Class which provides a single animated sprite character which can be controlled by
	 * the player or controlled by NPC AI.
	 * 
	 * This class handles all movement-related inputs for the player, and deals with collision
	 * detection between the sprite and objects on the map.
	 * 
	 * Uses {@link TinyWalkSpriteSheet} to draw the sprite itself.
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
		private var jumpShadow : Bitmap;
		private var prevX : int;
		private var prevY : int;
		private var hasCollidedWithWall : Boolean;
		private var hasCollidedWithGrass : Boolean;
		private var hasCollidedWithObject : Boolean;
		private var hasCollidedWithJump : Boolean;
		private var hasCollidedWithDisable : Boolean;
		private var eventStepCounter : uint;
		
		// This sprite's ID number.
		public var id : uint;
		
		// This sprite's current movement speed.
		public var speed : int;
		
		// The movement hitbox attached to this sprite. Only used if isPlayer is true.
		public var movementBox : TinyWalkSpriteHitbox;
		
		// The collision hitbox attached to this sprite.
		public var hitBox : TinyWalkSpriteHitbox;
		
		// The trainer sightbox attached to this sprite. Only used if isTrainer is true.
		public var sightBox : TinyTrainerSightHitbox;
		
		// The emote icon attached to this sprite.
		public var emoteIcon : TinyEmoteIcon;
		
		// Whether or not this sprite is the player's sprite.
		public var isPlayer : Boolean;
		
		// Whether or not this sprite is a trainer. 
		public var isTrainer : Boolean;
		
		// The name of the map this sprite is spawned on.
		public var homeMapName : String;
		
		// Whether or not the camera should track with the movement of this sprite, keeping it in the middle of the screen.
		public var lockToCamera : Boolean;
		
		// This sprite's current facing direction.
		public var currentDirection : String;
		
		// Whether or not this sprite is currently being controlled by the player.
		public var hasControl : Boolean = false;
		
		// Whether or not this sprite checks for collisions during movement.
		public var enableCollisions : Boolean = true;
		
		// Whether or not this sprite is active and able to be updated.
		public var isAlive : Boolean = true;

		/**
		 * @param	id				The sprite's ID number.
		 * @param	initialFacing	Facing value the sprite should spawn with. Valid values are UP, DOWN, LEFT, and RIGHT.
		 * @param	lockToCamera	Whether or not the camera should track with the movement of the sprite, keeping it in the middle of the screen.
		 * @param	isPlayer		Whether or not the sprite is the player's sprite.
		 * @param	isTrainer		Whether or not the sprite is a trainer. 
		 */
		public function TinyWalkSprite( id : uint, initialFacing : String = 'DOWN', lockToCamera : Boolean = false, isPlayer : Boolean = false, isTrainer : Boolean = false ) : void
		{
			TweenPlugin.activate( [ RoundPropsPlugin ] );
			
			this.id = id;
			this.currentDirection = initialFacing;
			this.spritesheet = new TinyWalkSpriteSheet( this.id, this.currentDirection );
			this.lockToCamera = lockToCamera;
			this.isPlayer = isPlayer;
			this.isTrainer = isTrainer;
			this.speed = MOVEMENT_SPEED;
			
			if ( TinyMapManager.getInstance().currentMap )
			{
				this.homeMapName = TinyMapManager.getInstance().currentMap.mapName;
			}
			
			// Create the grass overlay bitmap
			this.grassOverlay = new Bitmap( new GrassOverlay() );
			this.grassOverlay.x = -8;
			this.grassOverlay.y = -12;
			this.grassOverlay.visible = false;
			
			// Create the jump shadow bitmap
			this.jumpShadow = new Bitmap( new JumpShadow() );
			this.jumpShadow.x = -8;
			this.jumpShadow.y = -8;
			this.jumpShadow.visible = false;
			
			// Create the hitboxes
			this.movementBox = new TinyWalkSpriteHitbox( this, 0x00FF00 );
			this.sightBox = new TinyTrainerSightHitbox( this, 0x0000FF );
			this.hitBox = new TinyWalkSpriteHitbox( this, 0xFF00FF );
			
			// Set hitbox visibility flags
			this.movementBox.visible = false;
			this.sightBox.visible = false;
			this.hitBox.visible = false;
			
			// Create the emote icon sprite
			this.emoteIcon = new TinyEmoteIcon();
			this.emoteIcon.x -= 8;
			this.emoteIcon.y -= 4 + 8 + 16;
			
			// Add 'em up
			this.addChild( this.jumpShadow );
			this.addChild( this.spritesheet );
			this.addChild( this.grassOverlay );
			this.addChild( this.emoteIcon );
			this.addChild( this.hitBox );
			
			// Only the player gets the movement hitbox
			if ( this.isPlayer )
			{
				this.addChild( this.movementBox );
			}
			
			// Only trainers get the sight hitbox
			if ( this.isTrainer ) 
			{
				this.addChild( this.sightBox );
			}

			// Wait for control
			this.addEventListener( TinyInputEvent.CONTROL_ADDED, onControlAdded );
		}

		/**
		 * Listener for the CONTROL_ADDED event. 
		 */
		protected function onControlAdded( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onControlAdded', this );
			
			this.hasControl = true;
			this.speed = MOVEMENT_SPEED;
			
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

		/**
		 * Listener for the CONTROL_REMOVED event.
		 */
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
			// If we're already walking, we don't need to do anything
			if ( this.spritesheet.isWalking ) return;
			
			// Start walking in the desired direction
			this.spritesheet.startWalking( TinyInputManager.getInstance().getCurrentArrowKey(), this.speed );
			this.currentDirection = this.spritesheet.facing;
			this.updateMovementHitbox();
			
			// Check wall collisions and clear the flag if nothing is found
			this.hasCollidedWithWall = TinyMapManager.getInstance().currentMap.checkWallCollision( this.movementBox ).hit;
			
			// Check for grass collisions against the regular hitbox, but do not show the grass overlay yet
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
				TweenMax.delayedCall( this.speed, this.checkArrowInputs, null, true );
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
				TweenMax.delayedCall( this.speed, this.checkArrowInputs, null, true );				
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
			
			// Create a new movement timeline if there isn't one already. The movement timeline is used to
			// queue movement across multiple tiles.
			if ( this.movementTimeline == null ) 
			{
				this.movementTimeline = new TimelineMax({
					useFrames: true,
					onComplete: this.onMovementComplete
				});
				
				this.movementTimeline.autoRemoveChildren = true;
			}
			
			// Add the tween to the timeline
			this.movementTimeline.add( TweenMax.to( this, this.speed, movementEaseOptions ) );
		}

		protected function onMovementStart( facing : String ) : void
		{	
			// Check for grass collisions
			this.hasCollidedWithGrass = this.checkGrassCollision();
			
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
			
			// If this is the player sprite but the player doesn't have control, we don't need
			// to check for collisions, so exit early.
			if ( this.isPlayer && !this.hasControl ) return;
	
			this.prevX = this.x;
			this.prevY = this.y;
			
			// Set the sprite's direction and update the movement hitbox
			this.currentDirection = facing;
			this.spritesheet.setFacing( this.currentDirection );
			this.updateMovementHitbox();
			
			// Check for various collisions before every movement (player only)
			if ( this.isPlayer )
			{
				this.hasCollidedWithWall = TinyMapManager.getInstance().currentMap.checkWallCollision( this.movementBox ).hit;
				this.hasCollidedWithJump = this.checkJumpCollision();
				this.hasCollidedWithObject = this.checkObjectCollision();
			}
			
			// Force an early timeline completion if this sprite has collided with something (player only)
			if ( this.isPlayer && ( this.hasCollidedWithWall || this.hasCollidedWithObject || this.hasCollidedWithJump ) ) 
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
	
			// Update the grass overlay visibility			
			this.grassOverlay.visible = false;
			
			// Check for map object collisions
			this.checkObjectCollision();
				
			// Emit move complete event
			this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.MOVE_COMPLETE ) );
		}

		protected function onMovementUpdate( event : Event = null ) : void
		{
			// Update the camera if it needs to track this sprite's movements	
			if ( this.lockToCamera && this.isOnMap() )
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
			
			// Position the movement hitbox one tile in front of the sprite, according to the facing direction
			switch ( this.spritesheet.facing )
			{
				case TinyWalkSprite.UP:		this.movementBox.y -= 16; break;
				case TinyWalkSprite.DOWN:	this.movementBox.y += 16; break;
				case TinyWalkSprite.LEFT:	this.movementBox.x -= 16; break;
				case TinyWalkSprite.RIGHT:	this.movementBox.x += 16; break;
			}
			
			// Adjust the sight hitbox position, if it exists
			if ( this.sightBox ) 
			{
				this.sightBox.x = 0;
				this.sightBox.y = 0;
				this.sightBox.rotation = 0;
				
				// Rotate the sight hitbox according to the facing direction
				switch ( this.spritesheet.facing ) 
				{
					case TinyWalkSprite.UP:		this.sightBox.rotation -= 90;  break;
					case TinyWalkSprite.DOWN:	this.sightBox.rotation += 90;  break;
					case TinyWalkSprite.LEFT:	this.sightBox.rotation -= 180; break;
					case TinyWalkSprite.RIGHT:	this.sightBox.rotation += 0;   break;
				}
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
				var objectCollision : TinyCollisionData = TinyMapManager.getInstance().currentMap.checkObjectCollision( hitboxToUse );
				
				// Dispatch any relevant collision events and return a boolean value indicating if the hit should block movement or not
				if ( objectCollision.hit ) 
				{
					var hitObject : TinyFieldMapObject;
					var isBlocking : Boolean = false;
					var isSightbox : Boolean = false;
					
					// If the collision object is from a walk sprite, pull the owner out. When testing trainer sightboxes,
					// we don't want to collide with them when checking collision when the player presses the Accept button,
					// so ignore those if necessary. Otherwise just use the collision object as normal. 
					if ( objectCollision.object is TinyTrainerSightHitbox && !fromAcceptKeypress )
					{
						hitObject = ( objectCollision.object as TinyTrainerSightHitbox ).owner;
						isBlocking = false;
						isSightbox = true;
					}
					else if ( objectCollision.object is TinyWalkSpriteHitbox )
					{
						hitObject = ( objectCollision.object as TinyWalkSpriteHitbox ).owner;
						isBlocking = hitObject.isBlocking( this );
					}
					else 
					{
						hitObject = objectCollision.object as TinyFieldMapObject;
						isBlocking = hitObject.isBlocking( this );
					}
					
					this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.OBJECT_HIT, { 
						object: hitObject,
						isSightbox: isSightbox,
						fromAcceptKeypress: fromAcceptKeypress
					}));
					
					return isBlocking;
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
	
			// Only dispatch collision events for the player			
			if ( grassCollision.hit && this.isPlayer && this.hasControl )
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
			
			if ( this.lockToCamera && this.isOnMap() )
			{
				TinyMapManager.getInstance().updateCamera( this.x, this.y );
			}
		}
		
		public function getPositionOnGrid() : Point
		{
			var result : Point = new Point();
			result.x = ( this.x - 8 ) / 16;
			result.y = ( this.y - 8 ) / 16;
			return result; 
		}
		
		public function setPosition( x : int, y : int ) : void
		{
			this.x = 8 + x;
			this.y = 8 + y;
			
			if ( this.lockToCamera && this.isOnMap() )
			{
				TinyMapManager.getInstance().updateCamera( this.x, this.y );
			}
		}
		
		public function setFacing( facing : String ) : void
		{
			TinyLogManager.log( 'setFacing: ' + facing, this );
			
			this.currentDirection = facing;
			this.spritesheet.setFacing( this.currentDirection );
			this.updateMovementHitbox();
		}
		
		public function stop() : void
		{
			this.spritesheet.isWalking = false;
			this.spritesheet.reset();
		}
		
		public function playJump() : void 
		{
			TinyLogManager.log( 'playJump', this );
			
			var offsetY : String = '0'; 
			var offsetAmount = 8;
			var jumpTime = 8;
			
			switch ( this.currentDirection )
			{
				case TinyWalkSprite.UP: 	offsetY = '+' + offsetAmount.toString(); break;
				case TinyWalkSprite.DOWN: 	offsetY = '-' + offsetAmount.toString(); break;
			}
			
			if ( this.currentDirection == TinyWalkSprite.LEFT || this.currentDirection == TinyWalkSprite.RIGHT )
			{
				// Move the walk sprite up and down a bit during sideways jumps
				TweenMax.to( this.spritesheet, jumpTime, {
					y: "-12",
					ease: Cubic.easeOut,
					roundProps: [ 'y' ],
					yoyo: true,
					repeat: 1,
					useFrames: true
				});
			} 
			else
			{
				// Fake parallax by pushing the sprite backwards or forwards during vertical jumps
				TweenMax.to( this.spritesheet, jumpTime, {
					y: offsetY,
					ease: Cubic.easeOut,
					roundProps: [ 'y' ],
					yoyo: true,
					repeat: 1,
					useFrames: true
				});
			}
		}
		
		public function showJumpShadow() : void
		{
			TinyLogManager.log( 'showJumpShadow', this );
			this.jumpShadow.visible = true;
		}
		
		public function hideJumpShadow() : void
		{
			TinyLogManager.log( 'hideJumpShadow', this );
			this.jumpShadow.visible = false;
		}
		
		public function takeStep() : void
		{
			this.takeSteps( 1 );
		}
		
		public function takeSteps( numSteps : uint = 0, playWalkCycle : Boolean = true ) : void
		{
			TinyLogManager.log( 'takeSteps: ' + numSteps, this );
			
			this.eventStepCounter = numSteps;
			
			this.hasCollidedWithWall = false;
			this.hasCollidedWithJump = false;
			this.hasCollidedWithGrass = false;
			this.hasCollidedWithObject = false;
			
			this.setFacing( this.currentDirection );
			this.updateMovementHitbox();
			
			if ( playWalkCycle ) 
			{
				this.spritesheet.startWalking( this.currentDirection, this.speed );
			}
			
			this.onMovementAdvanced( this.currentDirection );
			this.addEventListener( TinyFieldMapEvent.MOVE_COMPLETE, this.onStepComplete );
		}
		
		protected function onStepComplete( event : TinyFieldMapEvent ) : void
		{
			this.eventStepCounter--;
			
			TinyLogManager.log( 'onStepComplete: ' + this.eventStepCounter + ' left, id: ' + this.id, this );
			
			if ( this.eventStepCounter == 0 )
			{			
				// Step counter is at 0, event stepping is complete	
				this.removeEventListener( TinyFieldMapEvent.MOVE_COMPLETE, this.onStepComplete );
				this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.STEP_COMPLETE ) );
				this.stop();
			}
			else
			{
				// Take another step
				this.onMovementAdvanced( this.currentDirection );
			}
		}
		
		protected function hideGrassOverlay() : void
		{
			this.grassOverlay.visible = false;
		}
		
		protected function isOnMap() : Boolean
		{
			return this.homeMapName == TinyMapManager.getInstance().currentMap.mapName;
		}

		public function setKeepFacing( value : Boolean ) : void
		{
			TinyLogManager.log( 'setKeepFacing: ' + value, this );
			this.spritesheet.keepFacing = value;
		}
		
		public function get isMoving() : Boolean
		{
			return this.movementTimeline ? true : false;
		}
	}
}
		