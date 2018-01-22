package com.tinyrpg.sequence
{
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinySetFacingCommand 
	{
		public var targetName 	: String;
		public var targetFacing : String;
		
		public function TinySetFacingCommand() : void { }
		
		public static function newFromXML( xmlData : XML ) : TinySetFacingCommand
		{
			var newCommand : TinySetFacingCommand = new TinySetFacingCommand;
			
			// Get target name
			newCommand.targetName = xmlData.child( 'TARGET' ).toString().toUpperCase();
			
			// Get facing
			newCommand.targetFacing = xmlData.child( 'FACING' ).toString().toUpperCase();
			
			return newCommand;
		}
		
		public function execute() : void
		{
			var target : TinyWalkSprite;
			
			// Get target sprite from either the player or the current map
			if ( this.targetName == 'PLAYER' ) 
			{
				TinyLogManager.log( 'execute: Player', this );
				target = TinyMapManager.getInstance().playerSprite;
			} 
			else 
			{	
				TinyLogManager.log( 'execute: ' + this.targetName, this );
				target = TinyMapManager.getInstance().currentMap.getNPCObjectByName( this.targetName ).walkSprite;
			}
			
			// Set facing
			target.setFacing( this.targetFacing );
		}
	}
}
