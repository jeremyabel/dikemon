package com.tinyrpg.misc 
{
	import flash.events.EventDispatcher;
	
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.display.TinyBattleMonStatDisplay;

	/**
	 * @author jeremyabel
	 */
	public class TinySetMonStatDisplayCommand extends EventDispatcher 
	{
		public var statDisplay : TinyBattleMonStatDisplay;
		public var mon : TinyMon;
		
		public function TinySetMonStatDisplayCommand( statDisplay : TinyBattleMonStatDisplay, mon : TinyMon )
		{
			this.statDisplay = statDisplay;
			this.mon = mon;
		}
	}
}