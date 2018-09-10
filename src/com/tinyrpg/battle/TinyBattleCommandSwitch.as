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
		
		public function TinyBattleCommandSwitch( battle : TinyBattle, user : String, switchMon : TinyMon, isForced : Boolean = false )
		{
			super( battle, TinyBattleCommand.COMMAND_SWITCH, user );
			
			this.switchMon = switchMon;
			this.isForced = isForced; 
			
			TinyLogManager.log('adding battle command: ' + this.logString, this);
					
			// Get the applicable objects to be used in the switch sequence
			var monContainer : TinyMonContainer = this.isEnemy ? this.battle.enemyMonContainer : this.battle.playerMonContainer;
			var ballDisplay : TinyBattleBallDisplay = this.isEnemy ? this.battle.enemyBallDisplay : this.battle.playerBallDisplay;
			var statDisplay : TinyBattleMonStatDisplay = this.isEnemy ? this.battle.enemyStatDisplay : this.battle.playerStatDisplay; 
			var previousMon : TinyMon = this.isEnemy ? this.battle.currentEnemyMon : this.battle.currentPlayerMon;
			var trainer : TinyTrainer = this.isEnemy ? this.battle.enemyTrainer : this.battle.playerTrainer;
			
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
				this.battle.currentEnemyMon = this.switchMon;
				this.battle.currentEnemyMon.moveSet.loadAllMoveFXSprites( this.battle.battlePalette, true );
			} else {
				this.battle.currentPlayerMon = this.switchMon;
				this.battle.currentPlayerMon.moveSet.loadAllMoveFXSprites( this.battle.battlePalette, false );
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
			TinyLogManager.log( 'doSwitchMon: ' + this.switchMon.name, this );
			super.execute();
		}
		
		override public function get logString() : String
		{
			return 'SWITCH: ' + this.user + ' switched to ' + switchMon.name;
		}
	}
}
