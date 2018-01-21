package com.tinyrpg.core 
{
	import com.tinyrpg.battle.TinyBattleStrings;
	import com.tinyrpg.data.TinyItemUseResult;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.events.EventDispatcher;

	public class TinyItem extends EventDispatcher
	{
		private static var REMOVE_STATUS_PARALYSIS	: String = '-PARALYZE';  
		private static var REMOVE_STATUS_POISON 	: String = '-POISON';
		private static var REMOVE_STATUS_SLEEP		: String = '-SLEEP';
		private static var REMOVE_STATUS_BURN		: String = '-BURN';
		private static var HEAL_HP					: String = 'HP';
		private static var HEAL_PP					: String = 'PP';
		private static var REVIVE					: String = 'REVIVE';
		private static var REPEL					: String = 'REPEL';
		private static var CATCH_RATE				: String = 'CATCHRATE';
		
		public static var ITEM_CONTEXT_BATTLE		: String = 'ITEM_CONTEXT_BATTLE';
		public static var ITEM_CONTEXT_FIELD 		: String = 'ITEM_CONTEXT_FIELD';
		
		public var name 			: String;
		public var description  	: String;
		public var price 			: int;		
		public var effect			: String;
		public var graphics			: String;
		public var quantity 		: int = 1;
		public var itemID			: int;
		public var effectAmount		: int;
		public var isBall			: Boolean = false;
		public var isRepel 			: Boolean = false;
		public var healPP 			: Boolean = false;
		public var healHP			: Boolean = false;
		public var healBurn 		: Boolean = false;
		public var healConfusion	: Boolean = false;
		public var healPoison		: Boolean = false;
		public var healParalysis	: Boolean = false;
		public var healSleep		: Boolean = false;
		public var healStatus		: Boolean = false;
		public var revive			: Boolean = false;
		
		private var trace			: Boolean = false;
		
		public static function newFromXML( xmlData : XML ) : TinyItem
		{
			var newItem : TinyItem = new TinyItem;
			TinyLogManager.log( 'newFromXML', newItem );
			
			// Set properties
			newItem.name = xmlData.child( 'RENAME' ).text();
			newItem.description = xmlData.child( 'DESCRIPTION' ).text();
			newItem.price = int( xmlData.child( 'PRICE' ).text() );
			newItem.effect = xmlData.child( 'EFFECT' ).text();
			
			// Initial parsing for item effects
			var needsAdditionalParsing : Boolean = true;
			switch ( newItem.effect )
			{
				case REVIVE:					needsAdditionalParsing = false; newItem.healStatus = true; newItem.revive = true; break;
				case REMOVE_STATUS_PARALYSIS: 	needsAdditionalParsing = false; newItem.healStatus = true; newItem.healParalysis = true; break;
				case REMOVE_STATUS_POISON:		needsAdditionalParsing = false; newItem.healStatus = true; newItem.healPoison = true; break;
				case REMOVE_STATUS_SLEEP:		needsAdditionalParsing = false; newItem.healStatus = true; newItem.healSleep = true; break;
				case REMOVE_STATUS_BURN:		needsAdditionalParsing = false; newItem.healStatus = true; newItem.healBurn = true; break;
				default: break;
			}
			
			// Do any additional parsing
			if ( needsAdditionalParsing ) 
			{
				// Remove underscores 
				var regex : RegExp = /_/g;
				var effectStrings : Array = newItem.effect.split( regex );
				var effectName : String = ( effectStrings[ 0 ] as String ).replace( regex, '' );
				var effectAmount : int = int( ( effectStrings[ 1 ] as String ).replace( regex, '' ) );

				switch ( effectName )
				{
					case REPEL: newItem.isRepel = true; break;
					case HEAL_HP: newItem.healHP = true; break;
					case HEAL_PP: newItem.healPP = true; break;		
					case CATCH_RATE: newItem.isBall = true; break; 
					default: break;
				}
				
				newItem.effectAmount = effectAmount;
			}
			
			TinyLogManager.log('new item: ' + newItem.name, newItem);
			
			// Trace stuff
			if ( newItem.trace ) 
			{
				newItem.printLog();
			}
			
			return newItem;
		}
		
		public function printLog() 
		{
			TinyLogManager.log('item: ====================================',  this);
			TinyLogManager.log('item name: ' + this.name, this);
			TinyLogManager.log('item ID: ' + this.itemID, this);
			TinyLogManager.log('item description: ' + this.description, this);
			TinyLogManager.log('item price: ' + this.price, this);
			TinyLogManager.log('item isBall: ' + this.isBall, this);
			TinyLogManager.log('item effect: ' + this.effect, this);
			TinyLogManager.log('item effect amount: ' + this.effectAmount, this);
		}
		
		public function checkCanUse( useContext : String, targetMon : TinyMon ) : TinyItemUseResult
		{
			TinyLogManager.log("checkCanUse: " + useContext, this);
			
			// Battle-specific checks
			if ( useContext == TinyItem.ITEM_CONTEXT_BATTLE )
			{	
				// Can't use a revive or repel in battle
				if ( this.revive || this.isRepel )
				{
					return new TinyItemUseResult( false, TinyBattleStrings.CANT_USE_ITEM );				
				}
			}
			
			// Field-specific checks
			if ( useContext == TinyItem.ITEM_CONTEXT_FIELD )
			{
				// Can't use balls out of battle
				if ( this.isBall ) 
				{
					return new TinyItemUseResult( false, TinyBattleStrings.CANT_USE_BALL );
				}
			}
			
			// Generic checks
			
			// Can't use a non-revive item on a dead mon
			if ( !this.revive && !targetMon.isHealthy )
			{
				return new TinyItemUseResult( false, TinyBattleStrings.CANT_USE_DEAD );
			}
			
			// Can't use a healing item on a mon with max HP
			if ( this.healHP && targetMon.isMaxHP )
			{
				return new TinyItemUseResult( false, TinyBattleStrings.CANT_USE_MAX_HP );
			}
			
			// Can't usea paralysis heal on a non-paralyzed mon
			if ( this.healParalysis && !targetMon.isParaylzed )
			{
				return new TinyItemUseResult( false, TinyBattleStrings.CANT_USE_PARALYSIS );
			}
			
			// Can't use a burn heal on a non-burned mon
			if ( this.healBurn && !targetMon.isBurned )
			{
				return new TinyItemUseResult( false, TinyBattleStrings.CANT_USE_BURN );
			}
			
			// Can't use a poison heal on a non-poisoned mon
			if ( this.healPoison && !targetMon.isPoisoned )
			{
				return new TinyItemUseResult( false, TinyBattleStrings.CANT_USE_POISON );
			}
			
			// Can't use a sleep heal on a non-sleeping mon
			if ( this.healSleep && !targetMon.isSleeping )
			{
				return new TinyItemUseResult( false, TinyBattleStrings.CANT_USE_SLEEP );
			}
			
			// Everything looks good, the item can be used
			return new TinyItemUseResult( true, null );
		}
	}
}
