package com.tinyrpg.display
{
	import flash.display.Sprite;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyTrainerSightHitbox extends Sprite 
	{
		public var owner : *;
		
		private var color : uint;
		
		public function TinyTrainerSightHitbox( owner : *, color : uint ) : void
		{
			this.color = color;
			this.owner = owner;
				
			this.graphics.beginFill( this.color, 0.25 );
			this.graphics.drawRect( -8, -8, 16, 16 );
			this.graphics.endFill();
		}
		
		public function setNumTiles( tiles : int ) : void
		{
			this.graphics.clear();
			this.graphics.beginFill( this.color, 0.25 );
			this.graphics.drawRect( -8, -8, 16 * tiles, 16 );
			this.graphics.endFill();
		}
	}
	
}
