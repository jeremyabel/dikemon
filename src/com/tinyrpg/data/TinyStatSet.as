package com.tinyrpg.data 
{
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyStatSet 
	{
		public static const STAT_NAME_ATTACK 		: String = 'ATTACK';
		public static const STAT_NAME_DEFENSE		: String = 'DEFENSE';
		public static const STAT_NAME_SP_ATTACK		: String = 'SP. ATTACK';
		public static const STAT_NAME_SP_DEFENSE	: String = 'SP. DEFENSE';
		public static const STAT_NAME_SPEED			: String = 'SPEED';
		public static const STAT_NAME_ACCURACY		: String = 'ACCURACY';
		public static const STAT_NAME_EVASION		: String = 'EVASION';
		public static const STAT_NAME_CRIT_CHANCE	: String = 'CRIT CHANCE';
		
		private var m_hp 		: int;
		private var m_attack 	: int;
		private var m_defense 	: int;
		private var m_spAttack 	: int;
		private var m_spDefense : int;
		private var m_speed 	: int;
		private var canModify 	: Boolean = false;
		
		public function get hp() 		: int { return m_hp; }
		public function get attack() 	: int { return m_attack; }
		public function get defense() 	: int { return m_defense; }
		public function get spAttack() 	: int { return m_spAttack; }
		public function get spDefense() : int { return m_spDefense; }
		public function get speed() 	: int { return m_speed; }
		
		public function set hp( value : int )			: void { if ( this.canModify ) this.m_hp = value; }
		public function set attack( value : int ) 		: void { if ( this.canModify ) this.m_attack = value; }
		public function set defense( value : int ) 		: void { if ( this.canModify ) this.m_defense = value; }
		public function set spAttack( value : int ) 	: void { if ( this.canModify ) this.m_spAttack = value; }
		public function set spDefense( value : int ) 	: void { if ( this.canModify ) this.m_spDefense = value; }
		public function set speed( value : int ) 		: void { if ( this.canModify ) this.m_speed = value; }
		
		public function TinyStatSet(hp : int, attack : int, defense : int, spAttack : int, spDefense : int, speed : int, canModify : Boolean = false )
		{
			this.m_hp = hp;
			this.m_attack = attack;
			this.m_defense = defense;
			this.m_spAttack = spAttack;
			this.m_spDefense = spDefense;
			this.m_speed = speed;
			this.canModify = canModify;
		}
		
		public function log() : void
		{
			TinyLogManager.log('hp: ' + this.hp, this);
			TinyLogManager.log('attack: ' + this.attack, this);
			TinyLogManager.log('defese: ' + this.defense, this);
			TinyLogManager.log('sp. attack: ' + this.spAttack, this);
			TinyLogManager.log('sp. defense: ' + this.spDefense, this);
			TinyLogManager.log('speed: ' + this.speed, this);
		}
		
		public function toJSON() : Object
		{
			var jsonObject : Object = {};
			
			jsonObject.hp = this.hp;
			jsonObject.attack = this.attack;
			jsonObject.defense = this.defense;
			jsonObject.spAttack = this.spAttack;
			jsonObject.spDefense = this.spDefense;
			jsonObject.speed = this.speed;
			
			return jsonObject;
		}

		public static function getStatStageMultiplier( stage : int ) : Number 
		{
			// Clamp to -6, +6
			stage = Math.min(Math.max(stage, -6), 6);
			
			// Return multiplier
			switch (stage) 
			{
				case -6: return 0.250;
				case -5: return 0.285;
				case -4: return 0.333;
				case -3: return 0.400;
				case -2: return 0.500;
				case -1: return 0.666;
				case  0: return 1.000;
				case  1: return 1.500;
				case  2: return 2.000;
				case  3: return 2.500;
				case  4: return 3.000;
				case  5: return 3.500;
				case  6: return 4.000;
			}
			
			return 1.0;	
		}
	}
}
