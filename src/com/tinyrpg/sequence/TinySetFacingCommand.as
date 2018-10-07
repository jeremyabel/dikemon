package com.tinyrpg.sequence
{
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * Class which represents the "SET_FACING" command in the event sequencer.
	 * 
	 * This command immediately sets the sprite facing for a given target sprite.
	 * Valid XML parameter tags are: 
	 * 
	 * 	TARGET: The name of the NPC to use, or "PLAYER" for the player character.
	 * 	FACING: The facing value. Valid values are UP, DOWN, LEFT, and RIGHT.
	 * 	TO_NPC: The name of another NPC to face towards, instead of a specific direction.
	 * 
	 * @author jeremyabel
	 */
	public class TinySetFacingCommand 
	{
		public var targetName 			: String;
		public var targetFacing 		: String;
		public var targetFacingNPCName 	: String;
		
		public function TinySetFacingCommand() : void { }
		
		/**
		 * Returns a new {@link TinySetFacingCommand} created from the given XML data.
		 */
		public static function newFromXML( xmlData : XML ) : TinySetFacingCommand
		{
			var newCommand : TinySetFacingCommand = new TinySetFacingCommand;
			
			// Get target name
			newCommand.targetName = xmlData.child( 'TARGET' ).toString().toUpperCase();
			
			// Get target facing
			newCommand.targetFacing = xmlData.child( 'FACING' ).toString().toUpperCase();
			
			// Get target facing NPC name
			newCommand.targetFacingNPCName = xmlData.child( 'TO_NPC' ).toString().toUpperCase();
			
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
			
			// If another NPC name is provided in the "TO_NPC" parameter tag, then find the other NPC that this one 
			// should face towards and and set the new facing value so that we're facing towards them.
			if ( this.targetFacingNPCName )
			{
				var targetFacingNPC : TinyWalkSprite = TinyMapManager.getInstance().currentMap.getNPCObjectByName( this.targetFacingNPCName ).walkSprite;
				
				switch ( targetFacingNPC.currentDirection )
				{
					case TinyWalkSprite.UP: 	this.targetFacing = 'DOWN';  break;
					case TinyWalkSprite.DOWN:	this.targetFacing = 'UP';  	 break;
					case TinyWalkSprite.LEFT:	this.targetFacing = 'RIGHT'; break;
					case TinyWalkSprite.RIGHT:	this.targetFacing = 'LEFT';  break;
				}
			}
			
			// Set facing
			target.setFacing( this.targetFacing );
		}
	}
}
