package com.tinyrpg.sequence 
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.display.TinyBattleMonStatDisplay;

	/**
	 * Class which represents a battle event for setting the current target mon for a given
	 * {@link TinyBattleMonStatDisplay}.
	 * 
	 * This command is called whenever the stat display needs to be updated due to a mon
	 * fainting or being switched.
	 * 
	 * @author jeremyabel
	 */
	public class TinySetMonStatDisplayCommand 
	{
		public var statDisplay : TinyBattleMonStatDisplay;
		public var mon : TinyMon;
		
		/**
		 * @param	statDisplay		The target {@link TinyBattleMonStatDisplay} to update.
		 * @param	mon				The new mon to be shown in the stat display.
		 */
		public function TinySetMonStatDisplayCommand( statDisplay : TinyBattleMonStatDisplay, mon : TinyMon )
		{
			this.statDisplay = statDisplay;
			this.mon = mon;
		}
	}
}