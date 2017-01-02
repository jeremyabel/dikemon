package com.tinyrpg.utils 
{

	/**
	 * @author jeremyabel
	 */
	public class TinyFourColorPalette 
	{
		public var color1 : TinyColor = null;
		public var color2 : TinyColor = null;
		public var color3 : TinyColor = null;
		public var color4 : TinyColor = null;
		
		public function TinyFourColorPalette( color1 : TinyColor = null, color2 : TinyColor = null, color3 : TinyColor = null, color4 : TinyColor = null )
		{
			this.color1 = color1;
			this.color2 = color2;
			this.color3 = color3;
			this.color4 = color4;
		}
		
		public static function newFromArray( colors : Array ) : TinyFourColorPalette
		{
			return new TinyFourColorPalette( colors[ 0 ], colors[ 1 ], colors[ 2 ], colors[ 3 ] );
		}
		
		public static function newFromArrayInv( colors : Array ) : TinyFourColorPalette
		{
			return new TinyFourColorPalette( colors[ 3 ], colors[ 2 ], colors[ 1 ], colors[ 0 ] );	
		}
		
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
		
		public function getInverted() : TinyFourColorPalette 
		{
			return new TinyFourColorPalette( 
				this.color4.clone(), 
				this.color3.clone(), 
				this.color2.clone(), 
				this.color1.clone() 
			);	
		}
		
		public function contains( color : TinyColor ) : Boolean
		{
			if ( this.color1 && this.color1.equals( color ) ) return true;
			if ( this.color2 && this.color2.equals( color ) ) return true;
			if ( this.color3 && this.color3.equals( color ) ) return true;
			if ( this.color4 && this.color4.equals( color ) ) return true;
			return false;
		}
		
		public function addColor( color : TinyColor ) : void
		{
			if ( !this.color1 ) { this.color1 = color; return; }
			if ( !this.color2 ) { this.color2 = color; return; }
			if ( !this.color3 ) { this.color3 = color; return; }
			if ( !this.color4 ) { this.color4 = color; return; }
		}
		
		public function isFull() : Boolean
		{
			return this.color1 && this.color2 && this.color3 && this.color4;
		}
		
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
		
		public function toString() : String
		{
			return '(' + this.color1.toString() + '), \n' +
			'(' + this.color2.toString() + '), \n' +
			'(' + this.color3.toString() + '), \n' +
			'(' + this.color4.toString() + ')'; 
		}
	}
}
