package com.tinyrpg.battle 
{		
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyMoveData;	
	import com.tinyrpg.data.TinyMoveEffect;
	import com.tinyrpg.data.TinyStatusEffect;
	import com.tinyrpg.data.TinyMoveEffectStatMod;
	import com.tinyrpg.display.TinyMonContainer;
	import com.tinyrpg.display.TinyStatusFXAnimation;
	import com.tinyrpg.display.TinyBattleMonStatDisplay;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleCommandMove extends TinyBattleCommand 
	{
		public static const RESULT_CONTINUE 		: String = 'RESULT_CONTINUE';
		public static const RESULT_PLAYER_FAINTED 	: String = 'RESULT_PLAYER_FAINTED';
		public static const RESULT_ENEMY_FAINTED 	: String = 'RESULT_ENEMY_FAINTED';
		public static const RESULT_BOTH_FAINTED 	: String = 'RESULT_BOTH_FAINTED';
		
		public var result : String = RESULT_CONTINUE;
		public var move : TinyMoveData;
		public var isFirstMoveCommand : Boolean = false;
		public var isSecondMoveCommand : Boolean = false;
		
		override public function get logString() : String
		{
			var resultString : String = 'nobody fainted';
			switch ( this.result ) 
			{
				case RESULT_PLAYER_FAINTED: resultString = 'PLAYER fainted.'; break;
				case RESULT_ENEMY_FAINTED: resultString = 'ENEMY fainted.'; break;
				case RESULT_BOTH_FAINTED: resultString = 'BOTH fainted.'; break;
			}
			
			return 'MOVE: ' + this.user + ' used ' + this.move.name + ' and ' + resultString;
		}


		public function TinyBattleCommandMove( battle : TinyBattleMon, user : String, move : TinyMoveData )
		{
			super( battle, TinyBattleCommand.COMMAND_MOVE, user );
			
			this.move = move;
			TinyLogManager.log('adding battle command: ' + this.logString, this);
		}
		

		public function determineResult() : void
		{
			// Get attacker and defender
			var attackingMon : TinyMon = this.isEnemy ? this.battle.m_currentEnemyMon : this.battle.m_currentPlayerMon;
			var defendingMon : TinyMon = this.isEnemy ? this.battle.m_currentPlayerMon : this.battle.m_currentEnemyMon;
			
			var attackerFainted : Boolean = false;
			var defenderFainted : Boolean = false;
			
			var attackerContainer : TinyMonContainer = this.isEnemy ? this.battle.m_enemyMonContainer : this.battle.m_playerMonContainer;
			var defenderContainer : TinyMonContainer = this.isEnemy ? this.battle.m_playerMonContainer : this.battle.m_enemyMonContainer;
			
			// If this is the enemy's turn, resolve any outstanding status effects here.
			// The player does this at the beginning of their turn before gaining control of the command menu, 
			// so the code for that is in the separate class TinyBattleCommandPlayerResolveStatus 
			if ( this.isEnemy )
			{
				// Decrement all status effect counters
				var statusesResolved : Object = this.battle.m_currentEnemyMon.decrementStatusCounters();

				// Add any applicable resolved dialogs
				if ( statusesResolved[ 'sleep' ] )	
					this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.WOKE_UP, this.battle.m_currentEnemyMon ) );
				if ( statusesResolved[ 'confusion' ] )
					this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.SOBERED_UP, this.battle.m_currentEnemyMon ) );
				if ( statusesResolved[ 'safeguard' ] )
					this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.SAFEGUARD_FADED, this.battle.m_currentEnemyMon ) );
			}
			
			// Display correct log message depending on target
			if ( move.targetsSelf )
				TinyLogManager.log(attackingMon.name + ' used ' + move.name + ' on itself.', this);
			else
				TinyLogManager.log(attackingMon.name + ' used ' + move.name + ' against ' + defendingMon.name + '.', this);
			
			// Do pre-attack checks
			var preAttackCheckResult : String = TinyBattleMath.doPreAttackChecks( attackingMon, this.eventSequence ); 
			
			// If the pre-attack checks fail, run the current battle event, then end the turn
			if ( preAttackCheckResult == TinyBattleMath.PRE_ATTACK_RESULT_FAILED || preAttackCheckResult == TinyBattleMath.PRE_ATTACK_RESULT_CONFUSED )
			{	
				// Confusion damage: 33% hit rate, as if mon attacks itself with a power 40 physical attack, no chance to crit
				if ( preAttackCheckResult == TinyBattleMath.PRE_ATTACK_RESULT_CONFUSED ) // && Math.random() < TinyBattleMath.CONFUSION_HIT_PROB )
				{
					// Calculate confusion damage using the special confusion attack					
					var confusionDamage : int = TinyBattleMath.calculateDamage( attackingMon, attackingMon, TinyMoveData.CONFUSION_ATTACK, false );
					
					// Play confusion effect animation
					this.eventSequence.addPlayStatusAnim( new TinyStatusFXAnimation( TinyStatusEffect.CONFUSION, isEnemy ) );
					
					// Apply damage
					this.applyDamageToTarget( attackingMon, confusionDamage, isEnemy );
					
					// Show "hurt itself" dialog
					this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.HURT_ITSELF, attackingMon ) );
					
					// Check if mon faints
					if ( !attackingMon.isHealthy )
					{
						// Faint mon
						this.playMonFaint( attackingMon, attackerContainer );
						attackerFainted = true;
						
						// If the enemy or player's mon fainted, use the correct callback when we finish the battle event, 
						// since whoever's mon fainted will need to switch.
						this.result = this.isEnemy ? RESULT_ENEMY_FAINTED : RESULT_PLAYER_FAINTED;
					} 
				}
				
				// Attack missed, so we're done
				result = RESULT_CONTINUE;
				return;
			}
			
			// Mark attacking mon as participating in the battle
			attackingMon.usedInBattle = true;
			
			// Successfully passed pre-attack checks. Deduct 1 PP.
			move.deductPP( 1 );
			
			var isCrit : Boolean = false;
			var isOneHitKO : Boolean = false;
			var damage : int = 0;
			var numHits : int = move.numHits;
			var numSuccessfulHits : int = 0;
			
			// Apply any move effect modifiers to the number of hits
			numHits = move.applyNumHitsModEffect();
			
			// For each hit, do an accuracy check, play the attack animation, deal damage, and show any damage-related dialog boxes
			if ( move.hasEffect( TinyMoveEffect.HIT ) )
			{
				for ( var i : int = 0; i < numHits; i++ ) 
				{		
					// Reset total damage counter
					damage = 0;
					
					// If the accuracy check fails, show the "missed" dialog box and exit. Moves with the ALWAYS_HIT effect bypass the accuracy check.
					if ( !TinyBattleMath.checkAccuracy( attackingMon, defendingMon, move ) && !move.hasEffect( TinyMoveEffect.ALWAYS_HIT ) )
					{
						this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.MISSED, attackingMon ) );
						this.eventSequence.addEnd();
						return;	
					}
					
					// Increment successful hits counter if there are multiple hits
					if ( numHits > 1 ) numSuccessfulHits++;
					
					// Attack hits. Show the "used move" dialog, but only for the first 
					if (i == 0) {
						this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.USED_MOVE, attackingMon, null, move ) );
					}
					
					// Attack hits. Is it a crit?
					var critMoveModifier : int = move.hasEffect( TinyMoveEffect.HIGH_CRITICAL ) ? 0 : 1;
					isCrit = Math.random() < attackingMon.getCritChance( critMoveModifier ) && move.numHits <= 1;
					
					// Calculate damage
					damage = TinyBattleMath.calculateDamage( attackingMon, defendingMon, move, isCrit );
					
					// Apply any move effect modifiers to the damage
					damage = move.applyDamageModEffect( damage, attackingMon, defendingMon );
					
					// Attack deals damage, is it a one-hit KO?
					isOneHitKO = defendingMon.currentHP == defendingMon.maxHP && damage >= defendingMon.currentHP && move.numHits <= 1;
					
					// Play attack animation
					this.playAttackAnimation( attackingMon, move, isEnemy );
										
					// Apply damage
					this.applyDamageToTarget( defendingMon, damage, !isEnemy );
					
					// Show crit dialog, if applicable
					if ( isCrit && move.hasEffect( TinyMoveEffect.HIT ) ) 
					{
						TinyLogManager.log('it\'s a crit!', this);
						this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.CRIT ) );
					}
					
					// Show one-hit-KO dialog, if applicable
					if ( isOneHitKO )
					{
						TinyLogManager.log('it\'s a one-hit KO!', this);
						this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.ONE_HIT_KO ) );	
					}
					
					// Show effectiveness dialog, if applicable
					if ( move.numHits <= 1 && move.hasEffect( TinyMoveEffect.HIT ) )
					{
						if ( move.isSuperEffectiveVs( [defendingMon.type1, defendingMon.type2] ) )
							this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.SUPER_EFFECTIVE ) );
						else if ( move.isNotEffectiveVs( [defendingMon.type1, defendingMon.type2 ] ) )
							this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.NOT_EFFECTIVE ) );
					}
					
					// If defending mon is dead, don't do any more attacks
					if ( !defendingMon.isHealthy )
					{
						defenderFainted = true;
						break;
					}
				}
			}
			
			// Show num hits dialog, if applicable
			if ( numSuccessfulHits > 1 ) {
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.HIT_MULTI, null, null, null, null, numSuccessfulHits ) );
			}
			
			// If target defeated, faint
			if ( defenderFainted )
			{
		 		this.playMonFaint( defendingMon, defenderContainer );
			}
			
			// Apply recoil, if applicable
			if ( move.hasEffect( TinyMoveEffect.RECOIL ) )
			{
				TinyLogManager.log('applying RECOIL effect', this);
				
				var recoilDamage : int = Math.ceil( damage / 4 );
				
				// Apply damage
				this.applyDamageToTarget( attackingMon, recoilDamage, isEnemy );
				
				// Show recoil dialog box
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.RECOIL, attackingMon ) );
				
				// If attacking mon is dead, faint
				if ( !attackingMon.isHealthy )
				{
					this.playMonFaint( attackingMon, attackerContainer );
					attackerFainted = true;
				}
			}
			
			// Apply additional move effects if target doesn't faint (or if the move targets the user)
			if ( !defenderFainted || move.targetsSelf )
			{
				TinyLogManager.log('defender hasn\'t fainted, do secondary effects.', this);
				
				// Get any stat or status changing effects
				var statModEffects : Array = move.getStatModEffects();
				var statusChangeEffects : Array = move.getStatusEffects();
				var allSecondaryEffects : Array = statModEffects.concat( statusChangeEffects ); 
				var wasHitAttack : Boolean = move.hasEffect( TinyMoveEffect.HIT );
				var affectedMon : TinyMon = move.targetsSelf ? attackingMon : defendingMon;
				var isFirstEffect : Boolean = true;
				
				TinyLogManager.log('move affects ' + (move.targetsSelf ? 'self' : 'enemy'), this);
				
				// Apply any stat mod effects and show associated dialog boxes
				for each ( var effect : TinyMoveEffect in allSecondaryEffects )
				{	
					// Do accuracy check using secondary effect accuracy value				
					if ( !TinyBattleMath.checkAccuracy( attackingMon, defendingMon, move, true ) )
					{
						// Attacks that don't make any hits have a special miss dialog, and the turn ends immediately
 						if ( !wasHitAttack )
						{
							this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.NOTHING_HAPPENED, attackingMon ) );
							this.eventSequence.addEnd();
							return;
						}
					}
					else
					{
						// Some attacks have no physical hits and thus skip all the events above. 
						// In this case, the "used move" text and attack animation still needs to be played.
						if ( !wasHitAttack && isFirstEffect ) 
						{
							TinyLogManager.log('secondary-only attack, so play the attack animation.', this);
							
							// Show "used move" dialog text
							this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.USED_MOVE, attackingMon, null, move ) );
							
							// Play attack animation (only once)
							this.playAttackAnimation( attackingMon, move, isEnemy );
						}
						
						var effectDialogString : String = '';
						var effectSucceeded : Boolean = true;
						
						if ( effect.type == 'STAT_MOD' )
						{
							var effectProperties : TinyMoveEffectStatMod = effect.property as TinyMoveEffectStatMod;
							
							// Success, try to apply the stat change
							effectSucceeded = move.applyStatModEffect( affectedMon, effectProperties.effectedStat, effectProperties.numStages );

							// Get effect dialog string
							effectDialogString = TinyBattleStrings.getStatChangeString( affectedMon, effectProperties.effectedStat, effectProperties.numStages );
						}
						else if ( effect.type == 'STATUS_EFFECT' )
						{						
							// Success, try to apply the status effect
							effectSucceeded = move.applyStatusChangeEffect( affectedMon, effect.property as String );
						
							// Get effect dialog string
							effectDialogString = TinyBattleStrings.getStatusChangeString( affectedMon, effect.property as String, effectSucceeded ); 
						}
						
						// Play hit reaction if the effect succeeded (only once)
						if ( !move.targetsSelf && isFirstEffect && effectSucceeded )
						{
							this.eventSequence.addDelay( 0.2 );
							
							if ( this.isEnemy )
								this.eventSequence.addPlayerHitSecondary();
							else
								this.eventSequence.addEnemyHitSecondary( battle.m_enemyMonContainer );
							
							// TODO: Play the appropriate status effect animation, if applicable  	
							if ( effect.type == 'STATUS_EFFECT' )
							{
								if ( TinyStatusEffect.isAnimated( effect.property as String ) ) 
								{
									this.eventSequence.addPlayStatusAnim( new TinyStatusFXAnimation( effect.property as String, !isEnemy ) );
								}
							}
								
							this.eventSequence.addDelay( 0.2 );
						}
							
						// Add "but it didn't work" message if the effect did not succeed, but only for attacks that are secondary-effect only
						if ( !effectSucceeded && !wasHitAttack && isFirstEffect ) 
						{
							this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.FAILED ) );							
						}
						
						// Show effect dialog, if the string is set
						if ( effectDialogString.length > 0 ) this.eventSequence.addDialogBoxFromString( effectDialogString );	
						
					} // end else
					
					isFirstEffect = false;
					
				} // end for each
				
			} // end if
			
			// If the move has the Explosion effect, the user faints
			if ( move.hasEffect( TinyMoveEffect.EXPLOSION ) )
			{
				TinyLogManager.log("applying EXPLOSION effect damage", this);
				
				var explosionDamage : int = attackingMon.maxHP;
				
				// Apply damage
				this.applyDamageToTarget( attackingMon, explosionDamage, isEnemy );
				
				// Faint
				this.playMonFaint( attackingMon, attackerContainer );
				attackerFainted = true;
			}
			
			// Apply poison damage
			if ( attackingMon.isPoisoned && !attackerFainted )
			{
				TinyLogManager.log('applying POISON damage', this);	
				
				// Play poison effect animation
				this.eventSequence.addPlayStatusAnim( new TinyStatusFXAnimation( TinyStatusEffect.POISON, isEnemy ) );
				
				var poisonDamage : int = Math.floor( Number(attackingMon.maxHP) / TinyBattleMath.POISON_DAMAGE_RATIO );
				
				// Show "hurt by poison" dialog
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.POISON_HURT, attackingMon ) );
				
				// Apply damage
				this.applyDamageToTarget( attackingMon, poisonDamage, isEnemy );
				
				// Faint if mon is out of HP
				if ( !attackingMon.isHealthy )
				{
					this.playMonFaint( attackingMon, attackerContainer );
					attackerFainted = true;
				}
			}
			
			// Apply burn damage
			if ( attackingMon.isBurned && !attackerFainted )
			{
				TinyLogManager.log('applying BURN damage', this);
				
				// Play burn effect animation
				this.eventSequence.addPlayStatusAnim( new TinyStatusFXAnimation( TinyStatusEffect.BURN, isEnemy ) );
				
				var burnDamage : int = Math.floor( Number(attackingMon.maxHP) / TinyBattleMath.BURN_DAMAGE_RATIO );
				
				// Show "hurt by burn" dialog
				this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.BURN_HURT, attackingMon ) );
				
				// Apply damage
				this.applyDamageToTarget( attackingMon, burnDamage, isEnemy );
				
				// Faint if mon is out of HP	
				if ( !attackingMon.isHealthy )
				{
					this.playMonFaint( attackingMon, attackerContainer );
					attackerFainted = true;
				}
			}

			// Give correct results flag, depending on who faints
			if ( attackerFainted && !defenderFainted ) 
			{ 
				if ( isEnemy ) { // Attacker fainted and attacker is enemy
					result = RESULT_ENEMY_FAINTED; 
				} else {		 // Attacker fained and attacker is player
					result = RESULT_PLAYER_FAINTED;
				}
			}
			else if ( defenderFainted && !attackerFainted )
			{
				if ( isEnemy ) { // Defender fainted and defender is player
					result = RESULT_PLAYER_FAINTED;
				} else {		 // Defender fainted and defender is enemy
					result = RESULT_ENEMY_FAINTED;
				}		
			}
			else if ( attackerFainted && defenderFainted )
			{			
				// Both mons fainted
				result = RESULT_BOTH_FAINTED;
			}
			
			// If the defending mon fainted, distribute Exp to all mons who participated (this only applies to the player)
			if ( defenderFainted && !isEnemy ) 
			{
				var participatingMons : Array = [];
				var mon : TinyMon;
				
				// Tally up the number of mons used in the battle, then clear the "used in battle" flag, 
				// since that only matters when calculating exp against the current defeated mon 
				for each ( mon in this.battle.m_testPlayerTrainer.squad ) 
				{
					if ( mon.usedInBattle ) 
					{
						// Only healthy mons are counted as having participated
						if ( mon.isHealthy )
						{
							participatingMons.push( mon );
						}
							
						mon.usedInBattle = false;
					}
				}
				
				var earnedExp : int = TinyBattleMath.getEarnedExp( defendingMon, participatingMons.length, this.battle.m_isWildEncounter );
				
				// Distribute exp to each participating mon
				for each ( mon in participatingMons )
				{
					// Add exp
					var levelUpInfo : TinyLevelUpInfo = mon.addExp( earnedExp );
					
					// Add EVs
					mon.addEVs( defendingMon );
					TinyLogManager.log('new EVs - ' + mon.name + ':', this);
					mon.evStatSet.log();
					
					// Deal with level up stuff if there is any. The EXP will be updated by these events, 
					// so only update it here if there are no levelups  
					if ( levelUpInfo )
					{
						TinyLevelUpSequencer.generateLevelUpSequence( this.battle, this.eventSequence, levelUpInfo );
					}
					else 
					{
						// Show "exp earned" dialog
						this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.GAIN_EXP_POINTS, mon, null, null, null, earnedExp ) );
						
						// Update the EXP bar
						this.eventSequence.addUpdateEXPDisplay( this.battle.m_playerStatDisplay );	
					}
				}
			}
			
			// Finished
			this.eventSequence.addEnd();
			TinyLogManager.log('result: ' + this.result, this);
		}
		
		
		override public function execute() : void
		{
			this.determineResult();
			super.execute();
		}
		
		
		override public function getNextCommands() : Array
		{
			var startTurnCommand : TinyBattleCommand;
			var forcePlayerSwitchCommand : TinyBattleCommand;
			var nextEnemyMon : TinyMon = this.battle.m_enemyTrainer.getFirstHealthyMon();
			
			switch ( this.result )
			{
				case RESULT_CONTINUE:
				{
					TinyLogManager.log('getNextCommands: none - RESULT_CONTINIUE, no additional commands required', this);
					return [];
				}
					
				case RESULT_PLAYER_FAINTED:
				{
					if ( this.battle.m_testPlayerTrainer.hasAnyHealthyMons() )
					{
						TinyLogManager.log('getNextCommands: RESULT_PLAYER_FAINTED, force player switch, then start the next turn', this);
						
						forcePlayerSwitchCommand = TinyBattleCommand.getForcePlayerSwitchCommand( this.battle );
						startTurnCommand = TinyBattleCommand.getStartTurnCommand( this.battle );
						return [ forcePlayerSwitchCommand, startTurnCommand ];
					}
					else 
					{
						TinyLogManager.log('getNextCommands: RESULT_PLAYER_FAINTED, no remaining player mons, player loss', this);
						return [ TinyBattleCommand.getPlayerLossCommand( this.battle ) ];
					}
				}
				
				case RESULT_ENEMY_FAINTED:
				{
					if ( nextEnemyMon ) 
					{
						TinyLogManager.log('getNextCommands: RESULT_ENEMY_FAINTED, force enemy switch, then start the next turn', this);
						
						startTurnCommand = TinyBattleCommand.getStartTurnCommand( this.battle );
						return [ new TinyBattleCommandSwitch( this.battle, TinyBattleCommand.USER_ENEMY, nextEnemyMon ), startTurnCommand ];
					}
					else
					{
						TinyLogManager.log('getNextCommands: RESULT_ENEMY_FAINTED, no remaining enemy mons, player victory', this); 
						return [ new TinyBattleCommandPlayerVictory( this.battle ) ];
					}
				}
				
				case RESULT_BOTH_FAINTED:
				{
					// If player has any remaining mons, force them to switch. If not, player loses
					if ( this.battle.m_testPlayerTrainer.hasAnyHealthyMons() )
					{	
						// If enemy has no remaining mons, player wins
						if ( !nextEnemyMon )
						{
							TinyLogManager.log('getNextCommands: RESULT_BOTH_FAINTED, no remaining enemy mons, player victory', this);
							return [ new TinyBattleCommandPlayerVictory( this.battle ) ];		
						}
						
						TinyLogManager.log('getNextCommands: RESULT_BOTH_FAINTED, player switches, then enemy switches, then start the next turn', this);
						
						var commandArray : Array = [];
						commandArray.push( TinyBattleCommand.getForcePlayerSwitchCommand( this.battle ) );
						commandArray.push( new TinyBattleCommandSwitch( this.battle, TinyBattleCommand.USER_ENEMY, nextEnemyMon ) );
						commandArray.push( TinyBattleCommand.getStartTurnCommand( this.battle ) );
						return commandArray;
					}
					else 
					{
						TinyLogManager.log('getNextCommands: RESULT_BOTH_FAINTED, no remaining player mons, player loses', this);
						return [ TinyBattleCommand.getPlayerLossCommand( this.battle ) ];	
					}
				}					
			} // end switch
			
			return [];
		}
		
		
		private function playAttackAnimation( attackingMon : TinyMon, move : TinyMoveData, isEnemy : Boolean ) : void
		{
			TinyLogManager.log('playAttackAnimation: ' + attackingMon.name + ' - ' + move.name, this);
			
			// Hitting attacks have a little "nudge" attack animation from the attacking mon
			if ( move.hasEffect( TinyMoveEffect.HIT ) ) 
			{
				this.eventSequence.addDelay( 0.2 );
				
				if (isEnemy)
					this.eventSequence.addEnemyAttack( this.battle.m_enemyMonContainer );
				else 
					this.eventSequence.addPlayerAttack( this.battle.m_playerMonContainer );				
			}
			else
			{
				this.eventSequence.addDelay( 0.2 );
			}
			
			// Play attack animation sequence
			this.eventSequence.addPlayAttackAnim( move.moveFXSAnimation );

			// Delay for good feels
			this.eventSequence.addDelay( 0.2 );
		}


		private function playMonFaint( faintedMon : TinyMon, targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('playMonFaint', this);
			 
			this.eventSequence.addDelay( 0.2 );
			this.eventSequence.addFaintMon( targetMonContainer );
			this.eventSequence.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.FAINTED, faintedMon ) );
			this.eventSequence.addDelay( 0.2 );
		}


		private function applyDamageToTarget( targetMon : TinyMon, damage : int, isEnemy : Boolean ) : void
		{
			TinyLogManager.log('applyDamageToTarget: ' + targetMon.name + ' - ' + damage + ' points', this);
			
			// Deal damage
			targetMon.dealDamage( damage );
			
			// Add delay for nice feels
			this.eventSequence.addDelay( 0.2 );
			
			// Play damage shake animaton and sound
			if ( isEnemy ) {
				this.eventSequence.addEnemyHitDamage( this.battle.m_enemyMonContainer );
			} else {
				this.eventSequence.addPlayerHitDamage();
			}
			
			// Add delay for nice feels
			this.eventSequence.addDelay( 0.2 ); 
			
			// Update HP display
			var targetStatDisplay : TinyBattleMonStatDisplay = isEnemy ? this.battle.m_enemyStatDisplay : this.battle.m_playerStatDisplay;
			this.eventSequence.addUpdateHPDisplay( targetStatDisplay );
		}
	}
}
