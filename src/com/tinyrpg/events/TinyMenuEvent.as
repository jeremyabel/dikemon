package com.tinyrpg.events 
{
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyMenuEvent extends Event 
	{
		// In-Game Menu
		public static var ITEM_SELECTED 	: String = 'ITEM_SELECTED';
		public static var STATS_SELECTED 	: String = 'STATS_SELECTED';
		public static var PARTY_SELECTED 	: String = 'PARTY_SELECTED';
		public static var SAVE_SELECTED 	: String = 'SAVE_SELECTED';
		public static var QUIT_SELECTED		: String = 'QUIT_SELECTED';
		public static var PARTY_CHANGED		: String = 'PARTY_CHANGED';
		
		// Title Screen Menu
		public static var NEW_SELECTED		: String = 'NEW_SELECTED';
		public static var LOAD_SELECTED		: String = 'LOAD_SELECTED'; 

		public function TinyMenuEvent(type : String) : void
		{
			super(type, false, false);
		}
	}
}
