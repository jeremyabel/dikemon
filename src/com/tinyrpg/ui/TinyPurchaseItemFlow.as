package com.tinyrpg.ui
{
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.data.TinyMoneyAmount;
	import com.tinyrpg.data.TinyItemDataList;
	import com.tinyrpg.display.TinyContentBox;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.display.TinySelectableItemItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyPurchaseItemFlow extends Sprite
	{
		private var isSelling				: Boolean;
		private var itemsForSale			: Array = [];
		private var selectedItem			: TinyItem;
		private var itemScrollList			: TinyScrollableSelectList;
		private var descriptionTextField 	: TextField;
		private var descriptionBox 			: TinyContentBox;
		private var currentMoneyTextField 	: TextField;
		private var currentMoneyBox			: TinyContentBox;
		private var purchaseQuantityFlow	: TinyPurchaseQuantityFlow;
		private var purchaseResultsDialog	: TinyDialogBox;
		
		public function TinyPurchaseItemFlow( items : Array, selling : Boolean = false ) : void
		{
			this.itemsForSale = items;
			this.isSelling = selling;
			
			// Create scrollable item list
			this.itemScrollList = new TinyScrollableSelectList( '', this.getShopItemsArray(), 144, 62, 12, 2, 0, 5 );
			this.itemScrollList.x = 8;
			this.itemScrollList.y = 36;
			
			// Make description text field
			this.descriptionTextField = TinyFontManager.returnTextField( 'left', false, true, true );
			this.descriptionTextField.width = 141;
			this.descriptionTextField.height = 20;
			this.descriptionTextField.y = -6;
			
			// Make description content box
			this.descriptionBox = new TinyContentBox( this.descriptionTextField, 144, 33 );
			this.descriptionBox.x = 8;
			this.descriptionBox.y = 104;
			
			// Make current money text field
			this.currentMoneyTextField = TinyFontManager.returnTextField( 'right', false, true, true );
			this.currentMoneyTextField.width = 70;
			this.currentMoneyTextField.height = 12;
			this.currentMoneyTextField.y = -4;
			
			// Make current money content box
			this.currentMoneyBox = new TinyContentBox( this.currentMoneyTextField, 52, 8 );
			this.currentMoneyBox.x = 8;
			this.currentMoneyBox.y = 8;
			
			// Add 'em up
			this.addChild( this.itemScrollList );
			this.addChild( this.descriptionBox );
			this.addChild( this.currentMoneyBox );
		}
		
		
		public function execute() : void
		{
			TinyLogManager.log( 'execute', this );
			
			// Pass control to the item selection list
			this.itemScrollList.addEventListener( TinyInputEvent.SELECTED, this.onItemSelectionChanged );
			this.itemScrollList.addEventListener( TinyInputEvent.ACCEPT, this.onItemSelectionAccept );
			this.itemScrollList.addEventListener( TinyInputEvent.CANCEL, this.onItemSelectionCancel );
			TinyInputManager.getInstance().setTarget( this.itemScrollList );
			
			// Update the interface
			this.updateMoneyLabel();
			this.onItemSelectionChanged();
		}
		
		
		private function onItemSelectionChanged( event : TinyInputEvent = null ) : void
		{
			var selectedItemName : String = this.itemScrollList.selectedItem.textString; 
			TinyLogManager.log( 'onItemSelectionChanged: ' + selectedItemName, this );
			
			// Update or clear description box
			if ( selectedItemName.toUpperCase() == TinyCommonStrings.CANCEL.toUpperCase() )
			{
				this.setDescriptionText( '' );
			}
			else
			{	
				var itemText : String = TinyItemDataList.getInstance().getItemByName( selectedItemName ).description;
				this.setDescriptionText( itemText );
			}
		}
		
		
		private function onItemSelectionAccept( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onItemSelectionAccept', this );
			
			var selectedItemName : String = this.itemScrollList.selectedItem.textString;
			
			// Exit if the CANCEL option was picked
			if ( selectedItemName.toUpperCase() == TinyCommonStrings.CANCEL.toUpperCase() )
			{
				this.onItemSelectionCancel();
				return;
			}
			
			this.selectedItem = TinySelectableItemItem( this.itemScrollList.selectedItem ).item; 
			
			// Create the purchase quantity flow and pass control to it
			this.purchaseQuantityFlow = new TinyPurchaseQuantityFlow( this.selectedItem, this.isSelling );
			this.purchaseQuantityFlow.addEventListener( TinyInputEvent.ACCEPT, this.onPurchaseQuantityAccept );
			this.purchaseQuantityFlow.addEventListener( TinyInputEvent.CANCEL, this.onPurchaseQuantityCancel );
			this.addChild( this.purchaseQuantityFlow );
			this.purchaseQuantityFlow.execute();
			
			// Mark the selected item with a black arrow 
			this.itemScrollList.setStickySelection();
		}
		
		
		private function onItemSelectionCancel( event : TinyInputEvent = null ) : void
		{
			TinyLogManager.log( 'onItemSelectionCancel', this );
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		
		private function onPurchaseQuantityAccept( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onPurchaseQuantityAccept', this );
			
			var purchasePriceString : String;
			var purchaseResultsString : String;
			
			var totalPrice : uint = this.selectedItem.price.value * this.purchaseQuantityFlow.quantity; 
			
			// Determine the correct results string and execute the transaction
			if ( this.isSelling )
			{
				purchasePriceString = new TinyMoneyAmount( Math.floor( totalPrice / 2 ) ).toString();
				purchaseResultsString = 'You got [delay 4]' + purchasePriceString + '.   [end]'; 
				
				// Give money. Items are bought at half of their selling price
				TinyGameManager.getInstance().playerTrainer.addMoney( Math.floor( totalPrice / 2 ) );
				
				// Take items
				for ( var i : uint = 0; i < this.purchaseQuantityFlow.quantity; i++ )
				{
					TinyGameManager.getInstance().playerTrainer.removeItem( this.selectedItem );					
				}
				
				// Update the quantities in the items list
				this.itemScrollList.resetListItems( this.getShopItemsArray() );
			}
			else
			{
				// If the player can't afford the sale, show an alert. 
				// Otherwise take their money and give them the items.
				if ( TinyGameManager.getInstance().playerTrainer.money.value < totalPrice )
				{
					TinyLogManager.log( 'cannot afford purchase!', this );
					
					switch ( TinyMath.randomInt( 0, 4 ) )
					{
						default:
						case 0: purchaseResultsString = "Hmm, [delay 4]looks like you're a little short in the cash department, [delay 4]yeah?   [end]"; break;
						case 1: purchaseResultsString = "Looks like you have a mixture of cash and uh, [delay 6]pocket [delay 6]lint? [halt]Nice try, [delay 4]but pocket lint is not legal tender[delay 2].[delay 2].[delay 2].   [end]"; break;
						case 2: purchaseResultsString = "Hey buddy, [delay 4]this is a boutique Dikémart, [delay 8]ya gotta pay full price for this stuff!   [end]"; break;
						case 3: purchaseResultsString = "Nuh-uh. [delay 8]Come back when you've got the dough, [delay 4]kiddo.  [end]"; break;
						case 4: purchaseResultsString = "I'm sorry, [delay 6]we don't serve poor people here.   [end]"; break;
					}
				}
				else
				{
					purchaseResultsString = 'O[delay 2]K, [delay 4]here ya go.   [end]';
					
					// Take money
					TinyGameManager.getInstance().playerTrainer.removeMoney( totalPrice );
					
					// Give items
					for ( var j : uint = 0; j < this.purchaseQuantityFlow.quantity; j++ )
					{
						TinyGameManager.getInstance().playerTrainer.addItem( this.selectedItem );	
					}
				}
			}
			
			this.updateMoneyLabel();
			this.removePurchaseQuantityFlow();
				
			// Create the purchase results dialog
			this.purchaseResultsDialog = TinyDialogBox.newFromString( purchaseResultsString );
			this.purchaseResultsDialog.x = 8;
			this.purchaseResultsDialog.y = 104;
			
			// Show the purchase results dialog and pass control		
			this.purchaseResultsDialog.show();
			this.addChild( this.purchaseResultsDialog );
			this.purchaseResultsDialog.addEventListener( Event.COMPLETE, this.onPurchaseResultsDialogComplete );
			TinyInputManager.getInstance().setTarget( this.purchaseResultsDialog );
		}
		
		
		private function onPurchaseQuantityCancel( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onPurchaseQuantityCancel', this );
			
			this.removePurchaseQuantityFlow();
			
			// De-select the marked selected item
			this.itemScrollList.clearStickySelection();
				
			// Return control to the item selection list
			TinyInputManager.getInstance().setTarget( this.itemScrollList );
		}
		
		
		private function onPurchaseResultsDialogComplete( event : Event ) : void
		{
			TinyLogManager.log( 'onPurchaseResultsDialogComplete', this );
			
			// Cleanup
			this.purchaseResultsDialog.addEventListener( Event.COMPLETE, this.onPurchaseResultsDialogComplete );
			this.removeChild( this.purchaseResultsDialog );
			this.purchaseResultsDialog = null;
			
			// Return control to the item selection list
			TinyInputManager.getInstance().setTarget( this.itemScrollList );
		}
		
		
		private function removePurchaseQuantityFlow() : void
		{
			TinyLogManager.log( 'removePurchaseQuantityMenu', this );
			
			// Cleanup
			this.removeChild( this.purchaseQuantityFlow );
			this.purchaseQuantityFlow.removeEventListener( TinyInputEvent.ACCEPT, this.onPurchaseQuantityAccept );
			this.purchaseQuantityFlow.removeEventListener( TinyInputEvent.CANCEL, this.onPurchaseQuantityCancel );
			this.purchaseQuantityFlow = null;
		}
		
		
		private function updateMoneyLabel() : void
		{
			var moneyString : String = TinyGameManager.getInstance().playerTrainer.money.toString();
			this.currentMoneyTextField.htmlText = TinyFontManager.returnHtmlText( moneyString, 'battleItemHP' );
		}
		

		private function setDescriptionText( description : String ) : void 
		{
			this.descriptionTextField.htmlText = TinyFontManager.returnHtmlText( description, 'dialogText' );
		}
		
		
		private function getShopItemsArray() : Array
		{
			// Use the player's inventory if items are being sold
			if ( this.isSelling ) 
			{
				this.itemsForSale = TinyGameManager.getInstance().playerTrainer.inventory;
			}
			
			// Add items to selection array
			var i : uint = 0;
			var shopItemsArray : Array = [];
			for each ( var item : TinyItem in this.itemsForSale )
			{
				item.itemID = i;
				var newLabel : TinySelectableItemItem = new TinySelectableItemItem( item, item.itemID, 140, !this.isSelling );
				shopItemsArray.push( newLabel );
				i++;
			}
			
			// Add CANCEL item
			shopItemsArray.push( new TinySelectableItem( TinyCommonStrings.CANCEL.toUpperCase(), shopItemsArray.length ) );
			
			return shopItemsArray;
		}
	}
}