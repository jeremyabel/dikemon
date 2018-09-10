package com.tinyrpg.sequence 
{
	import com.tinyrpg.display.TinyBattleMonStatDisplay;

	/**
	 * @author jeremyabel
	 */
	public class TinyUpdateHPCommand
	{		
		public var value : int;
		public var statDisplay : TinyBattleMonStatDisplay;
		
		public function TinyUpdateHPCommand( value : int, statDisplay : TinyBattleMonStatDisplay )
		{
			this.value = value;
			this.statDisplay = statDisplay;
		}
	}
}