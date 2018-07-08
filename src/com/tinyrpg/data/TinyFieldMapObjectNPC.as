package com.tinyrpg.data 
{
	import com.greensock.TweenLite;
	
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.lookup.TinyNameLookup;
	import com.tinyrpg.lookup.TinySpriteLookup;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;
	
	/**
	 * Class which represents a NPC sprite on the map. 
	 * 
	 * NPCs consist of a {@link TinyWalkSprite} which contains the visual representation
	 * of the NPC, along with an event name which will be executed if the player presses
	 * the Activate button while touching the NPC's sprite.  
	 * 
	 * In the original Pokemon Crystal, some NPCs were able to move. This has not been
	 * implemented here in order to keep things simple. NPCs are able to spin in place,
	 * in order to prevent them from being entirely static. 
	 */
	public class TinyFieldMapObjectNPC extends TinyFieldMapObject
	{
		public var facing 		: String;
		public var npcName		: String;
		public var spriteName 	: String;
		public var eventName 	: String;
		public var walkSprite 	: TinyWalkSprite;
		public var isInGrass	: Boolean;
		public var randomSpin	: Boolean = false;
		public var enableSpin	: Boolean = true;
		public var facePlayer	: Boolean = true;
		
		private var randomDirections : Array = [ 'UP', 'DOWN', 'LEFT', 'RIGHT' ];
		
		public function TinyFieldMapObjectNPC() : void 
		{
			
		}
		
		override public function dataReady() : void
		{
			var spriteId : uint = TinySpriteLookup.getFieldSpriteId( this.spriteName );
			
			// Rename the rival sprite to the correct name if required
			if ( this.spriteName.toUpperCase() == 'RIVAL' ) 
			{
				spriteId = TinySpriteLookup.getPlayerSpriteId( TinyNameLookup.getRivalNameForPlayerName( TinyGameManager.getInstance().playerTrainer.name ) ); 
			}
			
			// Get facing from the object name. Object name format is a string like "[object MapObjectNPCLeft]".
			// It needs to be sliced down to just the facing string at the end of the object name.
			this.facing = this.toString().toUpperCase().slice( 20, -1 );
			
			// Create the NPC sprite
			this.walkSprite = new TinyWalkSprite( spriteId, this.facing );
			this.walkSprite.x += 8;
			this.walkSprite.y += 8;
			
			// Configure hitbox
			this.hitbox = this.walkSprite.hitBox;
			this.walkSprite.hitBox.owner = this;
			
			// Add 'em up
			this.addChild( this.walkSprite );
				
			this.tryRestartSpin();
			super.dataReady();
		}
		
		
		/**
		 * If spinning is enabled, start the spin update after a brief delay. 
		 */
		public function tryRestartSpin() : void
		{
			if ( this.randomSpin ) 
			{		
				TinyLogManager.log( 'tryRestartSpin', this );
				TweenLite.delayedCall( TinyMath.randomInt( 100, 200 ), this.updateSpin, null, true );
			}
		}
		
		
		/**
		 * Randomizes the NPC's facing direction every 100 - 200 miliseconds.  
		 */
		private function updateSpin() : void
		{
			if ( this.enableSpin )
			{
				var directionIndex : uint = TinyMath.randomInt( 0, 3 );
				this.walkSprite.setFacing( this.randomDirections[ directionIndex ] );
				
				TweenLite.delayedCall( TinyMath.randomInt( 100, 200 ), this.updateSpin, null, true );
			}
		}
		
		
		/**
		 * Sets the NPC's facing direction such that it is facing towards the player.
		 * 
		 * @param	facing	the player's current facing direction
		 */
		public function setFacingFromPlayerFacing( facing : String ) : void
		{
			if ( this.facePlayer )
			{
				switch ( facing )
				{
					case 'UP':		this.walkSprite.setFacing( 'DOWN' ); break;
					case 'DOWN':	this.walkSprite.setFacing( 'UP' ); break;
					case 'LEFT':	this.walkSprite.setFacing( 'RIGHT' ); break;
					case 'RIGHT':	this.walkSprite.setFacing( 'LEFT' ); break;
				}
			}
		}
	}
}
