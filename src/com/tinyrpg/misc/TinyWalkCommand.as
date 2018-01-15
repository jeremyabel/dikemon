package com.tinyrpg.misc 
{
	import com.greensock.TweenLite;
//	import com.tinyrpg.core.TinyFieldMap;
//	import com.tinyrpg.core.TinyFriendSprite;
//	import com.tinyrpg.core.TinyPlayer;
//	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author jeremyabel
	 */
	public class TinyWalkCommand extends EventDispatcher
	{
//		private var _target  : TinyFriendSprite;
		public var direction : String;
		public var time		 : int;
		public var sync		 : Boolean;
		public var name		 : String;
		
		public function TinyWalkCommand() : void
		{
			
		}
		
		public function execute() : void
		{
//			TinyLogManager.log('execute', this);
//			
//			this.target.facing = this.direction;
//			
//			switch (this.direction) 
//			{
//				case TinyFriendSprite.UP:
//					this.target.walkBack();
//					break;
//				case TinyFriendSprite.DOWN:
//					this.target.walkForward();
//					break;
//				case TinyFriendSprite.LEFT:
//					this.target.walkLeft();
//					break;
//				case TinyFriendSprite.RIGHT:
//					this.target.walkRight();
//					break;
//			}
//			 
//			// Trigger idle state after time is up
//			TweenLite.delayedCall(this.time, this.target.idleWalk, null, true);
//			
//			// Immediately proceed to the next step if we're syncing with other animations
//			if (this.sync) {
//				this.dispatchEvent(new Event(Event.COMPLETE));
//			} else {
//				TweenLite.delayedCall(this.time, this.dispatchEvent, [new Event(Event.COMPLETE)], true);
//			}
		}
		
		public static function newFromXML(xmlData : XML) : TinyWalkCommand
		{
			TinyLogManager.log('newFromXML', TinyWalkCommand);
			
			var newWalkCommand : TinyWalkCommand = new TinyWalkCommand;
//			newWalkCommand.name = xmlData.child('TARGET');
			
//			// Get target
//			if (xmlData.child('TARGET') == 'PLAYER') {
//				newWalkCommand._target = TinyFriendSprite(TinyStatsEntity(TinyPlayer.getInstance().party.party[0]).graphics);
//			} else {
//				newWalkCommand._target = TinyFieldMap.getNPCSpriteByName(xmlData.child('TARGET'));
//			}
//			
//			// Set parameters
//			newWalkCommand.direction = xmlData.child('DIRECTION').toString().toUpperCase();
//			newWalkCommand.time = int(xmlData.child('TIME').text());
//			newWalkCommand.sync = (xmlData.child('SYNC').toString().toUpperCase() == 'TRUE');
			
			return newWalkCommand;
		}
		
		public function get target() : * //TinyFriendSprite
		{
			return null;
//			if (this._target) {
//				return this._target;
//			} else {
//				return TinyFieldMap.getNPCSpriteByName(this.name);
//			}
		}
	}
}
