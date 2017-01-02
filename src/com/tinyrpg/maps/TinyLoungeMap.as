package com.tinyrpg.maps 
{
	import com.tinyrpg.display.TinyMapMovieClip;
	import com.tinyrpg.display.maps.Map_Lounge;

	import flash.display.MovieClip;

	/**
	 * @author jeremyabel
	 */
	public class TinyLoungeMap extends TinyMapMovieClip 
	{
		private var mapClip : TinyMapMovieClip;
		
		public var BG		: TinyCastleMapBG;
		public var event	: String;
		
		public function TinyLoungeMap() : void
		{
			this.mapClip = new Map_Lounge;
			this.OVERLAY = this.mapClip.OVERLAY;
			this.OBJECTS = this.mapClip.OBJECTS;
			this.HIT 	 = this.mapClip.HIT;
			this.MAP	 = new MovieClip;
			
			// Add BG to MAP
			this.BG = new TinyCastleMapBG;
			this.BG.play();
			this.BG.x = 160;
			this.BG.y = 160;
			this.MAP.addChild(this.BG);
			this.MAP.addChild(this.mapClip.MAP);
				
		}
	}
}
