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
	 * @author jeremyabel
	 */
	public class TinyConditionalCommand 
	{
		public static const CONDITION_FLAG 	: String = 'FLAG';
		public static const CONDITION_ITEM	: String = 'ITEM';
		public static const CONDITION_NAME	: String = 'NAME';
		public static const CONDITION_RIVAL	: String = 'RIVAL';
		public static const CONDITION_MONEY	: String = 'MONEY';
		
		public var conditionType	: String;
		public var conditionValue	: *;
		public var trueSequence		: TinyEventSequence;
		public var falseSequence	: TinyEventSequence;
		
		public function TinyConditionalCommand() : void 
		{
			 
		}
		
		public static function newFromXML( xmlData : XML ) : TinyConditionalCommand
		{
			var newCommand : TinyConditionalCommand = new TinyConditionalCommand();
			
			// Get condition type
			newCommand.conditionType = xmlData.child( 'TYPE' ).toString().toUpperCase();
			
			// Get condition value
			switch( newCommand.conditionType )
			{
				default:
				case CONDITION_FLAG:	
				case CONDITION_ITEM:
				case CONDITION_NAME:
				case CONDITION_RIVAL:
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
			}
						
			if ( isTruthy ) return this.trueSequence;
			return this.falseSequence; 
		}
	}	
}
