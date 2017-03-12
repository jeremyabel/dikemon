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
		
		private var quantityField : TextField;
		
		public function TinySelectableItemItem( item : TinyItem, idNumber : int = 0 ) 
		{
			this.item = item;
			
			// Make quantity text field
			this.quantityField = TinyFontManager.returnTextField( 'right' );
			this.quantityField.x = 126;
			this.quantityField.y = 4;
			
			// Add 'em up
			this.addChild( this.quantityField );
			this.updateQuantity();
			
			super( this.item.name, idNumber );
			
		}
		
		public function updateQuantity() : void
		{
			TinyLogManager.log('updateQuantity: ' + this.item.quantity, this);
			
			this.quantityField.htmlText = TinyFontManager.returnHtmlText( this.item.quantity.toString(), 'battleItemHP', 'right' );
		}
	}
}
