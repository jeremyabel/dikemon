package com.tinyrpg.core 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;

	import com.tinyrpg.data.TinyMoneyAmount;
	import com.tinyrpg.data.TinyItemDataList;
	import com.tinyrpg.display.TinySpriteSheet;
	import com.tinyrpg.events.TinyFieldMapEvent;
	import com.tinyrpg.lookup.TinyMonLookup;
	import com.tinyrpg.lookup.TinyNameLookup;
	import com.tinyrpg.lookup.TinySpriteLookup;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyJSONUtils;

	/**
	 * @author jeremyabel
	 */
	public class TinyTrainer extends EventDispatcher
	{
		public var squad : Array = [];
		public var squadInPC : Array = [];
		public var inventory : Array = [];
		
		public var runAttempts : int = 0;
		public var usedWish : Boolean = false;
		public var money : TinyMoneyAmount;
		public var isEnemy : Boolean;
		public var repelStepCounter : uint = 0;
		
		protected var m_usedRepel : Boolean = false;
		protected var m_name : String;
		protected var m_battleBitmap : Bitmap;
		protected var m_overworldSpriteId : int; 
		
		public function get name() : String { return this.m_name; }
		public function get overworldSpriteId() : int { return this.m_overworldSpriteId; }
		public function get battleBitmap() : Bitmap { return this.m_battleBitmap; }
		public function get usedRepel() : Boolean { return this.m_usedRepel; }
	
		public function TinyTrainer( battleSpriteData : BitmapData, name : String )
		{
			m_name = name;
			m_battleBitmap = new Bitmap( battleSpriteData );
			m_overworldSpriteId = TinySpriteLookup.getPlayerSpriteId( this.name );
		}
		
		public static function newFromStarterData( name : String = 'Andy' ) : TinyTrainer 
		{
			TinyLogManager.log( 'newFromStarterData: ' + name, TinyTrainer );
			
			var newTrainer : TinyTrainer = new TinyTrainer( TinySpriteLookup.getTrainerSprite( name ), name );
			
			var starterName : String = TinyNameLookup.getStarterNameForPlayerName( name );
			var starterMon : TinyMon = TinyMonLookup.getInstance().getMonByHuman( starterName );
			newTrainer.squad.push( starterMon );
			
			// TODO: REMOVE, FOR TESTING
			starterMon.dealDamage( 5 );
			starterMon.isPoisoned = true;
			
			// TODO: REMOVE, FOR TESTING
			var item1 : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( 'Potion' );
			var item2 : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( 'Super Potion' );
			var item3 : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( 'Antidote' );
			var item4 : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( 'Revive' );
			var item5 : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( 'Ether' );
			var item6 : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( 'Repel' );
			var item7 : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( 'Ultraball' );
			
			newTrainer.addItem( item1 );
			newTrainer.addItem( item1 );
			newTrainer.addItem( item1 );
			newTrainer.addItem( item2 );
			newTrainer.addItem( item3 );
			newTrainer.addItem( item3 );
			newTrainer.addItem( item4 );
			newTrainer.addItem( item5 );
			newTrainer.addItem( item6 );
			newTrainer.addItem( item6 );
			newTrainer.addItem( item7 );
			newTrainer.addItem( item7 );
			
			// Give starting allowance
			newTrainer.money = new TinyMoneyAmount( 3000 );
			
			trace( JSON.stringify( newTrainer.toJSON() ) );
			
			return newTrainer;
		}
		
		public static function newFromSequenceCommand( name : String, mons : Array, money : uint = 0 ) : TinyTrainer
		{
			var newTrainer : TinyTrainer = new TinyTrainer( TinySpriteLookup.getTrainerSprite( name ), name );
			newTrainer.money = new TinyMoneyAmount( money );
			newTrainer.isEnemy = true;
			
			for ( var i : uint = 0; i < mons.length; i++ )
			{
				newTrainer.squad.push( mons[ i ] );
			}
	
			return newTrainer;
		}
		
		public static function newFromJSON( jsonObject : Object ) : TinyTrainer
		{
			TinyLogManager.log( 'newFromJSON: ' + jsonObject.name, TinyTrainer );
						
			var newTrainer : TinyTrainer = new TinyTrainer( TinySpriteLookup.getTrainerSprite( jsonObject.name ), jsonObject.name );
			
			newTrainer.squad = TinyJSONUtils.parseMonSquadJSON( jsonObject.squad );
			newTrainer.squadInPC = TinyJSONUtils.parseMonSquadJSON( jsonObject.squadInPC );
			newTrainer.inventory = TinyJSONUtils.parseInventoryJSON( jsonObject.inventory );
			newTrainer.money = new TinyMoneyAmount( jsonObject.money );
			newTrainer.usedRepel = jsonObject.usedRepel;
			newTrainer.runAttempts = jsonObject.runAttempts;
			newTrainer.repelStepCounter = jsonObject.repelStepCounter;
	
			// TODO: REMOVE, FOR TESTING
			var starterName : String = TinyNameLookup.getStarterNameForPlayerName( 'Chris' );			
			var starterMon : TinyMon = TinyMonLookup.getInstance().getMonByHuman( starterName );
			newTrainer.squad.push( starterMon );
			
			// TODO: REMOVE, FOR TESTING
			var item1 : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( 'Potion' );
			var item2 : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( 'Super Potion' );
			var item3 : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( 'Antidote' );
			var item4 : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( 'Revive' );
			var item5 : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( 'Ether' );
			var item6 : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( 'Repel' );
			var item7 : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( 'Ultraball' );
			
			newTrainer.addItem( item7 );
			newTrainer.addItem( item7 );
			
			return newTrainer;
		}
		
		public function toJSON() : Object
		{
			var jsonObject : Object = {};
			
			jsonObject.name = this.name;
			jsonObject.squad = TinyJSONUtils.monSquadToJSONArray( this.squad );
			jsonObject.squadInPC = TinyJSONUtils.monSquadToJSONArray( this.squadInPC );
			jsonObject.inventory = TinyJSONUtils.inventoryToJSONArray( this.inventory );
			jsonObject.runAttempts = this.runAttempts;
			jsonObject.money = this.money.value;
			jsonObject.usedRepel = this.usedRepel;
			jsonObject.repelSteps = this.repelStepCounter;

			return jsonObject;
		}
		
		public function getMonAtIndex( index : int ) : TinyMon 
		{
			return this.squad[index];
		}
		
		public function getFirstHealthyMon() : TinyMon
		{
			for (var i : int = 0; i < this.squad.length; i++) 
			{
				var mon : TinyMon = this.squad[i];
				
				if ( mon.isHealthy )
				{
					return mon;					
				}
			}
			
			return null;
		}
		
		public function postBattleCleanup() : void
		{
			TinyLogManager.log('postBattleCleanup', this);
			
			this.runAttempts = 0;
			this.usedWish = false;			
		}
		
		public function hasAnyHealthyMons() : Boolean
		{
			var anyHealthy : Boolean = false;
			for each (var mon : TinyMon in this.squad) 
			{
				if ( mon.isHealthy ) anyHealthy = true;
			}
			
			return anyHealthy;
		}
		
		public function addItem( item : TinyItem ) : void
		{
			// Check if the item exists in the inventory already 
			for ( var i : int = 0; i < this.inventory.length; i++ )
			{
				var currentItem : TinyItem = this.inventory[ i ];
				
				// If the item has been found, increment the quantity
				if ( currentItem.name == item.name ) 
				{	
					currentItem.quantity++;
					
					TinyLogManager.log( 'addItem: ' + item.name + ' quantity = ' + currentItem.quantity, this );
					return;
				}
			}
			
			// If the item has not been found, add it with a quantity of 1
			TinyLogManager.log( 'addItem: ' + item.name, this );
			this.inventory.push( item );
			item.quantity = 1;
		}

		public function removeItem( item : TinyItem ) : void
		{
			var itemInInventory : Boolean = false;
		
			// Find the matching item to remove from the inventory
			for ( var i : int = 0; i < this.inventory.length; i++ )
			{
				var currentItem : TinyItem = this.inventory[ i ];
				
				if ( currentItem.name == item.name ) 
				{	
					currentItem.quantity--;
					
					TinyLogManager.log( 'removeItem: ' + item.name + ' quantity = ' + currentItem.quantity, this );
							
					// If the item quantity is 0, remove the item entry from the inventory
					if ( currentItem.quantity <= 0 )
					{
						this.inventory.splice( this.inventory.indexOf( currentItem ), 1 );	
					}
					
					// Item removed, exit early
					return;
				}
			}
		}
		
		public function hasItem( item : TinyItem ) : Boolean
		{
			for ( var i : int = 0; i < this.inventory.length; i++ )
			{
				var currentItem : TinyItem = this.inventory[ i ];
				
				if ( currentItem.name == item.name ) 
				{
					TinyLogManager.log( 'hasItem: ' + item.name + ', true', this );	
					return true;
				}
			}
			
			TinyLogManager.log( 'hasItem: ' + item.name + ', false', this );
			return false;
		}
		
		public function addMoney( amount : int ) : void
		{
			TinyLogManager.log( 'addMoney: ' + amount, this );
			
			this.money.value += amount;
			TinyLogManager.log( 'current money: ' + this.money.value, this );
		}
		
		public function removeMoney( amount : int ) : void
		{
			TinyLogManager.log( 'removeMoney: ' + amount, this );
			
			this.money.value = Math.max( 0, this.money.value - amount );
			TinyLogManager.log( 'current money: ' + this.money.value, this );
		}
		
		public function set usedRepel( value ) : void 
		{
			TinyLogManager.log( 'usedRepel: ' + value, this );
			this.m_usedRepel = value;
			this.repelStepCounter = 0;				
		}
		
		public function incrementRepelCounter() : void
		{
			if ( !this.usedRepel ) return;
			
			this.repelStepCounter++;
			TinyLogManager.log( 'incrementRepelCounter: ' + this.repelStepCounter, this );
			
			// Repel wears off after 200 steps
			if ( this.repelStepCounter >= 200 )
			{
				this.usedRepel = false;
					
				TinyLogManager.log( 'repel has worn off!', this );
				
				// Trigger the event which shows the "repel has worn off!" dialog box.
				// The listener for this event is in TinyGameManager.
				this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.REPEL_WORE_OFF ) );
			}
		}
	}
}
