package com.tinyrpg.sequence 
{
	import com.greensock.TweenLite;
	
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.events.TinyFieldMapEvent;
	import com.tinyrpg.events.TinySequenceEvent;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author jeremyabel
	 */
	public class TinyWalkCommand extends EventDispatcher
	{
		public var tiles 	 	: int;
		public var speed		: int;
		public var sync		 	: Boolean;
		public var keepFacing	: Boolean = false; 
		public var targetName	: String;
		public var direction 	: String;
		public var targetSprite : TinyWalkSprite;
		
		public function TinyWalkCommand() : void { }
		
		public static function newFromXML(xmlData : XML) : TinyWalkCommand
		{
			var newCommand : TinyWalkCommand = new TinyWalkCommand();
			
			// Get target name
			newCommand.targetName = xmlData.child( 'TARGET' ).toString().toUpperCase();
			
			// Get direction
			newCommand.direction = xmlData.child( 'DIRECTION' ).toString().toUpperCase();
			
			// Get number of tiles to move
			newCommand.tiles = int( xmlData.child( 'TILES' ).text() );
			
			// Get walk speed
			newCommand.speed = int( xmlData.child( 'SPEED' ).text() );
			
			// Get sync status
			newCommand.sync = xmlData.attribute( 'sync' ).toString().toUpperCase() == 'TRUE';
			
			// Get keep facing status
			newCommand.keepFacing = xmlData.attribute( 'keepfacing' ).toString().toUpperCase() == 'TRUE'; 

			return newCommand;
		}
		
		public function execute() : void
		{	
			// Get target sprite from either the player or the current map
			if ( this.targetName == 'PLAYER' ) 
			{
				TinyLogManager.log( 'execute: Player, sync: ' + this.sync, this );
				this.targetSprite = TinyMapManager.getInstance().playerSprite;
			} 
			else 
			{	
				TinyLogManager.log( 'execute: ' + this.targetName + ', sync: ' + this.sync, this );
				this.targetSprite = TinyMapManager.getInstance().currentMap.getNPCObjectByName( this.targetName ).walkSprite;
			}
			
			this.targetSprite.speed = this.speed;
			this.targetSprite.setKeepFacing( this.keepFacing );
			this.targetSprite.setFacing( this.direction );
			this.targetSprite.takeSteps( this.tiles );
			
			// Immediately proceed to the next step if we're syncing with other animations.
			// Otherwise, wait for the steps to be completed before proceeding.
			if ( this.sync )
			{
				this.dispatchEvent( new TinySequenceEvent( TinySequenceEvent.WALK_COMPLETE, this ) );
			}
			else 
			{
				this.targetSprite.addEventListener( TinyFieldMapEvent.STEP_COMPLETE, this.onWalkComplete );	
			}
			
		}
		
		private function onWalkComplete( event : Event ) : void
		{
			TinyLogManager.log( 'onWalkComplete - id: ' + this.targetSprite.id, this );
			
			// Allow sprite to change direction again
			this.targetSprite.setKeepFacing( false );
			
			// Emit complete event after a 1-frame delay so that the sprite can come to a stop
			TweenLite.delayedCall( 1, this.dispatchEvent, [ new TinySequenceEvent( TinySequenceEvent.WALK_COMPLETE, this ) ], true );
		}
	}
}
