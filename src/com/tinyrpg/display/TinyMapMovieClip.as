package com.tinyrpg.display 
{
	import com.tinyrpg.data.TinyFieldMapObject;
	
	import flash.display.MovieClip;

	/**
	 * @author jeremyabel
	 */
	public class TinyMapMovieClip extends MovieClip 
	{
		public var map		: MovieClip;		public var hit		: MovieClip;
		public var grass 	: MovieClip;
		public var objects 	: MovieClip;
		public var jumpU 	: MovieClip;
		public var jumpD	: MovieClip;
		public var jumpL	: MovieClip;		public var jumpR	: MovieClip;
		public var disableU	: MovieClip;
		
		public function TinyMapMovieClip() : void { }
	}
}
