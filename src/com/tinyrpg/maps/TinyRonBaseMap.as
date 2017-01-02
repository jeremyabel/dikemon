package com.tinyrpg.maps 
{
	import com.tinyrpg.display.TinyMapMovieClip;
	import com.tinyrpg.display.maps.Map_Ron_Base;

	/**
	 * @author jeremyabel
	 */
	public class TinyRonBaseMap extends TinyMapMovieClip 
	{
		private var mapClip : TinyMapMovieClip;
		
		public var event : String;
		
		public function TinyRonBaseMap() : void
		{
			this.mapClip = new Map_Ron_Base;
			this.OVERLAY = this.mapClip.OVERLAY;
			this.HIT 	 = this.mapClip.HIT;
			this.OBJECTS = this.mapClip.OBJECTS;
			this.MAP	 = this.mapClip.MAP;
		}
	}
}
