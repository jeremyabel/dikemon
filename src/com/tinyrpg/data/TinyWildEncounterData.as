package com.tinyrpg.data
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.lookup.TinyMonLookup;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;
	
	/**
	 * Class which contains data about wild encounters on a single map.
	 * 
	 * Wild encounters are triggered by walking in tall grass, and can
	 * generate battle encounters with one of 7 leveled mons. The 7 slots 
	 * have a decreasing chance of being called.  
	 * 
	 * @author jeremyabel
	 */
	public class TinyWildEncounterData 
	{
		private var encounterMons : Array;
		
		private static const ENCOUNTER_CHANCE_TABLE : Array = [ 30 / 100, 30 / 100, 20 / 100, 10 / 100, 5 / 100, 4 / 100, 1 / 100 ]; 
		
		public function TinyWildEncounterData( encounterMonInfo : Array ) : void
		{
			this.encounterMons = encounterMonInfo;
		}
		
		/**
		 * Returns a wild encounter mon using the chance table.
		 */
		public function getEncounterMon() : TinyMon
		{
			var encounterIndex : uint = TinyMath.weightedRandomChoice( ENCOUNTER_CHANCE_TABLE ); 
			var encounterData : Array = this.encounterMons[ encounterIndex ];
			
			return TinyMonLookup.getInstance().getMonByName( encounterData[ 0 ], encounterData[ 1 ] ); 
		}
		
		public function printLog() : void
		{
			
		}
	}
}