package com.tinyrpg.data 
{
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.lookup.TinySpriteLookup;
	
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
		
		public function TinyFieldMapObjectNPC() : void 
		{
			
		}
		
		override public function dataReady() : void
		{
			// Create the NPC sprite
			this.walkSprite = new TinyWalkSprite( TinySpriteLookup.getFieldSpriteId( this.spriteName ), this.facing );
			this.walkSprite.x += 8;
			this.walkSprite.y += 8;
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
