package com.tinyrpg.data 
{
	import com.tinyrpg.utils.TinyLogManager;
	
	/**
	 * Class which represents the results of a ball throw event. 
	 */
	public class TinyBallThrowResult 
	{
		public var rejected : Boolean = false;
		public var caught : Boolean = false;
		public var isUltra : Boolean = false;
		public var numShakes : int = 0;
		
		public function TinyBallThrowResult( rejected : Boolean, caught : Boolean, isUltra : Boolean = false, numShakes : int = 0 )
		{
			this.rejected = rejected;
			this.caught = caught;
			this.isUltra = isUltra;
			this.numShakes = numShakes;
		}
		
		public function printLog() : void
		{	
			TinyLogManager.log('==================== BALL THROW RESULT ====================', this);
			TinyLogManager.log('rejected: ' + this.rejected, this);
			TinyLogManager.log('caught: ' + this.caught, this);
			TinyLogManager.log('num shakes: ' + this.numShakes, this);
		}
	}
}
