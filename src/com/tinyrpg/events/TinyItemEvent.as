package com.tinyrpg.events 
{
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyItemEvent extends Event 
	{
		public static const INVENTORY_FULL		: String = 'INVENTORY_FULL';
		public static const ITEM_NOT_FOUND		: String = 'ITEM_NOT_FOUND';
		public static const ITEM_ADDED			: String = 'ITEM_ADDED';
		public static const ITEM_REMOVED		: String = 'ITEM_REMOVED';
		public static const ITEM_USED			: String = 'ITEM_USED';
		public static const ITEM_DROPPED		: String = 'ITEM_DROPPED';
		public static const ITEM_REQUIRES_MON	: String = 'ITEM_REQUIRES_MON';
		public static const MON_FOR_ITEM_CHOSEN	: String = 'MON_FOR_ITEM_CHOSEN';
		
		public var param : *;
		
		public function TinyItemEvent( type : String, param : * )
		{	
			this.param = param;
			super( type, false, false );
		}
	}
}
