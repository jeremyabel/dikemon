package com.tinyrpg.data 
{
	import com.tinyrpg.display.TinyWalkSprite;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyFieldMapObjectTrigger extends TinyFieldMapObject
	{
		public var eventName : String;
		public var requiredFacing : String;
		public var requireAcceptKeypress : Boolean = true;
		public var blocking : Boolean = false;
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
