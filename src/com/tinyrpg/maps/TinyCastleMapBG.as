package com.tinyrpg.maps 
{
	import com.tinyrpg.display.TinySpriteSheet;
	import com.tinyrpg.display.maps.Map_Castle_Entrance.BGA;
	import com.tinyrpg.display.maps.Map_Castle_Entrance.BGB;
	import com.tinyrpg.display.maps.Map_Castle_Entrance.BGC;
	import com.tinyrpg.display.maps.Map_Castle_Entrance.BGD;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyCastleMapBG extends Sprite 
	{
		private var seq_01 : TinySpriteSheet;
		private var seq_02 : TinySpriteSheet;
		private var seq_03 : TinySpriteSheet;
		private var seq_04 : TinySpriteSheet;
		
		private var seqArray : Array = [];
		
		public function TinyCastleMapBG() : void
		{
			this.seq_01 = new TinySpriteSheet(new BGA, 320);
			this.seq_02 = new TinySpriteSheet(new BGB, 320);
			this.seq_03 = new TinySpriteSheet(new BGC, 320);
			this.seq_04 = new TinySpriteSheet(new BGD, 320);
			
			this.seqArray.push(this.seq_01);
			this.seqArray.push(this.seq_02);
			this.seqArray.push(this.seq_03);
			this.seqArray.push(this.seq_04);
		}
		
		public function play() : void
		{
			TinyLogManager.log('play', this);
			
			this.doNextSheet(null);
		}
		
		private function doNextSheet(event : Event) : void
		{
			// Loop next sheet			
			var nextSheet : TinySpriteSheet = this.seqArray.shift();
			this.seqArray.push(nextSheet);
			
			// Remove old one, show the next one
			if (this.numChildren > 0) this.removeChild(this.getChildAt(0));
			this.addChildAt(nextSheet, 0);
			nextSheet.addEventListener(Event.COMPLETE, this.doNextSheet);
			nextSheet.play();
		}
	}
}
