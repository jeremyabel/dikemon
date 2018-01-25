package com.tinyrpg.data 
{
	import com.tinyrpg.events.TinyFieldMapEvent;
	import com.tinyrpg.display.TinyWalkSprite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyFieldMapObject extends MovieClip
	{
		public var icon : MovieClip;
		public var hitbox : DisplayObject;
		
		public function TinyFieldMapObject() : void 
		{
			this.hitbox = this;
			
			if ( this.icon )
			{
				this.icon.alpha = 0.01; //false;
			}
		}
		
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
