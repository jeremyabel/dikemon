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
		private var seq_01 : TinySpriteSheet;		private var seq_02 : TinySpriteSheet;		private var seq_03 : TinySpriteSheet;		private var seq_04 : TinySpriteSheet;		private var seq_05 : TinySpriteSheet;		private var seq_06 : TinySpriteSheet;		private var seq_07 : TinySpriteSheet;		private var seq_08 : TinySpriteSheet;		private var seq_09 : TinySpriteSheet;		private var seq_10 : TinySpriteSheet;		private var seq_11 : TinySpriteSheet;		private var seq_12 : TinySpriteSheet;		private var seq_13 : TinySpriteSheet;		private var seq_14 : TinySpriteSheet;		private var seq_15 : TinySpriteSheet;		private var seq_16 : TinySpriteSheet;		private var seq_17 : TinySpriteSheet;
		
		private var seqArray : Array = [];
		
		public function TinyIntroMovie() : void
		{
			this.seq_01 = new TinySpriteSheet(new IntroA, 320);			this.seq_02 = new TinySpriteSheet(new IntroB, 320);			this.seq_03 = new TinySpriteSheet(new IntroC, 320);			this.seq_04 = new TinySpriteSheet(new IntroD, 320);			this.seq_05 = new TinySpriteSheet(new IntroE, 320);			this.seq_06 = new TinySpriteSheet(new IntroF, 320);			this.seq_07 = new TinySpriteSheet(new IntroG, 320);			this.seq_08 = new TinySpriteSheet(new IntroH, 320);			this.seq_09 = new TinySpriteSheet(new IntroI, 320);			this.seq_10 = new TinySpriteSheet(new IntroJ, 320);			this.seq_11 = new TinySpriteSheet(new IntroK, 320);			this.seq_12 = new TinySpriteSheet(new IntroL, 320);			this.seq_13 = new TinySpriteSheet(new IntroM, 320);			this.seq_14 = new TinySpriteSheet(new IntroN, 320);			this.seq_15 = new TinySpriteSheet(new IntroO, 320);			this.seq_16 = new TinySpriteSheet(new IntroP, 320);			this.seq_17 = new TinySpriteSheet(new IntroQ, 320);
			
			this.seqArray.push(this.seq_01);
			this.seqArray.push(this.seq_02);			this.seqArray.push(this.seq_03);			this.seqArray.push(this.seq_04);			this.seqArray.push(this.seq_05);			this.seqArray.push(this.seq_06);			this.seqArray.push(this.seq_07);			this.seqArray.push(this.seq_08);			this.seqArray.push(this.seq_09);			this.seqArray.push(this.seq_10);			this.seqArray.push(this.seq_11);			this.seqArray.push(this.seq_12);			this.seqArray.push(this.seq_13);			this.seqArray.push(this.seq_14);			this.seqArray.push(this.seq_15);			this.seqArray.push(this.seq_16);			this.seqArray.push(this.seq_17);
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
