package com.tinyrpg.misc 
{
	/**
	 * @author jeremyabel
	 */
	public class TinyRoundResult extends Object 
	{
		public static var RESULT_HIT : String = "RESULT_DAMAGE";
		public static var RESULT_HEAL : String = "RESULT_HEAL";
		public static var RESULT_MISS : String = "RESULT_MISS";
		
		public var result : String;
		public var quantity : int;
			
		public function TinyRoundResult(result : String, quantity : int = 0) : void
		{
			this.result = result;
			this.quantity = quantity;		
		}
	}
}