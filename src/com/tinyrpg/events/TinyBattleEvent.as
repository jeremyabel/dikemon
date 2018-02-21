package com.tinyrpg.events 
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.data.TinyMoveData;

	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleEvent extends Event 
	{
		public static var FIGHT_SELECTED	: String = 'FIGHT_SELECTED';
		public static var SWITCH_SELECTED	: String = 'SWITCH_SELECTED';
		public static var ITEM_SELECTED 	: String = 'ITEM_SELECTED';
		public static var RUN_SELECTED		: String = 'RUN_SELECTED';
		public static var MOVE_SELECTED		: String = 'MOVE_SELECTED';
		public static var MON_SELECTED		: String = 'MON_SELECTED';
		public static var ITEM_USED			: String = 'ITEM_USED';
		
		public var move : TinyMoveData;
		public var mon  : TinyMon;
		public var item	: TinyItem;
		
		public function TinyBattleEvent ( type : String, move : TinyMoveData = null, mon : TinyMon = null, item : TinyItem = null )
		{
			this.move = move;
			this.item = item;
			this.mon = mon;
			
			super( type, false, false );
		}
	}
}
