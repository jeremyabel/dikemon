package com.tinyrpg.data 
{
	import com.tinyrpg.display.TinyWalkSprite;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyFieldMapObjectWarp extends TinyFieldMapObject
	{
		public var targetMapName : String;
		public var targetWarpName : String;
		public var requiredFacing : String;
		public var destinationFacing : String;
		public var postFadeSequenceName : String;
		
		// Whether or not you warp instantly after stepping on the tile
		public var instant : Boolean = false;
		
		// Whether or not you take a step forward after warping
		public var stepForwardAfterWarp : Boolean = false;
		
		// Whether or not this warp was caused by a game over in battle
		public var fromGameOver : Boolean = false;
		
		public function TinyFieldMapObjectWarp() : void 
		{
			
		}
		
		override public function isBlocking( walkSprite : TinyWalkSprite ) : Boolean
		{
			return !this.instant && walkSprite.currentDirection == this.requiredFacing; 			
		}
	}
}
