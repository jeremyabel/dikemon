package com.tinyrpg.battle 
{

	/**
	 * Class which represents the final result of a battle.
	 * Used for determining what action to take after a battle is completed.
	 * 
	 * @author jeremyabel
	 */
	public class TinyBattleResult 
	{
		public static var RESULT_RAN : String = 'RESULT_RAN';
		public static var RESULT_WIN : String = 'RESULT_WIN';
		public static var RESULT_LOSE : String = 'RESULT_LOSE';
		public static var RESULT_FORCED : String = 'RESULT_FORCED';	// for battles you can't win
		public static var RESULT_CAUGHT	: String = 'RESULT_CAUGHT';
		
		public var value : String;
		
		/**
		 * Class constructor which takes a results string value
		 */
		public function TinyBattleResult( result : String ) : void
		{
			this.value = result;
		}
	}
}
