package com.tinyrpg.sequence 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.RoundPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	
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
	public class TinyTweenNPCCommand extends EventDispatcher
	{
		public var duration		: int;
		public var delay 		: int;
		public var xOffset		: int = 0;
		public var yOffset		: int = 0;
		public var repeats		: int = 0;
		public var yoyo			: Boolean = false;
		public var relative		: Boolean = false;
		public var sync		 	: Boolean = false;
		public var targetName	: String;
		public var targetSprite : TinyWalkSprite;
		
		public function TinyTweenNPCCommand() : void 
		{ 
			TweenPlugin.activate( [ RoundPropsPlugin ] );
		}
		
		public static function newFromXML(xmlData : XML) : TinyTweenNPCCommand
		{
			var newCommand : TinyTweenNPCCommand = new TinyTweenNPCCommand();
			
			// Get target name
			newCommand.targetName = xmlData.child( 'TARGET' ).toString().toUpperCase();
			
			// Get x offset
			newCommand.xOffset = int( xmlData.child( 'X' ).text() );
			
			// Get y offset
			newCommand.yOffset = int( xmlData.child( 'Y' ).text() );

			// Get tween time
			newCommand.duration = int( xmlData.child( 'DURATION' ).text() );
			
			// Get tween delay
			newCommand.delay = int( xmlData.child( 'DELAY' ).text() );
			
			// Get tween repeats
			newCommand.repeats = int( xmlData.child( 'REPEATS' ).text() );
			
			// Get yoyo status
			newCommand.yoyo = xmlData.attribute( 'yoyo' ).toString().toUpperCase() == 'TRUE';
			
			// Get sync status
			newCommand.sync = xmlData.attribute( 'sync' ).toString().toUpperCase() == 'TRUE';
			
			// Get relative status
			newCommand.relative = xmlData.attribute( 'relative' ).toString().toUpperCase() == 'TRUE';
			
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
			
			if ( !this.delay ) this.delay = 0;
			if ( !this.yoyo ) this.yoyo = false;
			if ( !this.repeats ) this.repeats = 0;
			
			var adjustedXOffset : * = null;
			var adjustedYOffset : * = null;
			
			if ( this.relative )
			{
				adjustedXOffset = '';
				adjustedYOffset = '';
				
				if ( this.xOffset >= 0 ) adjustedXOffset = '+';
				if ( this.yOffset >= 0 ) adjustedYOffset = '+';
				 
				adjustedXOffset += this.xOffset.toString();
				adjustedYOffset += this.yOffset.toString();
				
				trace( adjustedXOffset + ', ' + adjustedYOffset );
			}
			
			TweenMax.to( this.targetSprite, this.duration, {
				delay: this.delay,
				x: adjustedXOffset,
				y: adjustedYOffset,
				useFrames: true,
				yoyo: this.yoyo,
				repeat: this.repeats,
				ease: Linear.easeNone,
				roundProps: [ 'x', 'y' ],
				onComplete: this.onTweenComplete
			});
			
			// Immediately proceed to the next step if we're syncing with other animations.
			if ( this.sync )
			{
				this.dispatchEvent( new TinySequenceEvent( TinySequenceEvent.TWEEN_COMPLETE, this ) );
			}
		}
		
		private function onTweenComplete() : void
		{
			TinyLogManager.log( 'onTweenComplete', this );
			
			if ( !this.sync )
			{
				this.dispatchEvent( new TinySequenceEvent( TinySequenceEvent.TWEEN_COMPLETE, this ) );
			}
		}
	}
}
