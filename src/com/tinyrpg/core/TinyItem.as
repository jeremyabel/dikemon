package com.tinyrpg.core 
{
	import com.tinyrpg.battle.TinyBattleStrings;
	import com.tinyrpg.data.TinyItemUseResult;
	import com.tinyrpg.data.TinyMoneyAmount;
	import com.tinyrpg.managers.TinyGameManager;
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
		public var originalName		: String;
		public var description  	: String;
		public var price 			: TinyMoneyAmount;		
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
			newItem.originalName = xmlData.child( 'NAME' ).text();
			newItem.name = xmlData.child( 'RENAME' ).text();
			newItem.description = xmlData.child( 'DESCRIPTION' ).text();
			newItem.price = new TinyMoneyAmount( int( xmlData.child( 'PRICE' ).text() ) );
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

		public function toJSON() : Object
		{
			var jsonObject : Object = {};
			
			jsonObject.name = this.name;
			jsonObject.quantity = this.quantity;
			
			return jsonObject;
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
		
		public function checkCanUse( useContext : String, targetMon : TinyMon = null ) : TinyItemUseResult
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
				
				// Can't use PP items out of battle (because I'm too lazy)
				if ( this.healPP ) 
				{
					return new TinyItemUseResult( false, TinyBattleStrings.CANT_USE_ITEM_FIELD );
				}
				
				// Repels CAN be be used in the field
				if ( this.isRepel ) 
				{
					return new TinyItemUseResult( true, null );	
				}
				
				// All other field items require a mon to be selected. If one isn't, return an alert
				if ( !targetMon ) 
				{
					return new TinyItemUseResult( true, 'MON REQUIRED', true );
				}
			}
			
			// Generic checks
			
			// Can't use a non-revive item on a dead mon
			if ( !this.revive && !targetMon.isHealthy )
			{
				return new TinyItemUseResult( false, TinyBattleStrings.CANT_USE_DEAD );
			}
			
			// Can't use a revive item on a non-dead mon
			if ( this.revive && targetMon.isHealthy )
			{
				return new TinyItemUseResult( false, TinyBattleStrings.CANT_USE_ALIVE );
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
		
		
		public function useItem( targetMon : TinyMon = null ) : String
		{
			if ( targetMon ) 
			{
				TinyLogManager.log( 'useItem: ' + this.name + ' on ' + targetMon.name, this );
				
				var itemUsedString : String;
				
				// Resolve burning
				if ( this.healBurn ) 
				{
					TinyLogManager.log( 'heal status: BURN', this );
					itemUsedString = TinyBattleStrings.getBattleString( TinyBattleStrings.BURN_HEAL, targetMon );
					targetMon.isBurned = false;
				}
				
				// Resolve paralysis
				if ( this.healParalysis )
				{
					TinyLogManager.log( 'heal status: PARALYSIS', this );
					itemUsedString = TinyBattleStrings.getBattleString( TinyBattleStrings.PARALYSIS_HEALED, targetMon );
					targetMon.isParaylzed = false;
				}
				
				// Resolve poison
				if ( this.healPoison )
				{
					TinyLogManager.log( 'heal status: POISON', this );
					itemUsedString = TinyBattleStrings.getBattleString( TinyBattleStrings.POISON_HEAL, targetMon );
					targetMon.isPoisoned = false;
				}
	
				// Resolve sleep			
				if ( this.healSleep )
				{
				 	TinyLogManager.log( 'heal status: SLEEP', this );
				 	itemUsedString = TinyBattleStrings.getBattleString( TinyBattleStrings.WOKE_UP_ITEM, targetMon );
				 	targetMon.setSleepCounter( 0 );
				}
				
				// Recover HP
				if ( this.healHP )
				{
					TinyLogManager.log( 'heal HP: ' + this.effectAmount, this );
					targetMon.recoverHP( this.effectAmount );
					
					if ( targetMon.isMaxHP ) {
						itemUsedString = TinyBattleStrings.getBattleString( TinyBattleStrings.HP_FULL, targetMon );
					} else {
						itemUsedString = TinyBattleStrings.getBattleString( TinyBattleStrings.REGAINED_HEALTH, targetMon );
					}
				}
				
				// Revive
				if ( this.revive ) 
				{	
					// Revives heal the target mon to half of their max HP
					var revivedHP : int = Math.floor( targetMon.maxHP / 2 );
					TinyLogManager.log( 'revived with HP: ' + revivedHP, this );
					targetMon.recoverHP( revivedHP );
					itemUsedString = TinyBattleStrings.getBattleString( TinyBattleStrings.REVIVED, targetMon );
				}
				
				return itemUsedString;
			}
			else
			{
				TinyLogManager.log( 'useItem: ' + this.name, this );
				
				if ( this.isRepel ) 
				{
					TinyGameManager.getInstance().playerTrainer.usedRepel = true;
				}
				
				return null;
			}
		}
	}
}
