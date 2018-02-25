package com.tinyrpg.sequence 
{
	import com.greensock.TweenLite;
	
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.events.TinySequenceEvent;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author jeremyabel
	 */
	public class TinySpinCommand extends EventDispatcher
	{
		public var speed		: int;
		public var sync		 	: Boolean;
		public var continuous	: Boolean = false;
		public var isCCW		: Boolean = false;
		public var targetName	: String;
		public var startFacing 	: String;
		public var targetSprite : TinyWalkSprite;
		
		private var currentSpinIndex : uint = 0;
		private var currentSpinArray : Array;
		
		private var spinDirectionsStartUpCW  	: Array = [ 'UP', 'RIGHT', 'DOWN', 'LEFT' ];
		private var spinDirectionsStartDownCW  	: Array = [ 'DOWN', 'LEFT', 'UP', 'RIGHT' ];
		private var spinDirectionsStartLeftCW 	: Array = [ 'LEFT', 'UP', 'RIGHT', 'DOWN' ];
		private var spinDirectionsStartRightCW  : Array = [ 'RIGHT', 'DOWN', 'LEFT', 'UP' ];
		
		private var spinDirectionsStartUpCCW  	: Array = [ 'UP', 'LEFT', 'DOWN', 'RIGHT' ];
		private var spinDirectionsStartDownCCW  : Array = [ 'DOWN', 'RIGHT', 'UP', 'LEFT' ];
		private var spinDirectionsStartLeftCCW 	: Array = [ 'LEFT', 'DOWN', 'RIGHT', 'UP' ];
		private var spinDirectionsStartRightCCW : Array = [ 'RIGHT', 'UP', 'LEFT', 'DOWN' ];
		
		public function TinySpinCommand() : void 
		{
			 
		}
		
		public static function newFromXML(xmlData : XML) : TinySpinCommand
		{
			var newCommand : TinySpinCommand = new TinySpinCommand();
			
			// Get target name
			newCommand.targetName = xmlData.child( 'TARGET' ).toString().toUpperCase();
			
			// Get start facing
			newCommand.startFacing = xmlData.child( 'FACING' ).toString().toUpperCase();
			
			// Get spin speed
			newCommand.speed = int( xmlData.child( 'SPEED' ).text() );
			
			// Get sync status
			newCommand.sync = xmlData.attribute( 'sync' ).toString().toUpperCase() == 'TRUE';
			
			// Get continuous status
			newCommand.continuous = xmlData.attribute( 'continuous' ).toString().toUpperCase() == 'TRUE';
			
			// Get clockwise status
			newCommand.isCCW = xmlData.attribute( 'ccw' ).toString().toUpperCase() == 'TRUE'; 

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
			
			// Starting facing defaults to the sprite's current direction
			if ( !this.startFacing )
			{
				this.startFacing = this.targetSprite.currentDirection;
			}
			
			this.playSpin();
				
			// Immediately complete this command if we're syncing with other events
			if ( this.sync || this.continuous )
			{
				this.onSpinComplete();
			}
		}
		
		private function playSpin() : void
		{
			switch ( this.startFacing )
			{
				case TinyWalkSprite.UP:		this.currentSpinArray = ( this.isCCW ? this.spinDirectionsStartUpCCW    : this.spinDirectionsStartUpCW ); break;
				case TinyWalkSprite.DOWN:	this.currentSpinArray = ( this.isCCW ? this.spinDirectionsStartDownCCW  : this.spinDirectionsStartDownCW ); break;
				case TinyWalkSprite.LEFT:	this.currentSpinArray = ( this.isCCW ? this.spinDirectionsStartLeftCCW  : this.spinDirectionsStartLeftCW ); break;
				case TinyWalkSprite.RIGHT:	this.currentSpinArray = ( this.isCCW ? this.spinDirectionsStartRightCCW : this.spinDirectionsStartRightCW ); break;  
			}
			
			this.currentSpinIndex = 0;
			this.update();
			
			TweenLite.delayedCall( this.speed * 1, this.update, null, true );
			TweenLite.delayedCall( this.speed * 2, this.update, null, true );
			TweenLite.delayedCall( this.speed * 3, this.update, null, true );
			
			if ( this.continuous && this.targetSprite.isAlive )
			{
				TweenLite.delayedCall( this.speed * 4, this.playSpin, null, true );
			}
			else 
			{
				TweenLite.delayedCall( this.speed * 4, this.onSpinComplete, null, true );	
			}
		}
		
		private function update() : void
		{
			this.currentSpinIndex = ( this.currentSpinIndex + 1 ) % 4;
			this.targetSprite.setFacing( this.currentSpinArray[ this.currentSpinIndex ] );
		}
		
		private function onSpinComplete() : void
		{
			TinyLogManager.log( 'onSpinComplete - id: ' + this.targetSprite.id, this );
			
			this.dispatchEvent( new TinySequenceEvent( TinySequenceEvent.SPIN_COMPLETE, this ) );
		}
	}
}
