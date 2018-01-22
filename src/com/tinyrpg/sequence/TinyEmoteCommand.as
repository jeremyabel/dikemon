package com.tinyrpg.sequence
{
	import com.tinyrpg.display.TinyEmoteIcon;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyEmoteCommand 
	{
		public var targetName 	: String;
		public var targetEmote 	: String;
		public var isVisible	: Boolean;
		
		public function TinyEmoteCommand() : void { }
		
		public static function newFromXML( xmlData : XML, isVisible : Boolean ) : TinyEmoteCommand
		{
			var newCommand : TinyEmoteCommand = new TinyEmoteCommand;
			
			// Get target name
			newCommand.targetName = xmlData.child( 'TARGET' ).toString().toUpperCase();
			
			// Get facing
			newCommand.targetEmote = xmlData.child( 'EMOTE' ).toString().toUpperCase();
			
			// Get visibility
			newCommand.isVisible = isVisible;
			
			return newCommand;
		}
		
		public function execute() : void
		{
			var target : TinyEmoteIcon;
			
			// Get target sprite from either the player or the current map
			if ( this.targetName == 'PLAYER' ) 
			{
				TinyLogManager.log( 'execute: Player', this );
				target = TinyMapManager.getInstance().playerSprite.emoteIcon;
			} 
			else 
			{	
				TinyLogManager.log( 'execute: ' + this.targetName, this );
				target = TinyMapManager.getInstance().currentMap.getNPCObjectByName( this.targetName ).walkSprite.emoteIcon;
			}
			
			if ( this.isVisible ) {
				target.show( this.targetEmote );
			} else {
				target.hide();
			}
		}
	}
}
