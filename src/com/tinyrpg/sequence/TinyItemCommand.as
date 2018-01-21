package com.tinyrpg.sequence 
{
	import com.tinyrpg.core.TinyItem;

	/**
	 * @author jeremyabel
	 */
	public class TinyItemCommand 
	{
		public var gold : int;
		public var item : TinyItem;
		public var take : Boolean;
		
		public function TinyItemCommand( take : Boolean, item : TinyItem = null, gold : int = 0 ) : void
		{
			this.take = take;
			this.item = item;
			this.gold = gold;
		}
	}
}
