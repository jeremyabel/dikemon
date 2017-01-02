package com.tinyrpg.display 
{
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.text.TextField;

	/**
	 * @author jeremyabel
	 */
	public class TinyMoveDetailBox extends TinyContentBox 
	{
		private var typeTitleField : TextField;
		private var typeField : TextField; 
		private var ppTitleField : TextField;
		private var ppField : TextField;
	
		public function TinyMoveDetailBox( width : uint = 0, height : uint = 0 )
		{
			super( content, width, height );

			this.typeTitleField = TinyFontManager.returnTextField();
			this.typeTitleField.x = -1;
			this.typeTitleField.y = -2;
			this.typeTitleField.htmlText = TinyFontManager.returnHtmlText('Type:', 'battleItemText');
			
			this.typeField = TinyFontManager.returnTextField();
			this.typeField.x = -1;
			this.typeField.y = 3;
			this.typeField.htmlText = TinyFontManager.returnHtmlText('', 'selecterText');
			
			this.ppTitleField = TinyFontManager.returnTextField();
			this.ppTitleField.x = -1;
			this.ppTitleField.y = 15;
			this.ppTitleField.htmlText = TinyFontManager.returnHtmlText('PP:', 'battleItemText');
			
			this.ppField = TinyFontManager.returnTextField();
			this.ppField.x = -1;
			this.ppField.y = 18;
			this.ppField.htmlText = TinyFontManager.returnHtmlText('', 'selecterText');
			
			// Add 'em up
			this.addChild( this.typeTitleField );
			this.addChild( this.typeField );
			this.addChild( this.ppTitleField );
			this.addChild( this.ppField );
		}
		
		public function setMove( move : TinyMoveData ) : void
		{
			TinyLogManager.log('setMove: ' + move.name, this);
			
			var ppLabel : String = move.currentPP + '/' + move.maxPP;
			this.typeField.htmlText = TinyFontManager.returnHtmlText( move.type.name.toUpperCase(), 'selecterText' );
			this.ppField.htmlText = TinyFontManager.returnHtmlText( ppLabel, 'selecterText' );
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
//
////package com.tinyrpg.display 
//{
//	import com.greensock.TweenLite;
//	import com.tinyrpg.managers.TinyFontManager;
//	import com.tinyrpg.utils.TinyLogManager;
//
//	import flash.text.TextField;
//
//	/**
//	 * @author jeremyabel
//	 */
//	public class TinyOneLineBox extends TinyContentBox 
//	{
//		private var textField : TextField;
//		private var smallFont : Boolean;
//		
//		public function TinyOneLineBox(textString : String = null, width : int = 288, smallFont : Boolean = false)
//		{
//			super(content, width, 13);
//			
//			this.smallFont = smallFont;
//			
//			this.textField = TinyFontManager.returnTextField('center');
//			this.textField.x = int((this.width / 2) - (this.textField.width / 2));
//			this.textField.y = this.smallFont ? 0 : -3;
//			
//			if (textString && textString != '') {
//				this.text = textString;
//			}
//			
//			this.addChild(textField);
//		}
//		
//		public function set text(string : String) : void
//		{
//			TinyLogManager.log('set text: ' + string, this);
//			
//			var style : String = this.smallFont ?  'battleItemText' : 'selecterText';
//			
//			// Set text and center
//			this.textField.visible = false;
//			this.textField.htmlText = TinyFontManager.returnHtmlText(string, style, 'center');
//			TweenLite.delayedCall(3, this.setX, null, true);
//		}
//		
//		private function setX() : void
//		{
//			this.textField.x = int((this.width / 2) - (this.textField.width / 2));
//			this.textField.visible = true;
//		}
//		
//		public function show() : void
//		{
//			TinyLogManager.log('show', this);
//			this.visible = true;
//		}
//		
//		public function hide() : void
//		{
//			TinyLogManager.log('hide', this);
//			this.visible = false;
//		}
//	}
//}
