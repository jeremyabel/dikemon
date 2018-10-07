package com.tinyrpg.sequence 
{
	import com.tinyrpg.data.TinyPositionXMLData;
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * Class which represents a "SET_POSITION" command in the event sequencer.
	 * 
	 * This command immediately sets the position of a given target sprite on the map.
	 * Valid XML parameter tags are:
	 * 
	 *  TARGET:		The name of the sprite, or "PLAYER" for the player sprite.
	 *  POSITION:	The X and Y position on the map. In pixel units for all but the player sprite,
	 *  			which is in grid units.
	 * 
	 * @author jeremyabel
	 */
	public class TinySetPosCommand 
	{
		public var target : DisplayObject;
		public var targetName : String;
		public var position : TinyPositionXMLData;
		
		public function TinySetPosCommand() : void { }
		
		/**
		 * Returns a new {@link TinySetPosCommand} created from the given XML data.
		 */
		public static function newFromXML( xmlData : XML ) : TinySetPosCommand
		{
			var newCommand : TinySetPosCommand = new TinySetPosCommand;
			
			// Get target name
			newCommand.targetName = xmlData.child( 'TARGET' ).toString().toUpperCase();
			
			// Get location
			newCommand.position = TinyPositionXMLData.newFromXML( xmlData.child( 'POSITION' ) );
			
			return newCommand;
		}
		
		public function execute() : void
		{	
			// Get target sprite from either the player or the current map
			if ( this.targetName == 'PLAYER' ) 
			{
				TinyLogManager.log( 'execute: Player', this );
				
				this.target = TinyMapManager.getInstance().playerSprite;
				
				// Use the setPositionOnGrid function so that the camera tracks correctly
				( this.target as TinyWalkSprite ).setPositionOnGrid( this.position.gridX, this.position.gridY );
			} 
			else 
			{	
				TinyLogManager.log( 'execute: ' + this.targetName, this );
				
				this.target = TinyMapManager.getInstance().currentMap.getNPCObjectByName( this.targetName );
					
				// Set position
				this.target.x = this.position.x;
				this.target.y = this.position.y
			}
		}
	}
}
