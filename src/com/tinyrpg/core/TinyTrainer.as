package com.tinyrpg.core 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import com.tinyrpg.display.TinySpriteSheet;
	import com.tinyrpg.lookup.TinyMonLookup;
	import com.tinyrpg.lookup.TinyNameLookup;
	import com.tinyrpg.lookup.TinySpriteLookup;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyTrainer 
	{
		public var squad : Array = [];
		public var inventory : Array = [];
		
		public var runAttempts : int = 0;
		public var usedWish : Boolean = false;
		public var money : uint = 100;
		public var isEnemy : Boolean;
		
		protected var m_name : String;
		protected var m_battleBitmap : Bitmap;
		protected var m_overworldSpriteId : int; 
		
		public function get name() : String { return m_name; }
		public function get overworldSpriteId() : int { return m_overworldSpriteId; }
		public function get battleBitmap() : Bitmap { return m_battleBitmap; }
		
		public function TinyTrainer( battleSpriteData : BitmapData, name : String )
		{
			m_name = name;
			m_battleBitmap = new Bitmap( battleSpriteData );
			m_overworldSpriteId = TinySpriteLookup.getPlayerSpriteId( this.name );
		}
		
		public static function newFromStarterData( name : String = 'Andy' ) : TinyTrainer 
		{
			var newTrainer : TinyTrainer = new TinyTrainer( TinySpriteLookup.getTrainerSprite( name ), name );
			
			var starterName : String = TinyNameLookup.getStarterNameForPlayerName( name );
			newTrainer.squad.push( TinyMonLookup.getInstance().getMonByHuman( starterName ) );
			
			return newTrainer;
		}
		
		public static function newFromSequenceCommand( name : String, mons : Array, money : uint = 0 ) : TinyTrainer
		{
			var newTrainer : TinyTrainer = new TinyTrainer( TinySpriteLookup.getTrainerSprite( name ), name );
			newTrainer.money = money;
			newTrainer.isEnemy = true;
			
			for ( var i : uint = 0; i < mons.length; i++ )
			{
				newTrainer.squad.push( mons[ i ] );
			}
	
			return newTrainer;
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
			
			this.money += amount;
			TinyLogManager.log( 'current money: ' + this.money, this );
		}
		
		public function removeMoney( amount : int ) : void
		{
			TinyLogManager.log( 'removeMoney: ' + amount, this );
			
			this.money = Math.max( 0, this.money - amount );
			TinyLogManager.log( 'current money: ' + this.money, this );
		}
	}
}
