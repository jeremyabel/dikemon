package com.tinyrpg.misc 
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author jeremyabel
	 */
	public class TinyTweenCommand extends EventDispatcher 
	{
		public var waitForCompletion : Boolean = true;
		public var tween : TweenLite;
		
		public function TinyTweenCommand( tween : TweenLite, waitForCompletion : Boolean )
		{
			this.tween = tween;
			this.waitForCompletion = waitForCompletion;
			
			this.tween.pause();
		}
		
		public function execute() : void
		{
			this.tween.play();	
				
			if (this.waitForCompletion) 
			{
				TweenLite.delayedCall(this.tween.totalDuration, this.dispatchEvent, [new Event(Event.COMPLETE)]);
			} 
			else 
			{
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}