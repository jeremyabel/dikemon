package com.tinyrpg.battle 
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.data.TinyRankedMove;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;

	/**
	 * @author jeremyabel
	 */
	public class TinyTrainerAI 
	{
		public static const AI_RANDOM 	: String = 'AI_RANDOM';
		public static const AI_BASIC 	: String = 'AI_BASIC';
		public static const AI_ADVANCED	: String = 'AI_ADVANCED';
		public static const AI_GOOD		: String = 'AI_GOOD';
		
		private static const WILD_WEIGHTS : Array = [ 63 / 256, 64 / 256, 63 / 256, 66 / 256 ];
		
		public static function getWildMonMove( mon : TinyMon ) : TinyMoveData
		{
			// If no moves are usable, use Struggle
			if ( mon.moveSet.getPPSum() <= 0 ) {
				return TinyMoveData.STRUGGLE_ATTACK;
			}
			
			var chosenMove : TinyMoveData = null;
			
			// Get move from weighted random choice using weirdo gen 1 chart
			while ( chosenMove == null )
			{
				var randomChoice : int = TinyMath.weightedRandomChoice( WILD_WEIGHTS );
				
				switch ( randomChoice )
				{
					case 0: chosenMove = mon.moveSet.move1; break;
					case 1: chosenMove = mon.moveSet.move2; break;
					case 2: chosenMove = mon.moveSet.move3; break;
					case 3: chosenMove = mon.moveSet.move4; break; 
				}
								
				// If the chosen move has enough PP, return it. Otherwise, pick another one. 
				if ( chosenMove.currentPP > 0 ) 
				{
					TinyLogManager.log( 'getWildMonMove: ' + mon.name + ' - ' + chosenMove.name, TinyTrainerAI ); 
					return chosenMove;
					break; 
				} 
			}
			
			// If all else fails, just use Struggle
			return TinyMoveData.STRUGGLE_ATTACK;
		}
		
		public static function getTrainerMonMove( trainerMon : TinyMon, playerMon : TinyMon, aiType : String = 'AI_BASIC' ) : TinyMoveData
		{
			// If no moves are usable, use Struggle
			if ( trainerMon.moveSet.getPPSum() <= 0 ) {
				return TinyMoveData.STRUGGLE_ATTACK; 			
			}
			
			// If the AI is random, just use the wild mon function
			if ( aiType == AI_RANDOM ) {
				return getWildMonMove( trainerMon );
			}
			
			var rankedMove : TinyRankedMove = null;
			var rankedMoves : Array = [];
			
			// Put each move into a "ranked move" structure so we can sort them by preference later
			for each ( var move : TinyMoveData in trainerMon.moveSet.getMoves() ) {
				rankedMoves.push( new TinyRankedMove( move ) );
			}
			
			// Basic AI Modification: if the player's mon already has a status, don't use a move that only statuses 
			if ( aiType == AI_BASIC || aiType == AI_ADVANCED || aiType == AI_GOOD )
			{
				if ( !playerMon.isRegularStatus ) 
				{
					for each ( rankedMove in rankedMoves ) {
						rankedMove.adjustIfStatusOnly();
					}
				}
			}
			
			// Advanced AI Modification: on the mon's first turn in battle, prefer a STAT_MOD move 
			if ( aiType == AI_ADVANCED || aiType == AI_GOOD )
			{
				if ( trainerMon.isFirstTurn ) 
				{
					for each ( rankedMove in rankedMoves ) {
						rankedMove.adjustIfStatMod();
					}
				}
			}
			
			// Good AI Modification: prefer a move that is super-effective, and do not use moves that are not very effective as long as there is an alternative
			if ( aiType == AI_GOOD )
			{
				var playerTypes : Array = [ playerMon.type1, playerMon.type2 ];
				
				for each ( rankedMove in rankedMoves ) {
					rankedMove.adjustIfEffectiveVs( playerTypes );
				}
			}
			
			// Sort the moves by their rank property, highest to lowest 
			rankedMoves.sortOn( [ "rank" ], Array.NUMERIC | Array.DESCENDING );
			
			// Return the highest-ranked move that has enough PP to be used 
			for ( var i : int = 0; i < rankedMoves.length; i++ ) 
			{
				rankedMove = rankedMoves[ i ];
				
				if ( rankedMove.move.currentPP > 0 )
				{
					TinyLogManager.log( 'getTrainerMonMove: ' + trainerMon.name + ' - ' + rankedMove.move.name, TinyTrainerAI ); 
					return rankedMove.move;
					break;
				}
			}
			
			// If all else fails, just use Struggle
			return TinyMoveData.STRUGGLE_ATTACK;
		}
	}
}
