package com.tinyrpg.display 
{
	import com.greensock.TweenMax;
	import com.greensock.TimelineMax;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.RoundPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
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
		public var hasCollided : Boolean;
		public var lockToCamera : Boolean;

		public function TinyWalkSprite( id : uint, lockToCamera : Boolean = false ) : void
		{
			TweenPlugin.activate( [ RoundPropsPlugin ] );
			
			this.spritesheet = new TinyWalkSpriteSheet( id, TinyWalkSprite.DOWN );
			this.lockToCamera = lockToCamera;
			
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
			
			// Listen for movement updates
			this.spritesheet.addEventListener( TinyInputEvent.ADVANCE_MOVEMENT, this.onMovementAdvanced );
		}

		protected function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log( 'onControlAdded', this );
			
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
			this.spritesheet.startWalking();
			this.updateMovementHitbox();
			
			// Check collision and clear flag if nothing is found
			this.hasCollided = TinyMapManager.getInstance().currentMap.checkCollision( this.movementBox ); 
		}
		
		protected function onMovementAdvanced( event : TinyInputEvent ) : void
		{
			// Create a linear tween for moving this sprite around
			var movementEaseOptions : Object = { 
				ease: Linear.easeNone,
				onStart: this.onIndividualMovementStart,
				onStartParams: [ event.param ],
				onUpdate: this.onMovementUpdate,
				onComplete: this.onIndividualMovementComplete
			};
			
			// Get the correct movement direction and amount depending on what direction key is active
			switch ( event.param )
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
		
		protected function onIndividualMovementStart( facing : String ) : void
		{
			this.spritesheet.setFacing( facing );
			this.updateMovementHitbox();
			
			// Check collision before every movement
			this.hasCollided = TinyMapManager.getInstance().currentMap.checkCollision( this.movementBox );
				
			// Force an early timeline completion if this sprite has collided with something
			if ( this.hasCollided ) 
			{
				// Reset the latest tween so no movement happens
				this.movementTimeline.getActive()[ 0 ].time( 0 );
				this.onMovementComplete();
			}
		}
		
		protected function onIndividualMovementComplete( event : Event = null ) : void
		{
			// Ensure there's only one extra tween in the queue at all times, otherwise they could stack and act weird. 
			var tweens : Array = this.movementTimeline.getTweensOf( this );
			while ( tweens.length > 1 )
			{
				this.movementTimeline.remove( tweens[ 0 ] );
				tweens = this.movementTimeline.getTweensOf( this );
			}
			
			// Check collision after every movement
			this.hasCollided = TinyMapManager.getInstance().currentMap.checkCollision( this.movementBox );
			
			// Force an early timeline completion if a movement tween finishes and the sprite has stopped walking,
			// or if this sprite has collided with something.
			if ( ( !this.spritesheet.isWalking && this.movementTimeline ) || this.hasCollided )
			{
				this.onMovementComplete();
			}
		}
		
		protected function onMovementComplete( event : Event = null ) : void
		{
			// Reset the movement hitbox position
			this.movementBox.x = 0;
			this.movementBox.y = 0;
			
			// Clean up the movement timeline
			this.movementTimeline.kill();
			this.movementTimeline.clear();
			this.movementTimeline = null;
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
		
		public function setPositionOnGrid( x : int, y : int ) : void
		{
			this.x = 8 + 16 * x;
			this.y = 8 + 16 * y;
			
			if ( this.lockToCamera )
			{
				TinyMapManager.getInstance().updateCamera( this.x, this.y );
			}
		}
	}
}
		