package com.tinyrpg.events 
{
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyStatsEntity;

	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleEvent extends Event 
	{
		public static var TURN_DONE 			: String = 'TURN_DONE';
		public static var ATTACK_SELECTED		: String = 'ATTACK_SELECTED';
		public static var SWITCH_SELECTED		: String = 'SWITCH_SELECTED';
		public static var SPECIAL_SELECTED		: String = 'SPECIAL_SELECTED';
		public static var ITEM_SELECTED 		: String = 'ITEM_SELECTED';
		public static var RUN_SELECTED			: String = 'RUN_SELECTED';
		
		public static var MOVE_SELECTED			: String = 'MOVE_SELECTED';
		public static var MON_SELECTED			: String = 'MON_SELECTED';
		
		public static var ENEMY_SELECTED		: String = 'ENEMY_SELECTED';
		public static var ITEM_USED				: String = 'ITEM_USED';
		public static var ITEM_MOVE_SELECTED	: String = 'ITEM_MOVE_SELECTED';
		
		public static var GAME_OVER				: String = 'GAME_OVER';
		public static var BATTLE_COMPLETE		: String = 'BATTLE_COMPLETE';
		
		public var attacker : TinyStatsEntity;
		public var defender : TinyStatsEntity;
		public var item		: TinyItem;
		
		public function TinyBattleEvent(type : String, defender : TinyStatsEntity = null, item : TinyItem = null)
		{
			this.defender = defender;
			this.item = item;
			super(type, false, false);
		}
	}
}
