package com.tinyrpg.data 
{
	import com.tinyrpg.events.TinyFieldMapEvent;
	import com.tinyrpg.display.TinyWalkSprite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	/**
	 * Base class for all interactable objects placed on the field map.
	 */
	public class TinyFieldMapObject extends MovieClip
	{
		// The icon shown in the Flash editor
		public var icon : MovieClip;
		
		// A shape used for the object's hitbox
		public var hitbox : DisplayObject;
		
		public function TinyFieldMapObject() : void 
		{
			this.hitbox = this;
				
			if ( this.icon )
			{
				this.icon.alpha = 0.01; 
			}
		}
		
		
		/**
		 * Overrideable function which is used for notifying the {@link TinyFieldMap} that the object's
		 * data is set and ready. 
		 * 
		 * In order to keep all map data within the MapAssets.fla file, each object's data is defined via 
		 * ActionScript placed in the map's MovieClip on the first frame. As such, the data isn't ready 
		 * until that frame is executed, which is AFTER the TinyFieldMap's constructor is called. The 
		 * DATA_READY event is thrown to allow the map to delay initialization until after all of the 
		 * map's objects are ready. 
		 */
		public function dataReady() : void
		{
			this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.DATA_READY, this ) );
		}
		
		
		public function isBlocking( walkSprite : TinyWalkSprite ) : Boolean
		{
			return true;
		}
	}
}
