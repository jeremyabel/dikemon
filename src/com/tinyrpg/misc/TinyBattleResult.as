package com.tinyrpg.misc 
{

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleResult 
	{
		public static var RESULT_WIN : String = 'RESULT_WIN';
		public static var RESULT_LOST : String = 'RESULT_LOST';
		public static var RESULT_FORCED : String = 'RESULT_FORCED';	// for battles you can't win
		
		public var result : String;
		
		public function TinyBattleResult(result : String) : void
		{
			this.result = result;		
		}
	}
}
