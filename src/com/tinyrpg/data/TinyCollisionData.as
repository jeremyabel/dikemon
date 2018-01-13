package com.tinyrpg.data 
{	
	/**
	 * @author jeremyabel
	 */
	public class TinyCollisionData 
	{
		public var hit : Boolean;
		public var object : *;
		
		public function TinyCollisionData( hit : Boolean, object : * = null ) : void 
		{
			this.hit = hit;
			this.object = object; 
		}
	}
}
