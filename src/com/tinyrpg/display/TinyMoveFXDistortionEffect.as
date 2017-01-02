package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	import com.tinyrpg.utils.TinyMath;

	/**
	 * @author jeremyabel
	 */
	public class TinyMoveFXDistortionEffect extends TinyMoveFXBaseEffect
	{
		public static const DISTORT_WAVE_X		: String = 'WAVE_X';
		public static const DISTORT_WAVE_Y		: String = 'WAVE_Y';
		public static const DISTORT_HIDE		: String = 'HIDE';
		public static const DISTORT_WAGGLE		: String = 'WAGGLE';
		
		private static const WAVE_FREQ			: Number = 0.3;
		private static const WAVE_SPEED 		: Number = 0.3;
		private static const WAVE_AMP			: int = 4;
		
		private static var WAVE_Y_LOOKUP		: Array = [
			[  0,  2,  4,  4,  4,  4,  4,  6 ],
			[  1,  3,  3,  3,  3,  3,  5,  7 ],
			[  2,  2,  2,  2,  2,  4,  6,  8 ],
			[  0,  0,  0,  2,  4,  6,  8,  8 ],
			[ -1, -1,  1,  3,  5,  7,  7,  7 ],
			[ -1,  1,  3,  5,  5,  5,  5,  5 ]
		];		
		
		private var bgSprite 	: Sprite;
		private var alphaBitmap	: BitmapData;
		
		public function TinyMoveFXDistortionEffect( type : String, area : String )
		{
			this.type = type;
			this.area = area;
			
			this.bgSprite = new Sprite();	
			this.alphaBitmap = new BitmapData( 160, 144, false, 0xFF000000 );
		}

		public static function newFromString( str : String ) : TinyMoveFXDistortionEffect
		{
			var strings : Array = str.split( ',' );
			var rex : RegExp = /[\s\r\n]+/gim;
			var type : String = strings[ 0 ] as String;
			var area : String = strings[ 1 ] as String;
			return new TinyMoveFXDistortionEffect( type.replace( rex, '' ), area.replace( rex, '' ) );		
		}
		
		public function execute( bitmap : Bitmap, bgColor : uint, frame : int = 0 ) : void
		{
			this.bgSprite.graphics.clear();
			this.bgSprite.graphics.beginFill( bgColor );
			this.bgSprite.graphics.drawRect( 0, 0, 160, 144 );
			this.bgSprite.graphics.endFill();
			
			this.origBitmapData = new BitmapData( bitmap.width, bitmap.height, false ); 
			this.origBitmapData.draw( this.bgSprite );
			this.origBitmapData.draw( bitmap );
			this.applyEffect( this.type, bitmap, this.area, frame );
		}	
		
		public function applyEffect( name : String, bitmap : Bitmap, area : String, frame : int = 0 ) : void
		{	
			var rects : Array = this.getAreaRectanglesArray( area );
			
			switch ( name ) 
			{
				default:
				case DISTORT_WAVE_X:	this.applyWaveX( bitmap, rects, frame ); break;
				case DISTORT_WAVE_Y:	this.applyWaveY( bitmap, rects, frame ); break;
				case DISTORT_WAGGLE:	this.applyWaggle( bitmap, rects, frame ); break;
				case DISTORT_HIDE:		this.applyHide( bitmap, rects ); break;
			}
		}
		
		private function applyWaveX( bitmap : Bitmap, rects : Array, frame : int = 0 ) : void
		{
			for each ( var rect : Rectangle in rects )
			{
				bitmap.bitmapData.draw( this.bgSprite, null, null, null, rect );
				
				for ( var y : int = rect.y; y < rect.y + rect.height; y++ )
				{
					var xOffset : int = Math.floor( Math.sin( ( y * WAVE_FREQ ) + ( frame * WAVE_SPEED ) ) * WAVE_AMP );
					
					var sourceRect : Rectangle = new Rectangle( 0, y, 160, 1 );
					var destPoint : Point = new Point( xOffset, y );
					
					bitmap.bitmapData.copyPixels( this.origBitmapData, sourceRect, destPoint );	
				}
			}
		}
		
		private function applyWaveY( bitmap : Bitmap, rects : Array, frame : int = 0 ) : void
		{
			var patternOffset : int = Math.floor( frame ) % 6;
			
			for each ( var rect : Rectangle in rects )
			{
				bitmap.bitmapData.draw( this.bgSprite, null, null, null, rect );
				
				for ( var y : int = rect.y; y < rect.y + rect.height; y += 8 )
				{					
					for ( var i : int = 0; i < 8; i++ )
					{
						var yFromLookup : int = WAVE_Y_LOOKUP[ patternOffset ][ i ];
						var yOffset : int = TinyMath.clamp( y + yFromLookup, 0, 144 );
						
						var sourceRect : Rectangle = new Rectangle( 0, yOffset, 160, 1 );
						var destPoint : Point = new Point( 0, y + i );
						
						bitmap.bitmapData.copyPixels( this.origBitmapData, sourceRect, destPoint );
					}
				}
			}
		}
		
		private function applyHide( bitmap : Bitmap, rects : Array ) : void
		{
			
		}
		
		private function applyWaggle( bitmap : Bitmap, rects : Array, frame : int = 0 ) : void
		{
			
		}
		
		private function getAreaRectanglesArray( area : String ) : Array
		{
			var areaRects : Array = [];
			
			switch ( area )
			{
				case AREA_PLAYER:
				{
					areaRects.push( new Rectangle( 0, 48, 160, 48 ) );
					break;
				}
				
				case AREA_ENEMY:
				{
					areaRects.push( new Rectangle( 0, 0, 160, 56 ) );
					break;
				}
				
				case AREA_BOTH:
				{
					areaRects.push( new Rectangle( 0, 48, 160, 48 ) );
					areaRects.push( new Rectangle( 0, 0, 160, 56 ) );						
					break;
				}
			}
			
			return areaRects;
		}
	}
}
