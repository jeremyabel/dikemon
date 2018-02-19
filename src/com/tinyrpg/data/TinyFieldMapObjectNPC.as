package com.tinyrpg.data 
{
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.lookup.TinyNameLookup;
	import com.tinyrpg.lookup.TinySpriteLookup;
	import com.tinyrpg.managers.TinyGameManager;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyFieldMapObjectNPC extends TinyFieldMapObject
	{
		public var facing 		: String;
		public var npcName		: String;
		public var spriteName 	: String;
		public var eventName 	: String;
		public var walkSprite 	: TinyWalkSprite;
		public var isInGrass	: Boolean;
		
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
			
			// Create the NPC sprite
			this.walkSprite = new TinyWalkSprite( spriteId, this.facing );
			this.walkSprite.x += 8;
			this.walkSprite.y += 8;
			
			// Configure hitbox
			this.hitbox = this.walkSprite.hitBox;
			this.walkSprite.hitBox.owner = this;
			
			// Add 'em up
			this.addChild( this.walkSprite );
			
			super.dataReady();
		}
		
		public function setFacingFromPlayerFacing( facing : String ) : void
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
