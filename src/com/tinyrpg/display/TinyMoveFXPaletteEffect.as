package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	import com.tinyrpg.battle.TinyBattlePalette;
	import com.tinyrpg.utils.TinyColor;
	import com.tinyrpg.utils.TinyFourColorPalette;

	/**
	 * Class which handles the display of various palette-based move fx animations. 
	 * 
	 * These effects operate on a bitmap which stores a capture of the state of the screen, 
	 * and then modifies the 4-color palettes used to draw specific areas of the screen. 
	 * 
	 * There are a number of palette effects available:
	 *
	 *  	INVERT: Inverts the palette's order.
	 *		LIGHTEN1, 2, 3, 4: Lightens the palette, by 1, 2, 3, or 4 steps.
	 *		DARKEN1, 2, 3, 4: Darkens the palette, by 1, 2, 3, or 4 steps.
	 *		CYCLE: Cycles the normal palette.
	 *		CYCLE_INV: Cycles the inverted-order palette. 
	 *	
	 * These effects emulate the way the Gameboy Color deals with sprite color palettes, which 
	 * contain 4 unique colors, usually white, black, and two others, ordered by luminance from
	 * lightest to darkest. The palette effects operate by shifting and copying the entries in 
	 * the palettes. 
	 * 
	 * 		For example: the "LIGHTEN1" effect is done by shifting all palette entries forward by 1:
	 *
	 *		Before: 1 2 3 4
	 *		After:  1 1 2 3
	 *		
	 *	   	If you picture color 1 being white, 2 being light grey, 3 being dark grey, and 4 being black,
	 *	   	then in this case everything colored black becomes dark grey, everything dark grey becomes
	 *	   	light grey, and so on. All palette effects work like this. "LIGHTEN2-4" repeats this step
	 *	   	2-4 times to simulate 4 different levels of lightening. "DARKEN1-4" works the same way, only
	 *	   	from the other end of the palette:  
	 *	   	
	 *	   	Before: 1 2 3 4
	 *	   	After:  2 3 4 4
	 *	   	
	 *	   	The CYCLE and CYCLE_INV effects work by cycling the colors in the palette:
	 *	   	
	 *	   	Before: 1 2 3 4
	 *	   	After:  2 3 4 1 
	 *	   	
	 * The battle screen is divided up into 2 areas: "player" and "enemy". These areas are further divided
	 * into 2 more areas: "mon" and "stat", resulting in 4 areas total. Each individual area uses a unique 
	 * 4-color palette, and therefore has its own individual effected palette. Not all moves effect the 
	 * entire screen, so it has to be divided like this in order to animate the effect properly. For example,
	 * the INVERT effect changes the entire screen, so it modifies the palettes of all 4 areas. But the LIGHTEN1
	 * effect only effects the player and enemy mons, so it only modifies those 2 "mon" areas and leaves the two 
	 * "stat" areas unmodified. 
	 * 
	 * These effects are defined per-move using the ANIM_PALETTE_EFFECT tag. The tag's contents must be in the format:
	 * 
	 * 		effect_name, area_name
	 * 		
	 * For example: DARKEN2, PLAYER
	 * 
	 * See also: {@link TinyBattlePalette}, {@link TinyFourColorPalette}.
	 * 
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
		
		/**
		 * @param	type		The palette effect type. Valid values are listed in the class comment.
		 * @param	area		The type of area to apply the effect to. Valid values are "PLAYER", "ENEMY", and "BOTH".
		 * @param	isEnemy		Whether or not the effect is from a move used by the enemy mon.
		 */
		public function TinyMoveFXPaletteEffect( type : String, area : String, isEnemy : Boolean = false )
		{
			this.type = type;
			this.area = area;
			this.isEnemy = isEnemy;
		}

		/**
		 * Returns a new {@link TinyMoveFXPaletteEffect} from a string with the format "effect_name, area_name". 
		 * Used when parsing XML move data.
		 * 
		 * @param	str			The input string. Expects a format of "enemy_name, area_name".
		 * @param	isEnemy		Whether or not the effect is from a move used by the enemy mon.
		 */
		public static function newFromString( str : String, isEnemy : Boolean = false ) : TinyMoveFXPaletteEffect
		{
			var strings : Array = str.split( ',' );
			var rex : RegExp = /[\s\r\n]+/gim;
			var type : String = strings[ 0 ] as String;
			var area : String = strings[ 1 ] as String;
			return new TinyMoveFXPaletteEffect( type.replace( rex, '' ), area.replace( rex, '' ), isEnemy );		
		}
		
		/**
		 * Executes the palette effect on a given input bitmap.
		 * 
		 * @param	bitmap		The bitmap the effect will be applied to.
		 * @param	frame	 	The frame number of the effect to be rendered.
		 */
		public function execute( bitmap : Bitmap, frame : int = 0 ) : void
		{
			this.applyEffect( this.type, bitmap, this.area, frame );
		}
		
		/**
		 * Applies a palette effect with a given name to a given input bitmap.
		 * 
		 * @param	type	The palette effect type. Valid values are listed in the class comment.
		 * @param	bitmap	The bitmap the effect will be applied to.
		 * @param	area	The type of area to apply the effect to. Valid values are "PLAYER", "ENEMY", and "BOTH".
		 * @param	frame	The frame number of the effect to be rendered. 	
		 */
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
		
		/**
		 * Generates the offset palettes from a given {@link TinyBattlePalette}.
		 * 
		 * Called whenever a new move is used in order to precalculate the palette data
		 * required by the effect.
		 */
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
