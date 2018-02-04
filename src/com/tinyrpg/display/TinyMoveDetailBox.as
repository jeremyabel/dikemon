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