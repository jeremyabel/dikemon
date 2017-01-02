package com.tinyrpg.data 
{
	import com.tinyrpg.core.TinyConfig;
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;

	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * @author jeremyabel
	 */
	public class TinyStats extends EventDispatcher 
	{
		public static var XP_TABLE : Array = 
			[ 0, 40, 196, 547, 1171, 2146, 3550, 5461, 7957, 1116, 15016, 19735, 25351, 31942, 39586, 48361, 58345,
			  69617, 82253, 96332, 111932, 129131, 148008, 168639, 191103, 215479, 241843, 270275, 300851, 333651, 366450, 399250, 432049, 464849, 
			  497648, 530448, 563247, 596047, 628846, 661646, 694445, 727245, 760044, 792844, 825643, 858443, 891242, 924042, 956841, 989641 ];
			
		// Initial stats
		private var _str	 	: int;	// Strength
		private var _agi		: int; 	// Agility
		private var _vit		: int; 	// Vitality
		private var _def		: int;	// Defence
		private var _sdef 		: int;	// Special Defence
		private var _hit		: int; 	// Hit percentage
		private var _mhp		: int;	// Max Health
		private var _hp			: int;  // Current Health
		private var _lvl 		: int;	// Level
		private var _xp			: int; 	// Experience
		private var _nextLevel  : int; 	// XP needed for next level
		
		// Enemy-specific stats
		private var _e_attack	: int; 		// Enemy attack
		private var _e_accuracy	: int;		// Enemy accuracy
		private var _e_nHits	: int;		// Enemy number of hits
		private var _e_evade	: int;		// Enemy evade
		private var _e_gold		: int;		// Enemy gold amount
		private var _e_xp		: int;		// Enemy experience points given
		private var _e_item		: TinyItem;	// Enemy item dropped
		
		// Base stats
		private var baseHP				: int;
		private var baseAttack			: int;
		private var baseDefense			: int;
		private var baseSpecialAttack	: int;
		private var baseSpecialDefense	: int;
		private var baseSpeed			: int;
		
		// Individual values (IV)
		private var ivHP				: int;
		private var ivAttack			: int;
		private var ivDefense			: int;
		private var ivSpecialAttack		: int;
		private var ivSpecialDefense	: int;
		private var ivSpeed				: int;
		
		// Effort values (EV)
		private var evHP				: int;
		private var evAttack			: int;
		private var evDefense			: int;
		private var evSpecialAttack		: int;
		private var evSpecialDefense	: int;
		private var evSpeed				: int;
		
		// EV yields
		public var yieldHP				: int;
		public var yieldAttack			: int;
		public var yieldDefense			: int;
		public var yieldSpecialAttack	: int;
		public var yieldSpecialDefense	: int;
		public var yieldSpeed			: int;
		
		public var baseDamage 	: int;	// Base damage
		public var baseHit	  	: int;	// Base hit percentage
		public var baseEvade  	: int; 	// Base evade percentage
		public var initialHit 	: int;	// Initial hit percent value
		public var previousHP	: int;	// Previous HP value
		
		// Set of numbers which determine the chance of a stat being raised each level. Numbers are out of 8.
		public var levelValues : Array; 
		
		// Stat getters
		public function get HP()   : int { return this._hp;   }
		public function get STR()  : int { return this._str;  }
		public function get DEF()  : int { return this._def;  }
		public function get AGI()  : int { return this._agi;  }
		public function get VIT()  : int { return this._vit;  }
		public function get LVL()  : int { return this._lvl;  }
		public function get MHP()  : int { return this._mhp;  }
		public function get HIT()  : int { return this._hit;  }
		public function get XP()   : int { return this._xp;   }
		public function get SDEF() : int { return this._sdef; }
		public function get NXP()  : int { return this._nextLevel; }
		
		// Enemy stat getters
		public function get E_ATK()	 : int { return this._e_attack;   }
		public function get E_ACC()	 : int { return this._e_accuracy; }
		public function get E_HITS() : int { return this._e_nHits;	  }
		public function get E_EVD()	 : int { return this._e_evade;	  }
		public function get E_GP()	 : int { return this._e_gold;	  }
		public function get E_XP()	 : int { return this._e_xp;		  }
		public function get E_ITEM() : TinyItem { return this._e_item; }
		
		public function TinyStats(strength : int, defence : int, agility : int, vitality : int, maxHealth : int, hitPercent : int, specialDefence : int, levelValues : Array, eAttack : int = 0, eAccuracy : int = 0, eHits : int = 0, eEvade : int = 0, eGold : int = 0, eXP : int = 0, eItem : TinyItem = null)
		{
			this._str = strength;
			this._def = defence;
			this._agi = agility;
			this._vit = vitality;
			this._mhp = maxHealth;
			this._hit = hitPercent;
			this.levelValues = levelValues;
			this._sdef = specialDefence;
			this._e_attack = eAttack;
			this._e_accuracy = eAccuracy;
			this._e_evade = eEvade;
			this._e_nHits = eHits;
			this._e_gold = eGold;
			this._e_xp = eXP;
			this._e_item = eItem;
			
			// Keep initial hit stat
			this.initialHit = hitPercent;
						
			// Set base aux stats
			this._nextLevel = 39;
			this.baseDamage = Math.ceil(this._str / 2);
			this.baseHit = 0;
			this.baseEvade = this._agi + 48;
			this._lvl = 1;
			this._hp = this._mhp;
			this.previousHP = this._mhp;
		}
		
		public function toXMLString() : String
		{
			var returnString : String;
			
			return returnString;
		}

		public function levelUp() : void
		{	
			this._lvl++;
			
			TinyLogManager.log('levelUp: LEVEL UP: ' + this._lvl, this);
			
			// Update strength
			if (TinyMath.randomInt(1, 8) < this.levelValues[0]) {
				this._str += TinyConfig.STAT_INCREMENT;
				TinyLogManager.log('levelUp: STRENGTH UP', this);
			}
			
			// Update agility
			if (TinyMath.randomInt(1, 8) < this.levelValues[1]) {
				this._agi += TinyConfig.STAT_INCREMENT;
				TinyLogManager.log('levelUp: AGILITY UP', this);
			}
			
			// Update vitality 
			if (TinyMath.randomInt(1, 8) < this.levelValues[2]) {
				this._vit += TinyConfig.STAT_INCREMENT;
				TinyLogManager.log('levelUp: VITALITY UP', this);
			}
			
			// Update hidden stats
			this.baseDamage = Math.ceil(this._str / 2);
			this.baseHit = this.initialHit + (3 * (this._lvl - 1));
			this.baseEvade = this._agi + 48;
			this._sdef += 2;
			
			// Update HP
			this._mhp += 5 + Math.ceil(this._vit / 4) + TinyMath.randomInt(1, 6);
			if (this.LVL == 1 || this.LVL == 2) 
				this._hp = this._mhp;
			TinyLogManager.log('levelUp: MAX HP = ' + this._mhp, this);
		}
		
		public function set HP(value : int) : void
		{
			TinyLogManager.log('set hp: ' + value, this);
			var copier : ByteArray = new ByteArray();
			copier.writeInt(this._hp);
			copier.position = 0;
			this.previousHP = copier.readInt();
			this._hp = value;
		}
		
		public function set LVL(value : int) : void { this._lvl = value; }
		public function set  XP(value : int) : void { this._xp  = value; }

		public function addXP(value : int) : Boolean
		{
			TinyLogManager.log('addXP: ' + value, this);
			this._xp += value;
			
			// Do we have enough to gain a level?
			if (this._xp >= TinyStats.XP_TABLE[this._lvl]) {
				this.levelUp();
				return true;
			} else {
				return false;
			}
		}
		
		public function levelTo(value : int) : void
		{
			TinyLogManager.log('levelTo: ' + value, this);
			
			for (var i : int = 0; i < value; i++) {
				this.levelUp();
			}
			
			// Max out HP
			this.HP = this.MHP;
		}
	}
}
