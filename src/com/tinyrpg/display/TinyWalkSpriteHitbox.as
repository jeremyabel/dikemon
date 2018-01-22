package com.tinyrpg.display
{
	import flash.display.Sprite;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyWalkSpriteHitbox extends Sprite 
	{
		public var owner : *;
		
		public function TinyWalkSpriteHitbox( owner : *, color : uint ) : void
		{
			this.owner = owner;
				
			this.graphics.beginFill( color, 0.25 );
			this.graphics.drawRect( -8, -8, 16, 16 );
			this.graphics.endFill();
		}
	}
	
}
