package com.tinyrpg.sequence 
{
	import com.greensock.TweenLite;
	
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.events.TinyFieldMapEvent;
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
		public var sync		 	: Boolean;
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
			
			// Get sync status
			newCommand.sync = xmlData.attribute( 'sync' ) == 'TRUE';

			trace( xmlData.attribute( 'sync' ) );
			
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
			
			this.targetSprite.setFacing( this.direction );
			this.targetSprite.takeSteps( this.tiles );
			
			// Immediately proceed to the next step if we're syncing with other animations.
			// Otherwise, wait for the steps to be completed before proceeding.
			if ( this.sync )
			{
				this.dispatchEvent( new Event( Event.COMPLETE ) );
			}
			else
			{
				this.targetSprite.addEventListener( TinyFieldMapEvent.STEP_COMPLETE, this.onWalkComplete );	
			}
		}
		
		private function onWalkComplete( event : Event ) : void
		{
			TinyLogManager.log( 'onWalkComplete', this );
				
			// Cleanup
			TinyMapManager.getInstance().playerSprite.removeEventListener( TinyFieldMapEvent.STEP_COMPLETE, this.onWalkComplete );
			
			// Emit complete event after a 1-frame delay so that the sprite can come to a stop
			TweenLite.delayedCall( 1, this.dispatchEvent, [ new Event( Event.COMPLETE ) ], true );
		}
	}
}
