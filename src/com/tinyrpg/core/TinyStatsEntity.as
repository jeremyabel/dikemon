package com.tinyrpg.core 
{
	import com.tinyrpg.data.TinyEventFlagData;
	import com.tinyrpg.data.TinyItemDataList;
	import com.tinyrpg.data.TinyStats;
	import com.tinyrpg.misc.TinySpecialAttack;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.events.EventDispatcher;

	/**
	 * @author jeremyabel
	 */
	public class TinyStatsEntity extends EventDispatcher
	{
		public var isEnemy		: Boolean;
		public var graphics 	: ITinySprite;
		public var stats 		: TinyStats;
		public var name  		: String;
		public var attackType	: String;
		public var special		: TinySpecialAttack;
		public var specChance	: int;
		public var battleIndex	: int;
		public var lastAttack	: TinyStatsEntity;
		public var animated		: Boolean;
		
		private var _idNumber : int;
		private var trace 	  :	Boolean = true;

		public function TinyStatsEntity(isEnemy : Boolean, graphics : ITinySprite, idNumber : int = 0, name : String = 'JASON', animated : Boolean = false) 
		{
			this.isEnemy = isEnemy;
			this.animated = animated;
			this.graphics = graphics;
			this.idNumber = idNumber;
			this.name = name;
		}
		
		public static function newMonFromXML(xmlData : XML) : TinyStatsEntity
		{
			var xmlStats : XMLList = xmlData.child('STATS');
						
			// Set name and stats
			var newStats : TinyStats = new TinyStats(
										int(xmlStats.child('STRENGTH').text()),
										int(xmlStats.child('DEFENCE').text()),
										int(xmlStats.child('AGILITY').text()),
										int(xmlStats.child('VITALITY').text()),
										int(xmlStats.child('MAX_HP').text()),
										int(xmlStats.child('HIT_PERCENT').text()),
										int(xmlStats.child('SPECIAL_DEFENCE').text()),
										String(xmlStats.child('LEVEL_VALUES').text()).split(',')
									);
			
			// Set stats from saved data
			newStats.HP  = int(xmlStats.child('CURRENT_HP').text());
			newStats.LVL = int(xmlStats.child('LEVEL').text());
			newStats.XP  = int(xmlStats.child('XP').text());
			
			var newGraphics : ITinySprite = new TinyFriendSprite(0, xmlData.child('NAME'), int(xmlData.child('ANIMATION').child('ATTACK_LENGTH').text()), int(xmlData.child('ANIMATION').child('IDLE_LENGTH').text()));
			
			// Make new 
			var newTinyStatsEntity : TinyStatsEntity = new TinyStatsEntity(false, newGraphics, 0, xmlData.child('NAME'));
			newTinyStatsEntity.attackType = xmlData.child('ANIMATION').child('ATTACK_TYPE').text();
			newTinyStatsEntity.stats = newStats;

			TinyLogManager.log('newFromXML: new FRIEND made', newTinyStatsEntity);
			
			// Trace stuff
			if (newTinyStatsEntity.trace) {				
				TinyLogManager.log('newFromXML: HP:       ' + newTinyStatsEntity.stats.HP,   newTinyStatsEntity);
			}
			return newTinyStatsEntity;
		}
		
		public static function newEnemyFromXML(xmlData : XML) : TinyStatsEntity
		{
			TinyLogManager.log('newEnemyFromXML', TinyStatsEntity);
			
			var xmlStats : XMLList = xmlData.child('STATS');

			// Get item drop, if there is one
			var itemString : String = xmlStats.child('ITEM').text();
			var itemDrop : TinyItem = null;
			if (itemString && itemString != '') {
				itemDrop = TinyItemDataList.getInstance().getItemByName(itemString);
			}
			
			// Make new stats
			var newStats : TinyStats = new TinyStats(
										0, int(xmlStats.child('DEFENCE').text()),
										0,
										0, int(xmlStats.child('MAX_HP').text()),
										0, int(xmlStats.child('SPECIAL_DEFENCE').text()),
										[], int(xmlStats.child('ATTACK').text()),
										int(xmlStats.child('ACCURACY').text()),
										int(xmlStats.child('N_HITS').text()),
										int(xmlStats.child('EVADE').text()),
										int(xmlStats.child('GOLD').text()),
										int(xmlStats.child('EXP').text()),
										itemDrop
									);
			
			// Is this enemy fully animated?
			var newGraphics : ITinySprite;
			if (xmlData.child('ANIMATION').child('ANIMATED').toString() == 'TRUE') {
				TinyLogManager.log('ENEMY IS FULLY ANIMATED', TinyStatsEntity);
				newGraphics = new TinyFriendSprite(0, xmlData.child('NAME').toString(), int(xmlData.child('ANIMATION').child('ATTACK_LENGTH')), int(xmlData.child('ANIMATION').child('IDLE_LENGTH')), true);
			} else {
				newGraphics = new TinyEnemySprite(0, xmlData.child('NAME'));
			}
			
			var newTinyStatsEntity : TinyStatsEntity = new TinyStatsEntity(true, newGraphics, 0, xmlData.child('NAME'));
			newTinyStatsEntity.attackType = xmlData.child('ANIMATION').child('ATTACK_TYPE').text();
			newTinyStatsEntity.animated = xmlData.child('ANIMATION').child('ANIMATED').text() == 'TRUE';
			newTinyStatsEntity.stats = newStats;
			
			// Add special attack
			if (xmlData.child('SPECIAL') != '') {
				newTinyStatsEntity.special = TinySpecialAttack.newFromXML(xmlData.child('SPECIAL'));
				newTinyStatsEntity.specChance = int(xmlData.child('SPECIAL').child('CHANCE').text());
			}
			
			TinyLogManager.log('newFromXML: new ENEMY made', newTinyStatsEntity);
			
			// Trace stuff
			if (newTinyStatsEntity.trace) {	
				TinyLogManager.log('newFromXML: ====================================',  		newTinyStatsEntity);
				TinyLogManager.log('newFromXML: NAME:     ' + newTinyStatsEntity.name, 			newTinyStatsEntity);
				TinyLogManager.log('newFromXML: HP:       ' + newTinyStatsEntity.stats.HP, 		newTinyStatsEntity);
				TinyLogManager.log('newFromXML: ATTACK:   ' + newTinyStatsEntity.stats.E_ATK, 	newTinyStatsEntity);
				TinyLogManager.log('newFromXML: ACCURACY: ' + newTinyStatsEntity.stats.E_ACC,	newTinyStatsEntity);
				TinyLogManager.log('newFromXML: DEFENCE:  ' + newTinyStatsEntity.stats.DEF, 	newTinyStatsEntity);
				TinyLogManager.log('newFromXML: EVADE:    ' + newTinyStatsEntity.stats.E_EVD,  	newTinyStatsEntity);
				TinyLogManager.log('newFromXML: HITS:     ' + newTinyStatsEntity.stats.E_HITS, 	newTinyStatsEntity);
				TinyLogManager.log('newFromXML: SDEFENCE: ' + newTinyStatsEntity.stats.SDEF, 	newTinyStatsEntity);
				TinyLogManager.log('newFromXML: GOLD: 	  ' + newTinyStatsEntity.stats.E_GP, 	newTinyStatsEntity);
				TinyLogManager.log('newFromXML: EXP:      ' + newTinyStatsEntity.stats.E_XP, 	newTinyStatsEntity);
				if (itemDrop) TinyLogManager.log('newFromXML: ITEM:	  ' + newTinyStatsEntity.stats.E_ITEM.name, newTinyStatsEntity);
			}
			
			return newTinyStatsEntity;
		}
		
		public function getXMLString() : String
		{
			var xmlString : String;
			xmlString  = '<STATS>';
			return xmlString;
		}

		public function get dead() : Boolean
		{
			return stats.HP <= 0;
		}
		
		public function set idNumber(value : int) : void
		{
			TinyLogManager.log('set idNumber: ' + value, this);
			this._idNumber = value;
			this.graphics['idNumber'] = value;
		}

		public function get idNumber() : int
		{
			return this._idNumber;
		}
		
		public function get recruited() : Boolean
		{
			if (this.name.toUpperCase() == 'EVAN' || this.name.toUpperCase() == 'EVAN?' || this.name.toUpperCase() == 'HYBRID') {
				return false;
			} 
			
			// TODO: LOL
			var result : Boolean = true; //TinyEventFlagData.getRecruitFlagByName(this.name).value;
			TinyLogManager.log('get recruited: ' + result, this);
			return result;
		}
	}
}