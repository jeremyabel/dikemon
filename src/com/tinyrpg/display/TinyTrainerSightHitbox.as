package com.tinyrpg.display
{
	import flash.display.Sprite;
	
	/**
	 * Class which provides a rectangular hitbox used for trainer sight. 
	 * 
	 * This hitbox extends from the trainer's facing direction for a given 
	 * number of tiles. If the player walks into this box, it will trigger an 
	 * encounter with the trainer.
	 * 
	 * Instantiated by {@link TinyWalkSprite}.
	 * 
	 * @author jeremyabel
	 */
	public class TinyTrainerSightHitbox extends Sprite 
	{
		public var owner : *;
		
		private var color : uint;
		
		/**
		 * @param	owner	The object which owns this hitbox. Probably should be a {@link TinyWalkSprite}.
		 * @param	color	The hitbox's color, shown only when debugging.
		 */
		public function TinyTrainerSightHitbox( owner : *, color : uint ) : void
		{
			this.color = color;
			this.owner = owner;
				
			this.graphics.beginFill( this.color, 0.25 );
			this.graphics.drawRect( -8, -8, 16, 16 );
			this.graphics.endFill();
		}
		
		/**
		 * Sets how many tiles the hitbox extends beyond the trainer.
		 */
		public function setNumTiles( tiles : int ) : void
		{
			this.graphics.clear();
			this.graphics.beginFill( this.color, 0.25 );
			this.graphics.drawRect( -8, -8, 16 * tiles, 16 );
			this.graphics.endFill();
		}
	}
	
}
