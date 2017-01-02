package com.tinyrpg.misc 
{

	/**
	 * @author jeremyabel
	 */
	public class TinyItemType 
	{	
		// One-shot items
		public static var ONESHOT_ENEMY		: String = 'ONESHOT_ENEMY';		// Can only be used on enemies
		public static var ONESHOT_PLAYER	: String = 'ONESHOT_PLAYER';	// Can only be used on players
		public static var ONESHOT_BOTH		: String = 'ONESHOT_BOTH';		// Can be used on both players and enemies
		
		// Other types
		public static var KEY_ITEM			: String = 'KEY_ITEM';
	}
}
