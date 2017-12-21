package com.tinyrpg.display
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import com.tinyrpg.data.TinyMoveSet;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyMoveStatDisplay extends Sprite
	{
		private var moveListItem1 : TinyMoveStatListItem;
		private var moveListItem2 : TinyMoveStatListItem;
		private var moveListItem3 : TinyMoveStatListItem;
		private var moveListItem4 : TinyMoveStatListItem;
		
		private var ySpacing : int = 11;

		public function TinyMoveStatDisplay()
		{
			this.moveListItem1 = new TinyMoveStatListItem();
			this.moveListItem1.y = 0;
			
			this.moveListItem2 = new TinyMoveStatListItem();
			this.moveListItem2.y = this.moveListItem1.y + ySpacing;
			
			this.moveListItem3 = new TinyMoveStatListItem();
			this.moveListItem3.y = this.moveListItem2.y + ySpacing;
			
			this.moveListItem4 = new TinyMoveStatListItem();
			this.moveListItem4.y = this.moveListItem3.y + ySpacing;
			
			// Add 'em up
			this.addChild( this.moveListItem4 );
			this.addChild( this.moveListItem3 );
			this.addChild( this.moveListItem2 );
			this.addChild( this.moveListItem1 );
		}
		
		public function setMoveSet( moveSet : TinyMoveSet ) : void
		{
			TinyLogManager.log('set moveSet', this);
			
			this.moveListItem1.setMove( moveSet.move1 );
			this.moveListItem2.setMove( moveSet.move2 );
			this.moveListItem3.setMove( moveSet.move3 );
			this.moveListItem4.setMove( moveSet.move4 );
		}
	}
}