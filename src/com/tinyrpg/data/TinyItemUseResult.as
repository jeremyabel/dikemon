package com.tinyrpg.data 
{
	/**
	 * Class which holds the resulting data from a request to use an item.
	 * 
	 * The data is used to give feedback to the player if an item cannot be used
	 * by providing an error string along with the boolean value of whether the item
	 * can be used or not. 
	 */
	public class TinyItemUseResult
	{
		public var canUse : Boolean;
		public var monRequired : Boolean;
		public var errorString : String;
		
		/**
		 * @param	canUse			whether or not the item can be used
		 * @param	errorString		if the item cannot be used, this string will be shown to the player
		 * @param	monRequired		whether or not the item is required to be used on a specific mon
		 */
		public function TinyItemUseResult( canUse : Boolean, errorString : String = 'OK', monRequired : Boolean = false ) 
		{
			this.canUse = canUse;
			this.monRequired = monRequired;
			this.errorString = errorString;		
		}
	}
}