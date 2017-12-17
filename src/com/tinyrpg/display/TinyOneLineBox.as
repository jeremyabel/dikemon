package com.tinyrpg.display 
{
	import com.greensock.TweenLite;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.text.TextField;

	/**
	 * @author jeremyabel
	 */
	public class TinyOneLineBox extends TinyContentBox 
	{
		private var textField : TextField;
		private var smallFont : Boolean;
		
		public function TinyOneLineBox(textString : String = null, width : int = 288, smallFont : Boolean = false)
		{
			super(content, width, 11);
			
			this.smallFont = smallFont;
			
			this.textField = TinyFontManager.returnTextField('center');
			this.textField.x = int((this.width / 2) - (this.textField.width / 2));
			
			if (textString && textString != '') {
				this.text = textString;
			}
			
			this.addChild(textField);
		}
		
		public function set text(string : String) : void
		{
			TinyLogManager.log('set text: ' + string, this);
			
			var style : String = this.smallFont ?  'battleItemText' : 'selecterText';
			
			// Set text and center
			this.textField.visible = false;
			this.textField.htmlText = TinyFontManager.returnHtmlText(string, style, 'center');
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