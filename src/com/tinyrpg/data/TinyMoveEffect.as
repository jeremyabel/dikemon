package com.tinyrpg.data 
{
	/**
	 * Class which represents a special effect added to a move.
	 * 
	 * These effects can modify a mon's stats, cause status effects, or
	 * do various other special things.
	 * 
	 * @author jeremyabel
	 */
	public class TinyMoveEffect 
	{
		public static const HIT					: TinyMoveEffect = new TinyMoveEffect( 'HIT' );
		public static const HEAL_STATUS			: TinyMoveEffect = new TinyMoveEffect( 'HEAL_STATUS' );
		public static const ALWAYS_HIT			: TinyMoveEffect = new TinyMoveEffect( 'ALWAYS_HIT' );
		public static const RECOIL				: TinyMoveEffect = new TinyMoveEffect( 'RECOIL' );
		public static const EXPLOSION			: TinyMoveEffect = new TinyMoveEffect( 'EXPLOSION' );
		public static const MULTI_HIT			: TinyMoveEffect = new TinyMoveEffect( 'MULTI_HIT' );
		public static const DOUBLE_HIT			: TinyMoveEffect = new TinyMoveEffect( 'DOUBLE_HIT' );
		public static const FALSE_SWIPE			: TinyMoveEffect = new TinyMoveEffect( 'FALSE_SWIPE' );
		public static const PSYWAVE				: TinyMoveEffect = new TinyMoveEffect( 'PSYWAVE' );
		public static const LOW_KICK			: TinyMoveEffect = new TinyMoveEffect( 'LOW_KICK' );
		public static const HIGH_CRITICAL		: TinyMoveEffect = new TinyMoveEffect( 'HIGH_CRITICAL' );
		public static const USELESS_TEXT		: TinyMoveEffect = new TinyMoveEffect( 'USELESS_TEXT' );
		public static const ABSORB				: TinyMoveEffect = new TinyMoveEffect( 'ABSORB' );
		public static const FAKE_OUT			: TinyMoveEffect = new TinyMoveEffect( 'FAKE_OUT' );
		public static const DREAM_EATER			: TinyMoveEffect = new TinyMoveEffect( 'DREAM_EATER' );
		public static const HEAL_BELL			: TinyMoveEffect = new TinyMoveEffect( 'HEAL_BELL' );
		public static const METRONOME			: TinyMoveEffect = new TinyMoveEffect( 'METRONOME' );
		public static const PROTECT				: TinyMoveEffect = new TinyMoveEffect( 'PROTECT' );
		public static const QUICK_ATTACK		: TinyMoveEffect = new TinyMoveEffect( 'QUICK_ATTACK' );
		public static const RECHARGE			: TinyMoveEffect = new TinyMoveEffect( 'RECHARGE' );
		public static const REFRESH				: TinyMoveEffect = new TinyMoveEffect( 'REFRESH' );
		public static const REST				: TinyMoveEffect = new TinyMoveEffect( 'REST' );
		public static const RESTORE_HP			: TinyMoveEffect = new TinyMoveEffect( 'RESTORE_HP' );
		public static const SNORE				: TinyMoveEffect = new TinyMoveEffect( 'SNORE' );
		public static const SPITE				: TinyMoveEffect = new TinyMoveEffect( 'SPITE' );
		public static const WISH				: TinyMoveEffect = new TinyMoveEffect( 'WISH' );
		
		public static const CRIT_CHANCE_UP		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_CRIT_CHANCE, +1 ) );
		public static const CRIT_CHANCE_UP_2	: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_CRIT_CHANCE, +2 ) );
		public static const CRIT_CHANCE_DOWN	: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_CRIT_CHANCE, -1 ) );
		public static const CRIT_CHANCE_DOWN_2	: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_CRIT_CHANCE, -2 ) );
		
		public static const ACCURACY_UP			: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_ACCURACY, +1 ) );
		public static const ACCURACY_UP_2		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_ACCURACY, +2 ) );
		public static const ACCURACY_DOWN		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_ACCURACY, -1 ) );
		public static const ACCURACY_DOWN_2		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_ACCURACY, -2 ) );
		
		public static const EVASION_UP			: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_EVASION, +1 ) );
		public static const EVASION_UP_2		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_EVASION, +2 ) );
		public static const EVASION_DOWN		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_EVASION, -1 ) );
		public static const EVASION_DOWN_2		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_EVASION, -2 ) );
		
		public static const ATTACK_UP			: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_ATTACK, +1 ) );
		public static const ATTACK_UP_2			: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_ATTACK, +2 ) );
		public static const ATTACK_DOWN			: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_ATTACK, -1 ) );
		public static const ATTACK_DOWN_2		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_ATTACK, -2 ) );
		
		public static const DEFENSE_UP			: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_DEFENSE, +1 ) );
		public static const DEFENSE_UP_2		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_DEFENSE, +2 ) );
		public static const DEFENSE_DOWN		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_DEFENSE, -1 ) );
		public static const DEFENSE_DOWN_2		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_DEFENSE, -2 ) );
		
		public static const SP_ATTACK_UP		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_SP_ATTACK, +1 ) );
		public static const SP_ATTACK_UP_2		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_SP_ATTACK, +2 ) );
		public static const SP_ATTACK_DOWN		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_SP_ATTACK, -1 ) );
		public static const SP_ATTACK_DOWN_2	: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_SP_ATTACK, -2 ) );
		
		public static const SP_DEFENSE_UP		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_SP_DEFENSE, +1 ) );
		public static const SP_DEFENSE_UP_2		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_SP_DEFENSE, +2 ) );
		public static const SP_DEFENSE_DOWN		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_SP_DEFENSE, -1 ) );
		public static const SP_DEFENSE_DOWN_2	: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_SP_DEFENSE, -2 ) );
		
		public static const SPEED_UP			: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_SPEED, +1 ) );
		public static const SPEED_UP_2			: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_SPEED, +2 ) );
		public static const SPEED_DOWN			: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_SPEED, -1 ) );
		public static const SPEED_DOWN_2		: TinyMoveEffect = new TinyMoveEffect( 'STAT_MOD', new TinyMoveEffectStatMod( TinyStatSet.STAT_NAME_SPEED, -2 ) );
		
		public static const CONFUSE				: TinyMoveEffect = new TinyMoveEffect( 'STATUS_EFFECT',	TinyStatusEffect.CONFUSION );
		public static const POISON				: TinyMoveEffect = new TinyMoveEffect( 'STATUS_EFFECT', TinyStatusEffect.POISON );
		public static const PARALYZE			: TinyMoveEffect = new TinyMoveEffect( 'STATUS_EFFECT',	TinyStatusEffect.PARALYSIS );
		public static const SLEEP 				: TinyMoveEffect = new TinyMoveEffect( 'STATUS_EFFECT',	TinyStatusEffect.SLEEP );
		public static const BURN				: TinyMoveEffect = new TinyMoveEffect( 'STATUS_EFFECT',	TinyStatusEffect.BURN );	
		public static const FLINCH 				: TinyMoveEffect = new TinyMoveEffect( 'STATUS_EFFECT',	TinyStatusEffect.FLINCH );
		public static const MEAN_LOOK			: TinyMoveEffect = new TinyMoveEffect( 'STATUS_EFFECT', TinyStatusEffect.MEAN_LOOK );
		public static const LOCK_ON				: TinyMoveEffect = new TinyMoveEffect( 'STATUS_EFFECT',	TinyStatusEffect.LOCK_ON ); 
		
		public var type : String;
		public var property : *;
		
		/**
		 * @param	type		The type of move effect.
		 * @param	property	The move effect's property, if it has one.
		 */
		public function TinyMoveEffect( type : String, property : * = null )
		{
			this.type = type;
			this.property = property;	
		}
		
		/**
		 * Array filter function which returns true if the move deals damage.
		 */
		public static function isDamageEffect( element : *, index : int, arr : Array ) : Boolean
		{
			index; arr;
			var moveEffect : TinyMoveEffect = element as TinyMoveEffect;
			
			switch ( moveEffect.type ) 
			{
				case HIT:				
				case ALWAYS_HIT:		
				case EXPLOSION:		
				case MULTI_HIT:		
				case DOUBLE_HIT:		
				case PSYWAVE:			
				case LOW_KICK:		
				case HIGH_CRITICAL:	
				case ABSORB:			
				case QUICK_ATTACK: return true;
				default: return false;
			}
		}
		
		/**
		 * Array filter function which returns true if the move type is STAT_MOD.
		 */
		public static function isStatModEffect( element : *, index : int, arr : Array ) : Boolean
		{
			index; arr;
			var moveEffect : TinyMoveEffect = element as TinyMoveEffect;
			return moveEffect.type == 'STAT_MOD';
		}
		
		/**
		 * Array filter function which returns true if the move type is STATUS_EFFECT.
		 */
		public static function isStatusEffect( element : *, index : int, arr : Array ) : Boolean
		{
			index; arr;
			var moveEffect : TinyMoveEffect = element as TinyMoveEffect;
			return moveEffect.type == 'STATUS_EFFECT';
		}
		
		/**
		 * Array filter function which returns true if the move type is USELESS_TEXT.
		 */
		public static function isMiscEffect( element : *, index : int, arr : Array ) : Boolean
		{
			index; arr;
			var moveEffect : TinyMoveEffect = element as TinyMoveEffect;
			return moveEffect.type == 'USELESS_TEXT';
		}
		
		/**
		 * Returns the TinyMoveEffect with a given name. Returns null if none is found.
		 */
		public static function getEffectByName( name : String ) : TinyMoveEffect
		{
			switch ( name.toUpperCase() )
			{
				case 'HIT': 				return HIT;
				case 'ALWAYS_HIT':			return ALWAYS_HIT;
				case 'RECOIL': 				return RECOIL;
				case 'EXPLOSION': 			return EXPLOSION;
				case 'MULTI_HIT':			return MULTI_HIT;
				case 'DOUBLE_HIT':			return DOUBLE_HIT;
				case 'FALSE_SWIPE':			return FALSE_SWIPE;
				case 'PSYWAVE':				return PSYWAVE;
				case 'LOW_KICK':			return LOW_KICK;
				case 'HIGH_CRITICAL':		return HIGH_CRITICAL;
				case 'USELESS_TEXT':		return USELESS_TEXT;
				case 'ABSORB':				return ABSORB;
				case 'DREAM_EATER':			return DREAM_EATER;
				case 'FAKE_OUT':			return FAKE_OUT;
				case 'HEAL_BELL':			return HEAL_BELL;
				case 'METRONOME':			return METRONOME;
				case 'PROTECT':				return PROTECT;
				case 'QUICK_ATTACK':		return QUICK_ATTACK;
				case 'REFRESH':				return REFRESH;
				case 'REST':				return REST;
				case 'RESTORE_HP':			return RESTORE_HP;
				case 'SNORE':				return SNORE;
				case 'SPITE':				return SPITE;
				case 'WISH':				return WISH;
				
				case 'CRIT_CHANCE_UP': 		return CRIT_CHANCE_UP;
				case 'CRIT_CHANCE_UP_2': 	return CRIT_CHANCE_UP_2;
				case 'CRIT_CHANCE_DOWN': 	return CRIT_CHANCE_DOWN;
				case 'CRIT_CHANCE_DOWN_2': 	return CRIT_CHANCE_DOWN_2;
				
				case 'ACCURACY_UP': 		return ACCURACY_UP;
				case 'ACCURACY_UP_2': 		return ACCURACY_UP_2;
				case 'ACCURACY_DOWN': 		return ACCURACY_DOWN;
				case 'ACCURACY_DOWN_2': 	return ACCURACY_DOWN_2;
				
				case 'EVASION_UP': 			return EVASION_UP;
				case 'EVASION_UP_2': 		return EVASION_UP_2;
				case 'EVASION_DOWN': 		return EVASION_DOWN;
				case 'EVASION_DOWN_2':	 	return EVASION_DOWN_2;
				
				case 'ATTACK_UP': 			return ATTACK_UP;
				case 'ATTACK_UP_2': 		return ATTACK_UP_2;
				case 'ATTACK_DOWN': 		return ATTACK_DOWN;
				case 'ATTACK_DOWN_2': 		return ATTACK_DOWN_2;
				
				case 'DEFENSE_UP': 			return DEFENSE_UP;
				case 'DEFENSE_UP_2':	 	return DEFENSE_UP_2;
				case 'DEFENSE_DOWN': 		return DEFENSE_DOWN;
				case 'DEFENSE_DOWN_2': 		return DEFENSE_DOWN_2;
				
				case 'SP_ATTACK_UP': 		return SP_ATTACK_UP;
				case 'SP_ATTACK_UP_2': 		return SP_ATTACK_UP_2;
				case 'SP_ATTACK_DOWN': 		return SP_ATTACK_DOWN;
				case 'SP_ATTACK_DOWN_2': 	return SP_ATTACK_DOWN_2;
				
				case 'SP_DEFENSE_UP': 		return SP_DEFENSE_UP;
				case 'SP_DEFENSE_UP_2': 	return SP_DEFENSE_UP_2;
				case 'SP_DEFENSE_DOWN': 	return SP_DEFENSE_DOWN;
				case 'SP_DEFENSE_DOWN_2': 	return SP_DEFENSE_DOWN_2;
				
				case 'SPEED_UP': 			return SPEED_UP;
				case 'SPEED_UP_2': 			return SPEED_UP_2;
				case 'SPEED_DOWN': 			return SPEED_DOWN;
				case 'SPEED_DOWN_2': 		return SPEED_DOWN_2;
				
				case 'CONFUSE': 			return CONFUSE;
				case 'POISON': 				return POISON;
				case 'PARALYZE': 			return PARALYZE;
				case 'SLEEP': 				return SLEEP;
				case 'BURN': 				return BURN;
				case 'FLINCH': 				return FLINCH;
				case 'MEAN_LOOK': 			return MEAN_LOOK;
				case 'LOCK_ON': 			return LOCK_ON;
				case 'RECHARGE':			return RECHARGE;
				
				default: 					return null;
			}
		}
	}
}
