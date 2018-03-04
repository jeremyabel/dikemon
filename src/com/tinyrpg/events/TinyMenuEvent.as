package com.tinyrpg.events 
{
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyMenuEvent extends Event 
	{
		// In-Game Menu
		public static var MONS_SELECTED 	: String = 'MONS_SELECTED';
		public static var ITEM_SELECTED 	: String = 'ITEM_SELECTED';
		public static var SAVE_SELECTED 	: String = 'SAVE_SELECTED';
		public static var QUIT_SELECTED		: String = 'QUIT_SELECTED';
		public static var QUIT_COMPLETE		: String = 'QUIT_COMPLETE';
		
		// Title Screen Menu
		public static var NEW_SELECTED		: String = 'NEW_SELECTED';
		public static var LOAD_SELECTED		: String = 'LOAD_SELECTED';
		
		public var param : *; 

		public function TinyMenuEvent( type : String, param : * = null ) : void
		{
			this.param = param;
			super( type, false, false );
		}
	}
}
