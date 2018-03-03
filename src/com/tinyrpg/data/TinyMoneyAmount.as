package com.tinyrpg.data
{
	/**
	 * @author jeremyabel
	 */
	public class TinyMoneyAmount 
	{
		public var value : int = 0;
		
		public function TinyMoneyAmount( amount : int = 0 ) : void
		{
			this.value = amount;
		}
		
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