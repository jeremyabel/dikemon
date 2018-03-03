package com.tinyrpg.display 
{
	import flash.text.TextField;
	
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;
	
	/**
	 * @author jeremyabel
	 */
	public class TinySelectableItemItem extends TinySelectableItem 
	{
		public var item : TinyItem;
		
		private var quantityField 	: TextField;
		private var showPrice		: Boolean = false;
		
		public function TinySelectableItemItem( item : TinyItem, idNumber : int = 0, quantityOffset : int = 124, showPrice : Boolean = false ) 
		{
			this.item = item;
			this.showPrice = showPrice;
			
			// Make quantity text field
			this.quantityField = TinyFontManager.returnTextField( 'right' );
			this.quantityField.x = quantityOffset;
			this.quantityField.y = 4;
			
			// Add 'em up
			this.addChild( this.quantityField );
			
			if ( this.showPrice ) {
				this.updatePrice();
			} else {
				this.updateQuantity();
			}
			
			super( this.item.name, idNumber );
		}
		
		public function updateQuantity() : void
		{
			TinyLogManager.log( 'updateQuantity: ' + this.item.quantity, this );
			
			this.quantityField.htmlText = TinyFontManager.returnHtmlText( 'x' + this.item.quantity.toString(), 'battleItemHP', 'right' );
		}
		
		public function updatePrice() : void
		{
			TinyLogManager.log( 'updatePrice: ' + this.item.price, this );
			
			this.quantityField.htmlText = TinyFontManager.returnHtmlText( this.item.price.toString(), 'battleItemHP', 'right' );
		}
	}
}
