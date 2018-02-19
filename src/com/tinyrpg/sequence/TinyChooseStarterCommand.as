package com.tinyrpg.sequence
{
	import com.tinyrpg.core.TinyEventSequence;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.display.TinyContentBox;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.events.TinySequenceEvent;
	import com.tinyrpg.lookup.TinyMonLookup;
	import com.tinyrpg.lookup.TinyNameLookup;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.ui.TinyDialogBox;
	import com.tinyrpg.ui.TinyDialogSelectList;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyChooseStarterCommand extends EventDispatcher
	{
		public var mon						: TinyMon;
		public var monName					: String;
		public var monDisplayBox 			: TinyContentBox;
		public var monDescriptionDialog		: TinyDialogBox;
		public var confirmSelectDialog		: TinyDialogSelectList;
		public var yesSequence				: TinyEventSequence;
		public var noSequence				: TinyEventSequence;
		
		private var confirmChoiceOptions 	: Array = [];
		private var parentDisplay 			: Sprite; 
		
		public function TinyChooseStarterCommand() : void 
		{
			this.confirmChoiceOptions[ 0 ] = new TinySelectableItem( 'Yes', 0 );
			this.confirmChoiceOptions[ 1 ] = new TinySelectableItem( 'No', 1 );
		}
		
		public static function newFromXML( xmlData : XML ) : TinyChooseStarterCommand
		{
			var newCommand : TinyChooseStarterCommand = new TinyChooseStarterCommand();
			
			// Get the chosen mon's name
			newCommand.monName = xmlData.child( 'NAME' ).toString().toUpperCase();
			
			// Get the chosen mon
			if ( newCommand.monName == 'STARTER' )
			{
				var playerName : String = TinyGameManager.getInstance().playerTrainer.name;
				var starterName : String = TinyNameLookup.getStarterNameForPlayerName( playerName );
				newCommand.mon = TinyMonLookup.getInstance().getMonByHuman( starterName );
				newCommand.monName = starterName.toUpperCase();
			}
			else 
			{ 
				newCommand.mon = TinyMonLookup.getInstance().getMonByName( newCommand.monName );
			}	
			
			// Create the mon sprite display box
			newCommand.monDisplayBox = new TinyContentBox( newCommand.mon.bitmap, 60, 60, true );
			
			// Create the mon description dialog
			newCommand.monDescriptionDialog = TinyDialogBox.newFromString( 'This Dikémon is really [delay 4] ' + newCommand.mon.starterText + '!   [end]' );
			
			// Get the confirmation question string
			var confirmationString : String = 'Choose ' + newCommand.monName + '?'; 
			
			// Create the choice confirmation dialog
			newCommand.confirmSelectDialog = new TinyDialogSelectList( newCommand.confirmChoiceOptions, confirmationString, true, 32 );
			
			// Wrap the conditional sequences in an EVENT tag to create a new full event XML object
			var xmlStringYes : String = '<EVENT>' + xmlData.child( 'IF_YES' ).child( 'SEQUENCE' ).toXMLString() + '</EVENT>';
			var xmlStringNo  : String = '<EVENT>' + xmlData.child( 'IF_NO'  ).child( 'SEQUENCE' ).toXMLString() + '</EVENT>';

			// Get the source XML data from the current map			
			var sourceXML : XML = TinyMapManager.getInstance().currentMap.eventXML;
			
			// Create new true and false sequences
			newCommand.yesSequence = TinyEventSequence.newFromXML( new XML( xmlStringYes ), sourceXML, 'yes_sequence' );
			newCommand.noSequence = TinyEventSequence.newFromXML( new XML( xmlStringNo ), sourceXML, 'no_sequence' );
			
			return newCommand;
		}
		
		public function execute( parentDisplay : Sprite ) : void
		{
			TinyLogManager.log( 'execute', this );
			
			this.parentDisplay = parentDisplay;	
			
			// Position and show the mon sprite box
			this.monDisplayBox.x = ( 144 / 2 ) - ( 60 / 2 ) + 6;
			this.monDisplayBox.y = 22;
			this.parentDisplay.addChild( this.monDisplayBox );
			
			// Position and show the description dialog
			this.monDescriptionDialog.x = 8;
			this.monDescriptionDialog.y = 104;
			this.monDescriptionDialog.show();
			this.parentDisplay.addChild( this.monDescriptionDialog );
			
			// Pass control to the dialog
			TinyInputManager.getInstance().setTarget( this.monDescriptionDialog );
			
			// Wait for the dialog to be completed before continuing to the next item in the sequence			
			this.monDescriptionDialog.addEventListener( Event.COMPLETE, this.onDescriptionDialogComplete );
		}
		
		private function onDescriptionDialogComplete( event : Event ) : void
		{
			TinyLogManager.log( 'onDescriptionDialogComplete', this );
			
			// Clean up
			this.monDescriptionDialog.removeEventListener( Event.COMPLETE, this.onDescriptionDialogComplete );
			this.parentDisplay.removeChild( this.monDescriptionDialog );
			this.monDescriptionDialog = null;
			
			// Remove control from the dialog
			TinyInputManager.getInstance().setTarget( null );
			
			// Position and show the choice dialog
			this.confirmSelectDialog.x = 8;
			this.confirmSelectDialog.y = 104;
			this.confirmSelectDialog.show();
			this.parentDisplay.addChild( this.confirmSelectDialog );
			
			// Pass control to the dialog
			TinyInputManager.getInstance().setTarget( this.confirmSelectDialog );
			
			// Wait for the dialog to be completed before continuing to the next item in the sequence			
			this.confirmSelectDialog.addEventListener( TinyInputEvent.OPTION_ONE, this.onConfirmChoiceYes );
			this.confirmSelectDialog.addEventListener( TinyInputEvent.OPTION_TWO, this.onConfirmChoiceNo );
		}
		
		private function onConfirmChoiceYes( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onConfirmChoiceYes', this );
			
			this.onConfirmChoiceComplete();
			this.dispatchEvent( new TinySequenceEvent( TinySequenceEvent.CHOICE_COMPLETE, this.yesSequence ) );
		}
		
		private function onConfirmChoiceNo( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onConfirmChoiceNo', this );
			
			this.onConfirmChoiceComplete();
			this.dispatchEvent( new TinySequenceEvent( TinySequenceEvent.CHOICE_COMPLETE, this.noSequence ) );
		}
		
		private function onConfirmChoiceComplete() : void
		{
			// Remove control from the choice confirmation dialog
			TinyInputManager.getInstance().setTarget( null );
			
			// Cleanup
			this.confirmSelectDialog.removeEventListener( TinyInputEvent.OPTION_ONE, this.onConfirmChoiceYes );
			this.confirmSelectDialog.removeEventListener( TinyInputEvent.OPTION_TWO, this.onConfirmChoiceNo );
			this.parentDisplay.removeChild( this.confirmSelectDialog );
			this.parentDisplay.removeChild( this.monDisplayBox );
			this.confirmSelectDialog = null;
			this.monDisplayBox = null;
		}
	}
}
