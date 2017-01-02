package com.tinyrpg.misc 
{
	import flash.events.EventDispatcher;
	import flash.display.DisplayObject;

	/**
	 * @author jeremyabel
	 */
	public class TinySetVisibilityCommand extends EventDispatcher 
	{
		public var element : DisplayObject;
		public var visibility : Boolean;
		
		public function TinySetVisibilityCommand( element : DisplayObject, visibility : Boolean )
		{
			this.element = element;
			this.visibility = visibility;	
		}
	}
}
