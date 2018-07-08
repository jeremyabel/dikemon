package com.tinyrpg.data 
{
	import com.tinyrpg.display.TinyWalkSprite;
	
	/**
	 * Class which represents an invisible tile which warps the player to
	 * another warp tile on a different map.
	 */
	public class TinyFieldMapObjectWarp extends TinyFieldMapObject
	{
		// The name of the map to warp to.
		public var targetMapName : String;
		
		// The name of the warp object we're warping to, on the target map.
		public var targetWarpName : String;
		
		// The direction the player must be facing to trigger the warp.
		public var requiredFacing : String;
		
		// The direction to set the player's facing at the warp's destination.
		public var destinationFacing : String;
		
		// The name of an event sequence to play after the warp is complete.
		// If none is provided, no event will play.
		public var postFadeSequenceName : String;
		
		// Whether or not the post-fade event is a global event
		public var isPostFadeSequenceGlobal : Boolean = false;
		
		public var useGridPos : Boolean = false;
		public var gridPosX : int;
		public var gridPosY : int;
		
		// Whether or not you warp instantly after stepping on the tile
		public var instant : Boolean = false;
		
		// Whether or not to move the player forward one step after warping
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
