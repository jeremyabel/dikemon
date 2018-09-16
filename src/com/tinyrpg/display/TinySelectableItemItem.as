package com.tinyrpg.display 
{
	import flash.text.TextField;
	
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;
	
	/**
	 * Display class for a {@link TinySelectableItem} which adds a numeric quantity field,
	 * used for showing the items in the player's inventory.
	 * 
	 * @author jeremyabel
	 */
	public class TinySelectableItemItem extends TinySelectableItem 
	{
		public var item : TinyItem;
		
		private var quantityField 	: TextField;
		private var showPrice		: Boolean = false;
		
		/**
		 * @param	item			The item represented.
		 * @param	idNumber		The index in the selection array.
		 * @param	quantityOffset	An optional x-axis offset for the item quantity number.
		 * @param	showPrice		Whether or not to show the item's price instead of the quantity number.
		 * 							Used for showing the item list in a shop.
		 */
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
		
		/**
		 * Updates the quantity number of the item.
		 */
		public function updateQuantity() : void
		{
			TinyLogManager.log( 'updateQuantity: ' + this.item.quantity, this );
			
			this.quantityField.htmlText = TinyFontManager.returnHtmlText( 'x' + this.item.quantity.toString(), 'battleItemHP', 'right' );
		}
		
		/**
		 * Updates the price number of the item.
		 */
		public function updatePrice() : void
		{
			TinyLogManager.log( 'updatePrice: ' + this.item.price, this );
			
			this.quantityField.htmlText = TinyFontManager.returnHtmlText( this.item.price.toString(), 'battleItemHP', 'right' );
		}
	}
}
