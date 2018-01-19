package com.tinyrpg.display 
{
	import com.tinyrpg.data.TinyFieldMapObject;
	
	import flash.display.MovieClip;

	/**
	 * @author jeremyabel
	 */
	public class TinyMapMovieClip extends MovieClip 
	{
		public var map			: MovieClip;		public var hit			: MovieClip;
		public var objects 		: MovieClip;
		public var overlay		: MovieClip;
		public var grass 		: MovieClip;
		public var jumpU 		: MovieClip;
		public var jumpD		: MovieClip;
		public var jumpL		: MovieClip;		public var jumpR		: MovieClip;
		public var disableU		: MovieClip;
		
		public var hasGrass 	: Boolean = false;
		public var hasJumpU 	: Boolean = false;
		public var hasJumpD 	: Boolean = false;
		public var hasJumpL 	: Boolean = false;
		public var hasJumpR 	: Boolean = false;
		public var hasOverlay	: Boolean = false;
		public var hasDisableU 	: Boolean = false;
		
		public function TinyMapMovieClip() : void 
		{
			 if ( this.grass ) this.hasGrass = true;
			 if ( this.jumpU ) this.hasJumpU = true;
			 if ( this.jumpD ) this.hasJumpD = true;
			 if ( this.jumpL ) this.hasJumpL = true;
			 if ( this.jumpR ) this.hasJumpR = true;
			 if ( this.overlay ) this.hasOverlay = true;
			 if ( this.disableU ) this.hasDisableU = true;
		}
	}
}
