package com.tinyrpg.sequence
{
	import com.tinyrpg.core.TinyEventSequence;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.data.TinyItemDataList;
	import com.tinyrpg.lookup.TinyEventFlagLookup;
	import com.tinyrpg.lookup.TinyNameLookup;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.utils.TinyLogManager;
	
	/**
	 * Class which represents an "CONDITIONAL" command in the event sequencer.
	 * 
	 * This command immediately evaluates the truthy state of various kinds of parameters and runs
	 * a corresponding sub-sequence depending on the result. Valid XML parameter tags are:
	 * 
	 * 	TYPE: 		The type of conditional check to use. These are discussed more below.
	 * 	VALUE:		The truthy value for the conditional check.
	 * 	IF_TRUE:	The inline sub-sequence which will run if the conditional is true.
	 * 	IF_FALSE:	The inline sub-sequence which will run if the conditional is false.
	 * 
	 * Serval kinds of conditional checks can be chosen using the "TYPE" parameter tag. These are:
	 *  
	 *  FLAG: 		{@link TinyEventFlag} with the given name is set.
	 *  ITEM:		Player has an item with the given name. 
	 *  NAME:		Player's name matches the given string.
	 *  RIVAL:		Player's rival name matches the given string. 
	 *  MONEY:		Player has at least a given value of money.
	 *  FACING:	 	Player's sprite facing matches the given value.
	 *  HEALTHY: 	Player's mons are all in a healthy state.
	 *  
	 * @author jeremyabel
	 */
	public class TinyConditionalCommand 
	{
		public static const CONDITION_FLAG 		: String = 'FLAG';
		public static const CONDITION_ITEM		: String = 'ITEM';
		public static const CONDITION_NAME		: String = 'NAME';
		public static const CONDITION_RIVAL		: String = 'RIVAL';
		public static const CONDITION_MONEY		: String = 'MONEY';
		public static const CONDITION_FACING 	: String = 'FACING';
		public static const CONDITION_HEALTHY	: String = 'HEALTHY';
		
		public var conditionType	: String;
		public var conditionValue	: *;
		public var trueSequence		: TinyEventSequence;
		public var falseSequence	: TinyEventSequence;
		
		public function TinyConditionalCommand() : void { }
		
		/**
		 * Returns a new {@link TinyConditionalCommand} created from the given XML data.
		 */
		public static function newFromXML( xmlData : XML ) : TinyConditionalCommand
		{
			var newCommand : TinyConditionalCommand = new TinyConditionalCommand();
			
			// Get condition type
			newCommand.conditionType = xmlData.child( 'TYPE' ).toString().toUpperCase();
			
			// Get condition check value, if applicable
			switch( newCommand.conditionType )
			{
				case CONDITION_FLAG:	
				case CONDITION_ITEM:
				case CONDITION_NAME:
				case CONDITION_RIVAL:
				case CONDITION_FACING:
					newCommand.conditionValue = xmlData.child( 'VALUE' ).toString().toUpperCase();
					break;
				case CONDITION_MONEY:
					newCommand.conditionValue = uint( xmlData.child( 'VALUE' ).toString() );
					break; 
			}

			// Wrap the conditional sequences in an EVENT tag to create a new full event XML object
			var xmlStringTrue  : String = '<EVENT>' + xmlData.child( 'IF_TRUE'  ).child( 'SEQUENCE' ).toXMLString() + '</EVENT>';
			var xmlStringFalse : String = '<EVENT>' + xmlData.child( 'IF_FALSE' ).child( 'SEQUENCE' ).toXMLString() + '</EVENT>';

			// Get the source XML data from the current map			
			var sourceXML : XML = TinyMapManager.getInstance().currentMap.eventXML;
			
			// Create new true and false sequences
			newCommand.trueSequence  = TinyEventSequence.newFromXML( new XML( xmlStringTrue ), sourceXML, 'true_sequence' );
			newCommand.falseSequence = TinyEventSequence.newFromXML( new XML( xmlStringFalse ), sourceXML, 'false_sequence' );
			
			return newCommand;
		}
		
		public function execute() : TinyEventSequence
		{
			var isTruthy : Boolean = false;
			var player : TinyTrainer = TinyGameManager.getInstance().playerTrainer;
			
			switch ( this.conditionType )
			{
				case CONDITION_FLAG:
				{
					isTruthy = TinyEventFlagLookup.getInstance().getFlagByName( this.conditionValue ).value;
					
					TinyLogManager.log( 'executing condition = flag ' + this.conditionValue + ' is set: ' + isTruthy, this );
					break;
				}
				
				case CONDITION_ITEM:
				{
					isTruthy = player.hasItem( TinyItemDataList.getInstance().getItemByName( this.conditionValue ) );
					
					TinyLogManager.log( 'executing condition = has item ' + this.conditionValue + ': ' + isTruthy, this );
					break;
				}
				
				case CONDITION_NAME:
				{
					isTruthy = player.name.toUpperCase() == this.conditionValue;
					
					TinyLogManager.log( 'executing condition = is named ' + this.conditionValue + ': ' + isTruthy, this );
					break;
				}
				
				case CONDITION_RIVAL:
				{
					isTruthy = TinyNameLookup.getRivalNameForPlayerName( player.name ).toUpperCase() == this.conditionValue;
					
					TinyLogManager.log( 'executing condition = is rival ' + this.conditionValue + ': ' + isTruthy, this );
					break;
				}
				
				case CONDITION_MONEY:
				{
					isTruthy = player.money.value >= this.conditionValue;
					
					TinyLogManager.log( 'executing condition = has at least ' + this.conditionValue + ' bucks: ' + isTruthy, this );
					break;
				}
				
				case CONDITION_FACING:
				{
					isTruthy = TinyMapManager.getInstance().playerSprite.currentDirection.toUpperCase() == this.conditionValue;
					
					TinyLogManager.log( 'executing condition = player is facing ' + this.conditionValue + ': ' + isTruthy, this );
					break;
				}
				
				case CONDITION_HEALTHY:
				{
					isTruthy = player.hasAnyHealthyMons();
					
					TinyLogManager.log( 'executing condition = player is healthy: ' + isTruthy, this );
					break;
				}
			}
						
			if ( isTruthy ) return this.trueSequence;
			return this.falseSequence; 
		}
	}	
}
