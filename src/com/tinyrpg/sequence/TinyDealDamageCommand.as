package com.tinyrpg.sequence 
{
	import com.tinyrpg.core.TinyMon;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyDealDamageCommand 
	{
		public var mon : TinyMon;
		public var damage : int;
		public var isEnemy : Boolean;
		
		public function TinyDealDamageCommand( mon : TinyMon, damage : int, isEnemy : Boolean )
		{
			this.mon = mon;
			this.damage = damage;
			this.isEnemy = isEnemy; 
		}
	}
}
