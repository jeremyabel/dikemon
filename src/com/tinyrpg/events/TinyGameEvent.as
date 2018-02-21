package com.tinyrpg.events 
{
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyGameEvent extends Event 
	{
		public static const LOAD_GAME 			: String = 'LOAD_GAME';
		public static const NEW_GAME			: String = 'NEW_GAME';
		public static const QUIT_GAME			: String = 'QUIT_GAME';
		public static const FADE_IN_COMPLETE 	: String = 'FADE_IN_COMPLETE';
		public static const FADE_OUT_COMPLETE 	: String = 'FADE_OUT_COMPLETE';
		public static const BATTLE_IN_COMPLETE	: String = 'BATTLE_IN_COMPLETE';
		public static const BATTLE_COMPLETE		: String = 'BATTLE_COMPLETE';
		
		public var param : *;
		
		public function TinyGameEvent(type : String, param : * = null )
		{
			this.param = param;
			super( type, false, false );
		}
	}
}
