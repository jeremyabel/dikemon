package com.tinyrpg.display 
{
	import com.tinyrpg.display.battlebg.BGBeach;
	import com.tinyrpg.display.battlebg.BGBoat;
	import com.tinyrpg.display.battlebg.BGCastle;
	import com.tinyrpg.display.battlebg.BGDesert;
	import com.tinyrpg.display.battlebg.BGDungeon;
	import com.tinyrpg.display.battlebg.BGField;
	import com.tinyrpg.display.battlebg.BGForest;
	import com.tinyrpg.display.battlebg.BGLake;
	import com.tinyrpg.utils.TinyMath;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleBackground extends Sprite 
	{
		private var backgroundData : BitmapData;
		private var backgroundSprite : Sprite;
		
		public function TinyBattleBackground()
		{
			switch(TinyMath.randomInt(0, 7)) 
			{
				case 0:
					this.backgroundData = new BGBeach;	break;
				case 1:
					this.backgroundData = new BGLake;	break;
				case 2:
					this.backgroundData = new BGDungeon;break;
				case 3:
					this.backgroundData = new BGForest;	break;
				case 4:
					this.backgroundData = new BGBoat;	break;
				case 5:
					this.backgroundData = new BGField;	break;
				case 6:
					this.backgroundData = new BGCastle;	break;
				case 7:
					this.backgroundData = new BGDesert;	break;
			}
			
			this.backgroundSprite = new Sprite;
			this.backgroundSprite.addChild(new Bitmap(this.backgroundData));
			
			// Add 'em up
			this.addChild(this.backgroundSprite);
		}
	}
}
