package com.tinyrpg.sequence 
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.display.TinyBattleMonStatDisplay;

	/**
	 * @author jeremyabel
	 */
	public class TinySetMonStatDisplayCommand 
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