package com.tinyrpg.ui
{
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.data.TinyItemDataList;
	import com.tinyrpg.data.TinyMoneyAmount;
	import com.tinyrpg.display.TinyContentBox
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyPurchaseQuantityFlow extends Sprite 
	{
		public var quantity				: uint = 0;
		
		private var item				: TinyItem;
		private var howManyTextField 	: TextField;
		private var howManyBox			: TinyContentBox;
		private var quantityMenu 		: TinyPurchaseQuantityMenu;
		private var confirmDialog		: TinyDialogBox;
		private var yesNoSelectList		: TinyYesNoSelectList;
		private var isSelling			: Boolean = false;
		
		public function TinyPurchaseQuantityFlow( item : TinyItem, selling : Boolean = false ) : void
		{
			this.item = item;
			this.isSelling = selling;
			
			// Create "how many?" text field
			this.howManyTextField = TinyFontManager.returnTextField( 'left', false, true, true );
			this.howManyTextField.width = 141;
			this.howManyTextField.height = 20;
			this.howManyTextField.y = -6;
			this.howManyTextField.htmlText = TinyFontManager.returnHtmlText( TinyCommonStrings.HOW_MANY, 'dialogText' );
			
			// Create "how many?" content box
			this.howManyBox = new TinyContentBox( this.howManyTextField, 144, 33 );
			this.howManyBox.x = 8;
			this.howManyBox.y = 104;
			
			// Create the quantity control menu
			this.quantityMenu = new TinyPurchaseQuantityMenu( this.item, this.isSelling );
			this.quantityMenu.x = 8;
			this.quantityMenu.y = 112;
			
			// Make yes / no select list
			this.yesNoSelectList = new TinyYesNoSelectList();
			this.yesNoSelectList.x = this.howManyBox.width - this.yesNoSelectList.width + 2;
			this.yesNoSelectList.y = 104 - ( this.yesNoSelectList.height + 4 );
			this.yesNoSelectList.visible = false;
			
			// Add 'em up
			this.addChild( this.howManyBox );
			this.addChild( this.quantityMenu );			
			this.addChild( this.yesNoSelectList );
		}
		
		
		public function execute() : void
		{
			TinyLogManager.log( 'execute', this );
			
			this.quantityMenu.addEventListener( TinyInputEvent.ACCEPT, this.onQuantityAccept );
			this.quantityMenu.addEventListener( TinyInputEvent.CANCEL, this.onQuantityCancel );
			
			TinyInputManager.getInstance().setTarget( this.quantityMenu );
		}
		
		
		private function onQuantityAccept( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onQuantityAccept', this );
			
			this.quantity = this.quantityMenu.quantity;
			
			this.removeQuantityMenu();
			
			// Figure out the plural suffix for the requested item
			var pluralSuffix : String = '';
			if ( this.quantityMenu.quantity > 1 ) 
			{
				pluralSuffix = 's';
				
				// Items ending in the letter "X" need an "es" suffix
				if ( this.item.name.substr( -1 ).toUpperCase() == 'X' )
				{
					pluralSuffix = 'es'; 
				}
			}
			
			// Prices for selling items are half of the item's purchased price
			var itemValue : int = this.isSelling ? Math.floor( this.item.price.value / 2 ) : this.item.price.value;
			
			// Create the appropriate confirmation string
			var priceString : String = new TinyMoneyAmount( itemValue * this.quantityMenu.quantity ).toString(); 
			var buyOrSellString : String = ( this.isSelling ? 'I can give ya' : "That'll be" ) + ' [delay 4]' + priceString; 
			var confirmDialogString : String = this.quantityMenu.quantity.toString() + ' ' + this.item.name + pluralSuffix + '? [delay 8]' + buyOrSellString + '.   [end]';
		   	
			// Create the confirm price dialog	
			this.confirmDialog = TinyDialogBox.newFromString( confirmDialogString );
			this.confirmDialog.x = 8;
			this.confirmDialog.y = 104;
			this.confirmDialog.show();
			this.addChild( this.confirmDialog );
			
			// Pass control to the dialog
			TinyInputManager.getInstance().setTarget( this.confirmDialog );
			this.confirmDialog.addEventListener( Event.COMPLETE, this.onConfirmDialogComplete );
		}
		
		
		private function onQuantityCancel( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onQuantityCancel', this );
			
			this.removeQuantityMenu();
			this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );
		}
		
		
		private function removeQuantityMenu() : void
		{
			TinyLogManager.log( 'removeQuantityMenu', this );
			
			this.quantityMenu.removeEventListener( TinyInputEvent.ACCEPT, this.onQuantityAccept );
			this.quantityMenu.removeEventListener( TinyInputEvent.CANCEL, this.onQuantityCancel );
		}
		
		
		private function onConfirmDialogComplete( event : Event ) : void
		{
			TinyLogManager.log( 'onConfirmDialogComplete', this );
			
			// Cleanup
			this.confirmDialog.removeEventListener( Event.COMPLETE, this.onConfirmDialogComplete );
			
			// Pass control to the yes/no selector
			this.yesNoSelectList.visible = true;
			this.yesNoSelectList.addEventListener( Event.COMPLETE, this.onConfirmAccept );
			this.yesNoSelectList.addEventListener( TinyInputEvent.CANCEL, this.onConfirmCancel );
			TinyInputManager.getInstance().setTarget( this.yesNoSelectList );
		}
		
		
		private function onConfirmAccept( event : Event ) : void
		{
			TinyLogManager.log( 'onConfirmAccept', this );
			
			this.removeYesNoSelector();
			this.dispatchEvent( new TinyInputEvent( TinyInputEvent.ACCEPT, this.quantityMenu.quantity ) );
		}
		
		
		private function onConfirmCancel( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onConfirmCancel', this );
			
			this.removeYesNoSelector();
			this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );
		}
		
		
		private function removeYesNoSelector() : void
		{
			TinyLogManager.log( 'removeYesNoSelector', this );
			
			this.yesNoSelectList.visible = false;
			this.yesNoSelectList.removeEventListener( Event.COMPLETE, this.onConfirmAccept );
			this.yesNoSelectList.removeEventListener( TinyInputEvent.CANCEL, this.onConfirmCancel );				
		}
	}
}
