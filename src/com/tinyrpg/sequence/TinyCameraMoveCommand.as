	package com.tinyrpg.sequence 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.RoundPropsPlugin;
	
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.events.TinyFieldMapEvent;
	import com.tinyrpg.events.TinySequenceEvent;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * Class which represents an "CAMERA_MOVE" command in the event sequencer.
	 * 
	 * This command plays a single-axis camera pan animation. Valid XML parameter tags are:
	 * 
	 * 	DIRECTION: 	The direction of the camera pan. Valid direcions are LEFT, RIGHT, UP, and DOWN.
	 * 	TILES: 		The number of map tiles to move. 
	 * 	SPEED:		The speed of the pan animation, in frames-per-tile.
	 * 	
	 * Valid XML attributes on the CAMERA_MOVE tag are:
	 * 	
	 *  sync:		If set to "true", the next event in the sequence executes immediately.
	 * 
	 * @author jeremyabel
	 */
	public class TinyCameraMoveCommand extends EventDispatcher
	{
		public var direction 	: String;
		public var tiles  		: int;
		public var speed		: int;
		public var sync		 	: Boolean;
		public var xTween		: int = 0;
		public var yTween		: int = 0;
		
		private var xTarget		: int = 0;
		private var yTarget		: int = 0;
		private var origCamX	: int = 0;
		private var origCamY	: int = 0;
		
		public function TinyCameraMoveCommand() : void 
		{ 
			TweenPlugin.activate( [ RoundPropsPlugin ] );
		}
		
		/**
		 * Returns a new {@link TinyCameraMoveCommand} created from the given XML data.
		 */
		public static function newFromXML( xmlData : XML ) : TinyCameraMoveCommand
		{
			var newCommand : TinyCameraMoveCommand = new TinyCameraMoveCommand();
			
			// Get direction
			newCommand.direction = xmlData.child( 'DIRECTION' ).toString().toUpperCase();
			
			// Get number of tiles to move
			newCommand.tiles = int( xmlData.child( 'TILES' ).text() );
			
			// Get walk speed
			newCommand.speed = int( xmlData.child( 'SPEED' ).text() );
			
			// Get sync status
			newCommand.sync = xmlData.attribute( 'sync' ).toString().toUpperCase() == 'TRUE';
			
			return newCommand;
		}
		
		public function execute() : void
		{	
			TinyLogManager.log( 'execute, sync: ' + this.sync, this );
			
			// Cache the original camera location so that we can use it as a starting point for the tween
			this.origCamX = TinyMath.deepCopyInt( TinyMapManager.getInstance().currentMap.x );
			this.origCamY = TinyMath.deepCopyInt( TinyMapManager.getInstance().currentMap.y );
			
			// Calculate the camera move target coordinates
			switch ( this.direction ) 
			{
				case 'UP':		this.yTarget = this.tiles * -16; break;
				case 'DOWN':	this.yTarget = this.tiles *  16; break;
				case 'LEFT':	this.xTarget = this.tiles * -16; break;
				case 'RIGHT':	this.xTarget = this.tiles *  16; break;
			}
			
			// Start the camera move tween
			TweenLite.to( this, this.speed * this.tiles, { 
				xTween: this.xTarget,
				yTween: this.yTarget, 
				roundProps: [ 'xTween', 'yTween' ],
				ease: Linear.easeNone, 
				useFrames: true,
				onUpdate: this.onCameraMoveUpdate,
				onComplete: this.sync ? null : this.onCameraMoveComplete
			});
			
			// Immediately proceed to the next step if we're syncing with other animations.
			// Otherwise, wait for the camera move tween to be completed before proceeding.
			if ( this.sync )
			{
				this.onCameraMoveComplete();
			}
		}
		
		/**
		 * Callback for updating the camera movement tween.
		 */
		private function onCameraMoveUpdate() : void
		{
			TinyMapManager.getInstance().updateCamera( -this.origCamX + this.xTween, -this.origCamY + this.yTween, false );
		}
		
		/**
		 * Listener called when the camerae movement tween is complete.
		 */
		private function onCameraMoveComplete( event : Event = null ) : void
		{
			TinyLogManager.log( 'onCameraMoveComplete', this );
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}
