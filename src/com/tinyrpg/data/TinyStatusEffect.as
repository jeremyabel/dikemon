package com.tinyrpg.data 
{

	/**
	 * @author jeremyabel
	 */
	public class TinyStatusEffect 
	{
		public static const CONFUSION 		: String = 'CONFUSION';
		public static const POISON			: String = 'POISON';
		public static const PARALYSIS		: String = 'PARALYSIS';
		public static const BURN			: String = 'BURN';
		public static const SLEEP			: String = 'SLEEP';
		public static const FLINCH			: String = 'FLINCH';
		public static const MEAN_LOOK		: String = 'MEAN_LOOK';
		public static const LOCK_ON			: String = 'LOCK_ON';
		
		public static function isVolatile( statusEffect : String ) : Boolean
		{
			return statusEffect == CONFUSION ||
				statusEffect == POISON ||
				statusEffect == PARALYSIS ||
				statusEffect == BURN ||
				statusEffect == SLEEP || 
				statusEffect == MEAN_LOOK ||
				statusEffect == LOCK_ON;
		}
	}
}
