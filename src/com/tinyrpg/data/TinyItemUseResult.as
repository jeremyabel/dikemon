package com.tinyrpg.data 
{
	public class TinyItemUseResult
	{
		public var canUse : Boolean;
		public var errorString : String;
		
		public function TinyItemUseResult( canUse : Boolean, errorString : String = 'OK' ) 
		{
			this.canUse = canUse;
			this.errorString = errorString;		
		}
	}
}