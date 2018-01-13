package com.tinyrpg.events 
{
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyFieldMapEvent extends Event 
	{
		public static var DATA_READY	: String = 'DATA_READY';
		public static var OBJECT_HIT	: String = 'OBJECT_HIT';
		public static var NOTHING_HIT	: String = 'NOTHING_HIT';
		public static var SHOW_COMPLETE	: String = 'SHOW_COMPLETE';
		public static var HIDE_COMPLETE	: String = 'HIDE_COMPLETE';
		public static var MOVE_START	: String = 'MOVE_START';
		public static var MOVE_COMPLETE : String = 'MOVE_COMPLETE';
		public static var STEP_COMPLETE	: String = 'STEP_COMPLETE';
		
		public var param : * = null;
		
		public function TinyFieldMapEvent( type : String, param : * = null )
		{
			this.param = param;
			super( type, false, false );
		}
	}
}