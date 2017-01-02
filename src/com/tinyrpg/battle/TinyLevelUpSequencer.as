package com.tinyrpg.battle 
{
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.ui.TinyDeleteMoveDialog;
	import com.tinyrpg.ui.TinyLevelUpStatsDisplay;

	/**
	 * @author jeremyabel
	 */
	public class TinyLevelUpSequencer 
	{
		public static function generateLevelUpSequence( battle : TinyBattleMon, eventSequence : TinyBattleEventSequence, levelUpInfo : TinyLevelUpInfo ) : void
		{
			// Add each new level to the sequence one by one
 			for ( var i : int = 1; i <= levelUpInfo.numLevelsGained; i++ ) 
 			{
				// Update exp bar to full
				eventSequence.addFillEXPDisplay( battle.m_playerStatDisplay );
				
				// Increment the level number display
				eventSequence.addIncrementLevelDisplay( battle.m_playerStatDisplay );
				
				// Add delay for nice feels
				eventSequence.addDelay( 0.1 );
				
				// Show "leveled up" dialog w/ new stats display
				eventSequence.addShowLevelStats( new TinyLevelUpStatsDisplay( levelUpInfo.mon, levelUpInfo.initialLevel + i, levelUpInfo.initialStatSet, levelUpInfo.updatedStatSets[ i - 1 ] ) );
				
				// Update the HP display with the new HP value
				eventSequence.addSetStatDisplayMon( battle.m_currentPlayerMon, battle.m_playerStatDisplay );
				
				// Deal with any new moves
				for each ( var newMove : TinyMoveData in levelUpInfo.newMoves[ i - 1 ] )
				{	
					var firstOpenMoveSlot : int = levelUpInfo.mon.moveSet.getFirstOpenMoveSlot();
			
					if ( firstOpenMoveSlot > -1 )
					{
						// Add move immediately if there's an open slot
						levelUpInfo.mon.moveSet.setMoveInSlot( newMove, firstOpenMoveSlot );
						
						// Show "learned move" dialog
						eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.LEARNED_MOVE, levelUpInfo.mon, null, newMove ) );
					}
					else
					{
						// Show "trying to learn" dialog
						eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.TRYING_TO_LEARN, levelUpInfo.mon, null, newMove ) );
						
						// Show "can't learn" dialog
						eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.CANT_LEARN_MOVE, levelUpInfo.mon, null, newMove ) );
						
						// Show "delete move?" dialog 
						eventSequence.addShowDeleteMoveDialog( new TinyDeleteMoveDialog( levelUpInfo.mon, newMove ) );
					}
				}
				
				// Add delay for nice feels
				eventSequence.addDelay( 0.2 );
				
				// Clear the exp bar to zero to accomidate more exp juice 
				eventSequence.addClearEXPDisplay( battle.m_playerStatDisplay );
				
				// If this is the last level gained, add the remaining exp to the exp bar display
				if ( i == levelUpInfo.numLevelsGained )
				{
					eventSequence.addUpdateEXPDisplay( battle.m_playerStatDisplay );	
				}
			}
		}
	}
}
