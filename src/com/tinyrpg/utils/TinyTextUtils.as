package com.tinyrpg.utils 
{
	/**
	 * @author jeremyabel
	 */
	public class TinyTextUtils 
	{
		public static function PadZeros( value : int, digits : int )
		{
			var s : String = String( value );
			while ( s.length < digits ) { s = '0' + s };
			return s;
		}
	}