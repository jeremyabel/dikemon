package com.tinyrpg.data 
{
	/**
	 * @author jeremyabel
	 */
	public class TinyDialogItem 
	{
		public static var TEXT  		: String = 'TEXT';
		public static var DELAY 		: String = 'DELAY';
		public static var HALT 			: String = 'HALT';
		public static var NAME			: String = 'NAME';
		public static var BREAK			: String = 'BREAK';
		public static var END			: String = 'END';
		public static var END_INT 		: String = 'END_INT';
		public static var FROM_XML		: String = 'FROM_XML';
		
		public var type : String;
		public var value : *;
		
		public function TinyDialogItem(type : String, value : * = null) : void
		{
			this.type = type;
			this.value = value;
		}
	}
}
