package com.tinyrpg.data 
{

	/**
	 * Structural class which contains info about a stat-modifying move effect.
	 * 
	 * @author jeremyabel
	 */
	public class TinyMoveEffectStatMod 
	{
		// The name of the stat being modified
		public var effectedStat : String;
		
		// The number of stat stages to increase or decrease. 
		public var numStages : int;
		
		/**
		 * @param	effectedStat	The name of the stat being modified.
		 * @param	numStages	 	The number of stat stages to increase or decrease.
		 */
		public function TinyMoveEffectStatMod( effectedStat : String, numStages : int )
		{
			this.effectedStat = effectedStat;
			this.numStages = numStages;
		}
	}
}
