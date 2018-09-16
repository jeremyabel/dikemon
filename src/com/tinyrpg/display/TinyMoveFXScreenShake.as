package com.tinyrpg.display 
{
	import flash.display.Bitmap;

	/**
	 * Class which provides a full-screen shaking effect that moves the screen up and down every
	 * other frame.
	 * 
	 * This effect is defined per-move, and is defined in a move's XML entry using the SCREEN_SHAKE
	 * tag. The contents of the tag must be a comma-separated list of 3 numbers, with the format:
	 * 
	 * 		shake amount, start frame, end frame
	 * 		
	 * For example: "2, 0, 13" would result in a 2-pixel shake that starts at frame 0 and ends at 
	 * frame 13.
	 *  
	 * @author jeremyabel
	 */
	public class TinyMoveFXScreenShake 
	{
		public var shakeAmount : int = 0;
		public var startFrame : int = 0;
		public var endFrame : int = 0;
		
		/**
		 * @param	shakeAmount		The number of pixels to move the screen during the shake.
		 * @param	startFrame		The frame number the shake effect starts on.
		 * @param	endFrame		The frame number the shake effect ends on.
		 */
		public function TinyMoveFXScreenShake( shakeAmount : int, startFrame : int, endFrame : int ) : void
		{
			this.shakeAmount = shakeAmount;
			this.startFrame = startFrame;
			this.endFrame = endFrame;		
		}
		
		/**
		 * Returns a new {@link TinyMoveFXScreenShake} from a string with the format "shake amount, start frame, end frame". 
		 * Used when parsing XML move data.
		 * 
		 * @param	string		The input string. Expects a format of "shake amount, start frame, end frame".
		 */
		public static function newFromString( string : String ) : TinyMoveFXScreenShake
		{
			var splitStrings : Array = string.split( ',' );
			var shakeAmount : int = int( splitStrings[ 0 ] );
			var startFrame : int = int ( splitStrings[ 1 ] );
			var endFrame : int = int ( splitStrings[ 2 ] );
						
			return new TinyMoveFXScreenShake( shakeAmount, startFrame, endFrame );  	
		}
		
		/**
		 * Executes the shake effect on a given input bitmap.
		 * 
		 * @param	currentFrame	The current frame number of the effect to be rendered.
		 * @param	bitmap			The bitmap the effect will be applied to.
		 */
		public function execute( currentFrame : int, bitmap : Bitmap ) : void
		{
			if ( currentFrame * 2 >= this.startFrame && currentFrame * 2 <= this.endFrame )
			{
				var screenOffset : int = this.shakeAmount * ( currentFrame % 2 ? -1 : 1 );
				bitmap.x = screenOffset;
			}
			else 
			{
				bitmap.x = 0;
			}
		}
	}
}
