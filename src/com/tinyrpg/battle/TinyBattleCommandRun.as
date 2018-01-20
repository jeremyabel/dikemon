package com.tinyrpg.battle 
{
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleCommandRun extends TinyBattleCommand 
	{
		public static const RESULT_PASSED 		: String = 'RUN_PASSED';
		public static const RESULT_PASSED_DAD	: String = 'RUN_PASSED_DAD';
		public static const RESULT_FAILED		: String = 'RUN_FAILED';
		public static const RESULT_IMPOSSIBLE	: String = 'RUN_IMPOSSIBLE';
		
		public var result : String = RESULT_IMPOSSIBLE;
		
		public function TinyBattleCommandRun( battle : TinyBattle, user : String )
		{
			super( battle, TinyBattleCommand.COMMAND_RUN, user );
			
			var trainer : TinyTrainer = this.isEnemy ? this.battle.m_enemyTrainer : this.battle.m_playerTrainer;
			
			// You can only run from wild encounters
			if ( this.battle.m_isWildEncounter )
			{
				var trainerMon : TinyMon = this.isEnemy ? this.battle.m_currentEnemyMon : this.battle.m_currentPlayerMon;
				var targetMon : TinyMon = this.isEnemy ? this.battle.m_currentPlayerMon : this.battle.m_currentEnemyMon;
				
				// Calculate running success
				this.result = TinyBattleMath.canRun( trainer, trainerMon, targetMon ) ? RESULT_PASSED : RESULT_FAILED; 
			}
			else if ( trainer.runAttempts >= 6 && !this.isEnemy ) // TODO: Check dad flag 
			{
				// But if this is the 6th time you've tried running, allow running due to the dad call easteregg
				this.result = RESULT_PASSED_DAD;
			}
			else 
			{	
				// Otherwise, running is impossible
				this.result = RESULT_IMPOSSIBLE;
			}
			
			// Add correct dialog to the event sequence 
			switch ( this.result ) 
			{
				case RESULT_PASSED:
					this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.GOT_AWAY ) ); break;
				case RESULT_PASSED_DAD:
					this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.RUN_PASSED_DAD ) ); break;
				case RESULT_FAILED:
					this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getRunFailedString( this.battle.m_playerTrainer.runAttempts ) ); break;
				case RESULT_IMPOSSIBLE:
					this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getRunImpossibleString( this.battle.m_playerTrainer.runAttempts ) ); break;
			}
			
			// Increment trainer's run attempts, which is used by the canRun() calculation
			trainer.runAttempts++;
		
			TinyLogManager.log('adding battle command: ' + this.logString + ' result: ' + this.result, this);
		}
	}
}
