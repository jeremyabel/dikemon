package com.tinyrpg.sequence 
{
	import flash.display.DisplayObject;

	/**
	 * @author jeremyabel
	 */
	public class TinySetVisibilityCommand 
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
