package com.tinyrpg.utils 
{

	/**
	 * @author jeremyabel
	 */
	public class TinyColor 
	{
		public var r : uint = 0;
		public var g : uint = 0;
		public var b : uint = 0;
		public var a : uint = 0;
		
		public function TinyColor( r : uint, g : uint, b : uint, a : uint = 0xFF )
		{
			this.r = r;
			this.g = g;
			this.b = b;
			this.a = a;
		}
		
		public static function newFromHex( hex : uint ) : TinyColor
		{
			var r : uint = hex >> 16 & 0xFF;
			var g : uint = hex >> 8 & 0xFF;
			var b : uint = hex & 0xFF;
			return new TinyColor( r, g, b );
		}
		
		public static function newFromHex32( hex : uint ) : TinyColor
		{
			var a : uint = hex >> 24 & 0xFF;
			var r : uint = hex >> 16 & 0xFF;
			var g : uint = hex >> 8 & 0xFF;
			var b : uint = hex & 0xFF;
			return new TinyColor( r, g, b, a );
		}
		
		public function clone() : TinyColor
		{
			return new TinyColor(
				TinyMath.deepCopyInt( this.r ),
				TinyMath.deepCopyInt( this.g ),
				TinyMath.deepCopyInt( this.b ),
				TinyMath.deepCopyInt( this.a )
			);
		}
		
		public function get fastLuminance() : Number 
		{
			return ( r + r + r + b + g + g + g + g ) >> 3;
		}
		
		public static function luminanceSort( a : TinyColor, b : TinyColor ) : int
		{
			var lumA : Number = a.fastLuminance;
			var lumB : Number = b.fastLuminance;
			
			if ( lumA < lumB ) return -1;
			if ( lumA > lumB ) return +1;
			else return 0;
		}
		
		public function equals( color : TinyColor ) : Boolean
		{
			return this.r == color.r && this.g == color.g && this.b == color.b && this.a == color.a;
		}
		
		public function toString() : String
		{
			return this.r + ', ' + this.g + ', ' + this.b + ', ' + this.a;
		}
		
		public function toInt32() : uint
		{
			return this.a << 24 | this.r << 16 | this.g << 8 | this.b;
		}
	}
}
