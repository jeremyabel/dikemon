package com.tinyrpg.battle 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleCommand extends EventDispatcher
	{
		public static const COMMAND_MOVE				: String = 'MOVE';
		public static const COMMAND_SWITCH				: String = 'SWITCH';
		public static const COMMAND_ITEM				: String = 'ITEM';
		public static const COMMAND_RUN					: String = 'RUN';
		public static const COMMAND_PLAYER_VICTORY	 	: String = 'PLAYER_VICTORY';
		public static const COMMAND_PLAYER_LOSS			: String = 'PLAYER_LOSS';
		public static const COMMAND_START_TURN			: String = 'START_TURN';
		public static const COMMAND_FORCE_PLAYER_SWITCH	: String = 'FORCE_PLAYER_SWITCH';
		public static const COMMAND_RESOLVE_STATUSES	: String = 'RESOLVE_STATUSES';
		public static const COMMAND_DISTRIBUTE_EXP		: String = 'DISTRIBUTE_EXP';
		public static const COMMAND_END_BATTLE			: String = 'END_BATTLE';
		
		public static const USER_PLAYER					: String = 'PLAYER';
		public static const USER_ENEMY					: String = 'ENEMY';
		
		public var type : String;
		public var user : String;
		public var eventSequence : TinyBattleEventSequence;
		
		protected var battle : TinyBattleMon;
		
		
		public function TinyBattleCommand( battle : TinyBattleMon, type : String, user : String )
		{
			this.type = type;
			this.user = user;
			this.battle = battle;
			
			this.eventSequence = new TinyBattleEventSequence( battle );
		}
		
		
		public function get isEnemy() : Boolean
		{
			return this.user == USER_ENEMY;
		}
		
		
		public function get logString() : String 
		{
			return type + ': ' + user;
		}
		
		
		public static function getStartTurnCommand( battle : TinyBattleMon ) : TinyBattleCommand
		{
			return new TinyBattleCommand( battle, TinyBattleCommand.COMMAND_START_TURN, TinyBattleCommand.USER_PLAYER );
		}
		
		
		public static function getPlayerVictoryCommand( battle : TinyBattleMon ) : TinyBattleCommand
		{
			return new TinyBattleCommand( battle, TinyBattleCommand.COMMAND_PLAYER_VICTORY, TinyBattleCommand.USER_PLAYER );
		}
		
		
		public static function getPlayerLossCommand( battle : TinyBattleMon ) : TinyBattleCommand
		{
			return new TinyBattleCommand( battle, TinyBattleCommand.COMMAND_PLAYER_LOSS, TinyBattleCommand.USER_PLAYER );	
		}
		
		
		public static function getForcePlayerSwitchCommand( battle : TinyBattleMon ) : TinyBattleCommand
		{
			return new TinyBattleCommand( battle, TinyBattleCommand.COMMAND_FORCE_PLAYER_SWITCH, TinyBattleCommand.USER_PLAYER );	
		}
		
		
		public static function getEndBattleCommand( battle : TinyBattleMon, user : String ) : TinyBattleCommand
		{
			return new TinyBattleCommand( battle, TinyBattleCommand.COMMAND_END_BATTLE, user );
		}


		public function execute() : void
		{
			TinyLogManager.log('execute: ' + this.type + ' for ' + this.user, this);
			
			switch ( this.type )
			{
				default:
				{
					// Remove control and start the event
					TinyInputManager.getInstance().setTarget( null );
					this.eventSequence.addEventListener( Event.COMPLETE, this.onEventComplete );
					this.eventSequence.startSequence();
					break;
				}
				
				case COMMAND_START_TURN:
				{
					this.battle.startTurn();
					break;
				}
				
				case COMMAND_FORCE_PLAYER_SWITCH:
				{
					this.battle.forcePlayerSwitch();
					break;
				}
				
				case COMMAND_END_BATTLE:
				{
					this.battle.endBattle();
					break;
				}
			}	
		}
		
		
		public function getNextCommands() : Array
		{
			TinyLogManager.log('getNextCommands: none', this);
			return [];	
		}
		
		
		protected function onEventComplete( event : Event = null) : void
		{	
			TinyLogManager.log('onEventComplete: ' + this.type + ' for ' + this.user, this);
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
	}
}
