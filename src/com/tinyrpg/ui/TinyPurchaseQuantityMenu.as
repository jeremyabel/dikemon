package com.tinyrpg.ui
{
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.data.TinyMoneyAmount;
	import com.tinyrpg.display.TinyModalSelectArrow;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyPurchaseQuantityMenu extends Sprite 
	{
		public var quantity 			: uint = 1;
		
		private var item 				: TinyItem;
		private var selectArrow 		: TinyModalSelectArrow;
		private var quantityTextField 	: TextField;
		private var priceTextField 		: TextField;
		private var isSelling			: Boolean;
		private var maxQuantity			: int;
		
		public function TinyPurchaseQuantityMenu( item : TinyItem, selling : Boolean = false ) : void
		{
			this.item = item;
			this.isSelling = selling;
			this.maxQuantity = this.isSelling ? this.item.quantity : 99;
			
			// Create the select arrow
			this.selectArrow = new TinyModalSelectArrow;
			this.selectArrow.x = 6;
			this.selectArrow.y = 10;
			this.selectArrow.visible = false;
			
			// Create quantity and price text field
			this.quantityTextField = TinyFontManager.returnTextField( 'left', false, true, true );
			this.quantityTextField.width = 120;
			this.quantityTextField.height = 20;
			this.quantityTextField.x = 6;
			this.quantityTextField.y = 2;
			
			// Create price text field
			this.priceTextField = TinyFontManager.returnTextField( 'left', false, true, true );
			this.priceTextField.width = 120;
			this.priceTextField.height = 20;
			this.priceTextField.x = 32;
			this.priceTextField.y = 2;
			
			// Add 'em up
			this.addChild( this.selectArrow );
			this.addChild( this.quantityTextField );
			this.addChild( this.priceTextField );
			
			// Wait for control to be added
			this.addEventListener( TinyInputEvent.CONTROL_ADDED, this.onControlAdded );
		}
		
		
		private function onControlAdded( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onControlAdded', this );

			TinyInputManager.getInstance().addEventListener( TinyInputEvent.ARROW_UP, this.onArrowUp );
			TinyInputManager.getInstance().addEventListener( TinyInputEvent.ARROW_DOWN, this.onArrowDown );
			TinyInputManager.getInstance().addEventListener( TinyInputEvent.ACCEPT, this.onAccept );
			TinyInputManager.getInstance().addEventListener( TinyInputEvent.CANCEL, this.onCancel );			
			this.addEventListener( TinyInputEvent.CONTROL_REMOVED, this.onControlRemoved );
			this.removeEventListener( TinyInputEvent.CONTROL_ADDED, this.onControlAdded );
			
			this.updatePrice();
			this.selectArrow.visible = true;
			MovieClip( this.selectArrow ).gotoAndPlay( 1 );
		}


		private function onControlRemoved( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onControlRemoved', this );
			
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.ARROW_UP, this.onArrowUp );
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.ARROW_DOWN, this.onArrowDown );
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.ACCEPT, this.onAccept );
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.CANCEL, this.onCancel );
			this.removeEventListener( TinyInputEvent.CONTROL_REMOVED, this.onControlRemoved );
		}
		
		private function onArrowUp( event : TinyInputEvent ) : void 
		{	
			if ( this.quantity == this.maxQuantity ) {
				this.quantity = 1;
			} else {
				this.quantity++;
			}
			
			this.updatePrice();
		}
		
		protected function onArrowDown(event : TinyInputEvent ) : void 
		{
			if ( this.quantity == 1 ) {
				this.quantity = this.maxQuantity;
			} else {
				this.quantity--;
			}
			
			this.updatePrice();
		}


		private function onAccept( event : TinyInputEvent ) : void 
		{
			TinyLogManager.log( 'onAccept', this );
			this.dispatchEvent( new TinyInputEvent( TinyInputEvent.ACCEPT ) );
		}
		
		
		private function onCancel( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onCancel', this );
			this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );
		}
		
		
		private function updatePrice() : void
		{
			var quantityString : String = 'x';
			if ( this.quantity < 10 ) quantityString += '0';
			quantityString += this.quantity.toString();
			
			// Item's selling price is half of the item's purchase price 
			var itemValue : uint = this.item.price.value / ( this.isSelling ? 2 : 1 );
			var priceString : String = new TinyMoneyAmount( itemValue * this.quantity ).toString();
			
			TinyLogManager.log( 'updatePrice: ' + quantityString + '  ' + priceString, this );
			
			this.quantityTextField.htmlText = TinyFontManager.returnHtmlText( quantityString, 'battleItemHP' );
			this.priceTextField.htmlText = TinyFontManager.returnHtmlText( priceString, 'battleItemHP' );
		}
	}
}
