package com.tinyrpg.battle 
{
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleCommandPlayerResolveStatus extends TinyBattleCommand 
	{
		public function TinyBattleCommandPlayerResolveStatus( battle : TinyBattle )
		{
			super( battle, TinyBattleCommand.COMMAND_RESOLVE_STATUSES, TinyBattleCommand.USER_PLAYER );
			
			TinyLogManager.log('adding battle command: ' + this.logString, this);

			// Decrement all status effect counters
			var statusesResolved : Object = this.battle.m_currentPlayerMon.decrementStatusCounters();
			
			// Add any applicable resolved dialogs
			if ( statusesResolved['sleep'] )	
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.WOKE_UP, this.battle.m_currentPlayerMon ) );
			if ( statusesResolved['confusion'] )
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.SOBERED_UP, this.battle.m_currentPlayerMon ) );
			if ( statusesResolved['safeguard'] )
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.SAFEGUARD_FADED, this.battle.m_currentPlayerMon ) );
		}
	}
}
