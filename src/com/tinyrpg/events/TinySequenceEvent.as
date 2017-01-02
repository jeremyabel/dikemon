package com.tinyrpg.events 
{
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinySequenceEvent extends Event 
	{
		public static var SEQUENCE_END : String = 'SEQUENCE_END';
		public static var DIALOG_COMPLETE : String = 'DIALOG_COMPLETE';
		
		public function TinySequenceEvent(type : String)
		{
			super(type, false, false);
		} 
	}
}
