package com.tinyrpg.data 
{
	import com.tinyrpg.display.TinyTrainerSightHitbox;
	
	import flash.display.Sprite;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyFieldMapObjectTrainer extends TinyFieldMapObjectNPC
	{
//		public var sightTiles 	: int = 5;
//		public var sightHitbox 	: TinyTrainerSightHitbox;
		 
		public function TinyFieldMapObjectTrainer() : void 
		{
			
		}
		
		override protected function initSprite() : void
		{
			// Get facing from the object name. Object name format is a string like "[object MapObjectTrainerLeft]".
			// It needs to be sliced down to just the facing string at the end of the object name.
			this.facing = this.toString().toUpperCase().slice( 24, -1 );
			
			super.initSprite();
			
			this.sightbox = this.walkSprite.sightBox;
			this.sightbox.setNumTiles( this.sightTiles );
			this.walkSprite.sightBox.owner = this;
		}
	}
}
