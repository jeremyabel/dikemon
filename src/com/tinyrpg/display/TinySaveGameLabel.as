package com.tinyrpg.display 
{
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.misc.TinySpriteConfig;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author jeremyabel
	 */
	public class TinySaveGameLabel extends TinySelectableItem 
	{
		private var saveData 	 : XML;
		private var containerBox : TinyContentBox;
		private var timeText	 : TextField;
		private var nPortraits	 : int = 0;

		public var empty 		 : Boolean = false;
		
		public function TinySaveGameLabel(saveData : XML, idNumber : int) : void
		{
			// Set properties
			if (saveData) {
				this.saveData = saveData;
			} else {
				this.empty = true;
			}
			
			// Container box	
			this.containerBox = new TinyContentBox(null, 180, 32, true);
			
			// Set text & position
			super('Slot ' + String(idNumber + 1) + ': ' + ((this.empty) ? 'Empty' : saveData.child('SAVE_MENU').child('NAME').toString()), idNumber);
			this.itemText.y -= 2;
			this.selectArrow.y -= 2;
			
			// Add portraits
			if (!this.empty)
			{
				// Get party XML data
				var partyXMLData : XMLList = saveData.child('SAVE_MENU').child('FOUND');
				
				// Add party members (but not the non-recruitable ones)
				for each (var memberData : XML in partyXMLData.children()) {
					if (memberData.toString().toUpperCase() != 'EVAN?' && memberData.toString().toUpperCase() != 'HYBRID' && memberData.toString().toUpperCase() != 'EVAN') {
						this.addPortrait(memberData.toString(), memberData.attribute('recruited').toString().toUpperCase() == 'TRUE');
					}
				}	
			}
			
			// Time
			this.timeText = TinyFontManager.returnTextField('right');
			this.timeText.htmlText = TinyFontManager.returnHtmlText(!this.empty ? saveData.child('SAVE_MENU').child('TIME').toString() : '', 'dialogText', 'right');
			this.timeText.x = 145;
			this.timeText.y = this.itemText.y;
			
			// Add 'em up
			this.addChildAt(this.containerBox, 0);
			this.addChild(this.timeText);
		}
		
		private function addPortrait(charName : String, recruited : Boolean) : void
		{
			TinyLogManager.log('addPortrait: ' + charName + ' recruited: ' + recruited, this);
			
			// Get character portrait
			var spriteData : BitmapData = TinySpriteConfig.getSpriteSheet(charName);
			var portraitSize : Point = new Point(19, 19);
			var newData	: BitmapData = new BitmapData(portraitSize.x, portraitSize.y);
			if (charName.toUpperCase() != 'FISH') {
				newData.copyPixels(spriteData, new Rectangle(50, 392, portraitSize.x, portraitSize.y), new Point(0, 0));			} else {
				newData.copyPixels(spriteData, new Rectangle(50, 530, portraitSize.x, portraitSize.y), new Point(0, 0));
			}
			
			// Non-recruited characters get greyed out
			if (!recruited)	{
				var alphaCopy : BitmapData = newData.clone();

				// Color array, set everything grey
				var redArray : Array = [];
				var greenArray : Array = [];
				var blueArray : Array = [];
				for (var i : int = 0; i < 256; i++) {
					redArray[i] = 0x00C1C1C1;
					greenArray[i] = 0x00C1C1C1;
					blueArray[i] = 0x00C1C1C1;
				}
				
				redArray[0] = 0x00C1C1C1;
				greenArray[0] = 0x00C1C1C1;
				blueArray[0] = 0x00C1C1C1;
				
				// Hit Sprite bitmap - palette mapped to white with pure black set to red
				newData.paletteMap(newData, newData.rect, new Point(0, 0), redArray, greenArray, blueArray);
				newData.copyChannel(alphaCopy, newData.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			}
		
			// Position portrait
			var newPortrait : Sprite = new Sprite;
			newPortrait.x = (portraitSize.x * this.nPortraits) + this.itemText.x;
			newPortrait.y = 12;
			newPortrait.alpha = (recruited) ? 1 : 0.3;
			newPortrait.addChild(new Bitmap(newData));
			this.addChild(newPortrait);
			this.nPortraits++;
		}

		override public function get height() : Number { return this.containerBox.height; }
	}
}
