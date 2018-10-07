package com.tinyrpg.utils 
{

	/**
	 * Class which represents a Gameboy Color four-color palette.
	 * 
	 * Used for doing color transforms and fades during battle fx animations.
	 * 
	 * @author jeremyabel
	 */
	public class TinyFourColorPalette 
	{
		public var color1 : TinyColor = null;
		public var color2 : TinyColor = null;
		public var color3 : TinyColor = null;
		public var color4 : TinyColor = null;
		
		/**
		 * @param	color1	The first color.
		 * @param	color2	The second color.
		 * @param	color3	The third color.
		 * @param	color4	The fourth color.
		 */
		public function TinyFourColorPalette( color1 : TinyColor = null, color2 : TinyColor = null, color3 : TinyColor = null, color4 : TinyColor = null )
		{
			this.color1 = color1;
			this.color2 = color2;
			this.color3 = color3;
			this.color4 = color4;
		}
		
		/**
		 * Returns a new {@link TinyFourColorPalette} using a given array of {@link TinyColor}s. 
		 * The array must have at least 4 elements.
		 */
		public static function newFromArray( colors : Array ) : TinyFourColorPalette
		{
			return new TinyFourColorPalette( colors[ 0 ], colors[ 1 ], colors[ 2 ], colors[ 3 ] );
		}
		
		/**
		 * Returns a new {@link TinyFourColorPalette} using a given array of {@link TinyColor}s, in reverse order.
		 * The array must have at least 4 elements.
		 */
		public static function newFromArrayInv( colors : Array ) : TinyFourColorPalette
		{
			return new TinyFourColorPalette( colors[ 3 ], colors[ 2 ], colors[ 1 ], colors[ 0 ] );	
		}
		
		/**
		 * Returns the palette color array with indicies shifted by a given amount.
		 * For example: getShifted(1) = [4, 1, 2, 3].
		 */
		public function getShifted( shiftAmount : int ) : Array
		{
			switch ( shiftAmount )
			{
				default:
				case 0: return [ this.color1.clone(), this.color2.clone(), this.color3.clone(), this.color4.clone() ];
				case 1: return [ this.color4.clone(), this.color1.clone(), this.color2.clone(), this.color3.clone() ];
				case 2: return [ this.color3.clone(), this.color4.clone(), this.color1.clone(), this.color2.clone() ];
				case 3: return [ this.color2.clone(), this.color3.clone(), this.color4.clone(), this.color1.clone() ];
			}
		}
		
		/**
		 * Returns the palette color array at a given step value in the lightness scale. 
		 * This simulates the gameboy's 4-step fade-to-white transition.
		 */
		public function getLightenOffset( offsetAmount : int ) : Array 
		{	
			var white : TinyColor = TinyColor.newFromHex( 0xFFFFFF );
			
			switch ( offsetAmount ) 
			{
				default:
				case 0: return [ this.color1.clone(), this.color2.clone(), this.color3.clone(), this.color4.clone() ];
				case 1: return [ this.color2.clone(), this.color3.clone(), this.color4.clone(), white.clone() ];
				case 2: return [ this.color3.clone(), this.color4.clone(), white.clone(), white.clone() ];
				case 3: return [ this.color4.clone(), white.clone(), white.clone(), white.clone() ];
				case 4: return [ white.clone(), white.clone(), white.clone(), white.clone() ];
			}
		}
		
		/**
		 * Returns the palette color array at a given step value in the darkness scale.
		 * This simulates the gameboy's 4-step fade-to-black transition.
		 */
		public function getDarkenOffset( offsetAmount : int ) : Array
		{
			var black : TinyColor = TinyColor.newFromHex( 0x000000 );
			
			switch ( offsetAmount )
			{
				default:
				case 0: return [ this.color1.clone(), this.color2.clone(), this.color3.clone(), this.color4.clone() ];
				case 1: return [ black.clone(), this.color1.clone(), this.color2.clone(), this.color3.clone() ];
				case 2: return [ black.clone(), black.clone(), this.color1.clone(), this.color2.clone() ];
				case 3: return [ black.clone(), black.clone(), black.clone(), this.color1.clone() ];
				case 4: return [ black.clone(), black.clone(), black.clone(), black.clone() ];
			}
		}
		
		/**
		 * Returns a copy of the palette with the color order reversed. 
		 */
		public function getInverted() : TinyFourColorPalette 
		{
			return new TinyFourColorPalette( 
				this.color4.clone(), 
				this.color3.clone(), 
				this.color2.clone(), 
				this.color1.clone() 
			);	
		}
		
		/**
		 * Returns true if the palette contains a given color.
		 */
		public function contains( color : TinyColor ) : Boolean
		{
			if ( this.color1 && this.color1.equals( color ) ) return true;
			if ( this.color2 && this.color2.equals( color ) ) return true;
			if ( this.color3 && this.color3.equals( color ) ) return true;
			if ( this.color4 && this.color4.equals( color ) ) return true;
			return false;
		}
		
		/**
		 * Adds a given {@link TinyColor} to the next available slot in the palette.
		 */
		public function addColor( color : TinyColor ) : void
		{
			if ( !this.color1 ) { this.color1 = color; return; }
			if ( !this.color2 ) { this.color2 = color; return; }
			if ( !this.color3 ) { this.color3 = color; return; }
			if ( !this.color4 ) { this.color4 = color; return; }
		}
		
		/**
		 * Returs true if all four colors in the palette are set.
		 */
		public function isFull() : Boolean
		{
			return this.color1 && this.color2 && this.color3 && this.color4;
		}
		
		/**
		 * Sorts the palette array by luminance, darkest to lightest.
		 */
		public function sort() : void
		{
			var colorArray : Array = [ 
				this.color1.clone(),
				this.color2.clone(),
				this.color3.clone(), 
				this.color4.clone()
			];
			
			colorArray.sort( TinyColor.luminanceSort );
			
			this.color1 = colorArray[ 0 ];
			this.color2 = colorArray[ 1 ];
			this.color3 = colorArray[ 2 ];
			this.color4 = colorArray[ 3 ];
		}
		
		/**
		 * Returns a string representation of the palette.
		 */
		public function toString() : String
		{
			return '(' + this.color1.toString() + '), \n' +
			'(' + this.color2.toString() + '), \n' +
			'(' + this.color3.toString() + '), \n' +
			'(' + this.color4.toString() + ')'; 
		}
	}
}
