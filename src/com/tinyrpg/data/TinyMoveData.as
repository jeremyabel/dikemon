package com.tinyrpg.data 
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.battle.TinyBattlePalette;
	import com.tinyrpg.display.TinyMoveFXAnimation;
	import com.tinyrpg.utils.TinyMath;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyMoveData 
	{
		private var m_name 				: String = '-';
		private var m_description 		: String;
		private var m_basePower 		: int;
		private var m_accuracy 			: int;
		private var m_effectAccuracy 	: int;
		private var m_pp 				: int;
		private var m_currentPP			: int;
		private var m_type 				: TinyType;
		private var m_priority 			: int;
		private var m_effects			: Array = [];
		private var m_numHits			: int = 1;
		private var m_target			: String;
		private var m_fxScreenInverts	: String;
		private var m_fxScreenShake		: String;
		private var m_fxAnimDistortion	: String;
		private var m_fxPaletteEffect	: String;
		private var m_uselessText		: String;
	
		public var moveFXSAnimation		: TinyMoveFXAnimation;
		
		public function get name() 			 	: String { return m_name; }
		public function get description() 	 	: String { return m_description; }
		public function get basePower() 	 	: int { return m_basePower; }
		public function get accuracy() 		 	: int { return m_accuracy; }
		public function get effectAccuracy() 	: int { return m_effectAccuracy; }
		public function get maxPP() 			: int { return m_pp; }
		public function get currentPP()			: int { return m_currentPP; }
		public function get type() 				: TinyType { return m_type; }
		public function get priority() 		 	: int { return m_priority; }
		public function get numHits() 		 	: int { return m_numHits; }
		public function get effects() 		 	: Array { return m_effects; }
		public function get targetsSelf()		: Boolean { return m_target == 'SELF'; }
		public function get fxScreenInverts()	: String { return m_fxScreenInverts; }
		public function get fxScreenShake()		: String { return m_fxScreenShake; }
		public function get fxAnimDistortion()	: String { return m_fxAnimDistortion; }
		public function get fxPaletteEffect()	: String { return m_fxPaletteEffect; }
		
		public function get uselessText() : String 
		{ 
			var commaReplacePattern : RegExp = /\|/;
			return m_uselessText.replace( commaReplacePattern, ',' ); 
		}
		
		// Special attack for use when a mon hurts itself in confusion
		public static var CONFUSION_ATTACK : TinyMoveData = new TinyMoveData('CONFUSION HIT', '', 40, 0, 0, 10, TinyType.NORMAL, 0, 'SELF', [ TinyMoveEffect.HIT ] );
		
		// Special attack for use when a mon is all out of moves
		public static var STRUGGLE_ATTACK : TinyMoveData = new TinyMoveData('STRUGGLE', '', 50, 0, 0, 10, TinyType.NORMAL, 0, 'ENEMY', [ TinyMoveEffect.HIT, TinyMoveEffect.RECOIL ] );

		public function TinyMoveData(
			name : String,
			description : String,
			basePower : int,
			accuracy : int,
			effectAccuracy : int,
			pp : int,
			type : TinyType,
			priority : int,
			target : String,
			effects : Array,
			fxScreenInverts : String = '',
			fxScreenShake : String = '',
			fxAnimDistortion : String = '',
			fxPaletteEffect : String = '',
			uselessText : String = '')  
		{
			m_name = name.toUpperCase();
			m_description = description;
			m_basePower = basePower;
			m_accuracy = accuracy;
			m_effectAccuracy = effectAccuracy;
			m_pp = pp;
			m_currentPP = m_pp;
			m_type = type;
			m_priority = priority;
			m_target = target;
			m_effects = effects; 
			m_fxScreenInverts = fxScreenInverts;
			m_fxScreenShake = fxScreenShake;
			m_fxAnimDistortion = fxAnimDistortion;
			m_fxPaletteEffect = fxPaletteEffect;
			m_uselessText = uselessText;
		}

		public static function newFromXML(xmlData : XML) : TinyMoveData
		{
			// Parse move effects list
			var moveEffectsListString : String = xmlData.child('EFFECT');
			var moveEffectsList : Array = moveEffectsListString.split(' ');
			var moveEffectsArray : Array = [];
			
			for each (var moveEffectString : String in moveEffectsList )
			{
				var moveEffect : TinyMoveEffect = TinyMoveEffect.getEffectByName( moveEffectString );
					
				// Print missing move effects
				if (moveEffect)
					moveEffectsArray.push(moveEffect);	
				else 
					trace( '======= MISSING ATTACK EFFECT: ' + moveEffectString + ' =======' );
			}
			
			// Return new move data
			return new TinyMoveData(
				xmlData.child('ORIG_MOVE_NAME'),
				xmlData.child('DESCRIPTION'),
				int(xmlData.child('POWER').text()),
				int(xmlData.child('ACC').text()),
				int(xmlData.child('EFFECT_ACC').text()),
				int(xmlData.child('PP').text()),
				TinyType.getTypeFromString(xmlData.child('TYPE')),
				int(xmlData.child('PRIORITY').text()),
				xmlData.child('TARGET'),
				moveEffectsArray,
				xmlData.child('SCREEN_INVERT'),
				xmlData.child('SCREEN_SHAKE'),
				xmlData.child('ANIM_DISTORTION_EFFECT'),
				xmlData.child('ANIM_PALETTE_EFFECT'),
				xmlData.child('USELESS_TEXT')
			);	
		}
		
		public static function newFromCopy( target : TinyMoveData ) : TinyMoveData
		{
			if (!target) 
			{
				return null;
			}
			
			return new TinyMoveData(
				TinyMath.deepCopyString( target.name ),
				TinyMath.deepCopyString( target.description ),
				TinyMath.deepCopyInt( target.basePower ),
				TinyMath.deepCopyInt( target.accuracy ),
				TinyMath.deepCopyInt( target.effectAccuracy ),
				TinyMath.deepCopyInt( target.maxPP ),
				TinyType.getTypeFromString( TinyMath.deepCopyString( target.type.name ) ),
				TinyMath.deepCopyInt( target.priority ),
				TinyMath.deepCopyString( target.targetsSelf ? 'SELF' : 'ENEMY' ),
				target.effects,
				TinyMath.deepCopyString( target.fxScreenInverts ),
				TinyMath.deepCopyString( target.fxScreenShake ),
				TinyMath.deepCopyString( target.fxAnimDistortion ),
				TinyMath.deepCopyString( target.fxPaletteEffect ),
				TinyMath.deepCopyString( target.uselessText )
			);
		}
		
		public function toJSON() : Object
		{
			var jsonObject : Object = {};
			
			jsonObject.name = this.name;
			jsonObject.pp = this.currentPP;
			
			return jsonObject;
		}
		
		public function loadMoveFXAnimation( palette : TinyBattlePalette, isEnemy : Boolean ) : void
		{
			TinyLogManager.log('loadMoveFXSprite: ' + this.name + ', isEnemy: ' + isEnemy, this);
			this.moveFXSAnimation = new TinyMoveFXAnimation( this, isEnemy, palette );
		}
		
		public function isSuperEffectiveVs( types : Array ) : Boolean
		{	
			// Moves with the USELESS_TEXT effect are never effective
			if ( this.hasEffect( TinyMoveEffect.USELESS_TEXT ) ) 
			{
				return false;
			}
			
			var effectiveness : Number = 1;
			for each ( var targetType : TinyType in types )
			{	
				if ( targetType.name != (types[0] as TinyType).name ) 
				{
					effectiveness *= this.type.getMatchupValueVersus( targetType );
				}	
			}
			
			return effectiveness > 1;
		}
		
		public function isNotEffectiveVs( types : Array ) : Boolean
		{
			// Moves with the USELESS_TEXT effect are always not effective
			if ( this.hasEffect( TinyMoveEffect.USELESS_TEXT ) ) 
			{
				return true;
			}
			
			var effectiveness : Number = 1;
			for each ( var targetType : TinyType in types )
			{
				if ( targetType.name != (types[0] as TinyType).name ) 
				{
					effectiveness *= this.type.getMatchupValueVersus( targetType );
				}	
			}
			
			return effectiveness < 1;	
		}
		
		public function deductPP( amount : int ) : void
		{
			TinyLogManager.log('deductPP: ' + amount, this);
			this.m_currentPP = Math.max(0, this.m_currentPP - amount);
		}
		
		public function recoverPP( amount : int ) : void
		{
			TinyLogManager.log('recoverPP: ' + amount, this);
			this.m_currentPP = Math.min( this.m_currentPP + amount, this.maxPP );
		}
		
		public function recoverAllPP() : void
		{
			TinyLogManager.log('recoverAllPP', this);
			this.m_currentPP = this.maxPP;
		}
		
		public function set currentPP( value : int ) : void 
		{
			var ppValue : int = value;
			
			if ( !value ) 
			{
				ppValue = this.maxPP;	
			}
			
			TinyLogManager.log( this.name + ' set current PP: ' + ppValue, this ); 
			this.m_currentPP = ppValue; 
		} 
		
		public function get isMaxPP() : Boolean
		{
			return this.m_currentPP == this.maxPP;
		}
		
		public function hasEffect( effect : TinyMoveEffect ) : Boolean
		{
			return this.m_effects.indexOf( effect ) > -1;
		}
		
		public function getStatModEffects() : Array
		{
			return this.m_effects.filter( TinyMoveEffect.isStatModEffect );
		}
		
		public function getStatusEffects() : Array
		{
			return this.m_effects.filter( TinyMoveEffect.isStatusEffect );	
		}
		
		public function getMiscEffects() : Array
		{
			return this.m_effects.filter( TinyMoveEffect.isMiscEffect );
		}

		////////////////////////////////////////////////////////////////////////////////////////////////////////
		//  Move Effect Functions
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function applyPowerModEffect( user : TinyMon, defender : TinyMon ) : int 
		{
			user;
			
			// LOW_KICK: Power determined by target weight
			if ( this.hasEffect( TinyMoveEffect.LOW_KICK ) )
			{
				TinyLogManager.log('applyPowerModEffect: LOW_KICK', this);
				
				if ( defender.weight <    9.9 ) return 20;
				if ( defender.weight <   24.9 )	return 40;
				if ( defender.weight <   49.9 )	return 60;
				if ( defender.weight <   99.9 )	return 80;
				if ( defender.weight <  199.9 )	return 100;
				if ( defender.weight >= 200.0 ) return 120;
			}
			
			return this.basePower;
		}
		
		public function applyNumHitsModEffect() : int
		{
			// DOUBLE_HIT: Hits twice
			if ( this.hasEffect( TinyMoveEffect.DOUBLE_HIT ) )
			{
				TinyLogManager.log('applyNumHitsModEffect: DOUBLE_HIT', this);
				return 2;
			}
			
			// MULTI_HIT: Hits 2 - 5 times, using a weighted random choice
			if ( this.hasEffect( TinyMoveEffect.MULTI_HIT ) )
			{
				TinyLogManager.log('applyNumHitsModEffect: MULTI_HIT', this);	
				var weights : Array = [ 0.375, 0.375, 0.125, 0.125 ];
				var weightedRandom : int = TinyMath.weightedRandomChoice( weights );
				return 2 + weightedRandom;
			}
			
			return this.numHits;
		}
		
		public function applyDamageModEffect( damage : int, user : TinyMon, defender : TinyMon ) : int
		{
			// FALSE_SWIPE: Inflicts damage, but will leave the target with 1 HP if it would otherwise cause it to faint.
			if ( this.hasEffect( TinyMoveEffect.FALSE_SWIPE ) )
			{
				TinyLogManager.log('applyDamageModEffect: FALSE_SWIPE', this);
				return Math.min( damage, defender.currentHP - 1 );
			}
			
			// PSYWAVE: Random damage according to some math
			if ( this.hasEffect( TinyMoveEffect.PSYWAVE ) )
			{
				TinyLogManager.log('applyDamageModEffect: PSYWAVE', this);
				return (Math.random() + 0.5) * user.level;
			}
			
			return damage;
		}
		
		public function applyStatModEffect( target : TinyMon, targetStat : String, modValue : int ) : Boolean
		{
			// Clamp stat stages to -6, +6		
			if ( target.getStatStageValue( targetStat ) >= +6 || target.getStatStageValue( targetStat ) <= -6 )
			{
				TinyLogManager.log('applyStatModEffect: ' + target.name + '\'s' + targetStat + ' is already maxed out!', this);
				return false;	
			} 
			
			TinyLogManager.log('applyStatModEffect: ' + target.name + '\'s ' + targetStat + ' ' + modValue, this);
			
			switch (targetStat)
			{
				case TinyStatSet.STAT_NAME_CRIT_CHANCE: target.critModStage += modValue; break;
				case TinyStatSet.STAT_NAME_ACCURACY: 	target.accuracyModStage += modValue; break;
				case TinyStatSet.STAT_NAME_EVASION:		target.evasivenessModStage += modValue; break;
				case TinyStatSet.STAT_NAME_ATTACK:		target.battleModStatSet.attack += modValue; break;
				case TinyStatSet.STAT_NAME_DEFENSE:		target.battleModStatSet.defense += modValue; break;
				case TinyStatSet.STAT_NAME_SP_ATTACK:	target.battleModStatSet.spAttack += modValue; break;
				case TinyStatSet.STAT_NAME_SP_DEFENSE:	target.battleModStatSet.spDefense += modValue; break;	
			}
			
			return true;
		}
		
		public function applyStatusChangeEffect( target : TinyMon, statusEffect : String ) : Boolean
		{
			TinyLogManager.log('applyStatusChangeEffect: ' + target.name + ' - ' + statusEffect, this);
			
			switch (statusEffect)
			{
				case TinyStatusEffect.BURN:
					if (target.isBurned) return false;
					target.isBurned = true; 
					break;
				case TinyStatusEffect.CONFUSION:
					if (target.isConfused) return false;
					if (!target.isConfused)
						target.setConfusionCounter();
					break;
				case TinyStatusEffect.FLINCH:
					if (target.isFlinching) return false;
					target.isFlinching = true;
					break;
				case TinyStatusEffect.LOCK_ON:
					if (target.isLockedOn) return false;
					target.isLockedOn = true;
					break;
				case TinyStatusEffect.MEAN_LOOK:
					if (target.isMeanLooked) return false;
					target.isMeanLooked = true;
					break;
				case TinyStatusEffect.PARALYSIS:
					if (target.isParalyzed) return false;
					target.isParalyzed = true;
					break;
				case TinyStatusEffect.POISON:
					if (target.isPoisoned) return false;
					target.isPoisoned = true;
					break;
				case TinyStatusEffect.SLEEP:
					if (target.isSleeping) return false;
					if (!target.isSleeping)
						target.setSleepCounter();
					break; 
			}
			
			return true;
		}
	}
}
