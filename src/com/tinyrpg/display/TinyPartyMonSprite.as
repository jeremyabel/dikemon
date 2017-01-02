package com.tinyrpg.display 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	import com.tinyrpg.display.misc.MonPartySprites;

	/**
	 * @author jeremyabel
	 */
	public class TinyPartyMonSprite extends TinySpriteSheet 
	{
		public function TinyPartyMonSprite( spriteIndex : int = 0 )
		{
			spriteIndex = Math.min( spriteIndex, 32 );
			var spriteRow : int = spriteIndex % 4;
			var spriteCol : int = Math.floor( spriteIndex / 4 );
			var sourceRect : Rectangle = new Rectangle(spriteRow * 32, spriteCol * 16, 32, 16);
			
			var sourceSpriteData : BitmapData = new MonPartySprites;
			var croppedSpriteData : BitmapData = new BitmapData(32, 16);
			croppedSpriteData.copyPixels(sourceSpriteData, sourceRect, new Point(0, 0));
			
			super( croppedSpriteData, 16, true );
		}
	}
}
