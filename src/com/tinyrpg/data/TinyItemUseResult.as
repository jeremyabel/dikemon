package com.tinyrpg.data 
{
	public class TinyItemUseResult
	{
		public var canUse : Boolean;
		public var monRequired : Boolean;
		public var errorString : String;
		
		public function TinyItemUseResult( canUse : Boolean, errorString : String = 'OK', monRequired : Boolean = false ) 
		{
			this.canUse = canUse;
			this.monRequired = monRequired;
			this.errorString = errorString;		
		}
	}
}