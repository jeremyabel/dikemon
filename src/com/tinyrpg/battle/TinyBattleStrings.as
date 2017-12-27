package com.tinyrpg.battle 
{
	import com.tinyrpg.data.TinyStatusEffect;
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.utils.TinyMath;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyBattleStrings 
	{
		// Running strings
		public static const GOT_AWAY			: String = 'You got away safely!';
		public static const TRAINER_FLED		: String = 'TRAINER fled!';
		public static const WILD_FLED			: String = 'Wild MON ran away!';
		public static const FLED_BATTLE			: String = 'MON fled from battle!';
		
		public static const RUN_FAILED_1		: String = 'Can\'t escape!';
		public static const RUN_FAILED_2		: String = 'Can\'t escape!';
		public static const RUN_FAILED_3		: String = 'Can\'t escape[delay 2].[delay 2].[delay 2].[delay 6] Maybe MON should try moving their dumb[delay 3] fat legs or whatever a bit faster.';
		public static const RUN_FAILED_4		: String = 'Can\'t escape![halt] You\'re not very good at this,[delay 4] are you?';
		public static const RUN_FAILED_5		: String = 'Guess what,[delay 4] you failed.';
		public static const RUN_FAILED_6		: String = 'You got away safely![halt] [delay 6].[delay 2].[delay 2].[delay 2]wait no, you didn\'t.';
		
		public static const RUN_IMPOSSIBLE_1	: String = 'There\'s no escape from a trainer battle!';
		public static const RUN_IMPOSSIBLE_2	: String = 'You can\'t escape from a trainer battle!';
		public static const RUN_IMPOSSIBLE_3	: String = 'Look,[delay 4] you\'re stuck here,[delay 4] so you might as well try and finish the battle.';
		public static const RUN_IMPOSSIBLE_4	: String = 'Oh hey it worked this time![halt] [delay 6].[delay 2].[delay 2].[delay 2]wait no, it didn\'t.';
		public static const RUN_IMPOSSIBLE_5	: String = 'Stop selecting that!';
		public static const RUN_IMPOSSIBLE_6	: String = 'DAD: Hey[delay 6] uh,[delay 6] [player][delay 6].[delay 6].[delay 6]. that\'s your name,[delay 4] right?[halt] Anyway, it\'s your dad here![halt] Yeah, pressing that run button during a trainer battle a bunch of times just calls me,[delay 4] your dad![halt] That\'s pretty neat[delay 4], huh?[halt] Anyway,[delay 6], it seems like you have a lot of spare time here,[delay 4] just pressing that run button,[halt] so I figured now might be a good time to come back into your life![halt] [delay 6].[delay 6].[delay 6].Aw jeez,[delay 4] looks like there\'s a call on the other line![halt] Look, call me back next turn[delay 3] and I\'ll definitely fill you in about what I\'ve been up to after I left your family!';
		
		public static const RUN_PASSED_DAD		: String = 'Oh hey it worked this time![halt][delay 6] Like,[delay 6] for really real![halt] .[delay 6].[delay 6].[delay 6].Guess you\'ll never find out about your dad now,[delay 3] huh?';
		public static const RUN_IMPOSSIBLE_DAD 	: String = 'You thought you heard your dad\'s voice,[delay 4] but it was just the sound of you being unable to escape from this trainer.';
		 
		// Poison status strings
		public static const POISONED			: String = 'MON got real sick from that one!';
		public static const ALREDY_POISONED		: String = 'MON is already pretty sick!';
		public static const POISON_HURT			: String = 'MON just barfed all over the place![delay 4] Gross!';
		public static const POISON_HEAL			: String = 'MON feels better! Barf Fix: it works every time!';
		
		// Sleep status strings
		public static const FELL_ASLEEP 		: String = 'MON fell asleep!';
		public static const WENT_TO_SLEEP		: String = 'MON went to sleep!';
		public static const ALREADY_ASLEEP 		: String = 'MON is already asleep!';
		public static const FAST_ASLEEP			: String = 'MON is fast asleep.';
		public static const WOKE_UP				: String = 'MON woke up!';
		public static const WOKE_UP_ITEM		: String = 'The Big Noise Box woke MON up!';
		
		// Drunk status strings
		public static const IS_DRUNK			: String = 'MON is drunk!';
		public static const SOBERED_UP			: String = 'MON sobered up!';
		public static const BECAME_DRUNK		: String = 'MON got real drunk!';
		public static const ALREADY_DRUNK		: String = 'MON is already pretty drunk!';
		public static const TOO_DRUNK			: String = 'MON is too drunk to attack properly!';
		public static const HURT_ITSELF			: String = 'MON drunkenly flailed about and got hurt!';
		
		// Burn status strings
		public static const WAS_BURNED			: String = 'MON is on fire![delay 4] Ouch!';
		public static const BURN_HURT			: String = 'MON is hurt by the fire![delay 4] It burns!';
		public static const ALREADY_BURNED		: String = 'MON is already on fire![delay 4] Quit it!';
		public static const BURN_HEAL			: String = 'MON cooled off by rubbing the Cool Jelly all over!';
		
		// Paralyized status strings
		public static const IS_PARALYZED_1		: String = 'MON is all sticky![delay 4] It may be unable to move!';
		public static const IS_PARALYZED_2		: String = 'MON is all sticky![delay 4] It can\'t move!';
		public static const ALREADY_PARALYZED 	: String = 'MON is already pretty sticky!';
		public static const PARALYSIS_HEALED 	: String = 'MON isn\'t sticky anymore!';
		
		// Safeguard status strings
		public static const SAFEGUARD_ACTIVE 	: String = 'MON is proctected by SAFEGUARD!';
		public static const SAFEGUARD_FADED		: String = 'MON\'s SAFEGUARD faded!';
		
		// Dad Memories status strings
		public static const REMEMBERED_DAD		: String = 'The smell of the TALL GRASS reminded you of your dad when he used to cut the lawn!';
		public static const REMEMBERING_DAD		: String = 'You were distracted by thoughts about your dad![halt] Man,[delay 6] what happened to your dad?';
		
		// Mean Look status strings
		public static const ALREADY_MEAN_LOOKED	: String = 'MON is already freaked out by your weird face!';
		public static const MEAN_LOOKED			: String = 'MON was freaked out by your weird face!';
		public static const MEAN_LOOK_RUN		: String = 'MON is too disturbed by that weird face to run!';
		public static const MEAN_LOOK_SWITCH	: String = 'MON is too disturbed by that weird face to switch out!';
		
		// Flinch status strings
		public static const FREAKED_OUT			: String = 'MON is feeling pretty freaked out from that!';
		public static const FLINCHED 			: String = 'MON is too freaked out to move!';
		
		// Lock-On status strings
		public static const LOCKED_ON			: String = 'MON is really concentrating on the next attack!';
		
		// Misc status strings
		public static const RECOIL				: String = 'MON was hit with recoil!';
		public static const RECHARGE			: String = 'MON must recharge!';
		public static const STATUS_NORMAL		: String = 'MON returned to normal!';
		public static const WORE_OFF			: String = 'MON\'s MOVE wore off!';
		
		// Recovery strings
		public static const REGAINED_HEALTH		: String = 'MON regained health!';
		public static const HP_FULL				: String = 'MON\'s HP is full!'; 
		
		// Attack result strings
		public static const USED_MOVE			: String = 'MON used MOVE!';
		public static const CRIT				: String = 'It\'s a critical hit!';
		public static const ONE_HIT_KO			: String = 'Nice one! You fucked that one up hardcore!';
		public static const NOT_EFFECTIVE		: String = 'That didn\'t do too much...';
		public static const MISSED 				: String = 'MON\'s attack missed!';
		public static const HIT_ONCE			: String = 'Aw, it only hit once!';
		public static const HIT_MULTI			: String = 'It hit INT times!';
		public static const SUPER_EFFECTIVE		: String = 'Dang, you hurt it really a lot!';
		public static const NOTHING_HAPPENED	: String = 'But nothing happened!';
		public static const FAILED				: String = 'But it failed! Nice job, idiot.';
		public static const NO_EFFECT			: String = 'But it didn\'t do too much!';
		public static const FAINTED				: String = 'MON fainted!';
		
		// Battle result strings 
		public static const DEFEATED_TRAINER	: String = 'Nice one, you defeated TRAINER!';
		public static const LOST_TRAINER		: String = 'You lost against TRAINER?! Jeez, that guy was pretty easy. You think you\'ll beat the Elite Four with that garbage technique? Like seriously, those guys are tough and you just lost to what is pretty much a preschooler. How long have you even been on this journey? Two minutes? Cause you play like a baby, like a really small stupid baby. Did you even consider type compatability and all that junk? These fights are pretty complex, you can\'t just throw out whatever move has the coolest name. Maybe you just have terrible luck or something, but that\'s barely an excuse, cause that last move you used had a good 21.6% of succeeding, so who knows why you even tried to use it. Hope you\'re not trying to speedrun this thing, cause you\'re way behind pace here.';
		public static const BATTLE_PRIZE		: String = 'You got INT bucks for winning!';
		
		// Wild mon strings
		public static const WILD_MON_APPEARD_1 	: String = 'A wild MON appeared! Neat!';
		public static const WILD_MON_APPEARD_2 	: String = 'Aw peas, wild MON appeared!';
		public static const WILD_MON_APPEARD_3 	: String = 'Aw beans, a wild MON appeared!';
		public static const WILD_MON_APPEARD_4 	: String = 'Shit! A wild MON appeared!';
		
		// Summon mon strings
		public static const TRAINER_SENT_OUT_1 	: String = 'TRAINER sent out MON!';
		public static const TRAINER_SENT_OUT_2 	: String = 'TRAINER sent out MON!';
		public static const PLAYER_SENT_OUT_1	: String = 'Go! MON!';
		public static const PLAYER_SENT_OUT_2	: String = 'Do it, MON!';
		public static const PLAYER_SENT_OUT_3	: String = 'Go for it, MON!';
		public static const PLAYER_SENT_OUT_4	: String = 'Don\'t fuck this up, MON!'; 
		public static const PLAYER_SENT_OUT_5	: String = 'Drop a train on \'em, MON!';
		
		// Recall mon strings
		public static const TRAINER_RECALLED_1	: String = 'TRAINER withdrew MON!';
		public static const TRAINER_RECALLED_2	: String = 'For some reason, TRAINER withdrew MON!';
		public static const TRAINER_RECALLED_3	: String = 'TRAINER withdrew MON![halt] God, this AI is pretty dumb...';
		public static const PLAYER_RECALLED_1	: String = 'MON, that\'s enough, come back!';
		public static const PLAYER_RECALLED_2	: String = 'MON, come back!';
		public static const PLAYER_RECALLED_3	: String = 'MON OK! Come back!';
		public static const PLAYER_RECALLED_4	: String = 'You dissapoint me, MON! Get back in your ball!'; 		
		
		// Trainer battle strings
		public static const TRAINER_BATTLE_1	: String = 'TRAINER wants to battle!';
		public static const TRAINER_BATTLE_2	: String = 'TRAINER would like to battle!';
		
		// Exp. gain strings
		public static const GAIN_EXP_POINTS		: String = 'MON gained INT EXP. Points!';
		public static const GREW_LEVEL			: String = 'MON grew to LV. INT!';
		public static const LEARNED_MOVE		: String = 'MON learned MOVE! Cool!';
		public static const TRYING_TO_LEARN		: String = 'MON is trying to learn MOVE.';
		public static const CANT_LEARN_MOVE		: String = 'But, MON can\'t learn more than four moves.';
		public static const DELETE_MOVE			: String = 'Delete a move to make room for MOVE?';
		public static const CHOOSE_MOVE			: String = 'Choose a move to delete.';
		public static const CONFIRM_DELETE		: String = 'Delete MOVE?';
		public static const AND_ITS_GONE		: String = '3...[delay 2] 2...[delay 2] 1...[delay 2][br]And[delay 3] it\'s gone!'; 
		public static const DELETED_MOVE		: String = 'MON forgot MOVE.';
		public static const STOP_LEARNING	 	: String = 'Stop learning MOVE?';
		public static const DID_NOT_LEARN		: String = 'MON did not learn MOVE.';
		
		// Item usage strings
		public static const CANT_USE_ITEM		: String = 'Hey, you can\'t use this during battle!';
	 	public static const CANT_USE_BALL		: String = 'Hey, you can only touch your balls during a battle!';
	 	public static const CANT_USE_DEAD		: String = 'This guy is way too dead for that to work...';
	 	public static const CANT_USE_MAX_HP		: String = 'Buddy, this guy is pretty healthy already...';
	 	public static const CANT_USE_MAX_PP		: String = 'Does that move look like it needs more PP?!';
	 	public static const CANT_USE_POISON		: String = 'It\'s been at least a few hours since this guy barfed...';
	 	public static const CANT_USE_BURN		: String = 'This guy is already cool as a cucumber!';
	 	public static const CANT_USE_SLEEP		: String = 'Pretty sure this guy\'s already awake...';
	 	public static const CANT_USE_PARALYSIS	: String = 'This guy\'s not very sticky!';
	 	
	 	// Ball throw strings
	 	public static const BALL_THROW_REJECT	: String = 'Jeez, don\'t go stealing other trainer\'s guys! Not cool!';
		
		// Misc other battle strings
		public static const EXPLOSION_FAINT		: String = 'MON fainted from the explosion!';
		
		// Internal randomization arrays
		private static var WILD_ENCOUNTER_STRINGS : Array = [
			WILD_MON_APPEARD_1,
			WILD_MON_APPEARD_2,
			WILD_MON_APPEARD_3,
			WILD_MON_APPEARD_4
		];
		
		private static var RUN_FAILED_STRINGS : Array = [
			RUN_FAILED_1,
			RUN_FAILED_2,
			RUN_FAILED_3,
			RUN_FAILED_4,
			RUN_FAILED_5,
			RUN_FAILED_6
		];
		
		private static var RUN_IMPOSSIBLE_STRINGS : Array = [
			RUN_IMPOSSIBLE_1,
			RUN_IMPOSSIBLE_2,
			RUN_IMPOSSIBLE_3,
			RUN_IMPOSSIBLE_4,
			RUN_IMPOSSIBLE_5,
			RUN_IMPOSSIBLE_6
		];
		
		private static var TRAINER_BATTLE_STRINGS : Array = [
			TRAINER_BATTLE_1,
			TRAINER_BATTLE_2
		];
		
		private static var PLAYER_SENT_OUT_STRINGS : Array = [
			PLAYER_SENT_OUT_1,
			PLAYER_SENT_OUT_2,
			PLAYER_SENT_OUT_3,
			PLAYER_SENT_OUT_4,
			PLAYER_SENT_OUT_5
		];
		
		private static var TRAINER_SENT_OUT_STRINGS : Array = [
			TRAINER_SENT_OUT_1,
			TRAINER_SENT_OUT_2
		];
		
		private static var PLAYER_RECALLED_STRINGS : Array = [
			PLAYER_RECALLED_1,
			PLAYER_RECALLED_2,
			PLAYER_RECALLED_3,
			PLAYER_RECALLED_4
		];
		
		private static var TRAINER_RECALLED_STRINGS : Array = [
			TRAINER_RECALLED_1,
			TRAINER_RECALLED_2,
			TRAINER_RECALLED_3
		];
		
		public static function getBattleString( string : String, mon : TinyMon = null, trainer : TinyTrainer = null, move : TinyMoveData = null, stat : String = null, number : int = undefined ) : String
		{
			var regexMon 		: RegExp = /MON/;
			var regexTrainer 	: RegExp = /TRAINER/;
			var regexMove		: RegExp = /MOVE/;
			var regexStat		: RegExp = /STAT/;
			var regexInt		: RegExp = /INT/;
		
			// Do string replacements
			if ( mon ) 		string = string.replace( regexMon, mon.name.toUpperCase() );
			if ( trainer )	string = string.replace( regexTrainer, trainer.name.toUpperCase() );
			if ( move ) 	string = string.replace( regexMove, move.name.toUpperCase() );
			if ( stat )		string = string.replace( regexStat, stat.toUpperCase() );
			if ( number ) 	string = string.replace( regexInt, number );
			
			// Return string + ending flag
			return string + '   [end]';						
		}
		
		public static function getRandomWildEncounterString( mon : TinyMon ) : String
		{
			return getBattleString( WILD_ENCOUNTER_STRINGS[ TinyMath.randomInt( 0, WILD_ENCOUNTER_STRINGS.length ) ], mon );	
		}
		
		public static function getRandomTrainerBattleString( trainer : TinyTrainer ) : String
		{
			return getBattleString( TRAINER_BATTLE_STRINGS[ TinyMath.randomInt( 0, TRAINER_BATTLE_STRINGS.length ) ], null, trainer );	
		}
		
		public static function getRandomSummonDialogString( isEnemy : Boolean, mon : TinyMon, trainer : TinyTrainer ) : String
		{
			var selectionArray : Array = isEnemy ? TRAINER_SENT_OUT_STRINGS : PLAYER_SENT_OUT_STRINGS;
			return getBattleString( selectionArray[ TinyMath.randomInt( 0, selectionArray.length ) ], mon, trainer );
		}
		
		public static function getRandomRecalledString( isEnemy : Boolean, mon : TinyMon, trainer : TinyTrainer ) : String 
		{
			var selectionArray : Array = isEnemy ? TRAINER_RECALLED_STRINGS : PLAYER_RECALLED_STRINGS;
			return getBattleString( selectionArray[ TinyMath.randomInt( 0, selectionArray.length ) ], mon, trainer );	 
		}
		
		public static function getStatChangeString( mon : TinyMon, effectedStat : String, modValue : int ) : String
		{
			var resultString : String = mon.name.toUpperCase() + '\'s ' + effectedStat + ' ';
			
			if ( mon.isStatMaxedOutHigh( effectedStat ) )
				resultString += 'won\'t go any higher!';
			else if ( mon.isStatMaxedOutLow( effectedStat ) )
				resultString += 'won\'t go any lower!';
			else
				switch (modValue)
				{
					case -2: resultString += 'sharply fell!'; break;
					case -1: resultString += 'fell a little!'; break;
					case +1: resultString += 'rose a little!'; break;
					case +2: resultString += 'sharply rose!'; break;	
				}
			
			// Return string + ending flag
			return resultString + '   [end]';  
		}
		
		public static function getStatusChangeString( mon : TinyMon, statusEffect : String, effectSucceeded : Boolean ) : String
		{
			var resultString : String = '';
			
			switch (statusEffect) 
			{
				case TinyStatusEffect.BURN:
					resultString = getBattleString( !effectSucceeded ? TinyBattleStrings.ALREADY_BURNED : TinyBattleStrings.WAS_BURNED, mon ); break;
				case TinyStatusEffect.CONFUSION:
					resultString = getBattleString( !effectSucceeded ? TinyBattleStrings.ALREADY_DRUNK : TinyBattleStrings.IS_DRUNK, mon ); break;
				case TinyStatusEffect.POISON:
					resultString = getBattleString( !effectSucceeded ? TinyBattleStrings.ALREDY_POISONED : TinyBattleStrings.POISONED, mon ); break;
				case TinyStatusEffect.SLEEP:
					resultString = getBattleString( !effectSucceeded ? TinyBattleStrings.ALREADY_ASLEEP : TinyBattleStrings.WENT_TO_SLEEP, mon ); break;
				case TinyStatusEffect.PARALYSIS:
					resultString = getBattleString( !effectSucceeded ? TinyBattleStrings.ALREADY_PARALYZED : TinyBattleStrings.IS_PARALYZED_1, mon ); break;
				case TinyStatusEffect.MEAN_LOOK:
					resultString = getBattleString( !effectSucceeded ? TinyBattleStrings.ALREADY_MEAN_LOOKED : TinyBattleStrings.MEAN_LOOKED, mon ); break;
				case TinyStatusEffect.FLINCH:
					resultString = getBattleString( TinyBattleStrings.FREAKED_OUT, mon ); break;
				case TinyStatusEffect.LOCK_ON:
					resultString = getBattleString( TinyBattleStrings.LOCKED_ON, mon ); break;
				default:
					resultString = '   [end]'; break;
			}
			
			return resultString;
		}
		
		public static function getRunFailedString( attempts : int ) : String
		{
			attempts = Math.min( attempts, TinyBattleStrings.RUN_FAILED_STRINGS.length - 1 );
			return getBattleString( TinyBattleStrings.RUN_FAILED_STRINGS[ attempts ] );	
		}

		public static function getRunImpossibleString( attempts : int ) : String
		{
			attempts = Math.min( attempts, TinyBattleStrings.RUN_IMPOSSIBLE_STRINGS.length - 1 );
	
			// TODO: Check dad call story flag
			if ( attempts == 5 && true ) {
				return getBattleString( RUN_IMPOSSIBLE_DAD );
			}
			
			return getBattleString( TinyBattleStrings.RUN_IMPOSSIBLE_STRINGS[ attempts ] );  
		}
	}
}
