package com.tinyrpg.ui 
{
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.data.TinyItemDataList;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.display.TinySelectableItemItem;
	import com.tinyrpg.events.TinyBattleEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleItemList extends TinySelectList 
	{
		private var trainer : TinyTrainer;
		
		private static const CANCEL_OPTION : String = 'CANCEL';
		
		public function TinyBattleItemList( trainer : TinyTrainer )
		{
			this.trainer = trainer;
			
			var newItemArray : Array = [];
			
			// Add items to selection array
			var i : int = 0;
			for each ( var item : TinyItem in this.trainer.inventory )
			{
				item.itemID = i;
				var newLabel : TinySelectableItemItem = new TinySelectableItemItem( item, item.itemID );
				newItemArray.push( newLabel );
				i++;
			}
			
			// Add CANCEL item
			newItemArray.push( new TinySelectableItem( CANCEL_OPTION, newItemArray.length ) );
			
			super( '', newItemArray, 124, 48, 10, 1, 0 );
		}
		
		public function removeItem( targetItem : TinyItem ) : void
		{
			TinyLogManager.log('removeItem: ' + targetItem.name, this);
			
			var targetLabel : TinySelectableItem = this.getItemByID( targetItem.itemID );
			this.removeListItem( targetLabel );
		}

		public function show() : void
		{
			TinyLogManager.log('show', this);
			
			this.visible = true;
			
			// Update item quantities
			for each ( var selectableItem : TinySelectableItem in this.itemArray )
			{
				if ( selectableItem is TinySelectableItemItem )
				{
					( selectableItem as TinySelectableItemItem ).updateQuantity();	
				}
			}
			
			// TODO: Show the description dialog
		}

		public function hide() : void
		{
			TinyLogManager.log('hide', this);
			
			this.visible = false;
			
			// TODO: Hide the description dialog
		}
		
		override protected function onControlAdded( e : TinyInputEvent ) : void
		{
			super.onControlAdded(e);
			
			if ( this.itemArray.length > 0 ) 
			{
				// TODO: Update helper box
				if ( !this.selectedItem.textString == CANCEL_OPTION )
				{
					var itemText : String = TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString ).description;
				}
				else
				{
					
				}
			}
		}

		override protected function onControlRemoved( e : TinyInputEvent ) : void
		{
			super.onControlRemoved( e );
			
			// TODO: Empty the helper dialog box
		}

		override protected function onArrowUp( e : TinyInputEvent ) : void
		{
			if ( this.itemArray.length > 0 )
			{
				super.onArrowUp( e );
				
				// TODO: Update helper box
				if ( !this.selectedItem.textString == CANCEL_OPTION )
				{
					var itemText : String = TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString ).description;
				}
				else
				{
					
				}
			}
		}
		
		override protected function onArrowDown( e : TinyInputEvent ) : void
		{
			if ( this.itemArray.length > 0 ) 
			{
				super.onArrowDown( e );
				
				// TODO: Update helper box			
				if ( !this.selectedItem.textString == CANCEL_OPTION )
				{
					var itemText : String = TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString ).description;
				}
				else
				{
					
				}
			}
		}
		
		override protected function onAccept( e : TinyInputEvent ) : void
		{
			if ( this.itemArray.length > 0 ) 
			{
				super.onAccept( e );
				
				if ( this.selectedItem.textString == CANCEL_OPTION )
				{
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );	
				}
				else
				{
					this.dispatchEvent( new TinyBattleEvent( TinyBattleEvent.ITEM_USED, null, TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString ) ) );
				}
			}
		}
		
		private function getItemByID( targetID : int ) : TinySelectableItem
		{
			// Find function
			var findFunction : Function = function(item : *, index : int, array : Array) : Boolean
				{ index; array; return (TinySelectableItem(item).idNumber == targetID); };
			
			// Search for character
			return this.itemArray.filter( findFunction )[ 0 ];
		}
	}
}
