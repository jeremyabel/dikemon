package com.tinyrpg.core 
{
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
		
		public var name 		: String;
		public var description  : String;
		public var price 		: int;		
		public var effect		: String;
		public var graphics		: String;
		public var quantity 	: int = 1;
		public var itemID		: int;
		public var effectAmount	: int;
		public var isBall		: Boolean = false;
		public var isRepel 		: Boolean = false;
		public var healPP 		: Boolean = false;
		public var healHP		: Boolean = false;
		public var revive		: Boolean = false;
		
		private var trace		: Boolean = false;
		
		public static function newFromXML( xmlData : XML ) : TinyItem
		{
			var newItem : TinyItem = new TinyItem;
			TinyLogManager.log( 'newFromXML', newItem );
			
			// Set properties
			newItem.name = xmlData.child( 'RENAME' ).text();
			newItem.description = xmlData.child( 'DESCRIPTION' ).text();
			newItem.price = int( xmlData.child( 'PRICE' ).text() );
			newItem.effect = xmlData.child( 'EFFECT' ).text();
			newItem.isBall = false;
			
			// Initial parsing for item effects
			var needsAdditionalParsing : Boolean = true;
			switch ( newItem.effect )
			{
				case REVIVE:
					newItem.revive = true;
				case REMOVE_STATUS_PARALYSIS:
				case REMOVE_STATUS_POISON:
				case REMOVE_STATUS_SLEEP:
				case REMOVE_STATUS_BURN:
					needsAdditionalParsing = false;
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
				TinyLogManager.log('new item: ====================================',  newItem);
				TinyLogManager.log('new item ID: ' + newItem.itemID, newItem);
				TinyLogManager.log('new item description: ' + newItem.description, newItem);
				TinyLogManager.log('new item price: ' + newItem.price, newItem);
				TinyLogManager.log('new item isBall: ' + newItem.isBall, newItem);
				TinyLogManager.log('new item effect: ' + newItem.effect, newItem);
				TinyLogManager.log('new item effect amount: ' + newItem.effectAmount, newItem);
			}
			
			return newItem;
		}
	}
}
