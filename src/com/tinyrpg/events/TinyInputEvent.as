package com.tinyrpg.events 
{
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyInputEvent extends Event 
	{
		public static var ARROW_UP	 	: String = 'ARROW_UP'; 
		
		public static var ACCEPT		: String = 'ACCEPT';
		public static var CANCEL		: String = 'CANCEL';
		public static var MENU			: String = 'MENU';
		
		public static var OPTION_ONE	: String = 'OPTION_ONE';
		
		public static var KEY_UP_UP		: String = 'KEY_UP_UP'; 
		
		public static var CONTROL_REMOVED : String = 'CONTROL_REMOVED';
		public static var CONTROL_ADDED   : String = 'CONTROL_ADDED';
		
		public function TinyInputEvent(type : String)
		{
			super(type, false, false);
		}
	}
}