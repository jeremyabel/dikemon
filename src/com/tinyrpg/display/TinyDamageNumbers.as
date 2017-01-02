package com.tinyrpg.display 
{
	import com.greensock.TweenLite;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author jeremyabel
	 */
	public class TinyDamageNumbers extends Sprite 
	{
		private var numbersData  : BitmapData;
		private var bitmapRects  : Array = [ 8, 6, 8, 8, 8, 8, 8, 8, 8, 8, 28 ];
		private var bitmapOffset : Array = [];
		private var bitmapArray	 : Array = [];
		private var spriteArray	 : Array = [];
		
		public static var numberTime : int = 30;
		
		public function TinyDamageNumbers()
		{
			this.numbersData = new DamageNumbersBitmap;
			
			// Cut up spritesheet
			var xAccum : int = 0; 
			for (var i : uint = 0; i < this.bitmapRects.length; i++)
			{
				var newNumberSprite : Sprite = new Sprite;
				var newNumberBitmap : Bitmap = new Bitmap(new BitmapData(this.bitmapRects[i], 8));
				newNumberBitmap.bitmapData.copyPixels(this.numbersData, new Rectangle(xAccum, 0, this.bitmapRects[i], 8), new Point(0, 0));
				newNumberSprite.addChild(newNumberBitmap);
				this.spriteArray.push(newNumberSprite);
				
				this.bitmapArray.push(newNumberBitmap);
				this.bitmapOffset.push(xAccum);
				xAccum += this.bitmapRects[i];
			}
		}

		public function show(damage : int, healing : Boolean = false, special : Boolean = false) : void
		{
			TinyLogManager.log('show: ' + damage, this);
			
			var newNumberSprite : Sprite = new Sprite;
			
			// Show MISSED, or cobble together some numbers
			if (damage <= 0 && !special) {
				newNumberSprite.addChild(this.spriteArray[10]);
			} else {
				// Split number into single digits
				var stringArray : Array = String(damage).split('');
				
				// Copy in numbers
				for each (var numberStr : String in stringArray)
				{
					var newNumber : Sprite = new Sprite;
					newNumber.addChild(new Bitmap(Bitmap(this.bitmapArray[Number(numberStr)]).bitmapData.clone()));
					newNumber.x = newNumberSprite.width;
					if (Number(numberStr) == 7 && stringArray.length > 1) newNumber.x--;
					newNumberSprite.addChild(newNumber);
				}
			}
			
			// Change to green if healing
			if (healing) {
				var greenTransform : ColorTransform = new ColorTransform(0.80, 1, 0.80, 1, 0, 75, 0, 0);
				newNumberSprite.transform.colorTransform = greenTransform;
			}
			
			// Display
			newNumberSprite.x = -int(newNumberSprite.width / 2);
			this.addChild(newNumberSprite);
			TweenLite.to(newNumberSprite, TinyDamageNumbers.numberTime, { visible:false, onComplete:this.removeChild, onCompleteParams:[newNumberSprite], useFrames:true });
		}
	}
}
