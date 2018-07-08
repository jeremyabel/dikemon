package com.tinyrpg.sequence
{
	import com.tinyrpg.data.TinyFieldMapObjectWarp;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyWarpCommand 
	{
		public var mapName				: String; 
		public var warpName				: String;
		public var warpFacing			: String;
		public var preFadeSequenceName 	: String;
		public var postFadeSequenceName	: String;
		public var stepForward			: Boolean = false;
		public var fadeSpeed			: uint;
		public var fadeDelay			: uint; 
		public var warpObject 			: TinyFieldMapObjectWarp;
			
		public function TinyWarpCommand() : void
		{
			
		}
		
		public static function newFromXML( xmlData : XML ) : TinyWarpCommand
		{
			var newCommand : TinyWarpCommand = new TinyWarpCommand();
				
			// Get map name
			newCommand.mapName = xmlData.child( 'MAP_NAME' ).toString().toUpperCase();
			
			// Get warp name
			newCommand.warpName = xmlData.child( 'WARP_NAME' ).toString();
			
			// Get facing direction
			newCommand.warpFacing = xmlData.child( 'FACING' ).toString().toUpperCase();
			
			// Get pre-fade sequence name
			newCommand.preFadeSequenceName = xmlData.child( 'PREFADE' ).toString();
			
			// Get post-fade sequence name
			newCommand.postFadeSequenceName = xmlData.child( 'POSTFADE' ).toString();
			
			// Get fade settings
			newCommand.fadeSpeed = uint( xmlData.child( 'FADE_SPEED' ).toString() );
			newCommand.fadeDelay = uint( xmlData.child( 'FADE_DELAY' ).toString() );
			
			// Get step forward status
			newCommand.stepForward = xmlData.attribute( 'stepforward' ).toString().toUpperCase() == 'TRUE';
				
			// Create warp object
			newCommand.warpObject = new TinyFieldMapObjectWarp();
			newCommand.warpObject.targetMapName = newCommand.mapName;
			newCommand.warpObject.targetWarpName = newCommand.warpName;
			newCommand.warpObject.destinationFacing = newCommand.warpFacing;
			newCommand.warpObject.stepForwardAfterWarp = newCommand.stepForward;		
			
			return newCommand;
		}
	}
}
