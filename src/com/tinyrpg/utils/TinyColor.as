package com.tinyrpg.utils 
{

	/**
	 * Class which represents a single 32-bit RGBA color.
	 * 
	 * @author jeremyabel
	 */
	public class TinyColor 
	{
		public var r : uint = 0;
		public var g : uint = 0;
		public var b : uint = 0;
		public var a : uint = 0;
		
		/**
		 * @param	r	The value for the red channel.
		 * @param	g	The value for the green channel.
		 * @param	b	The value for the blue channel.
		 * @param	a	The value for the alpha channel.
		 */
		public function TinyColor( r : uint, g : uint, b : uint, a : uint = 0xFF )
		{
			this.r = r;
			this.g = g;
			this.b = b;
			this.a = a;
		}
		
		/**
		 * Returns a {@link TinyColor} for a given 16-bit hex number.
		 * Expected bit order is R8G8B8.
		 */
		public static function newFromHex( hex : uint ) : TinyColor
		{
			var r : uint = hex >> 16 & 0xFF;
			var g : uint = hex >> 8 & 0xFF;
			var b : uint = hex & 0xFF;
			return new TinyColor( r, g, b );
		}
		
		/**
		 * Returns a {@link TinyColor} for a given 32-bit hex number.
		 * Expected bit order is A8R8G8B8.
		 */
		public static function newFromHex32( hex : uint ) : TinyColor
		{
			var a : uint = hex >> 24 & 0xFF;
			var r : uint = hex >> 16 & 0xFF;
			var g : uint = hex >> 8 & 0xFF;
			var b : uint = hex & 0xFF;
			return new TinyColor( r, g, b, a );
		}
		
		/**
		 * Returns a deep copy of the color.
		 */
		public function clone() : TinyColor
		{
			return new TinyColor(
				TinyMath.deepCopyInt( this.r ),
				TinyMath.deepCopyInt( this.g ),
				TinyMath.deepCopyInt( this.b ),
				TinyMath.deepCopyInt( this.a )
			);
		}
		
		/**
		 * Returns the approximate luminance of the color.
		 * See https://stackoverflow.com/a/596241/1510727
		 */
		public function get fastLuminance() : Number 
		{
			return ( r + r + r + b + g + g + g + g ) >> 3;
		}
		
		/**
		 * Sort function for comparing two colors by luminance.
		 */
		public static function luminanceSort( a : TinyColor, b : TinyColor ) : int
		{
			var lumA : Number = a.fastLuminance;
			var lumB : Number = b.fastLuminance;
			
			if ( lumA < lumB ) return -1;
			if ( lumA > lumB ) return +1;
			else return 0;
		}
		
		/**
		 * Returns true if this color is equal to a given other color.
		 */
		public function equals( other : TinyColor ) : Boolean
		{
			return this.r == other.r && this.g == other.g && this.b == other.b && this.a == other.a;
		}
		
		/**
		 * Returns a string representation of the color.
		 */
		public function toString() : String
		{
			return this.r + ', ' + this.g + ', ' + this.b + ', ' + this.a;
		}
		
		/**
		 * Returns a 32-bit integer representation of the color.
		 * Output bit order is A8R8B8G8.
		 */
		public function toInt32() : uint
		{
			return this.a << 24 | this.r << 16 | this.g << 8 | this.b;
		}
	}
}
