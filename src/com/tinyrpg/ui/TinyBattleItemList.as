package com.tinyrpg.ui 
{
	import flash.text.TextField;
	
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.data.TinyItemDataList;
	import com.tinyrpg.display.TinyContentBox;
	import com.tinyrpg.display.IShowHideObject;	
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.display.TinySelectableItemItem;
	import com.tinyrpg.events.TinyBattleMonEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleItemList extends TinyScrollableSelectList implements IShowHideObject 
	{
		private var trainer : TinyTrainer;
		private var descriptionTextField : TextField;
		private var descriptionBox : TinyContentBox;
		
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
			
			super( '', newItemArray, 130, 49, 12, 2, 0, 4 );
			
			// Make description text field
			this.descriptionTextField = TinyFontManager.returnTextField('left', false, true, true);
			this.descriptionTextField.width = 141;
			this.descriptionTextField.height = 20;
			this.descriptionTextField.y = -4;
			
			// Make description content box
			this.descriptionBox = new TinyContentBox( this.descriptionTextField, 144, 33 );
			this.descriptionBox.x = -14;
			this.descriptionBox.y = 56;
			
			// Add 'em up
			this.addChild( this.descriptionBox );
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
		}

		public function hide() : void
		{
			TinyLogManager.log('hide', this);
			this.visible = false;
		}
		
		override protected function onControlAdded( e : TinyInputEvent ) : void
		{
			super.onControlAdded(e);
			
			if ( this.itemArray.length > 0 ) 
			{
				// Update or clera description box
				if ( this.selectedItem.textString != CANCEL_OPTION )
				{
					var itemText : String = TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString ).description;
					this.setDescriptionText( itemText );
				}
				else
				{
					this.setDescriptionText( '' );
				}
			}
		}

		override protected function onControlRemoved( e : TinyInputEvent ) : void
		{
			super.onControlRemoved( e );
			
			// Empty the description dialog box
			this.setDescriptionText( '' );
			
			// Clear the selected item
			this.selectedItem = null;
		}

		override protected function onArrowUp( e : TinyInputEvent ) : void
		{
			if ( this.itemArray.length > 0 )
			{
				super.onArrowUp( e );
								
				// Update or clera description box
				if ( this.selectedItem.textString != CANCEL_OPTION )
				{
					var itemText : String = TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString ).description;
					this.setDescriptionText( itemText );
				}
				else
				{
					this.setDescriptionText( '' );	
				}
			}
		}
		
		override protected function onArrowDown( e : TinyInputEvent ) : void
		{
			if ( this.itemArray.length > 0 ) 
			{
				super.onArrowDown( e );
								
				// Update or clera description box			
				if ( this.selectedItem.textString != CANCEL_OPTION )
				{
					var itemText : String = TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString ).description;
					this.setDescriptionText( itemText );
				}
				else
				{
					this.setDescriptionText( '' );
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
					this.dispatchEvent( new TinyBattleMonEvent( TinyBattleMonEvent.ITEM_USED, null, null, TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString ) ) );
				}
			}
		}
		
		private function setDescriptionText( description : String ) : void 
		{
			this.descriptionTextField.htmlText = TinyFontManager.returnHtmlText( description, 'dialogText' );
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
