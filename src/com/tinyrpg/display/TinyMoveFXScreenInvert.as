package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import com.tinyrpg.battle.TinyBattlePalette;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyMoveFXScreenInvert 
	{
		public var startFrame : int = 0;
		public var endFrame : int = 0;
		public var isInverting : Boolean = false;
		
		private var paletteEffect : TinyMoveFXPaletteEffect;
		
		public function TinyMoveFXScreenInvert( startFrame : int, endFrame : int, palette : TinyBattlePalette ) : void
		{
			this.startFrame = startFrame;
			this.endFrame = endFrame;
			
			this.paletteEffect = new TinyMoveFXPaletteEffect( TinyMoveFXPaletteEffect.PALETTE_FX_INVERT, TinyMoveFXBaseEffect.AREA_BOTH );
			this.paletteEffect.generateCyclePalettes( palette );
		}

		public static function newFromString( string : String, palette : TinyBattlePalette ) : TinyMoveFXScreenInvert
		{
			var splitStrings : Array = string.split( ',' );
			var startFrame : int = int ( splitStrings[ 0 ] );
			var endFrame : int = int ( splitStrings[ 1 ] );
			
			return new TinyMoveFXScreenInvert( startFrame, endFrame, palette );	
		}
		
		public function setBattlePalette( palette : TinyBattlePalette ) : void
		{
			TinyLogManager.log('setBattlePalette', this);
			this.paletteEffect.generateCyclePalettes( palette );
		}
		
		public function setOriginalBitmapData( bitmapData : BitmapData ) : void
		{
			TinyLogManager.log('setOriginalBitmapData', this);
			this.paletteEffect.origBitmapData = bitmapData.clone();
		}

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
