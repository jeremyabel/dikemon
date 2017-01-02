package com.tinyrpg.events 
{
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyStatsEvent extends Event 
	{
		public var data : *;
		
		public static const STATUS_DAMAGED 	: String = 'STATUS_DAMAGED'; 
		public static const STATUS_HEALED 	: String = 'STATUS_HEALED';
		public static const STATUS_DEAD 	: String = 'STATUS_DEAD';
		
		public function TinyStatsEvent(type : String, data : *)
		{
			this.data = data;
			super(type, false, false);
		}
	}
}
