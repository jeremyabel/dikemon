package com.tinyrpg.battle 
{
	import flash.media.Sound;
	
	import com.tinyrpg.battle.TinyBattleMath;
	import com.tinyrpg.core.TinyConfig;
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.display.TinyBallFXAnimation;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.media.sfx.itemfx.SFXUseItem;
	import com.tinyrpg.data.TinyBallThrowResult;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;

	/**
	 * Class which represents a battle command for using an item.
	 * The functionality of each item is defined in this class, including using balls.
	 * 
	 * Subclass of {@link TinyBattleCommand}.
	 * 
	 * @author jeremyabel
	 */
	public class TinyBattleCommandItem extends TinyBattleCommand 
	{
		public static const RESULT_OK 			: String = 'ITEM_OK';
		public static const RESULT_MON_CAUGHT	: String = 'ITEM_MON_CAUGHT';
		
		private var mon : TinyMon;
		private var item : TinyItem;
		private var move : TinyMoveData;
		private var canCatch : Boolean;
		private var numWobbles : int;
		
		public var result : String = RESULT_OK;
		
		
		/**
		 * Creates a battle command for using a given item in a given battle. 
		 * The command is automatically set to be called by the PLAYER, because only
		 * players can use items in battle. 
		 * 
		 * TODO: enemies be able to use items too if we have time...
		 * 
		 * @param	battle	The battle this command is created for.
		 * @param	item	The item that is being used.
		 * @param	move	If the item restores a move's PP, then the player picks a move before this item command is created, and it is passed in here.
		 */
		public function TinyBattleCommandItem( battle : TinyBattle, item : TinyItem, move : TinyMoveData = null )
		{
			super( battle, TinyBattleCommand.COMMAND_ITEM, TinyBattleCommand.USER_PLAYER );
			
			this.item = item;
			this.move = move;
			this.mon = this.battle.currentPlayerMon;
			
			this.item.printLog();
			
			// For ball items, the result is pre-computed in order to set up the sequencing of the commands that follow this one. 
			if ( this.item.isBall && this.battle.isWildEncounter )
			{
				// Calculate this catch result and number of wobbles
				this.canCatch = TinyBattleMath.canCatch( this.battle.currentEnemyMon, this.item.effectAmount );
				this.numWobbles = TinyBattleMath.getNumCaptureWobbles( this.battle.currentEnemyMon, this.item.effectAmount );
				
				if ( this.canCatch )
				{
					this.result = RESULT_MON_CAUGHT;
				}
			}
		}
		
		
		/**
		 * Overridden execute() function which remaps the item's type to various functions which
		 * create the required sequence for the specific item.
		 */
		override public function execute() : void
		{
			if ( this.item.healHP ) this.healHP(); 
			if ( this.item.healPP ) this.healPP();
			if ( this.item.healStatus ) this.healStatus();
			if ( this.item.isBall && this.battle.isWildEncounter ) this.useBall();
			
			this.eventSequence.addEnd();
			super.execute();
		}
		
		
		/**
		 * Function which handles the sequencing of ball items which have the possibility of catching a wild mon.
		 * The probability of this happening is determined by a number of factors and is calculated by the 
		 * {@link TinyBattleMath} class and is precalculated in the constructor.
		 */
		private function useBall() : void
		{
			TinyLogManager.log('useBall: ' + this.item.effectAmount, this);
			
			var isUltra : Boolean = this.item.effectAmount > 1;
			
			// Add delay for nice feels
			this.eventSequence.addDelay( 0.2 );
			
			// Animate the ball throw result 
			if ( this.battle.isWildEncounter )
			{
				TinyLogManager.log( 'canCatch: ' + this.canCatch, this );
				TinyLogManager.log( 'numWobbles: ' + this.numWobbles, this );
				
				// Throw and open the ball
				this.eventSequence.addPlayBallAnim( new TinyBallFXAnimation( TinyBallFXAnimation.BALL_PHASE_OPEN, isUltra ) );
				
				// Get in the ball
				this.eventSequence.addGetInBall( this.battle.enemyMonContainer );
				
				// Close the ball
				this.eventSequence.addPlayBallAnim( new TinyBallFXAnimation( TinyBallFXAnimation.BALL_PHASE_CLOSE, isUltra ) );
				
				// Wobble the ball some number of times
				for ( var i : int = 0; i < this.numWobbles; i++ ) 
				{
					this.eventSequence.addPlayBallAnim( new TinyBallFXAnimation( TinyBallFXAnimation.BALL_PHASE_WOBBLE, isUltra ) );
				}
				
				// The rest of the sequence depends on if the mon is caught or not
				if ( this.canCatch )
				{
					// TODO: play some sound
					
					// Show caught message
					this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.BALL_CAUGHT, this.battle.currentEnemyMon ) );
					
					// If the player already has a full squad, send the caught mon to the storage PC. Otherwise, add it to the player's regular squad. 
					if ( TinyGameManager.getInstance().playerTrainer.squad.length >= TinyConfig.MAX_SQUAD_LENGTH )
					{
						this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.CAUGHT_SQUAD_FULL, this.battle.currentEnemyMon ) );
						TinyGameManager.getInstance().playerTrainer.squadInPC.push( this.battle.currentEnemyMon );
						TinyLogManager.log( 'added ' + this.battle.currentEnemyMon.name + ' to Storage PC', this );
					}
					else
					{
						TinyGameManager.getInstance().playerTrainer.squad.push( this.battle.currentEnemyMon );
						TinyLogManager.log( 'added ' + this.battle.currentEnemyMon.name + ' to squad', this );
					}
				}
				else
				{
					// Escape from the ball
					this.eventSequence.addEscapeFromBall( this.battle.enemyMonContainer );
					
					// Burst open the ball
					this.eventSequence.addPlayBallAnim( new TinyBallFXAnimation( TinyBallFXAnimation.BALL_PHASE_BURST, isUltra ) );
					
					// Show "almost" message
					this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBallWobbleString( this.numWobbles ) );
				}
			}
			else
			{
				// Can't capture trainer mons, so reject the ball throw
				this.eventSequence.addPlayBallAnim( new TinyBallFXAnimation( TinyBallFXAnimation.BALL_PHASE_REJECT, isUltra ) );
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.BALL_THROW_REJECT );
			}
		}
		
		
		/**
		 * Function which handles the sequencing of items which restore HP to the current mon.
		 */
		private function healHP() : void
		{
			TinyLogManager.log('healHP: ' + this.item.effectAmount, this );
			
			// Add delay for nice feels
			this.eventSequence.addDelay( 0.2 );
			
			// Play mon bounce animation
			this.playHealAnimation();
			
			// Recover HP
			this.mon.recoverHP( this.item.effectAmount );
			
			// Add delay for nice feels
			this.eventSequence.addDelay( 0.2 ); 
			
			// Update HP display
			this.eventSequence.addUpdateHPDisplay( this.mon.currentHP, this.battle.playerStatDisplay );
			
			// Show dialog box
			if ( this.mon.isMaxHP ) {
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.HP_FULL, this.mon ) );
			} else {
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.REGAINED_HEALTH, this.mon ) );
			}
		}
		
		
		/**
		 * Function which handles the sequencing of items which restore PP to a single move.
		 * The specific move is given in the constructor and is set as a parameter.
		 */
		private function healPP() : void
		{
			TinyLogManager.log('healPP: ' + this.item.effectAmount, this );
			
			// Add delay for nice feels
			this.eventSequence.addDelay( 0.2 );
			
			// Play mon bounce animation
			this.playHealAnimation();
			
			// Recover PP
			this.move.recoverPP( this.item.effectAmount );
			
			// Add delay for nice feels
			this.eventSequence.addDelay( 0.2 ); 
			
			// Show dialog box
			if ( this.move.isMaxPP ) {
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.PP_FULL, this.mon, null, this.move ) );
			} else {
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.REGAINED_PP, this.mon, null, this.move ) );
			}
		}
		
		
		/**
		 * Function which handles the sequencing of items that resolve one or more of the the four core 
		 * status effects: burn, paralysis, poison, and sleep.
		 */
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
				this.mon.isParalyzed = false;
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
			this.eventSequence.addUpdateHPDisplay( this.mon.currentHP, this.battle.playerStatDisplay );
			
			// Show dialog box
			this.eventSequence.addDialogBoxFromString( healStatusString );
		}
		
		
		private function playHealAnimation() : void
		{
			// Play the "used item" sound
			this.eventSequence.addPlaySound( new SFXUseItem() as Sound );
			
			// Play the jumpy heal animation
			this.eventSequence.addPlayerHeal( this.battle.playerMonContainer );
		}
	}
}
