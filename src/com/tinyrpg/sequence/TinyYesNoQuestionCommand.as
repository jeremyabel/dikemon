package com.tinyrpg.sequence
{
	import com.tinyrpg.core.TinyEventSequence;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.events.TinySequenceEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.ui.TinyDialogSelectList;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyYesNoQuestionCommand extends EventDispatcher
	{
		public var yesNoSelectDialog	: TinyDialogSelectList;
		public var yesSequence			: TinyEventSequence;
		public var noSequence			: TinyEventSequence;
		
		private var choiceOptions 		: Array = [];
		private var parentDisplay 		: Sprite; 
		
		public function TinyYesNoQuestionCommand() : void 
		{
			this.choiceOptions[ 0 ] = new TinySelectableItem( 'Yes', 0 );
			this.choiceOptions[ 1 ] = new TinySelectableItem( 'No', 1 );
		}
		
		public static function newFromXML( xmlData : XML ) : TinyYesNoQuestionCommand
		{
			var newCommand : TinyYesNoQuestionCommand = new TinyYesNoQuestionCommand();
			
			// Get the question string
			var questionString : String = xmlData.child( 'QUESTION' ).toString(); 
			
			// Create the choice confirmation dialog
			newCommand.yesNoSelectDialog = new TinyDialogSelectList( newCommand.choiceOptions, questionString, true, 32 );
			
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
			
			// Position and show the choice dialog
			this.yesNoSelectDialog.x = 8;
			this.yesNoSelectDialog.y = 104;
			this.yesNoSelectDialog.show();
			this.parentDisplay.addChild( this.yesNoSelectDialog );
			
			// Pass control to the dialog
			TinyInputManager.getInstance().setTarget( this.yesNoSelectDialog );
			
			// Wait for the dialog to be completed before continuing to the next item in the sequence			
			this.yesNoSelectDialog.addEventListener( TinyInputEvent.OPTION_ONE, this.onConfirmChoiceYes );
			this.yesNoSelectDialog.addEventListener( TinyInputEvent.OPTION_TWO, this.onConfirmChoiceNo );
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
			this.yesNoSelectDialog.removeEventListener( TinyInputEvent.OPTION_ONE, this.onConfirmChoiceYes );
			this.yesNoSelectDialog.removeEventListener( TinyInputEvent.OPTION_TWO, this.onConfirmChoiceNo );
			this.parentDisplay.removeChild( this.yesNoSelectDialog );
			this.yesNoSelectDialog = null;
		}
	}
}
