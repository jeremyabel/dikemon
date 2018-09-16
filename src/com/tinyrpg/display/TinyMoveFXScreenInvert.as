package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import com.tinyrpg.battle.TinyBattlePalette;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * Class which provides a full-screen color palette invert effect.
	 * 
	 * This effect doesn't invert like Photoshop does. Instead, it reverses the indexed
	 * color palettes used by the elements on the screen. These palettes consist of 4 
	 * unique colors, usually white, black, and 2 others. They are stored lightest to 
	 * darkest, so the invert effect will reverse these colors, meaning that the order
	 * of the palette will instead be sorted from darkest to lightest.
	 * 
	 * This emulates how the Gameboy Color deals with color palettes, where it can't 
	 * modify the values of the colors in a palette, but it can change their order.
	 * 
	 * This effect is defined per-move, and a move can have multiple inverts triggered during
	 * the move's animation. These are defined in the move's XML entry using the SCREEN_INVERT
	 * tag, where invert effect data is specified in a list with the format:
	 * 
	 * 		(start frame, end frame)
	 * 
	 * See also: {@link TinyMoveFXPaletteEffect}, {@link TinyBattlePalette}, {@link TinyFourColorPalette}.
	 *  
	 * @author jeremyabel
	 */
	public class TinyMoveFXScreenInvert 
	{
		public var startFrame : int = 0;
		public var endFrame : int = 0;
		public var isInverting : Boolean = false;
		
		private var paletteEffect : TinyMoveFXPaletteEffect;
		
		/**
		 * @param	startFrame	The frame number the invert effect starts on.
		 * @param	endFrame	The frame number the invert effect ends on.
		 * @param	palette		The palette the effect will be applied to.	
		 */
		public function TinyMoveFXScreenInvert( startFrame : int, endFrame : int, palette : TinyBattlePalette ) : void
		{
			this.startFrame = startFrame;
			this.endFrame = endFrame;
			
			this.paletteEffect = new TinyMoveFXPaletteEffect( TinyMoveFXPaletteEffect.PALETTE_FX_INVERT, TinyMoveFXBaseEffect.AREA_BOTH );
			this.paletteEffect.generateCyclePalettes( palette );
		}

		/**
		 * Returns a new {@link TinyMoveFXScreenInvert} from a string with the format "(start frame, end frame)". 
		 * Used when parsing XML move data.
		 * 
		 * @param	string		The input string. Expects a format of "(start frame, end frame)".
		 * @param	palette 	The palette the effect will be applied to.
		 */
		public static function newFromString( string : String, palette : TinyBattlePalette ) : TinyMoveFXScreenInvert
		{
			var splitStrings : Array = string.split( ',' );
			var startFrame : int = int ( splitStrings[ 0 ] );
			var endFrame : int = int ( splitStrings[ 1 ] );
			
			return new TinyMoveFXScreenInvert( startFrame, endFrame, palette );	
		}
		
		/**
		 * Sets the palette used for the effect.
		 */
		public function setBattlePalette( palette : TinyBattlePalette ) : void
		{
			TinyLogManager.log('setBattlePalette', this);
			this.paletteEffect.generateCyclePalettes( palette );
		}
		
		/**
		 * Sets the bitmap data used for the effect.
		 */
		public function setOriginalBitmapData( bitmapData : BitmapData ) : void
		{
			TinyLogManager.log('setOriginalBitmapData', this);
			this.paletteEffect.origBitmapData = bitmapData.clone();
		}

		/**
		 * Executes the invert effect on a given input bitmap.
		 * 
		 * @param	currentFrame	The current frame number of the effect to be rendered.
		 * @param	bitmap			The bitmap the effect will be applied to.
		 */
		public function execute( currentFrame : int, bitmap : Bitmap ) : void
		{
			this.isInverting = currentFrame * 2 >= this.startFrame && currentFrame * 2 <= this.endFrame;
			 
			if ( this.isInverting )
			{
				this.paletteEffect.execute( bitmap );								
			}
		}
	}
}
