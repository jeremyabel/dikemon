package com.tinyrpg.events 
{
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyAutotypeTextEvent extends Event 
	{
		public static var TEXT_ENTRY_COMPLETE	: String = 'TEXT_ENTRY_COMPLETE';
		public static var LINE_COMPLETE			: String = 'LINE_COMPLETE';
		public static var DIALOG_COMPLETE		: String = 'DIALOG_COMPLETE';
		
		public var param : *;
		
		public function TinyAutotypeTextEvent( type : String, param : * = null )
		{
			this.param = param;
			super( type, false, false );
		} 
	}
}
