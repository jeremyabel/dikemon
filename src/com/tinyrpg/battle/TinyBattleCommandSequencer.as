package com.tinyrpg.battle 
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleCommandSequencer extends EventDispatcher 
	{
		private var commands : Array = [];
		private var playerCommand : TinyBattleCommand;
		private var enemyCommand : TinyBattleCommand;
		private var firstMoveCommand : TinyBattleCommandMove;
		private var secondMoveCommand : TinyBattleCommandMove;
		private var currentCommand : TinyBattleCommand;
		private var battle : TinyBattle;
		
		public function TinyBattleCommandSequencer( battle : TinyBattle )
		{
			this.battle = battle; 
		}
		
		public function commandSelected( command : TinyBattleCommand ) : void
		{
			switch ( command.type )
			{
				case TinyBattleCommand.COMMAND_MOVE:
				{
					// Clear the commands array
					this.commands = [];
					this.firstMoveCommand = null;
					this.secondMoveCommand = null;
					
					var moveCommand : TinyBattleCommandMove = command as TinyBattleCommandMove;
					TinyLogManager.log('commandSelected: MOVE - ' + moveCommand.move.name, this );
					
					this.playerCommand = moveCommand; 
					break;
				}
				
				case TinyBattleCommand.COMMAND_SWITCH:
				{
					var switchCommand : TinyBattleCommandSwitch = command as TinyBattleCommandSwitch;
					TinyLogManager.log('commandSelected: SWITCH - ' + switchCommand.switchMon.name, this );
					
					// If this switch command is forced as a result of a player mon fainting, there will already be additional commands in the queue, 
					// so add it to the start of the queue and execute it immediately. Otherwise, proceed normally.
					if ( switchCommand.isForced )
					{
						this.commands.unshift( switchCommand );
						this.onCommandCompleted( null );
						return;	
					}
					else
					{
						// Clear the commands array
						this.commands = [];
						this.firstMoveCommand = null;
						this.secondMoveCommand = null;
						
						this.playerCommand = switchCommand;
					}
					
					break;
				}
				
				case TinyBattleCommand.COMMAND_ITEM:
				{
					TinyLogManager.log('commandSelected: ITEM', this);
					
					// Clear the commands array
					this.commands = [];
					this.firstMoveCommand = null;
					this.secondMoveCommand = null;
					
					var itemCommand : TinyBattleCommandItem = command as TinyBattleCommandItem;
					this.playerCommand = itemCommand;
					break;
				}
				
				case TinyBattleCommand.COMMAND_RUN:
				{
					TinyLogManager.log('commandSelected: RUN', this);
					
					// Clear the commands array
					this.commands = [];
					this.firstMoveCommand = null;
					this.secondMoveCommand = null;
					
					var runCommand : TinyBattleCommandRun = command as TinyBattleCommandRun;
					this.playerCommand = runCommand;
					break;
				}
			}
			
			/*
			 * Enemy Move
			 * 	- player faint: force player switch -> player turn
			 * 	- enemy faint: enemy switch -> player turn 
			 * 	- both faint: enemy switch -> force player switch -> player turn
			 * 	 
			 * Player Move
			 * 	- enemy faint: enemy switch -> player turn
			 * 	- player faint: force player switch -> player turn
			 *  - both faint: enemy switch -> force player switch -> player turn
			 */
			 
			// Pick which move the enemy will use
			var enemyMove : TinyMoveData = null;
			if ( this.battle.isWildEncounter ) {
				enemyMove = TinyTrainerAI.getWildMonMove( this.battle.currentEnemyMon );
			} else {
				enemyMove = TinyTrainerAI.getTrainerMonMove( this.battle.currentEnemyMon, this.battle.currentPlayerMon, this.battle.enemyTrainer.aiType );
			}
			
			// Create the enemy's move command
			this.enemyCommand = new TinyBattleCommandMove( this.battle, TinyBattleCommand.USER_ENEMY, enemyMove );
			
			// Figure out the turn order based on what the player's command is
			switch ( this.playerCommand.type )
			{
				// Player Command = MOVE
				case TinyBattleCommand.COMMAND_MOVE:
				{
					var playerMoveCommand : TinyBattleCommandMove = this.playerCommand as TinyBattleCommandMove;
					
					switch ( this.enemyCommand.type ) 
					{	
						// Player Command = MOVE and Enemy Command = MOVE: Resolve using battle math
						case TinyBattleCommand.COMMAND_MOVE:
						{
							var enemyMoveCommand : TinyBattleCommandMove = this.enemyCommand as TinyBattleCommandMove;
							
							if ( TinyBattleMath.doesEnemyGoFirst( this.battle.currentPlayerMon, playerMoveCommand.move, this.battle.currentEnemyMon, enemyMoveCommand.move ) ) 
							{
								// Enemy goes first
								TinyLogManager.log('commandSelected: Player = MOVE, Enemy = MOVE. Enemy goes first.', this);
								this.firstMoveCommand = this.enemyCommand as TinyBattleCommandMove;
								this.secondMoveCommand = this.playerCommand as TinyBattleCommandMove;
							} 
							else 
							{
								// Player goes first
								TinyLogManager.log('commandSelected: Player = MOVE, Enemy = MOVE. Player goes first.', this);
								this.firstMoveCommand = this.playerCommand as TinyBattleCommandMove;
								this.secondMoveCommand = this.enemyCommand as TinyBattleCommandMove;
							}
							
							// Set move order flags
							this.firstMoveCommand.isFirstMoveCommand = true;
							this.secondMoveCommand.isSecondMoveCommand = true;
							
							// Add first move command
							this.commands.push( this.firstMoveCommand );
							break;
						}
						
						// Player Command = MOVE and Enemy Command = SWITCH: Enemy switch goes first, then player goes
						case TinyBattleCommand.COMMAND_SWITCH:
						{
							TinyLogManager.log('commandSelected: Player = MOVE, Enemy = SWITCH. Enemy goes first.', this);
							this.commands.push( this.enemyCommand );
							this.commands.push( this.playerCommand );
							break;
						}
					}
					
					break;
				}
				
				// Player Command = SWITCH
				case TinyBattleCommand.COMMAND_SWITCH:
				{
					switch ( this.enemyCommand.type )
					{
						// Player Command = SWITCH and Enemy Command = MOVE: Player switch goes first, then enemy goes
						case TinyBattleCommand.COMMAND_MOVE:
						{
							TinyLogManager.log('commandSelected: Player = SWITCH, Enemy = MOVE. Player goes first.', this);
							this.commands.push( this.playerCommand );
							this.commands.push( this.enemyCommand );
							break;
						}
						
						// Player Command = SWITCH and Enemy Command = SWITCH: Player switch goes first, then enemy goes
						case TinyBattleCommand.COMMAND_SWITCH:
						{
							TinyLogManager.log('commandSelected: Player = SWITCH, Enemy = SWITCH. Player goes first.', this);
							this.commands.push( this.playerCommand );
							this.commands.push( this.enemyCommand );
							break;
						}
					}
					
					break;
				}
				
				// Player Command = ITEM	
				case TinyBattleCommand.COMMAND_ITEM:
				{
					itemCommand = this.playerCommand as TinyBattleCommandItem;
					
					// Player Command = ITEM: Player item use goes first, but Player caught the mon so end the battle
					if ( itemCommand.result == TinyBattleCommandItem.RESULT_MON_CAUGHT )
					{
						TinyLogManager.log( 'commandSelected: Player = ITEM. Player goes first, catches mon, then end battle.', this );
						this.commands.push( this.playerCommand );
						this.commands.push( TinyBattleCommand.getEndBattleCommand( this.battle, TinyBattleCommand.USER_PLAYER ) );
						this.battle.result = new TinyBattleResult( TinyBattleResult.RESULT_CAUGHT );
						break; 
					}
					
					// Player Command = ITEM: Player item use goes first, then enemy goes
					else
					{
				 		TinyLogManager.log( 'commandSelected: Player = ITEM. Player goes first.', this );
						this.commands.push( this.playerCommand );
						this.commands.push( this.enemyCommand );
						break;
					}
				}
				
				// Player Command = RUN
				case TinyBattleCommand.COMMAND_RUN:
				{
					runCommand = this.playerCommand as TinyBattleCommandRun;
					
					// Player Command = RUN, IMPOSSIBLE / FAILED
					if ( runCommand.result == TinyBattleCommandRun.RESULT_IMPOSSIBLE || runCommand.result == TinyBattleCommandRun.RESULT_FAILED ) 
					{
						switch ( this.enemyCommand.type )
						{
							// Player Command = RUN, IMPOSSIBLE / FAILED, Enemy Command = MOVE. Player attempts run, then enemy goes  
							case TinyBattleCommand.COMMAND_MOVE:
							{
								TinyLogManager.log('commandSelected: Player = RUN, Enemy = MOVE. Player goes first.', this);
								this.commands.push( this.playerCommand );
								this.commands.push( this.enemyCommand );
								break;											
							}
							
							// Player Command = RUN, IMPOSSIBLE / FAILED, Enemy Command = SWITCH. Player attempts run, then enemy switch goes
							case TinyBattleCommand.COMMAND_SWITCH:
							{
								TinyLogManager.log('commandSelected: Player = RUN, Enemy = SWITCH. Player goes first.', this);
								this.commands.push( this.playerCommand );
								this.commands.push( this.playerCommand );
								break;		
							}
						}
						
						break;
					}
					
					// Player Command = RUN, PASSED, Player runs, then battle ends.
					else
					{
						TinyLogManager.log('commandSelected: Player = RUN PASSED. Player goes, then end battle.', this);	
						this.commands.push( this.playerCommand );
						this.commands.push( TinyBattleCommand.getEndBattleCommand( this.battle, TinyBattleCommand.USER_PLAYER ) );
						this.battle.result = new TinyBattleResult( TinyBattleResult.RESULT_RAN );
						break;
					}
				}
			}

			// Trace out the sequence
			TinyLogManager.log('======================================================================', this);
			for each ( var sequenceCommand : TinyBattleCommand in this.commands ){
				TinyLogManager.log('command sequence: ' + sequenceCommand.logString, this);
			}
			
			// Execute the sequence
			TinyLogManager.log('======================================================================', this);
			this.executeNextCommand();
		} 
		
		
		private function executeNextCommand() : void
		{
			this.currentCommand = this.commands.shift();
				
			// If there is no next command, end the battle
			if ( !this.currentCommand )
			{
				TinyLogManager.log( 'executeNextCommand: no commands left, ending battle', this );
				this.battle.endBattle();
				return;
			}
			
			TinyLogManager.log( 'executeNextCommand: ' + this.currentCommand.logString, this );
			
			// Execute next command
			this.currentCommand.addEventListener( Event.COMPLETE, this.onCommandCompleted );
			this.currentCommand.execute();
		}


		private function onCommandCompleted( event : Event ) : void
		{
			TinyLogManager.log('onCommandCompleted: ' + this.currentCommand.logString, this); 
			
			var doNextCommand : Boolean = true;
			
			// Add any additional commands that resulted from running the previous command
			this.commands = this.commands.concat( this.currentCommand.getNextCommands() ); 
			
			// Clear the applicable first or second move value
			if ( this.currentCommand.type == TinyBattleCommand.COMMAND_MOVE )
			{
				var moveCommand : TinyBattleCommandMove = this.currentCommand as TinyBattleCommandMove;
				if ( moveCommand.isFirstMoveCommand ) this.firstMoveCommand = null;
				if ( moveCommand.isSecondMoveCommand ) this.secondMoveCommand = null;
			}
			
			// Translate victory command to winning battle result
			if ( this.currentCommand.type == TinyBattleCommand.COMMAND_PLAYER_VICTORY ) 
			{
				this.battle.result = new TinyBattleResult( TinyBattleResult.RESULT_WIN );
			}
			
			// Translate loss command to losing battle result
			if ( this.currentCommand.type == TinyBattleCommand.COMMAND_PLAYER_LOSS ) 
			{
				this.battle.result = new TinyBattleResult( TinyBattleResult.RESULT_LOSE );
			}
			
			// If no victory or loss has occurred, and there are no commands left...
			if ( this.currentCommand.type != TinyBattleCommand.COMMAND_PLAYER_VICTORY && this.currentCommand.type != TinyBattleCommand.COMMAND_PLAYER_LOSS && this.commands.length <= 0 )
			{
				// Add the second move command, otherwise start the next turn
				if ( this.secondMoveCommand ) {
					this.commands.push( this.secondMoveCommand );
				} else {
					this.commands.push( new TinyBattleCommandPlayerResolveStatus( this.battle ) );
					this.commands.push( TinyBattleCommand.getStartTurnCommand( this.battle ) );
				}
			}
			
			// Clean up
			this.currentCommand.removeEventListener( Event.COMPLETE, this.onCommandCompleted );
			this.currentCommand = null;
			
			// Next!
			this.executeNextCommand();
		}
	}
}
