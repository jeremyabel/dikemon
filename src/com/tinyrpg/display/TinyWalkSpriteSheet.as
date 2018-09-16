package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import com.greensock.TweenMax;
	
	import com.tinyrpg.display.OverworldChars;
	import com.tinyrpg.display.misc.GrassTile;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * Class which provides an animated character sprite used by {@link TinyWalkSprite}.
	 * 
	 * @author jeremyabel
	 */
	public class TinyWalkSpriteSheet extends Sprite 
	{
		private var frontIdle	 	: Bitmap;
		private var backIdle	 	: Bitmap;
		private var sideIdle	 	: Bitmap;
		private var frontStep	 	: Bitmap;
		private var backStep	 	: Bitmap;
		private var sideStep 	 	: Bitmap;
		private var grassTile		: Bitmap;
		private var grassTileMask	: Sprite;
		private var spriteHolder 	: Sprite;
		private var currentSprite	: Bitmap;
		private var walkCycleTween	: TweenMax;
		
		public var spriteId			: uint;
		public var speed			: uint = 5;
		public var facing			: String;
		public var isWalking		: Boolean = false;
		public var keepFacing		: Boolean = false;
		public var keepDirection	: Boolean = false;
		public var walkCycleIndex 	: uint = 0;
		
		/**
		 * @param	id				The sprite's ID number.
		 * @param	initialFacing	Facing value the sprite should spawn with. Valid values are UP, DOWN, LEFT, and RIGHT.
		 */
		public function TinyWalkSpriteSheet( id : uint, initialFacing : String )
		{	
			this.spriteId = id;
			this.spriteHolder = new Sprite();
			this.spriteHolder.y -= 4;
			
			this.grassTileMask = new Sprite();
			this.grassTileMask.graphics.beginFill( 0xFF00FF );
			this.grassTileMask.graphics.drawRect( -8, -4, 16, 8 );
			this.grassTileMask.graphics.endFill();
			this.grassTileMask.cacheAsBitmap = true;
			
			this.grassTile = new Bitmap( new GrassTile() );
			this.grassTile.x += 8 - 32;
			this.grassTile.y += 8 - 32;
			this.grassTile.mask = this.grassTileMask;
			this.grassTile.visible = false;
			
			// Add 'em up			
			this.addChild( this.spriteHolder );
			this.addChild( this.grassTile );
			this.addChild( this.grassTileMask );
			
			// Create new BitmapData objects for the various sprites
			var frontIdleBitmapData : BitmapData = new BitmapData( 16, 16 );
			var backIdleBitmapData  : BitmapData = new BitmapData( 16, 16 );
			var sideIdleBitmapData  : BitmapData = new BitmapData( 16, 16 );
			var frontStepBitmapData : BitmapData = new BitmapData( 16, 16 );
			var backStepBitmapData  : BitmapData = new BitmapData( 16, 16 );
			var sideStepBitmapData  : BitmapData = new BitmapData( 16, 16 );
			
			var bitmapDataArray : Array = [
				frontIdleBitmapData,
				backIdleBitmapData,
				sideIdleBitmapData,
				frontStepBitmapData,
				backStepBitmapData,
				sideStepBitmapData 
			];
			
			var bitmapArray : Array = [];
			
			// Calculate the initial sprite position in the master overworld character spritesheet
			var overworldCharData = new OverworldChars();
			var currentX : uint = ( this.spriteId % 8 ) * 16;
			var currentY : uint = Math.floor( this.spriteId / 8 ) * 16;
			var copyRect : Rectangle = new Rectangle( currentX, currentY, 16, 16 );
			var destPoint : Point = new Point( 0, 0 );
			 
			// Copy each portion of the walk cycle spritesheet into the correct bitmaps
			for ( var i : uint = 0; i < bitmapDataArray.length; i++ ) 
			{
				bitmapDataArray[ i ].copyPixels( overworldCharData, copyRect, destPoint );
				bitmapArray.push( new Bitmap( bitmapDataArray[ i ] ) );
				bitmapArray[ i ].x = bitmapArray[ i ].y = -8;
				this.spriteHolder.addChild( bitmapArray[ i ] );
				
				currentX = ( currentX + 16 ) % 128;
				currentY = currentX == 0 ? currentY + 16 : currentY;
				copyRect = new Rectangle( currentX, currentY, 16, 16 );
			}
			
			// Set sprite accessor variables
			this.frontIdle = bitmapArray[ 0 ];
			this.backIdle  = bitmapArray[ 1 ];
			this.sideIdle  = bitmapArray[ 2 ];
			this.frontStep = bitmapArray[ 3 ];
			this.backStep  = bitmapArray[ 4 ];
			this.sideStep  = bitmapArray[ 5 ];
			
			this.facing = initialFacing;
			this.walkCycleIndex = 1;
			this.update();
		}
		
		/**
		 * Starts the sprite's walk animation at a given speed with a given facing.
		 * 
		 * @param	facing	The desired facing value. Valid values are UP, DOWN, LEFT, and RIGHT.
		 * @param	speed	The desired movement speed.  
		 */
		public function startWalking( facing : String, speed : uint = 5 ) : void
		{
			if ( this.isWalking ) return;
				
			this.isWalking = true;
			
			// Update speed and facing direction
			this.speed = speed;
			this.setFacing( facing );
			
			TinyLogManager.log( 'startWalking: ' + this.speed + ', ' + this.facing, this );
			
			// Reset the walk cycle index to the first step frame
			this.walkCycleIndex = 1;
			
			// Animate the walk cycle index if it hasn't started already 
			if ( !this.walkCycleTween ) 
			{
				this.incrementWalkCycle();
			}
		}
		
		/**
		 * Increments the sprite's walk cycle animation as long as the sprite is walking. 
		 * Triggers the next step automatically.
		 */
		public function incrementWalkCycle() : void
		{
			if ( !this.isWalking ) return;
			 
			// Increment the walk cycle index and update the sprite
			this.walkCycleIndex = ( this.walkCycleIndex + 1 ) % 4;
			this.update();
			
			// Update the cycle in a few frames
			this.walkCycleTween = TweenMax.delayedCall( 4, this.incrementWalkCycle, null, true );
		}
		
		public function update() : void
		{
			this.setSprite( this.facing, this.getIsSteppingForWalkCycleIndex() );			
		}
		
		public function reset() : void
		{
			if ( this.walkCycleTween )
			{
				this.walkCycleTween.kill();
				this.walkCycleTween = null;
				this.walkCycleIndex = 1;
			}
			
			this.update();
		}
		
		/**
		 * Sets the sprite's facing. 
		 * 
		 * @param	facing	The desired facing value. Valid values are UP, DOWN, LEFT, and RIGHT.
		 */
		public function setFacing( facing : String ) : void
		{
			if ( this.keepFacing ) return;
			
			if ( this.facing == facing ) 
			{
				this.keepDirection = true;
				return;
			}
			
			TinyLogManager.log( 'setFacing: ' + facing, this );
			this.facing = facing;
			this.keepDirection = false;
			
			// Update the sprite with the new facing direction, but maintain same the walk cycle index
			this.update();
		}
		
		/**
		 * Sets both the sprite's facing and the step state.
		 * 
		 * @param	facing	The desired facing value. Valid values are UP, DOWN, LEFT, and RIGHT.
		 * @param	step	Whether or not the step sprite is shown.
		 */
		public function setSprite( facing : String, step : Boolean ) : void 
		{	
			this.facing = facing;
			 
			// Hide all sprites
			this.setAllHidden();
				
			// Show only the updated walk cycle sprite
			this.currentSprite = this.getSpriteForFacing( facing, step );
			this.currentSprite.visible = true;
			
			// Flip the sprite container if necessary
			this.spriteHolder.scaleX = this.getXScaleForWalkCycleIndex();
		}
		
		/**
		 * Sets the visibility of the grass layer.
		 */
		public function setGrassVisible( visible : Boolean ) : void
		{
			this.grassTile.visible = visible;
		}
		
		public function updateGrassOffset( x : int, y : int ) : void
		{	
			this.grassTile.x = 8 - 32 - x;
			this.grassTile.y = 8 - 32 - y;
		}
		
		private function setAllHidden() : void
		{
			this.frontIdle.visible = false;
			this.backIdle.visible = false;
			this.sideIdle.visible = false;
			this.frontStep.visible = false;
			this.backStep.visible = false;
			this.sideStep.visible = false;
		}
		
		private function getSpriteForFacing( facing : String, step : Boolean ) : Bitmap
		{	
			switch ( facing )
			{
				case TinyWalkSprite.UP: 	return step ? this.backStep  : this.backIdle;
				case TinyWalkSprite.DOWN:	return step ? this.frontStep : this.frontIdle;
				case TinyWalkSprite.LEFT:	return step ? this.sideStep  : this.sideIdle;
				case TinyWalkSprite.RIGHT:	return step ? this.sideStep  : this.sideIdle;
			}
			
			return this.frontIdle;
		}
		
		private function getXScaleForWalkCycleIndex() : int
		{
			if ( this.facing == TinyWalkSprite.LEFT ) return 1;
			if ( this.facing == TinyWalkSprite.RIGHT ) return -1;
			
			if ( this.facing == TinyWalkSprite.UP || this.facing == TinyWalkSprite.DOWN ) 
			{
				if ( this.walkCycleIndex < 2 ) return 1;
				if ( this.walkCycleIndex > 1 ) return -1; 
			}
			
			return 1;
		}
		
		private function getIsSteppingForWalkCycleIndex() : Boolean
		{
			if ( this.walkCycleIndex == 0 || this.walkCycleIndex == 2 ) return true;
			return false;
		}
	}
}
