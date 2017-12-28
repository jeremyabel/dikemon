package com.tinyrpg.battle 
{
	import flash.media.Sound;
	
	import com.tinyrpg.battle.TinyBattleMath;
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.display.TinyBallFXAnimation;
	import com.tinyrpg.media.sfx.itemfx.SFXUseItem;
	import com.tinyrpg.misc.TinyBallThrowResult;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleCommandItem extends TinyBattleCommand 
	{
		private var mon : TinyMon;
		private var item : TinyItem;
		
		public function TinyBattleCommandItem( battle : TinyBattleMon, item : TinyItem )
		{
			super( battle, TinyBattleCommand.COMMAND_ITEM, TinyBattleCommand.USER_PLAYER );
			
			this.item = item;
			this.mon = this.battle.m_currentPlayerMon;
			
			this.item.printLog();
		}
		
		
		override public function execute() : void
		{
			if ( this.item.healHP ) this.healHP(); 
			if ( this.item.healStatus ) this.healStatus();
			if ( this.item.isBall ) this.useBall();
			
			this.eventSequence.addEnd();
			super.execute();
		}
		
		
		private function useBall() : void
		{
			TinyLogManager.log('useBall: ' + this.item.effectAmount, this);

			var resultString : String = '';
			var isUltra : Boolean = this.item.effectAmount > 1;
			
			// Add delay for nice feels
			this.eventSequence.addDelay( 0.2 );
			
			// Calculate and animate the ball throw result 
			if ( this.battle.m_isWildEncounter )
			{
				// Calculate catch result and number of wobbles
				var canCatch : Boolean = TinyBattleMath.canCatch( this.battle.m_currentEnemyMon, this.item.effectAmount );
				var numWobbles : int = TinyBattleMath.getNumCaptureWobbles( this.battle.m_currentEnemyMon, this.item.effectAmount );
				
				TinyLogManager.log('canCatch: ' + canCatch, this );
				TinyLogManager.log('numWobbles: ' + numWobbles, this );
				
				// Throw and open the ball
				this.eventSequence.addPlayBallAnim( new TinyBallFXAnimation( TinyBallFXAnimation.BALL_PHASE_OPEN, isUltra ) );
				
				// Get in the ball
				this.eventSequence.addGetInBall( this.battle.m_enemyMonContainer );
				
				// Close the ball
				this.eventSequence.addPlayBallAnim( new TinyBallFXAnimation( TinyBallFXAnimation.BALL_PHASE_CLOSE, isUltra ) );
				
				// Wobble the ball some number of times
				for ( var i : int = 0; i < numWobbles; i++ ) 
				{
					this.eventSequence.addPlayBallAnim( new TinyBallFXAnimation( TinyBallFXAnimation.BALL_PHASE_WOBBLE, isUltra ) );
				}
				
				// The rest of the sequence depends on if the mon is caught or not
				if ( canCatch )
				{
					// TODO: play some sound
					// TODO: add to dex and stuff
					
					// Show caught message
					resultString = TinyBattleStrings.getBattleString( TinyBattleStrings.BALL_CAUGHT, this.battle.m_currentEnemyMon );
					
					// TODO: end battle
				}
				else
				{
					// Escape from the ball
					this.eventSequence.addEscapeFromBall( this.battle.m_enemyMonContainer );
					
					// Burst open the ball
					this.eventSequence.addPlayBallAnim( new TinyBallFXAnimation( TinyBallFXAnimation.BALL_PHASE_BURST, isUltra ) );
					
					// Show "almost" message
					resultString = TinyBattleStrings.getBallWobbleString( numWobbles );
				}
			}
			else
			{
				// Can't capture trainer mons, so reject the ball throw
				this.eventSequence.addPlayBallAnim( new TinyBallFXAnimation( TinyBallFXAnimation.BALL_PHASE_REJECT, isUltra ) );
				resultString = TinyBattleStrings.BALL_THROW_REJECT;
			}
			
			// Show dialog box
			this.eventSequence.addDialogBoxFromString( resultString );
		}
		
		
		private function healHP() : void
		{
			TinyLogManager.log('healHP: ' + this.item.effectAmount, this );
			
			// Add delay for nice feels
			this.eventSequence.addDelay( 0.2 );
			
			this.playHealAnimation();
			
			// Recover HP
			this.mon.recoverHP( this.item.effectAmount );
			
			// Add delay for nice feels
			this.eventSequence.addDelay( 0.2 ); 
			
			// Update HP display
			this.eventSequence.addUpdateHPDisplay( this.battle.m_playerStatDisplay );
			
			// Show dialog box
			if ( this.mon.isMaxHP ) {
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.HP_FULL, this.mon ) );
			} else {
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.REGAINED_HEALTH, this.mon ) );
			}
		}
		
		
		private function healStatus() : void
		{
			// Add delay for nice feels
			this.eventSequence.addDelay( 0.2 );
			
			this.playHealAnimation();
			
			var healStatusString : String = '';
			
			// Resolve burning
			if ( this.item.healBurn ) 
			{
				TinyLogManager.log('healStatus: BURN', this );
				healStatusString = TinyBattleStrings.getBattleString( TinyBattleStrings.BURN_HEAL, this.mon );
				this.mon.isBurned = false;
			}
			
			// Resolve paralysis
			if ( this.item.healParalysis )
			{
				TinyLogManager.log('healStatus: PARALYSIS', this );
				healStatusString = TinyBattleStrings.getBattleString( TinyBattleStrings.PARALYSIS_HEALED, this.mon );
				this.mon.isParaylzed = false;
			}
			
			// Resolve poison
			if ( this.item.healPoison )
			{
				TinyLogManager.log('healStatus: POISON', this );
				healStatusString = TinyBattleStrings.getBattleString( TinyBattleStrings.POISON_HEAL, this.mon );
				this.mon.isPoisoned = false;
			}

			// Resolve sleep			
			if ( this.item.healSleep )
			{
			 	TinyLogManager.log('healStatus: SLEEP', this );
			 	healStatusString = TinyBattleStrings.getBattleString( TinyBattleStrings.WOKE_UP_ITEM, this.mon );
			 	this.mon.setSleepCounter( 0 );
			}
			
			// Update status display
			this.eventSequence.addUpdateHPDisplay( this.battle.m_playerStatDisplay );
			
			// Show dialog box
			this.eventSequence.addDialogBoxFromString( healStatusString );
		}
		
		
		private function playHealAnimation() : void
		{
			// Play the "used item" sound
			this.eventSequence.addPlaySound( new SFXUseItem() as Sound );
			
			// Play the jumpy heal animation
			this.eventSequence.addPlayerHeal( this.battle.m_playerMonContainer );
		}
	}
}
