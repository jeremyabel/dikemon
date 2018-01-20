package com.tinyrpg.battle 
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyMoveData;
	
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleCommandDistributeExp extends TinyBattleCommand 
	{
		private var participatingMons : Array = [];
		private var earnedExp : int = 0;
		
		
		public function TinyBattleCommandDistributeExp( battle : TinyBattle, participatingMons : Array, earnedExp : int )
		{
			super( battle, TinyBattleCommand.COMMAND_DISTRIBUTE_EXP, TinyBattleCommand.USER_PLAYER );
			
			TinyLogManager.log('adding battle command: ' + this.logString, this);
			
			this.participatingMons = participatingMons;
			this.earnedExp = earnedExp;
		}
		
		
		override public function execute() : void 
		{
			// Distribute exp to each mon that participated in the battle
			for each ( var mon : TinyMon in this.participatingMons )
			{
				// Show "gained exp" dialog 
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.GAIN_EXP_POINTS, mon, null, null, null, this.earnedExp ) );
										
				// If the mon has leveled up, a bunch of extra dialogs and such are shown
				var levelUpInfo : TinyLevelUpInfo = mon.addExp( this.earnedExp );
				if ( levelUpInfo )
				{
					// Update exp bar and show the "grew level" dialog for each level grown
					for ( var i : int = mon.level + 1; i < levelUpInfo.numLevelsGained; i++ )
					{
						// TODO: update exp bar
						this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.GREW_LEVEL, mon, null, null, null, i ) );		
					}
					
					// TODO: Show updated stats
					
					// Show "learn move" dialogs, if there are any
					for each ( var newMove : TinyMoveData in levelUpInfo.newMoves )
					{
						var firstOpenMoveSlot : int = mon.moveSet.getFirstOpenMoveSlot();
						if ( firstOpenMoveSlot > -1 )
						{
							// There's an open slot, just add the move and show the basic dialog 
							this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.LEARNED_MOVE, mon, null, newMove ) );
							mon.moveSet.setMoveInSlot( newMove, firstOpenMoveSlot );
						}
						else 
						{
							// If there isn't an open move slot, the player is given the option to overwrite an old move
							this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.TRYING_TO_LEARN, mon, null, newMove ) );
						}
					}
				}
			}
			
			super.execute();
		}
	}
}
