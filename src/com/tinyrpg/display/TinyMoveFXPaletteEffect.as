package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	import com.tinyrpg.battle.TinyBattlePalette;
	import com.tinyrpg.utils.TinyColor;
	import com.tinyrpg.utils.TinyFourColorPalette;

	/**
	 * @author jeremyabel
	 */
	public class TinyMoveFXPaletteEffect extends TinyMoveFXBaseEffect
	{
		public static const PALETTE_FX_INVERT 		: String = 'INVERT';
		public static const PALETTE_FX_LIGHTEN 		: String = 'LIGHTEN';
		public static const PALETTE_FX_DARKEN		: String = 'DARKEN';
		public static const PALETTE_FX_CYCLE		: String = 'CYCLE';
		public static const PALETTE_FX_CYCLE_INV 	: String = 'CYCLE_INV';
	
		private var playerMonPalettes : Array = [];
		private var playerMonPalettesInv : Array = [];
		private var playerStatPalettes : Array = [];
		private var playerStatPalettesInv : Array = [];
		
		private var enemyMonPalettes : Array = [];
		private var enemyMonPalettesInv : Array = [];
		private var enemyStatPalettes : Array = [];
		private var enemyStatPalettesInv : Array = [];
		
		public function TinyMoveFXPaletteEffect( type : String, area : String )
		{
			this.type = type;
			this.area = area;	
		}

		public static function newFromString( str : String ) : TinyMoveFXPaletteEffect
		{
			var strings : Array = str.split( ',' );
			var rex : RegExp = /[\s\r\n]+/gim;
			var type : String = strings[ 0 ] as String;
			var area : String = strings[ 1 ] as String;
			return new TinyMoveFXPaletteEffect( type.replace( rex, '' ), area.replace( rex, '' ) );		
		}
		
		public function execute( bitmap : Bitmap, frame : int = 0 ) : void
		{
			this.applyEffect( this.type, bitmap, this.area, frame );
		}
		
		public function applyEffect( name : String, bitmap : Bitmap, area : String, frame : int = 0 ) : void
		{	
			var rects : Object = this.getAreaRectangles( area );
			
			switch ( name ) 
			{
				default:
				case PALETTE_FX_INVERT: 	this.applyInvert( bitmap, rects ); break;
				case PALETTE_FX_LIGHTEN: 	this.applyLighten( bitmap, rects ); break;
				case PALETTE_FX_DARKEN: 	this.applyDarken( bitmap, rects ); break;
				case PALETTE_FX_CYCLE:		this.applyCycle( bitmap, rects, frame ); break;
				case PALETTE_FX_CYCLE_INV: 	this.applyCycleInverted( bitmap, rects, frame ); break;
			}
		}

		private function applyInvert( bitmap : Bitmap, rects : Object ) : void
		{
			this.applyPaletteMap( bitmap, rects[ 'mon' ][ 'player' ],  this.playerMonPalettesInv[ 0 ] );
			this.applyPaletteMap( bitmap, rects[ 'mon' ][ 'enemy' ],   this.enemyMonPalettesInv[ 0 ] );
			this.applyPaletteMap( bitmap, rects[ 'stat' ][ 'player' ], this.playerStatPalettesInv[ 0 ] );
			this.applyPaletteMap( bitmap, rects[ 'stat' ][ 'enemy' ],  this.enemyStatPalettesInv[ 0 ] );
		}
		
		private function applyLighten( bitmap : Bitmap, rects : Object, frame : int = 0 ) : void
		{
			
		}
		
		private function applyDarken( bitmap : Bitmap, rects : Object, frame : int = 0 ) : void
		{
			 
		}
		
		private function applyCycle( bitmap : Bitmap, rects : Object, frame : int = 0 ) : void
		{
			var i : int = Math.floor( frame / 2.0 ) % 4;
			
			this.applyPaletteMap( bitmap, rects[ 'mon' ][ 'player' ],  this.playerMonPalettes[ i ] );
			this.applyPaletteMap( bitmap, rects[ 'mon' ][ 'enemy' ],   this.enemyMonPalettes[ i ] );
			this.applyPaletteMap( bitmap, rects[ 'stat' ][ 'player' ], this.playerStatPalettes[ i ] );
			this.applyPaletteMap( bitmap, rects[ 'stat' ][ 'enemy' ],  this.enemyStatPalettes[ i ] ); 
		}
		
		private function applyCycleInverted( bitmap : Bitmap, rects : Object, frame : int = 0 ) : void
		{
			var i : int = Math.floor( frame / 2.0 ) % 4;
			
			this.applyPaletteMap( bitmap, rects[ 'mon' ][ 'player' ],  this.playerMonPalettesInv[ i ] );
			this.applyPaletteMap( bitmap, rects[ 'mon' ][ 'enemy' ],   this.enemyMonPalettesInv[ i ] );
			this.applyPaletteMap( bitmap, rects[ 'stat' ][ 'player' ], this.playerStatPalettesInv[ i ] );
			this.applyPaletteMap( bitmap, rects[ 'stat' ][ 'enemy' ],  this.enemyStatPalettesInv[ i ] ); 	 
		}
		
		private function applyPaletteMap( bitmap : Bitmap, rect : Rectangle, paletteMap : Array ) : void
		{
			if ( rect )
			{
				for ( var i : int = 0; i < 4; i++ )
				{
					var map : Object = paletteMap[ i ] as Object;
					bitmap.bitmapData.threshold( this.origBitmapData, rect, new Point( rect.x, rect.y ), '==', map[ 'src' ], map[ 'dst' ], 0xFFFFFFFF );
				}
			}
		}
		
		public function generateCyclePalettes( battlePalette : TinyBattlePalette ) : void
		{
			// Regular palettes
			var playerMonPalette 	: TinyFourColorPalette = battlePalette.playerMon;
			var playerStatPalette 	: TinyFourColorPalette = battlePalette.playerStats;
			var enemyMonPalette 	: TinyFourColorPalette = battlePalette.enemyMon;
			var enemyStatPalette 	: TinyFourColorPalette = battlePalette.enemyStats;
			
			// Sort palettes by luminance
			playerMonPalette.sort();
			playerStatPalette.sort();
			enemyMonPalette.sort();
			enemyStatPalette.sort();
			
			// Inverted palettes
			var playerMonPaletteInv	 : TinyFourColorPalette = playerMonPalette.getInverted();
			var playerStatPaletteInv : TinyFourColorPalette = playerStatPalette.getInverted();
			var enemyMonPaletteInv 	 : TinyFourColorPalette = enemyMonPalette.getInverted();
			var enemyStatPaletteInv  : TinyFourColorPalette = enemyStatPalette.getInverted();
			
			// Clear any existing palettes
			this.playerMonPalettes = [];
			this.playerStatPalettes = [];
			this.enemyMonPalettes = [];
			this.enemyStatPalettes = [];
			this.playerMonPalettesInv = [];
			this.playerStatPalettesInv = [];
			this.enemyMonPalettesInv = [];
			this.enemyStatPalettesInv = [];
			
			for ( var i : int = 0; i < 4; i++ )
			{
				// Regular
				this.playerMonPalettes.push( this.generateSourceDestMapPalette( playerMonPalette.getShifted( 0 ), playerMonPalette.getShifted( i ) ) );
				this.playerStatPalettes.push( this.generateSourceDestMapPalette( playerStatPalette.getShifted( 0 ), playerStatPalette.getShifted( i ) ) );
				this.enemyMonPalettes.push( this.generateSourceDestMapPalette( enemyMonPalette.getShifted( 0 ), enemyMonPalette.getShifted( i ) ) );
				this.enemyStatPalettes.push( this.generateSourceDestMapPalette( enemyStatPalette.getShifted( 0 ), enemyStatPalette.getShifted( i ) ) );

				// Inverted	
				this.playerMonPalettesInv.push( this.generateSourceDestMapPalette( playerMonPalette.getShifted( 0 ), playerMonPaletteInv.getShifted( i ) ) );
				this.playerStatPalettesInv.push( this.generateSourceDestMapPalette( playerStatPalette.getShifted( 0 ), playerStatPaletteInv.getShifted( i ) ) );
				this.enemyMonPalettesInv.push( this.generateSourceDestMapPalette( enemyMonPalette.getShifted( 0 ), enemyMonPaletteInv.getShifted( i ) ) );
				this.enemyStatPalettesInv.push( this.generateSourceDestMapPalette( enemyStatPalette.getShifted( 0 ), enemyStatPaletteInv.getShifted( i ) ) );
			}
		}
		
		private function generateSourceDestMapPalette( sourceColors : Array, destColors : Array ) : Array
		{
			var palettes : Array = [];
			
			for ( var i : int = 0; i < 4; i++ )
			{
				var obj : Object = new Object();
				obj[ 'src' ] = ( sourceColors[ i ] as TinyColor ).toInt32();
				obj[ 'dst' ] = ( destColors[ i ] as TinyColor ).toInt32();
				
				palettes.push( obj );
			}
			
			return palettes;
		}
	}
}
