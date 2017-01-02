package com.tinyrpg.display 
{
	import flash.display.Bitmap;

	/**
	 * @author jeremyabel
	 */
	public class TinyMoveFXScreenShake 
	{
		public var shakeAmount : int = 0;
		public var startFrame : int = 0;
		public var endFrame : int = 0;
		
		public function TinyMoveFXScreenShake( shakeAmount : int, startFrame : int, endFrame : int ) : void
		{
			this.shakeAmount = shakeAmount;
			this.startFrame = startFrame;
			this.endFrame = endFrame;		
		}
		
		public static function newFromString( string : String ) : TinyMoveFXScreenShake
		{
			var splitStrings : Array = string.split( ',' );
			var shakeAmount : int = int( splitStrings[ 0 ] );
			var startFrame : int = int ( splitStrings[ 1 ] );
			var endFrame : int = int ( splitStrings[ 2 ] );
						
			return new TinyMoveFXScreenShake( shakeAmount, startFrame, endFrame );  	
		}
		
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
