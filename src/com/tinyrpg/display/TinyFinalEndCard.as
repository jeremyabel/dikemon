package com.tinyrpg.display 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.greensock.easing.SteppedEase;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyFinalEndCard extends Sprite 
	{
		private var speed : int;
		
		public function TinyFinalEndCard(bitmapData : BitmapData, speed : int = 1) : void
		{
			this.addChild(new Bitmap(bitmapData));
			this.alpha = 0;
			this.speed = speed;
		}
		
		public function show() : void
		{
			TinyLogManager.log('show', this);
			TweenLite.to(this, 40, { alpha:1, ease:SteppedEase.create(6), useFrames:true });
			
			TweenLite.delayedCall(80, this.startScroll, null, true);
		}
		
		private function startScroll() : void
		{
			TinyLogManager.log('startScroll', this);
			TweenLite.to(this, (this.height - 240) * this.speed, { y:-(this.height - 240), roundProps:["x", "y"], ease:Linear.easeNone, useFrames:true, onComplete:this.onScrollComplete });
		}
		
		private function onScrollComplete() : void
		{
			TinyLogManager.log('onScrollComplete', this);
			TweenLite.delayedCall(150, this.dispatchEvent, [new Event(Event.COMPLETE)], true);
		}
	}
}
