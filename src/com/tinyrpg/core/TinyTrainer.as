package com.tinyrpg.core 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import com.tinyrpg.display.TinySpriteSheet;
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
		protected var m_overworldSprite : TinySpriteSheet; 
		protected var m_isEnemy : Boolean;
		
		public function get name() : String { return m_name; }
		public function get battleBitmap() : Bitmap { return m_battleBitmap; }
		public function get isEnemy() : Boolean { return m_isEnemy; }
		
		public function TinyTrainer(battleSpriteData : BitmapData, name : String)
		{
			m_battleBitmap = new Bitmap(battleSpriteData);
			m_name = name;
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
			TinyLogManager.log('addItem: ' + item.name, this);
			
			var itemInInventory : Boolean = false;
			
			for ( var i : int = 0; i < this.inventory.length; i++ )
			{
				var currentItem : TinyItem = this.inventory[ i ];
				if ( currentItem.name == item.name ) 
				{	
					itemInInventory = true;
					currentItem.quantity++;
					
					TinyLogManager.log('removeItem: ' + item.name + ' quantity = ' + currentItem.quantity, this);
					
					break;
				}
			}
			
			if ( !itemInInventory )
			{
				this.inventory.push( item );
				item.quantity = 1;
			}
		}

		public function removeItem( item : TinyItem ) : void
		{
			TinyLogManager.log('removeItem: ' + item.name, this);
			
			var itemInInventory : Boolean = false;
						
			for ( var i : int = 0; i < this.inventory.length; i++ )
			{
				var currentItem : TinyItem = this.inventory[ i ];
				if ( currentItem.name == item.name ) 
				{	
					itemInInventory = true;
					currentItem.quantity--;
					
					TinyLogManager.log('removeItem: ' + item.name + ' quantity = ' + currentItem.quantity, this);
						
					if ( currentItem.quantity <= 0 )
					{
						var index : int = this.inventory.indexOf( currentItem );
						this.inventory.splice( index, 1 );	
					}
					
					break;
				}		
			}
		}
	}
}
