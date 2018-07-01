package com.tinyrpg.data
{
	/**
	 * Class which represents an amount of money, either as a reward from a trainer or
	 * in the player's inventory. 
	 */
	public class TinyMoneyAmount 
	{
		public var value : int = 0;
		
		public function TinyMoneyAmount( amount : int = 0 ) : void
		{
			this.value = amount;
		}
		
		/**
		 * Returns a formatted string based on value: 100 = $1.00
		 */
		public function toString() : String
		{
			if ( this.value < 100 )
			{
				return '$0.' + this.value.toString();
			}
			
			var hundreds : int = Math.floor( this.value / 100 );
			var tens : int = this.value - ( 100 * hundreds );
			var prePadding : String = '';
			var postPadding : String = '';
			
			if ( tens < 10 && tens > 0 ) prePadding = '0';
			if ( tens == 0 ) postPadding = '0';
			
			return '$' + hundreds.toString() + '.' + prePadding + tens.toString() + postPadding;
		}
	}
}