package com.tinyrpg.display
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.display.TinyModalDivider;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.managers.TinyFontManager;

	/**
	 * Display class which shows information about a single battle move.
	 * 
	 * Used as part of the {@link TinyMoveStatDisplay} full move stat display.
	 *   
	 * @author jeremyabel
	 */
	public class TinyMoveStatListItem extends Sprite 
	{
		private var moveNameValue : TextField;
		private var ppValue : TextField;
		private var divider : TinyModalDivider;
		
		public function TinyMoveStatListItem()
		{
			this.moveNameValue = TinyFontManager.returnTextField();
			
			// Add a white background for the name field. This is used to cover up the grey dot pattern.
			this.moveNameValue.background = true;
			this.moveNameValue.backgroundColor = 0xFFFFFF;
			this.moveNameValue.height = 10;
			
			this.ppValue = TinyFontManager.returnTextField();
			this.ppValue.x = 102; 
			
			this.divider = new TinyModalDivider();
			this.divider.alpha = 0.35;
			this.divider.y = 12;
			this.divider.x = this.ppValue.x - this.divider.width - 1;
			
			// Add 'em up
			this.addChild( this.divider );
			this.addChild( this.moveNameValue );
			this.addChild( this.ppValue );
		}
		
		/**
		 * Sets which move's stats are shown in the display.
		 */
		public function setMove( moveData : TinyMoveData ) : void
		{
			// No move data, show empty entry with "--" placeholder data.
			if ( !moveData )
			{
				TinyLogManager.log('setMove: --', this);
				this.moveNameValue.htmlText = TinyFontManager.returnHtmlText( '--', 'dialogText' );
				this.ppValue.htmlText = TinyFontManager.returnHtmlText( '--', 'dialogText' );
				return;	
			}
			
			TinyLogManager.log('setMove: ' + moveData.name, this);
			
			this.moveNameValue.htmlText = TinyFontManager.returnHtmlText( moveData.name.toUpperCase(), 'dialogText' );
			
			var ppString : String = moveData.currentPP + '/' + moveData.maxPP;
			this.ppValue.htmlText = TinyFontManager.returnHtmlText( ppString, 'dialogText' );
 		}
	}
}
