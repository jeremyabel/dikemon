package com.tinyrpg.sequence
{
	import com.tinyrpg.battle.TinyTrainerAI;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.core.TinyEventSequence;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.lookup.TinyMonLookup;
	import com.tinyrpg.lookup.TinyNameLookup;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyTrainerBattleCommand 
	{
		public var enemyTrainer		: TinyTrainer;
		public var trainerName 		: String;
		public var trainerMons 		: Array = [];
		public var trainerMoney 	: uint;
		public var trainerAI		: String = TinyTrainerAI.AI_BASIC;
		public var allowGameOver 	: Boolean = true;
		public var winSequence		: TinyEventSequence;
		public var loseSequence		: TinyEventSequence;
			
		public function TinyTrainerBattleCommand() : void
		{
			
		}
		
		public static function newFromXML( xmlData : XML ) : TinyTrainerBattleCommand
		{
			var newCommand : TinyTrainerBattleCommand = new TinyTrainerBattleCommand();
				
			// Get trainer name
			newCommand.trainerName = xmlData.child( 'TRAINER_NAME' ).toString().toUpperCase();
			
			// Replace rival name if required
			if ( newCommand.trainerName == 'RIVAL' )
			{
				var playerName : String = TinyGameManager.getInstance().playerTrainer.name;
				newCommand.trainerName = TinyNameLookup.getRivalNameForPlayerName( playerName ).toUpperCase();
			}
			
			// Get trainer money
			newCommand.trainerMoney = uint( xmlData.child( 'TRAINER_MONEY' ).toString() );
			
			// Get trainer AI, if provided
			if ( xmlData.child( 'TRAINER_AI' ).length > 0 ) {
				newCommand.trainerAI = xmlData.child( 'TRAINER_AI' ).toString().toUpperCase();
			}
			
			// Get trainer mons
			for each ( var monXML : XML in xmlData.child( 'TRAINER_MONS' ).children() )
			{
				var monName : String = monXML.child( 'NAME' ).toString();
				var monLevel : uint = uint( monXML.child( 'LEVEL' ).toString() );
				var monEvolved : Boolean = monXML.child( 'EVOLVED' ).toString().toUpperCase() == 'TRUE';
				
				newCommand.trainerMons.push( TinyMonLookup.getInstance().getMonByName( monName, monLevel, monEvolved ) ); 
			}
			
			// Create new trainer
			newCommand.enemyTrainer = TinyTrainer.newFromSequenceCommand(
				newCommand.trainerName,
				newCommand.trainerMons,
				newCommand.trainerMoney,
				newCommand.trainerAI
			);
			
			// Trainer battles allow game over's by default, unless the "gameover" attribute is set to false
			if ( xmlData.attribute( 'gameover' ).toString().toUpperCase() == 'FALSE' )
			{ 
				newCommand.allowGameOver = false;
			}
			
			// Wrap the conditional sequences in an EVENT tag to create a new full event XML object
			var xmlStringWin  : String = '<EVENT>' + xmlData.child( 'IF_WIN'  ).child( 'SEQUENCE' ).toXMLString() + '</EVENT>';
			var xmlStringLose : String = '<EVENT>' + xmlData.child( 'IF_LOSE' ).child( 'SEQUENCE' ).toXMLString() + '</EVENT>';

			// Get the source XML data from the current map			
			var sourceXML : XML = TinyMapManager.getInstance().currentMap.eventXML;
			
			// Create new true and false sequences
			newCommand.winSequence  = TinyEventSequence.newFromXML( new XML( xmlStringWin ), sourceXML, 'win_sequence' );
			newCommand.loseSequence = TinyEventSequence.newFromXML( new XML( xmlStringLose ), sourceXML, 'lose_sequence' );
			
			return newCommand;
		}
	}
}
