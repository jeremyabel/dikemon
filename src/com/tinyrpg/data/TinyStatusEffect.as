package com.tinyrpg.data 
{
	import com.tinyrpg.display.TinyStatusFXAnimation;

	/**
	 * Class which represents a status effect that can be applied to a mon.
	 * 
	 * Status effects can change the flow of battle, either by causing damage at the
	 * end of a turn, or by preventing a turn from happening.
	 * 
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
		
		/**
		 * Returns true if the given status effect has a battle animation that is triggered on each
		 * turn that the effect is active.
		 */
		public static function isAnimated( statusEffect : String ) : Boolean
		{
			return statusEffect == CONFUSION ||
				statusEffect == POISON ||
				statusEffect == PARALYSIS ||
				statusEffect == BURN ||
				statusEffect == SLEEP;
		}
	}
}
