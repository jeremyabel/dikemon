package com.tinyrpg.display 
{
	import com.tinyrpg.display.misc.intro.IntroA;
	import com.tinyrpg.display.misc.intro.IntroB;
	import com.tinyrpg.display.misc.intro.IntroC;
	import com.tinyrpg.display.misc.intro.IntroD;
	import com.tinyrpg.display.misc.intro.IntroE;
	import com.tinyrpg.display.misc.intro.IntroF;
	import com.tinyrpg.display.misc.intro.IntroG;
	import com.tinyrpg.display.misc.intro.IntroH;
	import com.tinyrpg.display.misc.intro.IntroI;
	import com.tinyrpg.display.misc.intro.IntroJ;
	import com.tinyrpg.display.misc.intro.IntroK;
	import com.tinyrpg.display.misc.intro.IntroL;
	import com.tinyrpg.display.misc.intro.IntroM;
	import com.tinyrpg.display.misc.intro.IntroN;
	import com.tinyrpg.display.misc.intro.IntroO;
	import com.tinyrpg.display.misc.intro.IntroP;
	import com.tinyrpg.display.misc.intro.IntroQ;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyIntroMovie extends Sprite 
	{
		private var seq_01 : TinySpriteSheet;
		
		private var seqArray : Array = [];
		
		public function TinyIntroMovie() : void
		{
			this.seq_01 = new TinySpriteSheet(new IntroA, 320);
			
			this.seqArray.push(this.seq_01);
			this.seqArray.push(this.seq_02);
		}
		
		public function play() : void
		{
			TinyLogManager.log('play', this);
			
			TinyAudioManager.getInstance().setSong(TinyAudioManager.getInstance().INTRO, false);
			
			this.doNextSheet(null);
		}
		
		private function doNextSheet(event : Event) : void
		{
			TinyLogManager.log('doNextSheet', this);
			
			// Stop if we're done
			if (this.seqArray.length <= 0) {
			 	this.dispatchEvent(new Event(Event.COMPLETE));
			 	return;	
			} 
			
			var nextSheet : TinySpriteSheet = this.seqArray.shift();
			
			// Remove old one, show the next one
			if (this.numChildren > 0) this.removeChild(this.getChildAt(0));
			this.addChildAt(nextSheet, 0);
			nextSheet.addEventListener(Event.COMPLETE, this.doNextSheet);
			nextSheet.play();
		}
	}
}