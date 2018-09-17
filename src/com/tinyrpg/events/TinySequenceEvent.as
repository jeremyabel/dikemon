package com.tinyrpg.events 
{
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinySequenceEvent extends Event 
	{
		public static var SEQUENCE_END 			: String = 'SEQUENCE_END';
		public static var DIALOG_COMPLETE 		: String = 'DIALOG_COMPLETE';
		public static var SPIN_COMPLETE			: String = 'SPIN_COMPLETE';
		public static var WALK_COMPLETE			: String = 'WALK_COMPLETE';
		public static var CHOICE_COMPLETE		: String = 'CHOICE_COMPLETE';
		public static var TWEEN_COMPLETE 		: String = 'TWEEN_COMPLETE';
		public static var CAMERA_MOVE_COMPLETE	: String = 'CAMERA_MOVE_COMPLETE';
		
		public var param : *;
		
		public function TinySequenceEvent( type : String, param : * = null )
		{
			this.param = param;
			super( type, false, false );
		} 
	}
}
