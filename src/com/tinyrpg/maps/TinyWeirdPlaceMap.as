package com.tinyrpg.maps 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import com.greensock.plugins.RoundPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.tinyrpg.display.TinyMapMovieClip;
	import com.tinyrpg.display.maps.Map_Weird_Place;
	import com.tinyrpg.display.maps.misc.Map_Weird_Place_Mouth;

	import flash.display.MovieClip;

	/**
	 * @author jeremyabel
	 */
	public class TinyWeirdPlaceMap extends TinyMapMovieClip 
	{
		private var mapClip : TinyMapMovieClip;
		
		public var event : String;
		
		public function TinyWeirdPlaceMap() : void
		{
			TweenPlugin.activate([RoundPropsPlugin]);
			
			this.mapClip = new Map_Weird_Place;
			this.HIT 	 = this.mapClip.HIT;
			this.MAP	 = this.mapClip.MAP;
			this.OBJECTS = this.mapClip.OBJECTS;
			this.PROPS 	 = new MovieClip;
			
			// Animate mouth
			var mouth : MovieClip = new Map_Weird_Place_Mouth;
			mouth.x = 176;
			mouth.y = 88;			
			this.MAP.addChild(mouth);
			TweenMax.to(mouth, 34, { y:95, repeat:-1, roundProps:["x","y"], ease:Sine.easeInOut, yoyo:true, useFrames:true });
		}
	}
}
