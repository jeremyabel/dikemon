package com.tinyrpg.battle 
{
	
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.display.TinyMonContainer;
	import com.tinyrpg.display.TinyBattleBallDisplay;
	import com.tinyrpg.display.TinyBattleMonStatDisplay;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleCommandSwitch extends TinyBattleCommand 
	{
		public var switchMon : TinyMon;
		public var isForced : Boolean;
		
		override public function get logString() : String
		{
			return 'SWITCH: ' + this.user + ' switched to ' + switchMon.name;
		}
		
		public function TinyBattleCommandSwitch( battle : TinyBattle, user : String, switchMon : TinyMon, isForced : Boolean = false )
		{
			super( battle, TinyBattleCommand.COMMAND_SWITCH, user );
			
			this.switchMon = switchMon;
			this.isForced = isForced; 
			
			TinyLogManager.log('adding battle command: ' + this.logString, this);
					
			// Get the applicable objects to be used in the switch sequence
			var monContainer : TinyMonContainer = this.isEnemy ? this.battle.m_enemyMonContainer : this.battle.m_playerMonContainer;
			var ballDisplay : TinyBattleBallDisplay = this.isEnemy ? this.battle.m_enemyBallDisplay : this.battle.m_playerBallDisplay;
			var statDisplay : TinyBattleMonStatDisplay = this.isEnemy ? this.battle.m_enemyStatDisplay : this.battle.m_playerStatDisplay; 
			var previousMon : TinyMon = this.isEnemy ? this.battle.m_currentEnemyMon : this.battle.m_currentPlayerMon;
			var trainer : TinyTrainer = this.isEnemy ? this.battle.m_enemyTrainer : this.battle.m_playerTrainer;
			
			// If this switch isn't due to the previous mon fainting, the current mon needs to be recalled
			if ( previousMon.isHealthy ) 
			{	
				// Show the "recalled" dialog box
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getRandomRecalledString( isEnemy, previousMon, trainer ) );
				
				// Recall current mon
				this.eventSequence.addRecallMon( monContainer );
				
				// Hide mon stats
				this.eventSequence.addHideElement( statDisplay );
				
				// Delay for nice feels
				this.eventSequence.addDelay( 0.5 );
			}
			else
			{	
				// Hide mon stats
				this.eventSequence.addHideElement( statDisplay );
				
				// Show trainer ball display
				this.eventSequence.addShowElement( ballDisplay );
				
				// Delay for nice feels
				this.eventSequence.addDelay( 0.5 );
			}
			
			// Set new mon as current and cleanup previous mon
			this.battle.wasLastSwitchEnemy = isEnemy;
			previousMon.isInBattle = false;
			switchMon.isInBattle = true;
			if (isEnemy) {
				this.battle.m_currentEnemyMon = this.switchMon;
			} else {
				this.battle.m_currentPlayerMon = this.switchMon;
			}
			
			// Show summon dialog
			this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getRandomSummonDialogString( isEnemy, switchMon, trainer ) ); 
			
			// Show new mon stats
			this.eventSequence.addSetStatDisplayMon( this.switchMon, statDisplay );
			this.eventSequence.addShowElement( statDisplay );
			
			// Hide ball display
			this.eventSequence.addHideElement( ballDisplay );
			
			// Summon new mon
			this.eventSequence.addSummonMon( this.switchMon, monContainer );
			
			// Delay for nice feels
			this.eventSequence.addDelay( 0.2 );
			
			// End
			this.eventSequence.addEnd();
		}
		
		override public function execute() : void
		{
			TinyLogManager.log('doSwitchMon: ' + this.switchMon.name, this);
			super.execute();
		}
	}
}
