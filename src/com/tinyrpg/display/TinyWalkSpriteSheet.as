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
	import com.tinyrpg.utils.TinyLogManager;

	/**
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
		private var spriteHolder 	: Sprite;
		private var currentSprite	: Bitmap;
		
		public var spriteId			: uint;
		public var speed			: uint = 4;
		public var facing			: String;
		public var isWalking		: Boolean = false;
		public var walkCycleIndex 	: uint = 0;
		
		public static const WALK_CYCLE_FRAMES : uint = 4;

		public function TinyWalkSpriteSheet( id : uint, initialFacing : String )
		{	
			this.spriteId = id;
			this.spriteHolder = new Sprite();
			this.addChild( this.spriteHolder );
			
			var overworldCharData = new OverworldChars(); 
			
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
			this.walkCycleIndex = this.getIdleWalkCycleIndexForFacing();
			this.update();
		}
		
		public function startWalking( speed : uint = 4 ) : void
		{
			TinyLogManager.log( 'startWalking', this );
			
			this.speed = speed;
			this.walkCycleIndex = 0;
			this.isWalking = true;
			this.update();
			
			// Trigger the next step in 4 frames
			TweenMax.delayedCall( this.speed, this.onWalkCycleUpdate, null, true );
		}
		
		public function stopWalking() : void
		{
			TinyLogManager.log( 'stopWalking', this );
			this.isWalking = false;
		}

		private function onWalkCycleUpdate() : void
		{
			// Increment the walk cycle index
			this.walkCycleIndex = ( this.walkCycleIndex + 1 ) % 4;
			
			// Update the sprite with the current facing direction and updated walk cycle index
			this.update();
			
			// Trigger the next step if we're still walking, otherwise return to the idle sprite
			if ( this.isWalking ) 
			{	
				// The next step in the cycle happens every 4 frames
				TweenMax.delayedCall( this.speed, this.onWalkCycleUpdate, null, true );
			}
			else 
			{
				this.walkCycleIndex = this.getIdleWalkCycleIndexForFacing();
				TweenMax.delayedCall( this.speed, this.update, null, true );
			}
		}
		
		public function update() : void
		{
			this.setSprite( this.facing, this.getIsSteppingForWalkCycleIndex() );			
		}
		
		public function setFacing( facing : String ) : void
		{
			if ( this.facing == facing ) return;
			
			this.facing = facing;
//			TinyLogManager.log( 'setFacing: ' + this.facing, this );
			
			// Update the sprite with the new facing direction, but maintain same the walk cycle index
			this.update();
		}
		
		public function setSprite( facing : String, step : Boolean ) : void 
		{	
			this.facing = facing;
			 
			this.setAllHidden();
			
			this.currentSprite = this.getSpriteForFacing( facing, step );
			this.currentSprite.visible = true;
			
			// Flip the sprite container if necessary
			this.spriteHolder.scaleX = this.getXScaleForWalkCycleIndex();
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
				case TinyWalkSprite.UP: 	return step ? this.backStep : this.backIdle;
				case TinyWalkSprite.DOWN:	return step ? this.frontStep : this.frontIdle;
				case TinyWalkSprite.LEFT:	return step ? this.sideStep : this.sideIdle;
				case TinyWalkSprite.RIGHT:	return step ? this.sideStep : this.sideIdle;
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
			if ( this.facing == TinyWalkSprite.UP )
			{
				if ( this.walkCycleIndex == 0 || this.walkCycleIndex == 2 ) return true;
				if ( this.walkCycleIndex == 1 || this.walkCycleIndex == 3 ) return false;
			}
			
			if ( this.facing == TinyWalkSprite.DOWN )
			{
				if ( this.walkCycleIndex == 0 || this.walkCycleIndex == 2 ) return false;
				if ( this.walkCycleIndex == 1 || this.walkCycleIndex == 3 ) return true;
			}
			
			if ( this.facing == TinyWalkSprite.LEFT || this.facing == TinyWalkSprite.RIGHT ) 
			{
				if ( this.walkCycleIndex == 0 || this.walkCycleIndex == 2 ) return true;
				if ( this.walkCycleIndex == 1 || this.walkCycleIndex == 3 ) return false;
			}
			
			return false;
		}
		
		private function getIdleWalkCycleIndexForFacing() : uint
		{
			switch ( this.facing ) 
			{
				case TinyWalkSprite.UP:		return 1;
				case TinyWalkSprite.DOWN:	return 0;
				case TinyWalkSprite.LEFT:	return 1;
				case TinyWalkSprite.RIGHT:	return 1;
			}
			
			return 1;
		}
		
		private function getBitmapForInitIndex( index : uint ) : Bitmap
		{
			switch ( index ) 
			{
				case 0: return this.frontIdle;
				case 1: return this.backIdle;
				case 2: return this.sideIdle; 
				case 3: return this.frontStep;
				case 4: return this.backStep;
				case 5: return this.sideStep;
			}
			
			return this.frontIdle;
		}
	}
}
