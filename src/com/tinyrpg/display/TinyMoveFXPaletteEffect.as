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
		public static const PALETTE_FX_LIGHTEN1 	: String = 'LIGHTEN1';
		public static const PALETTE_FX_LIGHTEN2 	: String = 'LIGHTEN2';
		public static const PALETTE_FX_LIGHTEN3 	: String = 'LIGHTEN3';
		public static const PALETTE_FX_LIGHTEN4 	: String = 'LIGHTEN4';
		public static const PALETTE_FX_DARKEN1		: String = 'DARKEN1';
		public static const PALETTE_FX_DARKEN2		: String = 'DARKEN2';
		public static const PALETTE_FX_DARKEN3		: String = 'DARKEN3';
		public static const PALETTE_FX_DARKEN4		: String = 'DARKEN4';
		public static const PALETTE_FX_CYCLE		: String = 'CYCLE';
		public static const PALETTE_FX_CYCLE_INV 	: String = 'CYCLE_INV';
	
		private var playerMonPalettes : Array = [];
		private var playerMonPalettesInv : Array = [];
		private var playerMonPalettesLighten : Array = [];
		private var playerMonPalettesDarken : Array = [];
		private var playerStatPalettes : Array = [];
		private var playerStatPalettesInv : Array = [];
		private var playerStatPalettesLighten : Array = [];
		private var playerStatPalettesDarken : Array = [];
		
		private var enemyMonPalettes : Array = [];
		private var enemyMonPalettesInv : Array = [];
		private var enemyMonPalettesLighten : Array = [];
		private var enemyMonPalettesDarken : Array = [];
		private var enemyStatPalettes : Array = [];
		private var enemyStatPalettesInv : Array = [];
		private var enemyStatPalettesLighten : Array = [];
		private var enemyStatPalettesDarken : Array = [];
		
		private var isEnemy : Boolean = false;
		
		public function TinyMoveFXPaletteEffect( type : String, area : String, isEnemy : Boolean = false )
		{
			this.type = type;
			this.area = area;
			this.isEnemy = isEnemy;
		}

		public static function newFromString( str : String, isEnemy : Boolean = false ) : TinyMoveFXPaletteEffect
		{
			var strings : Array = str.split( ',' );
			var rex : RegExp = /[\s\r\n]+/gim;
			var type : String = strings[ 0 ] as String;
			var area : String = strings[ 1 ] as String;
			return new TinyMoveFXPaletteEffect( type.replace( rex, '' ), area.replace( rex, '' ), isEnemy );		
		}
		
		public function execute( bitmap : Bitmap, frame : int = 0 ) : void
		{
			this.applyEffect( this.type, bitmap, this.area, frame );
		}
		
		public function applyEffect( name : String, bitmap : Bitmap, area : String, frame : int = 0 ) : void
		{	
			var rects : Object = this.getAreaRectangles( area, this.isEnemy );
			
			switch ( name ) 
			{
				default:
				case PALETTE_FX_INVERT: 	this.applyInvert( bitmap, rects ); break;
				case PALETTE_FX_LIGHTEN1: 	this.applyLighten( bitmap, rects, frame, 1 ); break;
				case PALETTE_FX_LIGHTEN2: 	this.applyLighten( bitmap, rects, frame, 2 ); break;
				case PALETTE_FX_LIGHTEN3: 	this.applyLighten( bitmap, rects, frame, 3 ); break;
				case PALETTE_FX_LIGHTEN4: 	this.applyLighten( bitmap, rects, frame, 4 ); break;
				case PALETTE_FX_DARKEN1: 	this.applyDarken( bitmap, rects, frame, 1 ); break;
				case PALETTE_FX_DARKEN2: 	this.applyDarken( bitmap, rects, frame, 2 ); break;
				case PALETTE_FX_DARKEN3: 	this.applyDarken( bitmap, rects, frame, 3 ); break;
				case PALETTE_FX_DARKEN4: 	this.applyDarken( bitmap, rects, frame, 4 ); break;
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
		
		private function applyLighten( bitmap : Bitmap, rects : Object, frame : int = 0, max : int = 1 ) : void
		{
			var i : int = Math.min( max, Math.floor( frame / 2.0 ) );
			
			this.applyPaletteMap( bitmap, rects[ 'mon' ][ 'player' ],  this.playerMonPalettesLighten[ i ] );
			this.applyPaletteMap( bitmap, rects[ 'mon' ][ 'enemy' ],   this.enemyMonPalettesLighten[ i ] );
		}
		
		private function applyDarken( bitmap : Bitmap, rects : Object, frame : int = 0, max : int = 1 ) : void
		{
			var i : int = Math.min( max, Math.floor( frame / 2.0 ) );
			
			this.applyPaletteMap( bitmap, rects[ 'mon' ][ 'player' ],  this.playerMonPalettesDarken[ i ] );
			this.applyPaletteMap( bitmap, rects[ 'mon' ][ 'enemy' ],   this.enemyMonPalettesDarken[ i ] );
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
		
		public function generateOffsetPalettes( battlePalette : TinyBattlePalette ) : void
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
			
			// Clear any existing palettes
			this.playerMonPalettesLighten = [];
			this.playerMonPalettesDarken = [];
			this.playerStatPalettesLighten = [];
			this.playerStatPalettesDarken = [];
			this.enemyMonPalettesLighten = [];
			this.enemyMonPalettesDarken = [];
			this.enemyStatPalettesLighten = [];
			this.enemyStatPalettesDarken = [];
			
			for ( var i : int = 0; i < 5; i++ )
			{
				// Lighten
				this.playerMonPalettesLighten.push( this.generateSourceDestMapPalette( playerMonPalette.getLightenOffset( 0 ), playerMonPalette.getLightenOffset( i ) ) );
				this.playerStatPalettesLighten.push( this.generateSourceDestMapPalette( playerStatPalette.getLightenOffset( 0 ), playerStatPalette.getLightenOffset( i ) ) );
				this.enemyMonPalettesLighten.push( this.generateSourceDestMapPalette( enemyMonPalette.getLightenOffset( 0 ), enemyMonPalette.getLightenOffset( i ) ) );
				this.enemyStatPalettesLighten.push( this.generateSourceDestMapPalette( enemyStatPalette.getLightenOffset( 0 ), enemyStatPalette.getLightenOffset( i ) ) );

				// Darken	
				this.playerMonPalettesDarken.push( this.generateSourceDestMapPalette( playerMonPalette.getDarkenOffset( 0 ), playerMonPalette.getDarkenOffset( i ) ) );
				this.playerStatPalettesDarken.push( this.generateSourceDestMapPalette( playerStatPalette.getDarkenOffset( 0 ), playerStatPalette.getDarkenOffset( i ) ) );
				this.enemyMonPalettesDarken.push( this.generateSourceDestMapPalette( enemyMonPalette.getDarkenOffset( 0 ), enemyMonPalette.getDarkenOffset( i ) ) );
				this.enemyStatPalettesDarken.push( this.generateSourceDestMapPalette( enemyStatPalette.getDarkenOffset( 0 ), enemyStatPalette.getDarkenOffset( i ) ) );
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
