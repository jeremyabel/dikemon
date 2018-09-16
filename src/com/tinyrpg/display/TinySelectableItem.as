package com.tinyrpg.display 
{
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * Base display class for any object that needs to be selectable inside a {@link TinySelectList}.
	 * 
	 * The base class provides just a textfield with a {@link TinyModalSelectArrow}.
	 * To add extra elements to the display, extend this class.
	 * 
	 * @author jeremyabel
	 */
	public class TinySelectableItem extends Sprite 
	{
		protected var itemText : TextField;
		protected var selectArrow : TinyModalSelectArrow;
		
		public var idNumber		: int;
		public var selectID 	: int;
		public var textString 	: String;
		public var tinyFont	  	: Boolean;
		public var customData	: *;
		
		private var _disabled 	: Boolean = false;
		
		/**
		 * @param	itemText		The item's text string.
		 * @param	idNumber		The item's index number in the selection list array.
		 * @param	styleSheet		The CSS stylesheet used for the textfield.
		 * @param	xOffset			An optional x-axis offset.
		 * @param	yOffset			An optional y-axis offset.
		 */
		public function TinySelectableItem( itemText : String, idNumber : int = 0, styleSheet : String = 'selecterText', xOffset : int = 0, yOffset : int = -1 )
		{
			// Set properties
			this.idNumber = idNumber;
			this.selectID = idNumber;
			this.tinyFont = tinyFont;
			
			// Item text
			this.itemText = TinyFontManager.returnTextField();
			this.itemText.htmlText = TinyFontManager.returnHtmlText(itemText, styleSheet);
			this.itemText.x = 6 + xOffset;
			this.itemText.y = yOffset;
			this.textString = itemText;
			
			// Select arrow
			this.selectArrow = new TinyModalSelectArrow;
			this.selectArrow.x = 6;
			this.selectArrow.y = (tinyFont) ? 6 : 10;
			this.selectArrow.visible = false;
			
			// Add 'em up
			this.addChild(this.itemText);			this.addChild(this.selectArrow);
		}
		
		/**
		 * Sets the visibility state of the selection arrow and starts the flashing animation. 
		 */
		public function set selected(value : Boolean) : void
		{
			this.selectArrow.visible = value;
			MovieClip(this.selectArrow).gotoAndPlay(1);
		}
		
		/**
		 * Sets the visibility state of the selection arrow and shows the solid black arrow.
		 */
		public function set autoSelected(value : Boolean) : void
		{
			this.selectArrow.visible = value;
			MovieClip(this.selectArrow).gotoAndStop('autoselect');
		}
		
		/**
		 * Sets the disabled state of the item. If the item is disabled it will be dimmed out 
		 * and will make an error sound when the Accept button is pressed.
		 */
		public function set disabled(value : Boolean) : void
		{
			TinyLogManager.log( this.textString + ' set disabled: ' + value, this );
			
			if (value) {
				this._disabled = true;
				this.itemText.alpha = 0.3;
			} else {
				this._disabled = false;
				this.itemText.alpha = 1;
			}
		}
		
		/**
		 * Returns the disabled state of this item.
		 */
		public function get disabled() : Boolean
		{
			return this._disabled;
		}
	}
}
