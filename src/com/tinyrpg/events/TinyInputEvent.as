package com.tinyrpg.events 
{
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyInputEvent extends Event 
	{
		public static var ARROW_UP	 	: String = 'ARROW_UP'; 		public static var ARROW_DOWN 	: String = 'ARROW_DOWN'; 		public static var ARROW_LEFT	: String = 'ARROW_LEFT'; 		public static var ARROW_RIGHT 	: String = 'ARROW_RIGHT';
		
		public static var ACCEPT		: String = 'ACCEPT';
		public static var CANCEL		: String = 'CANCEL';
		public static var MENU			: String = 'MENU';
		public static var SELECTED 		: String = 'SELECTED';
		
		public static var OPTION_ONE	: String = 'OPTION_ONE';		public static var OPTION_TWO	: String = 'OPTION_TWO';
		
		public static var KEY_UP_UP		: String = 'KEY_UP_UP'; 		public static var KEY_UP_DOWN	: String = 'KEY_UP_DOWN'; 		public static var KEY_UP_LEFT	: String = 'KEY_UP_LEFT'; 		public static var KEY_UP_RIGHT	: String = 'KEY_UP_RIGHT'; 		public static var KEY_UP_ACCEPT	: String = 'KEY_UP_ACCEPT'; 
		
		public static var STOP_MOVEMENT		: String = 'STOP_MOVEMENT';
		public static var ADVANCE_MOVEMENT 	: String = 'ADVANCE_MOVEMENT';
		public static var CAMERA_MOVEMENT 	: String = 'CAMERA_MOVEMENT'; 
		public static var CONTROL_REMOVED  	: String = 'CONTROL_REMOVED';
		public static var CONTROL_ADDED    	: String = 'CONTROL_ADDED';
		
		public var param : * = null;
		
		public function TinyInputEvent( type : String, param : * = null )
		{
			this.param = param;
			super( type, false, false );
		}
	}
}