package com.tinyrpg.events 
{
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyFieldMapEvent extends Event 
	{
		public static const DATA_READY			: String = 'DATA_READY';
		public static const GRASS_HIT			: String = 'GRASS_HIT';
		public static const JUMP_HIT			: String = 'JUMP_HIT';
		public static const OBJECT_HIT			: String = 'OBJECT_HIT';
		public static const NOTHING_HIT			: String = 'NOTHING_HIT';
		public static const SHOW_COMPLETE		: String = 'SHOW_COMPLETE';
		public static const HIDE_COMPLETE		: String = 'HIDE_COMPLETE';
		public static const MOVE_START			: String = 'MOVE_START';
		public static const MOVE_COMPLETE 		: String = 'MOVE_COMPLETE';
		public static const STEP_COMPLETE		: String = 'STEP_COMPLETE';
		public static const EVENT_COMPLETE 		: String = 'EVENT_COMPLETE'; 
		
		public var param : * = null;
		
		public function TinyFieldMapEvent( type : String, param : * = null )
		{
			this.param = param;
			super( type, false, false );
		}
	}
}