package com.tinyrpg.display 
{
	import com.greensock.TweenMax;
	import com.greensock.TimelineLite;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.RoundPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
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
		private var movementTimeline : TimelineLite;

		public var hitBox : Sprite;
		public var movementBox : Sprite;
		public var lockToCamera : Boolean;

		public function TinyWalkSprite( id : uint, lockToCamera : Boolean = false ) : void
		{
			TweenPlugin.activate( [ RoundPropsPlugin ] );
			
			this.spritesheet = new TinyWalkSpriteSheet( id, TinyWalkSprite.DOWN );
			this.lockToCamera = lockToCamera;
			
			this.hitBox = new Sprite;
			this.hitBox.name = 'hitBox_' + name;
			this.hitBox.graphics.beginFill(0xFF00FF, 0.25);
			this.hitBox.graphics.drawRect( -8, -8, 16, 16 );
			this.hitBox.graphics.endFill();
//			this.hitBox.visible = false;
			
			this.movementBox = new Sprite;
			this.movementBox.name = 'movementBox_' + name;
			this.movementBox.graphics.beginFill(0x00FF00, 0.25);
			this.movementBox.graphics.drawRect( -8, -8, 16, 16 );
			this.movementBox.graphics.endFill();
//			this.movementBox.visible = false;
			
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
		}
		
		protected function onMovementAdvanced( event : TinyInputEvent ) : void
		{
			// Create a linear tween for moving this sprite around
			var movementEaseOptions : Object = { 
				ease: Linear.easeNone,
				onStart: this.spritesheet.setFacing,
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
				this.movementTimeline = new TimelineLite({
					useFrames: true,
					onComplete: this.onMovementComplete
				});
			}
			
			// Tween the sprite
			this.movementTimeline.add( TweenMax.to( this, TinyWalkSprite.MOVEMENT_SPEED, movementEaseOptions ) );
		}
		
		protected function onIndividualMovementComplete( event : Event = null ) : void
		{
			// Force an early timeline completion if a movement tween finishes and the sprite has stopped walking
			if ( !this.spritesheet.isWalking && this.movementTimeline )
			{
				this.onMovementComplete();
			}
		}
		
		protected function onMovementComplete( event : Event = null ) : void
		{
			this.movementTimeline.kill();
			this.movementTimeline.clear();
			this.movementTimeline = null;
		}

		protected function onMovementUpdate( event : Event = null ) : void
		{
			// Dispatch an event which updates the camera if it needs to track this sprite's movements	
			if ( this.lockToCamera )
			{
				
			}
		}
	}
}
		