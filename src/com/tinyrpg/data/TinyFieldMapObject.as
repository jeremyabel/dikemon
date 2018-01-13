package com.tinyrpg.data 
{
	import com.tinyrpg.events.TinyFieldMapEvent;
	import com.tinyrpg.display.TinyWalkSprite;
	
	import flash.display.MovieClip;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyFieldMapObject extends MovieClip
	{
		public function TinyFieldMapObject() : void 
		{
			 
		}
		
		public function dataReady() : void
		{
			this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.DATA_READY ) );
		}
	
		public function isBlocking( walkSprite : TinyWalkSprite ) : Boolean
		{
			return true;
		}
	}
}
