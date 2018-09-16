package com.tinyrpg.display 
{
	import com.greensock.TweenLite;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.text.TextField;

	/**
	 * Class which provides a one-line non-interactive text display box.
	 * 
	 * Used mostly for showing short instructions over various selection menus.
	 * @author jeremyabel
	 */
	public class TinyOneLineBox extends TinyContentBox 
	{
		private var textField  : TextField;
		private var smallFont  : Boolean;
		private var textString : String;
		
		/**
		 * @param	textString		The text to display in the box.
		 * @param	width			The width of the box.
		 * @param	smallFont		Whether or not to use the small font.
		 */
		public function TinyOneLineBox(textString : String = null, width : int = 288, smallFont : Boolean = false)
		{
			super(content, width, 11);
			
			this.smallFont = smallFont;
			
			this.textField = TinyFontManager.returnTextField('center');
			this.textField.x = int((this.width / 2) - (this.textField.width / 2));			this.textField.y = this.smallFont ? 0 : -5;
			
			if (textString && textString != '') {
				this.text = textString;
			}
			
			this.addChild(textField);
		}
		
		/**
		 * Sets the text shown in the box.
		 */
		public function set text( string : String ) : void
		{
			if ( string == this.textString ) return;
			
			TinyLogManager.log( 'set text: ' + string, this );
			
			// Use a smaller font if requested
			var style : String = this.smallFont ?  'battleItemText' : 'selecterText';
			
			// Set text and center
			this.textString = string;
			this.textField.visible = false;
			this.textField.htmlText = TinyFontManager.returnHtmlText(this.textString, style, 'center');
			TweenLite.delayedCall(3, this.setX, null, true);
		}
		
		private function setX() : void
		{
			this.textField.x = int((this.width / 2) - (this.textField.width / 2));
			this.textField.visible = true;
		}
		
		public function show() : void
		{
			TinyLogManager.log('show', this);
			this.visible = true;
		}
		
		public function hide() : void
		{
			TinyLogManager.log('hide', this);
			this.visible = false;
		}
	}
}
