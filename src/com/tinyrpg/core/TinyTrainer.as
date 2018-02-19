package com.tinyrpg.core 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import com.tinyrpg.display.TinySpriteSheet;
	import com.tinyrpg.lookup.TinyMonLookup;
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
		
		protected var m_name : String;
		protected var m_battleBitmap : Bitmap;
		protected var m_overworldSpriteId : int; 
		protected var m_isEnemy : Boolean;
		protected var m_money : uint = 100;
		
		public function get name() : String { return m_name; }
		public function get overworldSpriteId() : int { return m_overworldSpriteId; }
		public function get battleBitmap() : Bitmap { return m_battleBitmap; }
		public function get isEnemy() : Boolean { return m_isEnemy; }
		public function get money() : uint { return m_money; }
		
		public function TinyTrainer( battleSpriteData : BitmapData, name : String )
		{
			m_name = name;
			m_battleBitmap = new Bitmap( battleSpriteData );
			m_overworldSpriteId = TinySpriteLookup.getPlayerSpriteId( this.name );
		}
		
		public static function newFromTestData( name : String = 'Player' ) : TinyTrainer 
		{
			var newTrainer : TinyTrainer = new TinyTrainer( TinySpriteLookup.getTrainerSprite( name ), name );
			
			newTrainer.squad.push( TinyMonLookup.getInstance().getMonByName( TinyMonLookup.MON_BUCKET ) );
			newTrainer.squad.push( TinyMonLookup.getInstance().getMonByName( TinyMonLookup.MON_TALL_GRASS ) );
			newTrainer.squad.push( TinyMonLookup.getInstance().getMonByName( TinyMonLookup.MON_BOX ) );
			
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
			
			this.m_money += amount;
			TinyLogManager.log( 'current money: ' + this.money, this );
		}
		
		public function removeMoney( amount : int ) : void
		{
			TinyLogManager.log( 'removeMoney: ' + amount, this );
			
			this.m_money = Math.max( 0, this.m_money - amount );
			TinyLogManager.log( 'current money: ' + this.money, this );
		}
	}
}
