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
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
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
		public var keepDirection	: Boolean = false;
		public var walkCycleIndex 	: uint = 0;
		
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
			this.walkCycleIndex = 1;
			this.update();
		}
		
		public function startWalking( speed : uint = 5 ) : void
		{
			if ( this.isWalking ) return;
			
			TinyLogManager.log( 'startWalking', this );
			
			this.speed = speed;
	
			// Update facing direction
			var arrowKey : String = TinyInputManager.getInstance().getCurrentArrowKey();
			this.setFacing( arrowKey );
			
			// Reset the walk cycle index to the first step frame
			this.walkCycleIndex = 1;
			
			// Check for arrow inputs to advance the walk cycle
			this.checkArrowInputs();
		}
		
		private function checkArrowInputs() : void
		{
			var arrowKey : String = TinyInputManager.getInstance().getCurrentArrowKey();
			
			TinyLogManager.log( 'checkArrowInputs: ' + arrowKey, this );
			
			if ( arrowKey ) 
			{
				this.isWalking = true;
				
				// Increment the walk cycle index
				this.walkCycleIndex = ( this.walkCycleIndex + 1 ) % 4;
				
				// Trigger a movement every time a step is taken
				if ( !this.getIsSteppingForWalkCycleIndex() || this.keepDirection ) 
				{
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.ADVANCE_MOVEMENT, arrowKey ) );
				}
				
				this.keepDirection = false;
				
				// Check again after a delay
				TweenMax.delayedCall( this.speed, this.checkArrowInputs, null, true );
			}
			else
			{
				// No arrows are being held down. Reset the walk cycle index.
				this.walkCycleIndex = 1;
				this.isWalking = false;
			}
			
			// Update the sprite with the current facing direction and walk cycle index
			this.update();
		}
		
		public function update() : void
		{
			this.setSprite( this.facing, this.getIsSteppingForWalkCycleIndex() );			
		}
		
		public function setFacing( facing : String ) : void
		{
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
