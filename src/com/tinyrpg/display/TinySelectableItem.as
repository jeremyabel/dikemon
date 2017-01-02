package com.tinyrpg.display 
{
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
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
		
		private var _disabled 	: Boolean = false;
		
		public function TinySelectableItem(itemText : String, idNumber : int = 0, styleSheet : String = 'selecterText', xOffset : int = 0, yOffset : int = 0)
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
		
		public function set selected(value : Boolean) : void
		{
			this.selectArrow.visible = value;
			MovieClip(this.selectArrow).gotoAndPlay(1);
		}
		
		public function set autoSelected(value : Boolean) : void
		{
			this.selectArrow.visible = value;
			MovieClip(this.selectArrow).gotoAndStop('autoselect');
		}
		
		public function set disabled(value : Boolean) : void
		{
			TinyLogManager.log('set disabled: ' + value, this);
			
			if (value) {
				this._disabled = true;
				this.itemText.alpha = 0.3;
			} else {
				this._disabled = false;
				this.itemText.alpha = 1;
			}
		}
		
		public function get disabled() : Boolean
		{
			return this._disabled;
		}
	}
}
