package com.tinyrpg.data 
{
	import com.tinyrpg.display.TinyWalkSprite;
	
	/**
	 * Class which represents a invisible event trigger tile on the map.
	 * 
	 * Triggers can have a required facing to activate, or require the Accept
	 * button be pressed before activating. 
	 */
	public class TinyFieldMapObjectTrigger extends TinyFieldMapObject
	{
		// The name of the event to be triggered
		public var eventName : String;
		
		// The direction the player must be facing to trigger the event.
		public var requiredFacing : String;
		
		// Whether or not the Accept key must be pressed to trigger the event.
		public var requireAcceptKeypress : Boolean = true;
		
		// Whether or not the tile blocks player movement.
		public var blocking : Boolean = false;
		
		// Whether or not the event is a map-specific event or a global event.
		public var isGlobal : Boolean = false;
		
		public function TinyFieldMapObjectTrigger() : void 
		{
			
		}
		
		override public function isBlocking( walkSprite : TinyWalkSprite ) : Boolean
		{
			return this.blocking;
		}
	}
}
