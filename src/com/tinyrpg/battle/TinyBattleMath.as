package com.tinyrpg.battle 
{
	import com.tinyrpg.data.TinyMoveEffect;
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.data.TinyStatSet;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;	

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleMath 
	{
		public static const PRE_ATTACK_RESULT_PASSED : String = 'PRE_ATTACK_RESULT_PASSED';
		public static const PRE_ATTACK_RESULT_FAILED : String = 'PRE_ATTACK_RESULT_FAILED';
		public static const PRE_ATTACK_RESULT_CONFUSED : String = 'PRE_ATTACK_RESULT_CONFUSED';
		
		public static const CONFUSION_HIT_PROB 		: Number = 0.33;
		public static const PARALYSIS_SKIP_PROB 	: Number = 0.25;
		public static const POISON_DAMAGE_RATIO		: Number = 8.0;
		public static const BURN_DAMAGE_RATIO		: Number = 8.0;	
		public static const CRIT_MULTIPLIER 		: Number = 2.0;
		public static const SAME_TYPE_BONUS			: Number = 1.5;
		public static const MAX_CATCH_WOBBLES		: int = 4;
		
		
		public static function doesEnemyGoFirst( playerMon : TinyMon, playerMove : TinyMoveData, enemyMon : TinyMon, enemyMove : TinyMoveData ) : Boolean
		{
			// Attacks with higher priority go first
			if ( enemyMove.priority > playerMove.priority ) return true;
			if ( playerMove.priority > enemyMove.priority ) return false;
			
			// If attacks have the same priority, ties are broken using the Speed stat
			if ( enemyMove.priority == playerMove.priority ) 
			{
				if ( enemyMon.speed > playerMon.speed ) return true;
				if ( playerMon.speed > enemyMon.speed ) return false;
			}
			
			// If the Speed stats are tied, ties are broken at random 
			return Math.random() > 0.5; 
		}
		
		
		public static function doPreAttackChecks( targetMon : TinyMon, battleEvent : TinyBattleEventSequence ) : String 
		{
			TinyLogManager.log('doPreAttackChecks: ' + targetMon.name, TinyBattleMath);
			
			// Sleep check
			if (targetMon.isSleeping)
			{
				TinyLogManager.log('doPreAttackChecks: failed (asleep)', TinyBattleMath);
				
				// TODO: Play sleep effect animation
				
				// Show "fast asleep" dialog
				battleEvent.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.FAST_ASLEEP, targetMon ) );
				battleEvent.addEnd();
				return PRE_ATTACK_RESULT_FAILED;	
			}
			
			// Recharge check
			if (targetMon.isRecharging)
			{
				TinyLogManager.log('doPreAttackChecks: failed (recharging)', TinyBattleMath);
				
				// Show "must recharge" dialog
				battleEvent.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.RECHARGE, targetMon ) );
				battleEvent.addEnd();
				return PRE_ATTACK_RESULT_FAILED;	
			}
			
			// Flinch check
			if (targetMon.isFlinching)
			{
				TinyLogManager.log('doPreAttackChecks: failed (flinched)', TinyBattleMath);
				
				// Show "flinched" dialog
				battleEvent.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.FLINCHED, targetMon ) );
				battleEvent.addEnd();
				return PRE_ATTACK_RESULT_FAILED;	
			}
			
			// Confusion check
			if (targetMon.isConfused)
			{
				TinyLogManager.log('doPreAttackChecks: failed (confused)', TinyBattleMath);
				
				// TODO: Play confusion effect animation
				
				// Show "confused" dialog
				battleEvent.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.TOO_DRUNK, targetMon ) );
				
				// Special result for confusion, cause we need to check if we hurt ourselves
				return PRE_ATTACK_RESULT_CONFUSED;
			}
			
			// Paralysis check (25% to lose turn)
			if (targetMon.isParaylzed && Math.random() < PARALYSIS_SKIP_PROB)
			{
				TinyLogManager.log('doPreAttackChecks: failed (paralyzed)', TinyBattleMath);
				
				// TODO: Play paralysis effect animation
				
				// Show "paralyzed" dialog
				battleEvent.addDialogBoxFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.IS_PARALYZED_2, targetMon ) );
				battleEvent.addEnd();	
				return PRE_ATTACK_RESULT_FAILED;
			}
			
			TinyLogManager.log('doPreAttackChecks: passed', TinyBattleMath);
			return PRE_ATTACK_RESULT_PASSED;
		}
		
		
		public static function checkAccuracy( attackingMon : TinyMon, defendingMon : TinyMon, move : TinyMoveData, isSecondaryEffect : Boolean = false ) : Boolean
		{			
			var accuracyValue : int = isSecondaryEffect ? move.effectAccuracy : move.accuracy;
			
			// Moves with an accuracy of 0 or the ALWAYS_HIT effect automatically pass
			if ( accuracyValue == 0 || move.hasEffect( TinyMoveEffect.ALWAYS_HIT ) ) 
			{
				TinyLogManager.log('checkAccuracy: passed (always hit)', TinyBattleMath);
				return true;
			}
			
			// Attacker's accuracy stat stage is subtracted by defender's evasiveness stat stage
			var modifiedAccuracyStage : int = move.targetsSelf ? attackingMon.accuracyModStage : attackingMon.accuracyModStage - defendingMon.evasivenessModStage;
			
			// Clamp to -6, +6
			modifiedAccuracyStage = Math.min(Math.max(modifiedAccuracyStage, -6), 6);
			
			// Get accuracy multipler from table
			var accuracyMultiplier : Number = 1.0;
			switch (modifiedAccuracyStage)
			{
				case -6: accuracyMultiplier = 0.33; break;
				case -5: accuracyMultiplier = 0.36; break;
				case -4: accuracyMultiplier = 0.43; break;
				case -3: accuracyMultiplier = 0.50; break;
				case -2: accuracyMultiplier = 0.60; break;
				case -1: accuracyMultiplier = 0.75; break;
				case  1: accuracyMultiplier = 1.33; break;
				case  2: accuracyMultiplier = 1.66; break;
				case  3: accuracyMultiplier = 2.00; break;
				case  4: accuracyMultiplier = 2.50; break;
				case  5: accuracyMultiplier = 2.66; break;
				case  6: accuracyMultiplier = 3.00; break;
			}
			
			var finalAccuracy : Number = accuracyValue * accuracyMultiplier; 
			
			// If a random int from 1 - 100 is <= accurracy, attack passes
			var result : Boolean = TinyMath.random(1, 100) <= finalAccuracy;  
			
			TinyLogManager.log('checkAccuracy: ' + (result ? 'passed' : 'failed') + ', ' + finalAccuracy, TinyBattleMath);
			return result;
		}

			
		public static function calculateDamage( attackingMon : TinyMon, defendingMon : TinyMon, move : TinyMoveData, isCrit : Boolean ) : int 
		{
			// Initial damage variables
			var L  : int = attackingMon.level;
			var P  : int = move.basePower;
			var A  : int = move.type.isPhysical ? attackingMon.attack : attackingMon.spAttack;
			var Am : int = move.type.isPhysical ? attackingMon.battleModStatSet.attack : attackingMon.battleModStatSet.spAttack;
			var D  : int = move.type.isPhysical ? defendingMon.defense : defendingMon.spDefense;
			var Dm : int = move.type.isPhysical ? defendingMon.battleModStatSet.defense : defendingMon.battleModStatSet.spDefense;
			
			// TODO: If Mud Sport is active, do power mod
			// TODO: If Water Sport is active, do power mod 
			
			// EXPLOSION: target's defense is halved
			if ( move.hasEffect( TinyMoveEffect.EXPLOSION ) ) D = D / 2;
			
			// If attack is a crit, clamp stat stages
			if (isCrit) 
			{
				Am = Math.max(0, Am);
				Dm = Math.min(0, Dm);
			}
			
			// Multiply by stat stages
			A = Math.floor( A * TinyStatSet.getStatStageMultiplier( Am ) );
			D = Math.floor( D * TinyStatSet.getStatStageMultiplier( Dm ) );
			 
			// Calculate initial damage
			var damage : Number = Math.floor( Math.floor( Math.floor( 2 * L / 5 + 2 ) * A * P / D ) / 50 );
			
			// If the attacker is burned, damage is halved
			damage /= attackingMon.isBurned ? 2 : 1;
			
			// If the attack is physical, min damage value is 1
			if (move.type.isPhysical) damage = Math.max(1, damage);
			
			// Add two, just because
			damage += 2;
			
			// Apply crit multiplier
			damage *= isCrit ? CRIT_MULTIPLIER : 1;
			
			// TODO: Apply any particular move damage multiplier 
			
			// Apply same-type bonus
			if (move.type.name == attackingMon.type1.name || move.type.name == attackingMon.type2.name) 
			{
				TinyLogManager.log('calculateDamage: same-type bonus!', TinyBattleMath);
				damage *= SAME_TYPE_BONUS;	
			}
			
			// Multiply by type matchup value for defender's types
			var type1Multiplier : Number = move.type.getMatchupValueVersus( defendingMon.type1 );
			var type2Multiplier : Number = move.type.getMatchupValueVersus( defendingMon.type2 );
			damage *= type1Multiplier;
			
			// If defender has a second type, multiply by second type matchup value
			if ( defendingMon.type2.name != defendingMon.type1.name ) damage *= type2Multiplier;
			
			// Apply damage variance
			damage *= TinyMath.randomInt( 85, 100 );
			damage = Math.floor( damage / 100.0 );
			damage = Math.max( 1, damage );
			
			TinyLogManager.log('calculateDamage:  L = ' + L, TinyBattleMath);
			TinyLogManager.log('calculateDamage:  P = ' + P, TinyBattleMath);
			TinyLogManager.log('calculateDamage:  A = ' + A, TinyBattleMath);
			TinyLogManager.log('calculateDamage:  D = ' + D, TinyBattleMath);
			TinyLogManager.log('calculateDamage: T1 = ' + type1Multiplier, TinyBattleMath);
			TinyLogManager.log('calculateDamage: T2 = ' + type2Multiplier, TinyBattleMath);
			TinyLogManager.log('calculateDamage: DAMAGE = ' + damage, TinyBattleMath);
			
			return damage;	
		}
		
		
		public static function canRun( targetTrainer : TinyTrainer, trainerMon : TinyMon, targetMon : TinyMon ) : Boolean
		{	
			// If the trainer's mon's speed is greater than or equal to the target's speed, running is automatically successful. 
			// Otherwise, do some math to calculate whether or not the run is successful.  
			if ( trainerMon.speed >= targetMon.speed ) return true;

			var A : int = trainerMon.speed;
			var B : int = targetMon.speed;
			var C : int = targetTrainer.runAttempts;
			var X : int = ( Math.floor( A * 128 / Math.min( 1, B ) ) + (30 * C) ) % 256;
			var R : int = TinyMath.randomInt( 0, 255 );

			return R < X;
		}
		
		
		public static function getEarnedExp( defeatedMon : TinyMon, numMonsUsedInBattle : int, isWildEncounter : Boolean ) : int
		{
			var L : int = defeatedMon.level;
			var G : int = defeatedMon.baseExp;
			var S : int = numMonsUsedInBattle;
			var X : Number = isWildEncounter ? 1.0 : 1.5;
			
			return Math.floor(Math.max( 1, L * G / ( 7 * S ) ) * X );
		}
		
		
		public static function getNumCaptureWobbles( targetMon : TinyMon, ballBonus : Number = 1.0 ) : int
		{
			var M : int = targetMon.maxHP;
			var H : int = targetMon.currentHP;
			var C : int = targetMon.catchRate;
			var B : Number = ballBonus;
			var S : Number = 1.0;
			
			// Get status modifier
			if ( targetMon.isSleeping ) S = 2.0;
			if ( targetMon.isPoisoned ) S = 1.5;
			if ( targetMon.isParaylzed ) S = 1.5;
			if ( targetMon.isBurned ) S = 1.5;
			
			var X : Number = Math.max( ( 3 * M - 2 * H ) * ( C * B ) / ( 3 * M ), 1 ) * S;
			
			if ( X >= 255 ) return MAX_CATCH_WOBBLES;
			
			var Y : Number = X / 255.0;
			var wobbles : int = 0;
			 
			while ( wobbles < MAX_CATCH_WOBBLES )
			{
				wobbles++;
				var N : Number = Math.random();
				if ( N >= Y ) break;
			}
			
			return wobbles;
		}
	}
}