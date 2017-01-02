package com.tinyrpg.events 
{
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyMonEvent extends Event 
	{
		public static const SOBERED_UP 		: String = 'SOBERED_UP';
		public static const WOKE_UP			: String = 'WOKE_UP';
		public static const SAVEGUARD_DONE	: String = 'SAFEGUARD_DONE';
		
		public function TinyMonEvent( type : String )
		{
			super( type, false );
		}
	}
}
