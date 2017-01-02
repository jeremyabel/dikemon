package com.tinyrpg.events 
{
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyItemEvent extends Event 
	{
		public static const INVENTORY_FULL	: String = 'INVENTORY_FULL';
		public static const ITEM_NOT_FOUND	: String = 'ITEM_NOT_FOUND';
		public static const ITEM_ADDED		: String = 'ITEM_ADDED';
		public static const ITEM_REMOVED	: String = 'ITEM_REMOVED';
		public static const ITEM_USED		: String = 'ITEM_USED';
		public static const ITEM_DROPPED	: String = 'ITEM_DROPPED';
		
		public function TinyItemEvent(type : String)
		{
			super(type, false, false);
		}
	}
}
