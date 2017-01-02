package com.tinyrpg.misc 
{
	import com.greensock.TweenLite;
	import com.tinyrpg.core.TinyFieldMap;
	import com.tinyrpg.core.TinyFriendSprite;
	import com.tinyrpg.core.TinyPlayer;
	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author jeremyabel
	 */
	public class TinyFXCommand extends EventDispatcher 
	{
		public var _target 	  : TinyFriendSprite;
		public var fxName	  : String;
		public var sync		  : Boolean;
		public var battle	  : Boolean;
		public var battleName : String;
		public var loop 	  : Boolean = false;

		public function TinyFXCommand()
		{
			
		}
		
		public function execute() : void
		{
			TinyLogManager.log('execute: ' + this.loop, this);
			
			this.target.playFX(this.fxName, this.loop);
			
			// Immediately proceed to the next step if we're syncing with other animations
			if (this.sync) {
				this.dispatchEvent(new Event(Event.COMPLETE));
			} else {
				TweenLite.delayedCall(this.target.damageTime, this.dispatchEvent, [new Event(Event.COMPLETE)], true);
			}
		}
		
		public static function newFromXML(xmlData : XML) : TinyFXCommand
		{
			TinyLogManager.log('newFromXML', TinyFXCommand);
			
			var newFXCommand : TinyFXCommand = new TinyFXCommand;
			
			// For battle?
			newFXCommand.battle = (xmlData.child('BATTLE').toString() == 'TRUE');
			newFXCommand.battleName = xmlData.child('TARGET').toString();
			
			// Loop?
			newFXCommand.loop = (xmlData.child('LOOP').toString() == 'TRUE');
			
			// Get target
			if (xmlData.child('TARGET') == 'PLAYER') {
				newFXCommand._target = TinyFriendSprite(TinyStatsEntity(TinyPlayer.getInstance().party.party[0]).graphics);
			} else {
				newFXCommand._target = TinyFieldMap.getNPCSpriteByName(xmlData.child('TARGET'));
			}
			
			// Set parameters
			newFXCommand.fxName = (xmlData.child('FX_NAME').toString().toUpperCase());
			newFXCommand.sync   = (xmlData.child('SYNC').toString().toUpperCase() == 'TRUE');
			
			return newFXCommand;
		}
		
		public function set target(value : TinyFriendSprite) : void
		{
			this._target = value;
		}

		public function get target() : TinyFriendSprite
		{
			if (this._target) {
				return this._target;
			} else {
				return TinyFieldMap.getNPCSpriteByName(this.battleName);
			}
		}
	}
}
