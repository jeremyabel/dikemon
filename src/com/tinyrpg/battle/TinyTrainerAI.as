package com.tinyrpg.battle 
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;

	/**
	 * @author jeremyabel
	 */
	public class TinyTrainerAI 
	{
		public static function getWildMonMove( mon : TinyMon ) : TinyMoveData
		{
			var chosenMove : TinyMoveData = null;
			
			// If no moves are usable, use Struggle
			if ( mon.moveSet.getPPSum() <= 0 ) {
				return TinyMoveData.STRUGGLE_ATTACK; 			
			}
			
			// Get move from weighted random choice using weirdo gen 1 chart
			while ( chosenMove == null )
			{
				var randomChoice : int = TinyMath.weightedRandomChoice( [ 63 / 256, 64 / 256, 63 / 256, 66 / 256 ] );
				
				switch ( randomChoice )
				{
					case 0: chosenMove = mon.moveSet.move1; break;
					case 1: chosenMove = mon.moveSet.move2; break;
					case 2: chosenMove = mon.moveSet.move3; break;
					case 3: chosenMove = mon.moveSet.move4; break; 
				}				
			}
				
			if ( chosenMove.currentPP > 0 ) {
				TinyLogManager.log('getWildMonMove: ' + mon.name + ' - ' + chosenMove.name, TinyTrainerAI); 
				return chosenMove; 
			} else {
				return TinyTrainerAI.getWildMonMove( mon );
			}
		}
	}
}
