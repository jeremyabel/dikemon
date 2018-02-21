package com.tinyrpg.battle 
{

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleResult 
	{
		public static var RESULT_RAN : String = 'RESULT_RAN';
		public static var RESULT_WIN : String = 'RESULT_WIN';
		public static var RESULT_LOSE : String = 'RESULT_LOSE';
		public static var RESULT_FORCED : String = 'RESULT_FORCED';	// for battles you can't win
		
		public var value : String;
		
		public function TinyBattleResult( result : String ) : void
		{
			this.value = result;
		}
	}
}
