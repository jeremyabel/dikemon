package com.tinyrpg.sequence 
{
	import com.tinyrpg.data.TinyPositionXMLData;
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * @author jeremyabel
	 */
	public class TinySetPosCommand 
	{
		public var target : DisplayObject;
		public var targetName : String;
		public var position : TinyPositionXMLData;
		
		public function TinySetPosCommand() : void { }
		
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
