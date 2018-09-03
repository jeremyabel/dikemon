package com.tinyrpg.battle 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * Class which represents a single action, or "command", in battle.
	 * The job of this class is to create a single {@link TinyBattleEventSequence}, populated
	 * with the events required to execute the given command. A battle is a sequence of these 
	 * commands, which can be triggered by the player, by the opposing mon or trainer, or 
	 * automatically as part of the course of the battle. 
	 * 
	 * {@link TinyBattleCommandSequencer} manages the order and execution of these commands.  
	 * 
	 * For more complex commands (move, switch, item, run, etc), this class is used as a 
	 * base class and the more complex behavior is definied separately.
	 * 
	 * @see TinyBattleCommandItem
	 * @see TinyBattleCommandMove
	 * @see TinyBattleCommandPlayerResolveStatus
	 * @see TinyBattleCommandPlayerVictory
	 * @see TinyBattleCommandRun
	 * @see TinyBattleCommandSwitch
	 *   
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
		
		protected var battle : TinyBattle;
		
		/**
		 * Constructs a new TinyBattleCommand of a given type for a given battle and user.
		 * 
		 * @param	battle	The battle this command will be used in
		 * @param	type	The type of command this is.
		 * @param	user	The user of the command, either "PLAYER" or "ENEMY"
		 */
		public function TinyBattleCommand( battle : TinyBattle, type : String, user : String )
		{
			this.type = type;
			this.user = user;
			this.battle = battle;
			
			this.eventSequence = new TinyBattleEventSequence( battle );
		}
		
		/**
		 * Returns true if this command is called by the enemy mon / trainer.
		 */
		public function get isEnemy() : Boolean
		{
			return this.user == USER_ENEMY;
		}
		
		/**
		 * Returns a string with some basic information about the command.
		 */
		public function get logString() : String 
		{
			return type + ': ' + user;
		}
		
		
		/**
		 * Returns a START_TURN command for a given battle.
		 */
		public static function getStartTurnCommand( battle : TinyBattle ) : TinyBattleCommand
		{
			return new TinyBattleCommand( battle, TinyBattleCommand.COMMAND_START_TURN, TinyBattleCommand.USER_PLAYER );
		}
		
		
		/**
		 * Returns a PLAYER_VICTORY command for a given battle.
		 */
		public static function getPlayerVictoryCommand( battle : TinyBattle ) : TinyBattleCommand
		{
			return new TinyBattleCommand( battle, TinyBattleCommand.COMMAND_PLAYER_VICTORY, TinyBattleCommand.USER_PLAYER );
		}
		
		
		/**
		 * Returns a PLAYER_LOSS command for a given battle.
		 */
		public static function getPlayerLossCommand( battle : TinyBattle ) : TinyBattleCommand
		{
			return new TinyBattleCommand( battle, TinyBattleCommand.COMMAND_PLAYER_LOSS, TinyBattleCommand.USER_PLAYER );	
		}
		
		
		/**
		 * Returns a FORCE_PLAYER_SWITCH command for a given battle.
		 */
		public static function getForcePlayerSwitchCommand( battle : TinyBattle ) : TinyBattleCommand
		{
			return new TinyBattleCommand( battle, TinyBattleCommand.COMMAND_FORCE_PLAYER_SWITCH, TinyBattleCommand.USER_PLAYER );	
		}
		
		/**
		 * Returns a END_BATTLE command for a given battle with a given user.
		 */
		public static function getEndBattleCommand( battle : TinyBattle, user : String ) : TinyBattleCommand
		{
			return new TinyBattleCommand( battle, TinyBattleCommand.COMMAND_END_BATTLE, user );
		}


		/**
		 * Executes the command. This has built-in functionality for a few simple commands, but otherwise
		 * it is overridden by one of the inherited complex command classes.
		 */
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
				
				// These simpler commands just remap single functions to the command's TinyBattle object.
				 
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
		
		
		/**
		 * Returns an array of commands to be run next. 
		 * This is a stub and is meant to be overridden.
		 */
		public function getNextCommands() : Array
		{
			TinyLogManager.log('getNextCommands: none', this);
			return [];	
		}
		
		
		/**
		 * Dispatches the COMPLETE event.
		 */
		protected function onEventComplete( event : Event = null) : void
		{	
			TinyLogManager.log('onEventComplete: ' + this.type + ' for ' + this.user, this);
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
	}
}
