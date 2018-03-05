package com.tinyrpg.ui
{
	import com.greensock.TweenLite;
	
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.data.TinySaveData;
	import com.tinyrpg.display.TinyContentBox;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.events.Event;	
	import flash.text.TextField;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyGameMenuSaveFlow extends TinyGameMenuBaseFlow
	{
		private var confirmDialog 		: TinyDialogSelectList;
		private var saveCompleteDialog	: TinyDialogBox;
		private var statusTextField 	: TextField;
		private var statusBox 			: TinyContentBox;
		private var saveData 			: TinySaveData;
		
		
		public function TinyGameMenuSaveFlow() : void
		{
			var confirmOptions : Array = [ 
				new TinySelectableItem( TinyCommonStrings.YES.toUpperCase(), 0 ),
				new TinySelectableItem( TinyCommonStrings.NO.toUpperCase(), 1 )
			];
			
			// Create the choice confirmation dialog
			this.confirmDialog = new TinyDialogSelectList( confirmOptions, 'Save your game?', true, 32 );
			this.confirmDialog.cancelOptionEvent = TinyInputEvent.OPTION_TWO;
			this.confirmDialog.x = 0;
			this.confirmDialog.y = 104 - 8;
			
			// Make description text field
			this.statusTextField = TinyFontManager.returnTextField( 'left', false, true, true );
			this.statusTextField.width = 141;
			this.statusTextField.height = 20;
			this.statusTextField.y = -6;
			
			// Make description content box
			this.statusBox = new TinyContentBox( this.statusTextField, 144, 33 );
			this.statusBox.x = 0;
			this.statusBox.y = 104 - 8;
		}
		
		
		override public function execute() : void
		{
			TinyLogManager.log( 'execute', this );
			
			// Show the confirm dialog
			this.confirmDialog.show();
			this.addChild( this.confirmDialog );
			
			this.confirmDialog.addEventListener( TinyInputEvent.OPTION_ONE, this.onConfirmYes );
			this.confirmDialog.addEventListener( TinyInputEvent.OPTION_TWO, this.onConfirmNo );			 
			TinyInputManager.getInstance().setTarget( this.confirmDialog );
		}
		
		
		private function onConfirmYes( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onConfirmYes', this );
			
			this.removeConfirmDialog();
			
			// Show the status text box
			this.addChild( this.statusBox );
			this.statusTextField.htmlText = TinyFontManager.returnHtmlText( 'Saving game, please wait.', 'dialogText' );
			
			// Remove player control during saving
			TinyInputManager.getInstance().setTarget( null );
			
			// Create the save data and save it
			this.saveData = new TinySaveData();
			this.saveData.save();
			
			// Delay the completion a bit, otherwise it feels too fast
			TweenLite.delayedCall( 24, this.onSaveComplete, null, true );
		}
		
		
		private function onConfirmNo( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onConfirmNo', this );
			
			this.removeConfirmDialog();
			this.onFlowComplete( null );
		}
		
		
		private function removeConfirmDialog() : void
		{
			if ( !this.confirmDialog ) return;
			
			TinyLogManager.log( 'removeConfirmDialog', this );
				
			// Cleanup
			this.confirmDialog.removeEventListener( TinyInputEvent.OPTION_ONE, this.onConfirmYes );
			this.confirmDialog.removeEventListener( TinyInputEvent.OPTION_TWO, this.onConfirmNo );
			this.removeChild( this.confirmDialog );
			this.confirmDialog = null;
		}
		
		
		private function onSaveComplete() : void
		{
			TinyLogManager.log( 'onSaveComplete', this );
			
			// Cleanup
			this.removeChild( this.statusBox );
			this.saveData = null;
			
			// Create the "you saved the game" dialog
			this.saveCompleteDialog = TinyDialogBox.newFromString( '[name] saved the game.   [end]' );
			this.saveCompleteDialog.x = 0;
			this.saveCompleteDialog.y = 104 - 8;
			this.saveCompleteDialog.show();
			this.addChild( this.saveCompleteDialog );
			
			// When the "you saved the game" dialog is complete, control returns to the main menu.
			this.saveCompleteDialog.addEventListener( Event.COMPLETE, this.onSaveCompleteDialogComplete );
			TinyInputManager.getInstance().setTarget( this.saveCompleteDialog );
		}
		
		
		private function onSaveCompleteDialogComplete( event : Event ) : void
		{
			TinyLogManager.log( 'onSaveCompleteDialogComplete', this );
			
			// Cleanup
			this.saveCompleteDialog.removeEventListener( Event.COMPLETE, this.onSaveCompleteDialogComplete );
			this.removeChild( this.saveCompleteDialog );
			this.saveCompleteDialog = null;	
			
			// Done
			this.onFlowComplete();
		}
	}
}
