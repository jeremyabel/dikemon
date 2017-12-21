package com.tinyrpg.misc 
{

	/**
	 * @author jeremyabel
	 */
	public class TinyEventItem 
	{
		public static const DIALOG	 	  : String = 'DIALOG';
		public static const DIALOG_CHOICE : String = 'DIALOG_CHOICE';
		public static const DIALOG_CUSTOM : String = 'DIALOG_CUSTOM';
		public static const CONDITIONAL	  : String = 'CONDITIONAL';
		public static const BATTLE		  : String = 'BATTLE';
		public static const ADD_NPC		  : String = 'ADD_NPC';
		public static const REMOVE_NPC	  : String = 'REMOVE_NPC';
		public static const ATTACK		  : String = 'ATTACK';
		public static const SUB_SEQUENCE  : String = 'SUB_SEQUENCE';
		public static const GIVE_ITEM	  : String = 'GIVE_ITEM';
		public static const TAKE_ITEM	  : String = 'TAKE_ITEM';
		public static const GIVE_GOLD	  : String = 'GIVE_GOLD';
		public static const TAKE_GOLD	  : String = 'TAKE_GOLD';
		public static const WALK		  : String = 'WALK';
		public static const SET_POSITION  : String = 'SET_POSITION';
		public static const SET_VISIBLITY : String = 'SET_VISIBILITY';
		public static const SHOW_OBJECT	  : String = 'SHOW_OBJECT';
		public static const HIDE_OBJECT	  : String = 'HIDE_OBJECT';
		public static const PLAY_ANIM	  : String = 'PLAY_ANIM';
		public static const PLAY_FX		  : String = 'PLAY_FX';
		public static const PLAY_SOUND	  : String = 'PLAY_SOUND';
		public static const PLAY_MUSIC	  : String = 'PLAY_MUSIC';
		public static const DELAY		  : String = 'DELAY';
		public static const SET_FLAG	  : String = 'SET_FLAG';
		public static const HEAL_ALL	  : String = 'HEAL_ALL';
		public static const RECRUIT		  : String = 'RECRUIT';
		public static const END			  : String = 'END';
		public static const FINAL_END	  : String = 'FINAL_END';
		
		// BATTLE EVENTS
		public static const SHOW_TRAINER 			: String = 'SHOW_TRAINER';
		public static const HIDE_TRAINER 			: String = 'HIDE_TRAINER';
		public static const SET_STAT_MON  			: String = 'SHOW_STAT_MON';
		public static const SUMMON_MON 	  			: String = 'SUMMON_MON';
		public static const RECALL_MON	  			: String = 'RECALL_MON';
		public static const FAINT_MON			  	: String = 'FAINT_MON';
		public static const UPDATE_HP	   			: String = 'UPDATE_HP';
		public static const UPDATE_EXP 	  			: String = 'UPDATE_EXP';
		public static const FILL_EXP_BAR			: String = 'FILL_EXP_BAR';
		public static const CLEAR_EXP_BAR			: String = 'CLEAR_EXP_BAR';
		public static const INCREMENT_LEVEL			: String = 'INCREMENT_LEVEL';
		public static const SHOW_LEVEL_UP_STATS		: String = 'SHOW_LEVEL_UP_STATS';
		public static const SHOW_DELETE_MOVE		: String = 'SHOW_DELETE_MOVE';
		public static const DEAL_DAMAGE				: String = 'DEAL_DAMAGE';
		public static const PLAY_ATTACK_ANIM		: String = 'PLAY_ATTACK_ANIM';
		public static const PLAY_STATUS_ANIM		: String = 'PLAY_STATUS_ANIM';
		public static const PLAYER_ATTACK			: String = 'PLAYER_ATTACK';
		public static const ENEMY_ATTACK			: String = 'ENEMY_ATTACK'; 
		public static const PLAYER_HIT_DAMAGE		: String = 'PLAYER_HIT_DAMAGE';
		public static const ENEMY_HIT_DAMAGE		: String = 'ENEMY_HIT_DAMAGE';
		public static const PLAYER_HIT_SECONDARY 	: String = 'PLAYER_HIT_SECONDARY';
		public static const ENEMY_HIT_SECONDARY 	: String = 'ENEMY_HIT_SECONDARY';
		
		// SPECIAL END STUFF
		public static const FADE_FLASH_OUT : String = 'FADE_FLASH_OUT';
		public static const FLASH_SCREEN   : String = 'FLASH_SCREEN';
		public static const OPEN_DOOR	   : String = 'OPEN_DOOR';
		public static const PLAY_NUKE	   : String = 'PLAY_NUKE';
		public static const EVERYBODY_OUT  : String = 'EVERYBODY_OUT';
		public static const SUCK_TO_CENTER : String = 'SUCK_TO_CENTER';
		public static const SHOW_HYBRID	   : String = 'SHOW_HYBRID';
		
		public var type   : String;
		public var thingToDo : *;
		public var battle : Boolean = false;
		
		public function TinyEventItem(eventType : String, thingToDo : *, battle : Boolean = false)
		{
			this.type = eventType;
			this.thingToDo = thingToDo;
			this.battle = battle;
		}
	}
}
