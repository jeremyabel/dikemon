package com.tinyrpg.core 
{	import com.tinyrpg.battle.TinyLevelUpInfo;
	
	import flash.display.Bitmap;
	
	import com.tinyrpg.data.TinyType;
	import com.tinyrpg.data.TinyExpGrowthRate;
	import com.tinyrpg.data.TinyMoveSet;
	import com.tinyrpg.data.TinyStatSet;
	
	import com.tinyrpg.lookup.TinyMonLookup;
	import com.tinyrpg.lookup.TinySpriteLookup;
	import com.tinyrpg.utils.TinyMath;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * Class which represents a single mon, with all included
	 * stats, moves, and other related data.
	 */
	public class TinyMon 
	{
		private var m_bitmap		: Bitmap;
		private var m_human			: String;
		private var m_name			: String;
		private var m_style			: String;
		private var m_dexEntry		: String;
		private var m_starterText	: String;
		private var m_type1			: TinyType;
		private var m_type2			: TinyType;
		private var m_level			: int;
		private var m_catchRate 	: int;
		private var m_baseExp		: int;
		private var m_weight		: Number;
		private var m_growthRate	: TinyExpGrowthRate;
		private var m_currentExp	: int;
		private var m_currentHP		: int;
		
		public var moveSet			: TinyMoveSet;
		
		public var isEvolved		: Boolean = false;
		public var isInBattle		: Boolean = false;
		public var usedInBattle		: Boolean = false;
		public var isFainted		: Boolean = false;
		public var isRecharging 	: Boolean = false;
		public var isFlinching		: Boolean = false;
		public var isPoisoned		: Boolean = false;
		public var isBurned			: Boolean = false;
		public var isParalyzed		: Boolean = false;
		public var isLockedOn		: Boolean = false;
		public var isMeanLooked		: Boolean = false;
		public var usedMudsport		: Boolean = false;
		public var usedWatersport	: Boolean = false;
		public var hasLevelledUp	: Boolean = false;

		private var sleepCounter		: int = 0;
		private var confuseCounter		: int = 0;
		private var safeguardCounter 	: int = 0;
		
		public function get isConfused() : Boolean { return this.confuseCounter > 0; }
		public function get isSleeping() : Boolean { return this.sleepCounter > 0; }
		public function get isSafeguarded() : Boolean { return this.safeguardCounter > 0; }
		
		public var baseStatSet 		: TinyStatSet;
		public var ivStatSet 		: TinyStatSet;
		public var evStatSet 		: TinyStatSet;
		public var yieldStatSet		: TinyStatSet;
		public var battleModStatSet : TinyStatSet;
		
		public var accuracyModStage 		: int = 0;
		public var evasivenessModStage		: int = 0;
		public var critModStage 			: int = 0;
		
		public var didUseMudsport			: Boolean = false;
		public var didUseWatersport			: Boolean = false;
		
		public function get bitmap()		: Bitmap { return m_bitmap; }
		public function get human()			: String { return m_human; }
		public function get style() 		: String { return m_style; }
		public function get dexEntry() 		: String { return m_dexEntry; }
		public function get starterText() 	: String { return m_starterText; } 
		public function get type1() 		: TinyType { return m_type1; }
		public function get type2() 		: TinyType { return m_type2; }
		public function get level()			: int { return m_level; }
		public function get catchRate() 	: int { return m_catchRate; }
		public function get baseExp() 		: int { return m_baseExp; }
		public function get weight() 		: int { return m_weight; }
		public function get currentHP()		: int { return m_currentHP; }
		public function get currentEXP()	: int { return m_currentExp; }
		
		
		public function TinyMon( xmlData : XML, level : uint = 5, evolved : Boolean = false )
		{
			this.initFromXML( xmlData, level, evolved );
		}
		
		
		public function initFromXML( xmlData : XML, level : uint = 5, evolved : Boolean = false ) : void
		{
			m_name 		  = xmlData.child('NAME');
			m_human		  = xmlData.child('HUMAN');
			m_style 	  = xmlData.child('STYLE');
			m_dexEntry	  = xmlData.child('DEX_ENTRY');
			m_starterText = xmlData.child('STARTER_TEXT');
			m_type1		  = TinyType.getTypeFromString(xmlData.child('TYPE_1'));
			m_type2 	  = TinyType.getTypeFromString(xmlData.child('TYPE_2'));
			m_catchRate   = int(xmlData.child('CATCH_RATE').text());
			m_baseExp 	  = int(xmlData.child('EXP').text());
			m_weight 	  = Number(xmlData.child('WEIGHT').text());
			
			m_growthRate = new TinyExpGrowthRate( xmlData.child('LV_RATE') );
			
			baseStatSet = new TinyStatSet(
				int(xmlData.child('HP').text()),
				int(xmlData.child('ATK').text()),
				int(xmlData.child('DEF').text()),
				int(xmlData.child('SP_ATK').text()),
				int(xmlData.child('SP_DEF').text()),
				int(xmlData.child('SPD').text())
			);
			
			yieldStatSet = new TinyStatSet(
				int(xmlData.child('YIELD_HP').text()),
				int(xmlData.child('YIELD_ATK').text()),
				int(xmlData.child('YIELD_DEF').text()),
				int(xmlData.child('YIELD_SP_ATK').text()),
				int(xmlData.child('YIELD_SP_DEF').text()),
				int(xmlData.child('YIELD_SPD').text())
			);
			
			this.ivStatSet = new TinyStatSet(0, 0, 0, 0, 0, 0);
			this.evStatSet = new TinyStatSet(0, 0, 0, 0, 0, 0, true);
			this.battleModStatSet = new TinyStatSet(0, 0, 0, 0, 0, 0, true);
			
			m_level = level;
			m_currentExp = 1;
			m_currentHP = TinyMath.deepCopyInt(this.maxHP);
			
			this.isEvolved = evolved;
			
			this.moveSet = TinyMoveSet.newFromXML( xmlData );
			this.moveSet.setMovesToLevel( this.m_level );
			
			m_bitmap = new Bitmap( TinySpriteLookup.getMonsterSprite( this.name ) );
		}
		
		
		public function initWithJSON( jsonObject : Object ) : void
		{
			TinyLogManager.log( 'initWithJSON: ' + this.name, this );
			
			this.ivStatSet = TinyStatSet.newFromJSON( jsonObject.ivs );
			this.evStatSet = TinyStatSet.newFromJSON( jsonObject.evs, true );
			
			this.m_currentHP = TinyMath.deepCopyInt( jsonObject.currentHP );
			this.m_currentExp = TinyMath.deepCopyInt( jsonObject.currentEXP );
			this.isEvolved = jsonObject.isEvolved;
			this.m_level = TinyMath.deepCopyInt( jsonObject.level );
			
			this.moveSet.setMovesFromJSON( jsonObject.moveSet );
		}
		
		
		public static function newFromJSON( jsonObject : Object ) : TinyMon
		{
			if ( jsonObject.humanName ) {
				TinyLogManager.log( 'newFromJSON: ' + jsonObject.humanName, TinyMon );
			} else {
				TinyLogManager.log( 'newFromJSON: ' + jsonObject.name, TinyMon );	
			}
			
			// Initialize with default data, then update with the JSON data
			var xmlData : XML = TinyMonLookup.getInstance().getMonXMLByName( jsonObject.name, jsonObject.humanName );
			var newMon : TinyMon = new TinyMon( xmlData );
			newMon.initWithJSON( jsonObject );
			
			return newMon; 
		}
		
		
		public function toJSON() : Object
		{
			var jsonObject : Object = {};
			
			// Only save the data that is unique to this mon. The rest will be derived from the
			// mon's default data stored in the Monsters.xml file.
			jsonObject.name = this.m_name;
			jsonObject.humanName = this.m_human;
			jsonObject.currentEXP = this.currentEXP;
			jsonObject.currentHP = this.currentHP;			
			jsonObject.ivs = this.ivStatSet.toJSON();
			jsonObject.evs = this.evStatSet.toJSON();
			jsonObject.moveSet = this.moveSet.toJSON();
			jsonObject.isEvolved = this.isEvolved; 
			jsonObject.level = this.level;
			
			return jsonObject;	
		}
		
		
		public function get name() : String 
		{ 
			if ( m_human.length > 0 && !this.isEvolved ) return m_human;
			return m_name; 
		}
				
				
		public function dealDamage( value : int ) : void
		{
			TinyLogManager.log('dealDamage: ' + this.name + ' - ' + value, this);
			this.m_currentHP = Math.max( 0, this.m_currentHP  - value );	
		}
		

		public function recoverHP( value : int ) : void
		{
			TinyLogManager.log('recoverHP: ' + this.name + ' - ' + value, this);
			this.m_currentHP = Math.min( this.currentHP + value, this.maxHP );
		}
		
		
		public function healFull() : void
		{
			TinyLogManager.log( 'healFull', this );
			
			// Heal all HP and PP
			this.m_currentHP = this.maxHP;
			this.moveSet.recoverAllPP();
			
			// Clear status effects
			this.isPoisoned = false;
			this.isBurned = false;
			this.isParalyzed = false;
		}


		public function addExp(exp : int) : TinyLevelUpInfo 
		{
			TinyLogManager.log('addExp: ' + this.name + ' - ' + exp, this);
			m_currentExp += exp;
			
			// Get updated level value for current exp
			var newLevel : int = this.m_growthRate.getLevelForExpValue( this.m_currentExp );
			
			// Level up?!
			this.hasLevelledUp = newLevel > this.level;
			
			// Level up!
			if ( this.hasLevelledUp ) 
			{
				// Update current HP. Maintain the ratio between current and max HP from the previous level
				var currentHPRatio : Number = this.m_currentHP / this.maxHP;
				this.m_currentHP = this.getMaxHP( newLevel ) * currentHPRatio;
				
				// Generate the set of level up info for use in sequencing the level up actions
				var levelInfo : TinyLevelUpInfo = new TinyLevelUpInfo( this, newLevel );
				
				// Set the new level
				this.m_level = newLevel;
								
				return levelInfo;
			}
			 
			return null;
		}


		public function addEVs( defeatedMon : TinyMon ) : void
		{
			this.evStatSet.hp += defeatedMon.yieldStatSet.hp;
			this.evStatSet.attack += defeatedMon.yieldStatSet.attack;
			this.evStatSet.defense += defeatedMon.yieldStatSet.defense;
			this.evStatSet.spAttack += defeatedMon.yieldStatSet.spAttack;
			this.evStatSet.spDefense += defeatedMon.yieldStatSet.spDefense;
			this.evStatSet.speed += defeatedMon.yieldStatSet.speed;
		}

		public function get isHealthy() : Boolean
		{
			return this.currentHP > 0;
		}
		
		public function get isRegularStatus() : Boolean
		{
			if ( this.isConfused ) return false;
			if ( this.isPoisoned ) return false;
			if ( this.isParalyzed ) return false;
			if ( this.isSleeping ) return false;
			if ( this.isBurned ) return false;
			return true;
		}
		
		public function get isMaxHP() : Boolean
		{
			return this.currentHP == this.getMaxHP( this.level );
		}

		public function decrementStatusCounters() : Object
		{
			TinyLogManager.log('decrementStatusCounters: ' + this.name, this);
			
			// If any status counters were above zero before being updated, we'll need to check if they've been removed
			var checkSleepCounter : Boolean = TinyMath.deepCopyInt( this.sleepCounter ) > 0;
			var checkConfuseCounter : Boolean = TinyMath.deepCopyInt( this.confuseCounter ) > 0;
			var checkSafeguardCounter : Boolean = TinyMath.deepCopyInt( this.safeguardCounter ) > 0;
			
			// Decrement all counters
			this.sleepCounter = Math.max( 0, this.sleepCounter - 1 );
			this.confuseCounter = Math.max( 0, this.confuseCounter - 1 );
			this.safeguardCounter = Math.max( 0, this.safeguardCounter - 1 );
			
			// Check if any statuses have worn off
			var statusesResolved : Object = new Object();
			statusesResolved['sleep'] = checkSleepCounter && !this.isSleeping;
			statusesResolved['confusion'] = checkConfuseCounter && !this.isConfused;
			statusesResolved['safeguard'] = checkSafeguardCounter && !this.isSafeguarded;
			
			return statusesResolved;
		}
		
		public function setSleepCounter( value : int = -1 ) : void
		{	
			if ( value < 0 )
				value = TinyMath.randomInt(1, 5);
			
			this.sleepCounter = value;
			TinyLogManager.log('setSleepCounter: ' + this.name + ' - ' + value, this);
		}

		public function setConfusionCounter( value : int = -1 ) : void
		{
			if ( value < 0 )
				value = TinyMath.randomInt(1, 5);
				
			this.confuseCounter = value;				
			TinyLogManager.log('setConfusionCounter: ' + this.name + ' - ' + value, this);
		}
		
		public function setSafeguardCounter( value : int ) : void
		{
			this.safeguardCounter = value;
			TinyLogManager.log('setSafeguardCounter: ' + this.name + ' - ' + value, this);
		}

		public function isStatMaxedOutLow( stat : String ) : Boolean
		{
			return this.getStatStageValue( stat ) <= -6; 
		}
		
		public function isStatMaxedOutHigh( stat : String ) : Boolean
		{
			return this.getStatStageValue( stat ) >= +6;
		}
		
		public function getStatStageValue( stat : String) : int
		{
			switch (stat)
			{
				case TinyStatSet.STAT_NAME_CRIT_CHANCE:	return this.critModStage; 
				case TinyStatSet.STAT_NAME_ACCURACY: 	return this.accuracyModStage; 
				case TinyStatSet.STAT_NAME_EVASION:		return this.evasivenessModStage; 
				case TinyStatSet.STAT_NAME_ATTACK: 		return this.battleModStatSet.attack; 
				case TinyStatSet.STAT_NAME_DEFENSE: 	return this.battleModStatSet.defense; 
				case TinyStatSet.STAT_NAME_SP_ATTACK: 	return this.battleModStatSet.spAttack; 
				case TinyStatSet.STAT_NAME_SP_DEFENSE: 	return this.battleModStatSet.spDefense; 
				case TinyStatSet.STAT_NAME_SPEED: 		return this.battleModStatSet.speed;
				default: return 0;
			}
		}
		
		public function postTurnCleanup() : void
		{
			TinyLogManager.log('postTurnCleanup: ' + this.name, this);
			
			// Reset status effects that only last one turn
			this.isFlinching = false;
			this.isRecharging = false;
		}

		public function postSwitchCleanup() : void
		{
			TinyLogManager.log('postSwitchCleanup: ' + this.name, this);
		
			// Reset status effects that get cleared when the mon is switched	
			this.safeguardCounter = 0;
			this.isFlinching = false;
			this.isRecharging = false;
			this.isLockedOn = false;
			this.usedMudsport = false;
			this.usedWatersport = false;
		}

		public function postBattleCleanup() : void 
		{
			TinyLogManager.log('postBattleCleanup: ' + this.name, this);
			
			this.isInBattle = false;
			
			// Reset all status effects
			this.sleepCounter = 0;
			this.confuseCounter = 0;
			this.safeguardCounter = 0;
			this.isParalyzed = false;
			this.isPoisoned = false;
			this.isFlinching = false;
			this.isMeanLooked = false;
			this.isLockedOn = false;
			this.isBurned = false;
			this.isRecharging = false;
			this.usedMudsport = false;
			this.usedWatersport = false;
			this.usedInBattle = false;
			
			// Clear all battle stat mod stages
			this.battleModStatSet.attack = 0;
			this.battleModStatSet.defense = 0;
			this.battleModStatSet.spAttack = 0;
			this.battleModStatSet.spDefense = 0;
			this.battleModStatSet.speed = 0;
			this.accuracyModStage = 0;
			this.evasivenessModStage = 0;
			this.critModStage = 0;
		}

		public function get maxHP() 	: int { return this.getMaxHP( this.level ); }
		public function get attack() 	: int { return this.getAttack( this.level ); }
		public function get defense() 	: int { return this.getDefense( this.level ); }
		public function get spAttack() 	: int { return this.getSpAttack( this.level ); }
		public function get spDefense() : int { return this.getSpDefense( this.level ); }
		public function get speed() 	: int { return this.getSpeed( this.level ); }
		
		public function getEXPForNextLevel() : int
		{
			return this.m_growthRate.levelTable[ this.level + 1 ];
		}

		public function getMaxHP( level : int ) : int 
		{
			var B : int = baseStatSet.hp;
			var I : int = ivStatSet.hp;
			var E : int = evStatSet.hp;
			
			return Math.floor((2 * B + I + E) * this.level / 100 + level + 10);
		}
		
		public function getAttack( level : int ) : int
		{
			var B : int = baseStatSet.attack;
			var I : int = ivStatSet.attack;
			var E : int = evStatSet.attack;
			
			return statCalculation( B, I, E, level );
		}
		
		public function getDefense( level : int ) : int
		{
			var B : int = baseStatSet.defense;
			var I : int = ivStatSet.defense;
			var E : int = evStatSet.defense;
			
			return statCalculation( B, I, E, level );	
		}
		
		public function getSpAttack( level : int ) : int
		{
			var B : int = baseStatSet.spAttack;
			var I : int = ivStatSet.spAttack;
			var E : int = evStatSet.spAttack;
			
			return statCalculation( B, I, E, level );
		}
		
		public function getSpDefense( level : int ) : int
		{
			var B : int = baseStatSet.spDefense;
			var I : int = ivStatSet.spDefense;
			var E : int = evStatSet.spDefense;
			
			return statCalculation( B, I, E, level );
		}
		
		public function getSpeed( level : int ) : int
		{
			var B : int = baseStatSet.speed;
			var I : int = ivStatSet.speed;
			var E : int = evStatSet.speed;
			
			return statCalculation( B, I, E, level );
		}
		
		public function getCritChance( moveModifier : int = 0 ) : Number 
		{
			var critStage : int = Math.min( this.critModStage + moveModifier, 4 ); 
			switch (critStage)
			{
				default:
				case 0: return 1 / 16; 
				case 1: return 1 / 8;
				case 2: return 1 / 4;
				case 3: return 1 / 3;
				case 4: return 1 / 2;
			}
		}
		
		private function statCalculation( base : int, iv : int, ev : int, level : int ) : int
		{
			return Math.floor( Math.floor( (2 * base + iv + ev) * level / 100 + 5 ) );
		}
	}
}
