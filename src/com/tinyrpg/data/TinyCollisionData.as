package com.tinyrpg.data 
{	
	/**
	 * Class which represents data about a collision in the field map between the player
	 * and some other object.
	 */
	public class TinyCollisionData 
	{
		// Whether or not the object was hit
		public var hit : Boolean;
		
		// The object that was hit
		public var object : *;
		
		public function TinyCollisionData( hit : Boolean, object : * = null ) : void 
		{
			this.hit = hit;
			this.object = object; 
		}
	}
}
