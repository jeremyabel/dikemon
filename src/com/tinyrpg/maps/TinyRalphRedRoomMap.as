package com.tinyrpg.maps 
{
	import com.tinyrpg.display.TinyMapMovieClip;
	import com.tinyrpg.display.maps.Map_Ralph_Red_Room;

	/**
	 * @author jeremyabel
	 */
	public class TinyRalphRedRoomMap extends TinyMapMovieClip 
	{
		private var mapClip : TinyMapMovieClip;
		
		public var event : String;
		
		public function TinyRalphRedRoomMap() : void
		{
			this.mapClip = new Map_Ralph_Red_Room;
			this.OVERLAY = this.mapClip.OVERLAY;
			this.HIT 	 = this.mapClip.HIT;
			this.OBJECTS = this.mapClip.OBJECTS;
			this.MAP	 = this.mapClip.MAP;
			
			this.MAP.addChild(this.mapClip.getChildByName('SCREEN'));
		}
	}
}
