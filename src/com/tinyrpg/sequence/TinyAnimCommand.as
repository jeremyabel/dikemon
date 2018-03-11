package com.tinyrpg.sequence 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.RoundPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author jeremyabel
	 */
	public class TinyAnimCommand extends EventDispatcher 
	{
		public static var WALK_IDLE		: String = 'WALK_IDLE';
		public static var BATTLE_IDLE	: String = 'BATTLE_IDLE';
		public static var ATTACK 		: String = 'ATTACK';
		public static var USE_ITEM		: String = 'USE_ITEM';
		public static var DIE			: String = 'DIE';
		public static var HIT			: String = 'HIT';
		public static var VICTORY		: String = 'VICTORY';
		public static var IDLE_DIR		: String = 'IDLE_DIR';
		public static var WALK_TO_PLAYER: String = 'WALK_TO_PLAYER';
		public static var FIRE_FLAIL	: String = 'FIRE_FLAIL';
		public static var DEATH_SHAKE	: String = 'DEATH_SHAKE';
		public static var FISH_EMERGE	: String = 'FISH_EMERGE';
		public static var SUCK_TO_POINT : String = 'SUCK_TO_POINT';
		
//		public var _target 	  : TinyFriendSprite;
		public var battleName : String;
		public var animName	  : String;
		public var sync		  : Boolean;
		public var direction  : String;
		public var battle	  : Boolean;
		
		public function TinyAnimCommand()
		{
			TweenPlugin.activate([RoundPropsPlugin]);
		}
		
		public function execute() : void
		{
			TinyLogManager.log('execute: ' + this.animName, this);
			
//			var delayTime : int = 0;
//			
//			if (this.target) 
//			{
//				switch (this.animName)
//				{
//					case TinyAnimCommand.WALK_IDLE:
//						this.target.idleWalk();
//						break;
//					case TinyAnimCommand.IDLE_DIR:
//						this.target.idleDirection(this.direction);
//						break;
//					case TinyAnimCommand.BATTLE_IDLE:
//						this.target.idleBattle();
//						break;
//					case TinyAnimCommand.ATTACK:
//						delayTime = this.target.attack();
//						break;
//					case TinyAnimCommand.USE_ITEM:
//						delayTime = this.target.useItem();
//						break;
//					case TinyAnimCommand.DIE:
//						this.target.die();
//						break;
//					case TinyAnimCommand.HIT:
//						delayTime = this.target.hit();
//						break;
//					case TinyAnimCommand.VICTORY:
//						delayTime = this.target.victory();
//						break;
//					case TinyAnimCommand.WALK_TO_PLAYER:
//						delayTime = this.target.walkToPlayer();
//						break;
//					case TinyAnimCommand.DEATH_SHAKE:
//						delayTime = this.target.deathShake();
//						break;
//					case TinyAnimCommand.FISH_EMERGE:
//						TweenLite.to(this.target, 15, { x:"15", y:"15", ease:Linear.easeNone, useFrames:true, roundProps:["x", "y"] });
//						delayTime = 15;
//						break;
//					case TinyAnimCommand.SUCK_TO_POINT:
//						this.target.suckToCenter();
//						delayTime = 100;
//						break;
//				}
//			}
//			
//			// Immediately proceed to the next step if we're syncing with other animations
//			if (this.sync || delayTime <= 0) {
//				this.dispatchEvent(new Event(Event.COMPLETE));
//			} else {
//				TweenLite.delayedCall(delayTime, this.dispatchEvent, [new Event(Event.COMPLETE)], true);
//			}
		}
		
		public static function newFromXML(xmlData : XML) : TinyAnimCommand
		{
			TinyLogManager.log('newFromXML', TinyAnimCommand);
			
			var newAnimCommand : TinyAnimCommand = new TinyAnimCommand;
			
//			// For battle?
//			newAnimCommand.battle = (xmlData.child('BATTLE').toString() == 'TRUE');
//			newAnimCommand.battleName = xmlData.child('TARGET').toString();
//			
//			// Get target
//			if (newAnimCommand.battle) {
//				newAnimCommand._target = null;
//			} else { 
//				if (xmlData.child('TARGET') == 'PLAYER') {
//				//} else {
//				//	newAnimCommand._target = TinyFieldMap.getNPCSpriteByName(xmlData.child('TARGET'));
//				}
//			}
//			
//			// Set parameters
//			newAnimCommand.direction = (xmlData.child('DIRECTION').toString().toUpperCase());
//			newAnimCommand.animName  = (xmlData.child('ANIM_NAME').toString().toUpperCase());
//			newAnimCommand.sync      = (xmlData.child('SYNC').toString().toUpperCase() == 'TRUE');
			
			return newAnimCommand;
		}
		
		public function set target( value : * ) : void //value : TinyFriendSprite) : void
		{
//			this._target = value;
		}

		public function get target() : *//TinyFriendSprite
		{
			return null;
//			if (this._target) {
//				return this._target;
//			} else {
//				return TinyFieldMap.getNPCSpriteByName(this.battleName);
//			}
		}
	}
}
