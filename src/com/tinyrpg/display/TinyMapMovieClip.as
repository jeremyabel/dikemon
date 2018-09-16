package com.tinyrpg.display 
{
	import com.tinyrpg.data.TinyFieldMapObject;
	
	import flash.display.MovieClip;

	/**
	 * Display class which represents a map constructed in the Flash editor from multiple bitmap layers.
	 *  
	 * Each map layer has specific functions, and this data is used by {@link TinyFieldMap} to determine
	 * the player's mobility options on specific parts of the map.
	 * 
	 * @author jeremyabel
	 */
	public class TinyMapMovieClip extends MovieClip 
	{
		// The base sprite layer. This is the only layer which is visible to the player.
		public var map : MovieClip;
		
		// The collision layer. Black areas cannot be walked on.		public var hit : MovieClip;
		
		// The objects layer. NPCs, warps, and triggers are placed here.
		public var objects : MovieClip;
		
		// The grass layer. The player can walk on this, but it might trigger an encounter.
		public var grass : MovieClip;
		
		// The jumpU layer. If the player walks into this while facing UP, a jump will trigger. Not traversable in other directions. 
		public var jumpU : MovieClip;
		
		// The jumpD layer. If the player walks into this while facing DOWN, a jump will trigger. Not traversable in other directions.
		public var jumpD : MovieClip;
		
		// The jumpL layer. If the player walks into this while facing LEFT, a jump will trigger. Not traversable in other directions.
		public var jumpL : MovieClip;		
		// The jumpR layer. If the player walks into this while facing RIGHT, a jump will trigger. Not traversable in other directions.
		public var jumpR : MovieClip;
		
		// The disableU layer. The player can traverse this layer in all directions except UP.
		public var disableU	: MovieClip;
		
		public var hasGrass 	: Boolean = false;
		public var hasJumpU 	: Boolean = false;
		public var hasJumpD 	: Boolean = false;
		public var hasJumpL 	: Boolean = false;
		public var hasJumpR 	: Boolean = false;
		public var hasDisableU 	: Boolean = false;
		
		// The name of the map that the player is sent to after a game over. Typically this should be the nearest Dikécenter.
		public var gameoverMapName  : String = '';
		
		public function TinyMapMovieClip() : void 
		{
			 if ( this.grass ) this.hasGrass = true;
			 if ( this.jumpU ) this.hasJumpU = true;
			 if ( this.jumpD ) this.hasJumpD = true;
			 if ( this.jumpL ) this.hasJumpL = true;
			 if ( this.jumpR ) this.hasJumpR = true;
			 if ( this.disableU ) this.hasDisableU = true;
		}
	}
}
