package com.tinyrpg.misc 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.SteppedEase;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyFlashCommand extends Sprite 
	{
		public var inOnly : Boolean = false;
		public var fade : Boolean = false;
		public var time : int = 1;
		public var color : uint = 0xFFFFFF;
		public var sync : Boolean;
		
		public function TinyFlashCommand() : void
		{
			
		}
		
		public function execute() : void
		{
			TinyLogManager.log('execute: fade = ' + this.fade, this);
			
			this.alpha = 1;
			this.graphics.beginFill(this.color);			this.graphics.drawRect(0, 0, 320, 240);			this.graphics.endFill();
			
			if (this.inOnly) {
				this.alpha = 0;
				TweenLite.to(this, this.time, { alpha:1, ease:SteppedEase.create(6), useFrames:true });
			} else if (this.fade) {
				TweenLite.to(this, this.time, { alpha:0, ease:SteppedEase.create(5), useFrames:true });
			}
			
			if (!this.inOnly) {
				var delayTime : int = this.sync ? 0 : this.time;
				TweenLite.delayedCall(delayTime, this.dispatchEvent, [new Event(Event.COMPLETE)], true);
			}		}
		
		public static function newFromXML(xmlData : XML) : TinyFlashCommand
		{
			var newFlash : TinyFlashCommand = new TinyFlashCommand;
			
			newFlash.fade = (xmlData.child('FADE').toString() == 'TRUE');
			newFlash.sync = (xmlData.child('SYNC').toString() == 'TRUE');
			newFlash.inOnly = (xmlData.child('IN_ONLY').toString() == 'TRUE');
			newFlash.time = int(xmlData.child('TIME').toString());
			newFlash.color = uint(xmlData.child('COLOR').toString());
						
			return newFlash;
		}
	}
}
