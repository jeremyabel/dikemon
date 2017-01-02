package com.tinyrpg.data 
{

	/**
	 * @author jeremyabel
	 */
	public class TinyMoveEffectStatMod 
	{
		public var effectedStat : String;
		public var numStages : int;
		
		public function TinyMoveEffectStatMod( effectedStat : String, numStages : int )
		{
			this.effectedStat = effectedStat;
			this.numStages = numStages;
		}
	}
}
