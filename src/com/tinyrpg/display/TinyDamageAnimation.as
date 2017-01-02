package com.tinyrpg.display 
{
	import com.greensock.TweenLite;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;

	/**
	 * @author jeremyabel
	 */
	public class TinyDamageAnimation extends Sprite 
	{
		private var spriteHolder : Sprite;
		
		public function TinyDamageAnimation()
		{
			this.spriteHolder = new Sprite;
			this.addChild(this.spriteHolder);
		}

		public function play() : void
		{
			TinyLogManager.log('play', this);
			
			var newSprite : Sprite = new Sprite;
			newSprite.graphics.beginFill(0xFF00FF);
			newSprite.graphics.drawCircle(0, 0, 2);
			newSprite.graphics.endFill();
			newSprite.alpha = 0;
			
			this.spriteHolder.addChild(newSprite);
			TweenLite.to(newSprite, 15, { scaleX:5, scaleY:5, alpha:1, onComplete:this.spriteHolder.removeChild, onCompleteParams:[newSprite], useFrames:true });
		}
		
		public static function getTimeLength() : int
		{
			return 15;
		}
	}
}
