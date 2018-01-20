package com.tinyrpg.data
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.misc.TinyMonConfig;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;
	
	/**
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
		
		public function getEncounterMon() : TinyMon
		{
			var encounterIndex : uint = TinyMath.weightedRandomChoice( ENCOUNTER_CHANCE_TABLE ); 
			var encounterData : Array = this.encounterMons[ encounterIndex ];
			
			return TinyMonConfig.getInstance().getMonByName( encounterData[ 0 ], encounterData[ 1 ] ); 
		}
		
		public function printLog() : void
		{
			
		}
	}
			
}