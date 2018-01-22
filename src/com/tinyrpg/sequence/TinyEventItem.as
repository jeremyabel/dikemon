package com.tinyrpg.sequence 
{

	/**
	 * @author jeremyabel
	 */
	public class TinyEventItem 
	{
		// Field Events
		public static const DIALOG	 	  			: String = 'DIALOG';
		public static const CONDITIONAL	 			: String = 'CONDITIONAL';
		public static const BATTLE		 			: String = 'BATTLE';
		public static const ADD_NPC		 			: String = 'ADD_NPC';
		public static const REMOVE_NPC	  			: String = 'REMOVE_NPC';
		public static const SHOW_EMOTE				: String = 'SHOW_EMOTE';
		public static const HIDE_EMOTE				: String = 'HIDE_EMOTE';
		public static const SET_FACING				: String = 'SET_FACING';
		public static const SUB_SEQUENCE  			: String = 'SUB_SEQUENCE';
		public static const GIVE_ITEM	  			: String = 'GIVE_ITEM';
		public static const TAKE_ITEM	  			: String = 'TAKE_ITEM';
		public static const GIVE_MONEY	  			: String = 'GIVE_MONEY';
		public static const TAKE_MONEY				: String = 'TAKE_MONEY';
		public static const WALK		  			: String = 'WALK';
		public static const SET_POSITION  			: String = 'SET_POSITION';
		public static const SET_VISIBLITY 			: String = 'SET_VISIBILITY';
		public static const SHOW_OBJECT	  			: String = 'SHOW_OBJECT';
		public static const HIDE_OBJECT	  			: String = 'HIDE_OBJECT';
		public static const PLAY_ANIM	  			: String = 'PLAY_ANIM';
		public static const PLAY_SOUND	  			: String = 'PLAY_SOUND';
		public static const PLAY_MUSIC	  			: String = 'PLAY_MUSIC';
		public static const DELAY		  			: String = 'DELAY';
		public static const SET_FLAG	  			: String = 'SET_FLAG';
		public static const HEAL_ALL	  			: String = 'HEAL_ALL';
		public static const END			  			: String = 'END';
		public static const FINAL_END	  			: String = 'FINAL_END';
		
		// Battle Events
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
		public static const PLAY_BALL_ANIM			: String = 'PLAY_BALL_ANIM';
		public static const GET_IN_BALL				: String = 'GET_IN_BALL';
		public static const ESCAPE_FROM_BALL		: String = 'ESCAPE_FROM_BALL';
		public static const PLAYER_HEAL				: String = 'PLAYER_HEAL';
		public static const PLAYER_ATTACK			: String = 'PLAYER_ATTACK';
		public static const ENEMY_ATTACK			: String = 'ENEMY_ATTACK'; 
		public static const PLAYER_HIT_DAMAGE		: String = 'PLAYER_HIT_DAMAGE';
		public static const ENEMY_HIT_DAMAGE		: String = 'ENEMY_HIT_DAMAGE';
		public static const PLAYER_HIT_SECONDARY 	: String = 'PLAYER_HIT_SECONDARY';
		public static const ENEMY_HIT_SECONDARY 	: String = 'ENEMY_HIT_SECONDARY';
		
		public var type   : String;
		public var thingToDo : *;
		
		public function TinyEventItem( eventType : String, thingToDo : * )
		{
			this.type = eventType;
			this.thingToDo = thingToDo;
		}
	}
}
