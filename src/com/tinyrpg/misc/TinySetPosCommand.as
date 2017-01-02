package com.tinyrpg.misc 
{
	import com.tinyrpg.core.TinyFieldMap;
	import com.tinyrpg.core.TinyFriendSprite;
	import com.tinyrpg.core.TinyPlayer;
	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.geom.Point;

	/**
	 * @author jeremyabel
	 */
	public class TinySetPosCommand 
	{
		public var _target : TinyFriendSprite;
		public var targetName : String;
		public var position : Point;
		public var facing : String;
		
		public function TinySetPosCommand() : void
		{
			
		}
		
		public function execute() : void
		{
			TinyLogManager.log('execute: ' + this.target.charName, this);
			
			// Set stuff
			this.target.x = this.position.x;			this.target.y = this.position.y;
			this.target.idleDirection(this.facing);
		}

		public static function newFromXML(xmlData : XML) : TinySetPosCommand
		{
			var newCommand : TinySetPosCommand = new TinySetPosCommand;
			
			newCommand.targetName = xmlData.child('TARGET');
			newCommand.facing = xmlData.child('FACING');
			
			// Get target
			if (xmlData.child('TARGET') == 'PLAYER') {
				newCommand._target = TinyFriendSprite(TinyStatsEntity(TinyPlayer.getInstance().party.party[0]).graphics);
			} else {
				newCommand._target = TinyFieldMap.getNPCSpriteByName(xmlData.child('TARGET').toString());
			}
		
			// Get location
			newCommand.position = new Point;
			var posArray : Array = xmlData.child('POSITION').toString().split(',');
			newCommand.position.x = int(posArray[0]);
			newCommand.position.y = int(posArray[1]);
			
			return newCommand;
		}
		
		public function get target() : TinyFriendSprite 
		{
			if (this._target) {
				return this._target;
			} else {
				return TinyFieldMap.getNPCSpriteByName(targetName);
			}
		}
	}
}
