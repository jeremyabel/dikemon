package com.tinyrpg.ui 
{
	import flash.media.Sound;
	import flash.text.TextField;
	
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.data.TinyItemUseResult;
	import com.tinyrpg.data.TinyItemDataList;
	import com.tinyrpg.display.TinyContentBox;
	import com.tinyrpg.display.IShowHideObject;	
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.display.TinySelectableItemItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.events.TinyItemEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.media.sfx.SoundErrorBuzz;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyItemMenu extends TinyScrollableSelectList implements IShowHideObject 
	{
		protected var trainer : TinyTrainer;
		protected var descriptionTextField : TextField;
		protected var descriptionBox : TinyContentBox;
		protected var item : TinyItem;
		

		public function TinyItemMenu( trainer : TinyTrainer, width : uint = 144, height : uint = 90, maxItems : uint = 7 )
		{
			super( '', this.getItemListForTrainer( trainer ), width, height, 12, 2, 0, maxItems );
			
			// Make description text field
			this.descriptionTextField = TinyFontManager.returnTextField( 'left', false, true, true );
			this.descriptionTextField.width = 141;
			this.descriptionTextField.height = 20;
			this.descriptionTextField.y = -6;
			
			// Make description content box
			this.descriptionBox = new TinyContentBox( this.descriptionTextField, 144, 33 );
			this.descriptionBox.x = 0;
			this.descriptionBox.y = 104 - 8;
			
			// Add 'em up
			this.addChild( this.descriptionBox );
		}
		
		
		public function getItemListForTrainer( trainer : TinyTrainer ) : Array
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
			newItemArray.push( new TinySelectableItem( TinyCommonStrings.CANCEL.toUpperCase(), newItemArray.length ) );
			
			return newItemArray;
		}
		
		
		public function refreshItems() : void
		{
			TinyLogManager.log( 'refreshItems', this );
			
			// Keep track of the name of the selected item before the list is reset.
			// The selection of this item will be restored after the list is reset.
			var previousSelectedItemName : String
			if ( this.selectedItem )
			{
				previousSelectedItemName = this.selectedItem.textString;
			}
			
			this.resetListItems( this.getItemListForTrainer( this.trainer ) );
			
			// Restore the previous selected item, if there is one
			if ( previousSelectedItemName ) 
			{
				this.selectedItem = this.getItemByName( previousSelectedItemName );
				
				if ( this.selectedItem )
				{
					TinyLogManager.log( 'restoring previous selection: ' + this.selectedItem.textString, this );
				}
				else 
				{
					TinyLogManager.log( 'previous selection was removed, selecting first item', this );
				}
			}
		}
		
		
		public function removeItem( targetItem : TinyItem ) : void
		{
			TinyLogManager.log('removeItem: ' + targetItem.name, this);
			
			var targetLabel : TinySelectableItem = this.getItemByID( targetItem.itemID );
			this.removeListItem( targetLabel );
		}


		override public function show() : void
		{
			super.show();
			
			// Update item quantities
			for each ( var selectableItem : TinySelectableItem in this.itemArray )
			{
				if ( selectableItem is TinySelectableItemItem )
				{
					( selectableItem as TinySelectableItemItem ).updateQuantity();	
				}
			}	
		}

		
		override protected function onControlAdded( e : TinyInputEvent ) : void
		{
			super.onControlAdded(e);
			
			if ( this.itemArray.length > 0 ) 
			{
				// Update or clear description box
				if ( this.selectedItem.textString.toUpperCase() == TinyCommonStrings.CANCEL.toUpperCase() )
				{
					this.setDescriptionText( '' );
				}
				else
				{
					var itemText : String = TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString ).description;
					this.setDescriptionText( itemText );
				}
			}
		}


		override protected function onControlRemoved( e : TinyInputEvent ) : void
		{
			super.onControlRemoved( e );
			
			// Empty the description dialog box
			this.setDescriptionText( '' );
		}


		override protected function onArrowUp( e : TinyInputEvent ) : void
		{
			if ( this.itemArray.length > 0 )
			{
				super.onArrowUp( e );
								
				// Update or clear description box
				if ( this.selectedItem.textString.toUpperCase() == TinyCommonStrings.CANCEL.toUpperCase() )
				{
					this.setDescriptionText( '' );	
				}
				else
				{
					var itemText : String = TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString ).description;
					this.setDescriptionText( itemText );
				}
			}
		}
		
		
		override protected function onArrowDown( e : TinyInputEvent ) : void
		{
			if ( this.itemArray.length > 0 ) 
			{
				super.onArrowDown( e );
								
				// Update or clear description box			
				if ( this.selectedItem.textString.toUpperCase() != TinyCommonStrings.CANCEL.toUpperCase() )
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
			super.onAccept( e );
			
			if ( this.selectedItem.textString.toUpperCase() == TinyCommonStrings.CANCEL.toUpperCase() )
			{
				this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );	
			}
			else
			{
				// Get the item to be used
				this.item = TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString );
				this.tryUseItem( this.item );
			}
		}
		
		
		protected function tryUseItem( item : TinyItem ) : void
		{
			TinyLogManager.log( 'tryUseItem: ' + item.name, this );
			
			this.item = item;
			
			// Check if the item can be used in the field
			var canUseResult : TinyItemUseResult = this.item.checkCanUse( TinyItem.ITEM_CONTEXT_FIELD );
			
			// If the item cannot be used, show the error string and exit
			if ( !canUseResult.canUse )
			{
				TinyAudioManager.play( new SoundErrorBuzz() as Sound );
				this.setDescriptionText( canUseResult.errorString );
				return;
			}
			
			if ( canUseResult.monRequired ) 
			{
				// If the item requires a mon to be selected, the mon menu needs to be displayed
				this.dispatchEvent( new TinyItemEvent( TinyItemEvent.ITEM_REQUIRES_MON, this.item ) );
			}
			else
			{
				// Otherwise, use the item
				this.dispatchEvent( new TinyItemEvent( TinyItemEvent.ITEM_USED, this.item ) );
			}
		}
		
		
		protected function setDescriptionText( description : String ) : void 
		{
			this.descriptionTextField.htmlText = TinyFontManager.returnHtmlText( description, 'dialogText' );
		}
		
		
		protected function getItemByID( targetID : int ) : TinySelectableItem
		{
			// Find function
			var findFunction : Function = function( item : *, index : int, array : Array ) : Boolean
			{ 
				index; 
				array; 
				return ( TinySelectableItem( item ).idNumber == targetID ); 
			};
			
			// Search for item
			return this.itemArray.filter( findFunction )[ 0 ];
		}
		
		
		protected function getItemByName( targetName : String ) : TinySelectableItem
		{
			TinyLogManager.log( 'getItemByName: ' + targetName, this );
			
			// Find function
			var findFunction : Function = function( item : *, index : int, array : Array ) : Boolean
			{ 
				index; 
				array; 
				return ( TinySelectableItem( item ).textString.toUpperCase() == targetName.toUpperCase() ); 
			};
			
			// Search for item
			return this.itemArray.filter( findFunction )[ 0 ];
		}
	}
}
