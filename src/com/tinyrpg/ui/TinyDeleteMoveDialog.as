package com.tinyrpg.ui 
{
	import flash.display.Sprite;
	import flash.events.Event;

	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.battle.TinyBattleStrings;
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.display.IShowHideObject;
	import com.tinyrpg.events.TinyBattleEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * Class which handles the UI and flow for the dialogs and selection lists
	 * shown during the move-replacement process. 
	 * 
	 * This process is triggered when a mon learns a new move during a level-up,
	 * but already has all four moveslots filled. This class manages the flow of
	 * this process, allowing the player to remove a previous move and replace it
	 * with the new one, or discard the new move entirely.
	 *  
	 * @author jeremyabel
	 */
	public class TinyDeleteMoveDialog extends Sprite implements IShowHideObject
	{
		private var deleteMoveAskDialog 	: TinyDialogBox;
		private var chooseMoveAskDialog		: TinyDialogBox;
		private var deleteConfirmAskDialog	: TinyDialogBox;
		private var andItsGoneDialog		: TinyDialogBox;
		private var forgotMoveDialog 		: TinyDialogBox;
		private var stopLearningAskDialog 	: TinyDialogBox;
		private var didNotLearnDialog 		: TinyDialogBox;
		private var learnedMoveDialog		: TinyDialogBox;
		private var yesNoSelectList			: TinyYesNoSelectList;
		private var moveSelector			: TinyMoveSelectMenu;
		private var moveToDelete			: TinyMoveData;
		
		private var mon : TinyMon;
		private var move : TinyMoveData;
		
		/**
		 * @param	mon		The mon who's moves we'll be fiddling with.
		 * @param	move	The new move the mon is trying to learn.
		 */
		public function TinyDeleteMoveDialog( mon : TinyMon, move : TinyMoveData )
		{
			this.mon = mon;
			this.move = move;
			
			// Make "delete move?" dialog
			this.deleteMoveAskDialog = TinyDialogBox.newFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.DELETE_MOVE, this.mon, null, this.move ) );
			this.deleteMoveAskDialog.visible = false;
			
			// Make "choose move" dialog
			this.chooseMoveAskDialog = TinyDialogBox.newFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.CHOOSE_MOVE ) );
			this.chooseMoveAskDialog.visible = false;
			
			// Make "and it's gone" dialog
			this.andItsGoneDialog = TinyDialogBox.newFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.AND_ITS_GONE ) );
			this.andItsGoneDialog.visible = false;
			
			// Make "stop learning?" dialog
			this.stopLearningAskDialog = TinyDialogBox.newFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.STOP_LEARNING, this.mon, null, this.move ) );
			this.stopLearningAskDialog.visible = false;
			
			// Make "did not learn" dialog
			this.didNotLearnDialog = TinyDialogBox.newFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.DID_NOT_LEARN, this.mon, null, this.move ) );
			this.didNotLearnDialog.visible = false;
			
			// Make "learned move" dialog
			this.learnedMoveDialog = TinyDialogBox.newFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.LEARNED_MOVE, this.mon, null, this.move ) );
			this.learnedMoveDialog.visible = false;
			
			// Make yes / no select list
			this.yesNoSelectList = new TinyYesNoSelectList();
			this.yesNoSelectList.visible = true;
			this.yesNoSelectList.x = this.deleteMoveAskDialog.width - this.yesNoSelectList.width;
			this.yesNoSelectList.y = -this.yesNoSelectList.height + 4;
			
			// Make move selection menu
			this.moveSelector = new TinyMoveSelectMenu( this.mon, false );
			this.moveSelector.visible = false;
			this.moveSelector.x = this.deleteMoveAskDialog.width - 94;
			this.moveSelector.y = -this.moveSelector.height + 4;
			
			// Add 'em up
			this.addChild( this.deleteMoveAskDialog );
			this.addChild( this.chooseMoveAskDialog );
			this.addChild( this.andItsGoneDialog );
			this.addChild( this.stopLearningAskDialog );
			this.addChild( this.didNotLearnDialog );
			this.addChild( this.learnedMoveDialog );
			this.addChild( this.yesNoSelectList );
			this.addChild( this.moveSelector );
		}

		public function hide() : void
		{
			TinyLogManager.log('hide', this);
			this.visible = false;
		}
		
		/**
		 * Shows the first dialog and starts the interaction flow.
		 * 
		 * The first dialog is a regular dialog that asks if the player wants to delete a move to 
		 * make room for a new one. 
		 */
		public function show() : void
		{
			TinyLogManager.log('show', this);
			this.visible = true;
			
			// Show "delete move?" dialog
			this.deleteMoveAskDialog.show();
			
			// Pass control to "delete move?" dialog
			this.deleteMoveAskDialog.addEventListener( Event.COMPLETE, this.onDeleteMoveAskDialogCompleted );
			TinyInputManager.getInstance().setTarget( this.deleteMoveAskDialog );
		}

		/**
		 * Listener called when the "delete move?" dialog is done drawing in.
		 * 
		 * After this is done, the yes / no selection list is shown. 
		 */
		private function onDeleteMoveAskDialogCompleted( event : Event = null ) : void
		{
			TinyLogManager.log('onDeleteMoveAskDialogCompleted', this);
			
			// Clean up
			this.deleteMoveAskDialog.removeEventListener( Event.COMPLETE, this.onDeleteMoveAskDialogCompleted );
			TinyInputManager.getInstance().setTarget( null );
			
			// Show yes / no selector			
			this.yesNoSelectList.show();
			
			// Pass control to yes / no selector	
			this.passControlToYesNoSelector( this.onDeleteMoveYesSelected, this.onDeleteMoveNoSelected );
		}

		/**
		 * Listener for selecting "yes" on the "delete move?" prompt.
		 * 
		 * After "yes" is selected, the player can choose a move to replace. 
		 */
		private function onDeleteMoveYesSelected( event : Event = null ) : void
		{
			TinyLogManager.log('onDeleteMoveYesSelected', this);
			
			// Clean up
			this.cleanYesNoSelector( this.onDeleteMoveYesSelected, this.onDeleteMoveNoSelected );
			this.yesNoSelectList.hide();
			this.deleteMoveAskDialog.hide();
			
			// Show "choose move" dialog
			this.chooseMoveAskDialog.show();
			
			// Pass control to "choose move" dialog
			this.chooseMoveAskDialog.addEventListener( Event.COMPLETE, this.onChooseMoveAskDialogCompleted );
			TinyInputManager.getInstance().setTarget( this.chooseMoveAskDialog );
		}
		
		/**
		 * Listener for selecting "no" on the "delete move?" prompt.
		 * 
		 * After "no" is selected, the player must verify whether or not they really want 
		 * to stop learning the move.
		 */
		private function onDeleteMoveNoSelected( event : TinyInputEvent = null ) : void
		{
			TinyLogManager.log('onDeleteMoveNoSelected', this);
			
			// Clean up
			this.cleanYesNoSelector( this.onDeleteMoveYesSelected, this.onDeleteMoveNoSelected );
			this.yesNoSelectList.hide();
			this.deleteMoveAskDialog.hide();
			
			// Show "stop learning?" dialog
			this.stopLearningAskDialog.show();
			
			// Pass control to "stop learning?" dialog
			this.stopLearningAskDialog.addEventListener( Event.COMPLETE, this.onStopLearningAskDialogCompleted );
			TinyInputManager.getInstance().setTarget( this.stopLearningAskDialog );
		}
	
		/**
		 * Listener called when the "stop learning?" dialog is done drawing in.
		 * 
		 * After this is done, the yes / no selection list is shown. 
		 */
		private function onStopLearningAskDialogCompleted( event : Event = null ) : void
		{
			TinyLogManager.log('onStopLearningAskDialogCompleted', this);
			
			// Clean up
			this.stopLearningAskDialog.removeEventListener( Event.COMPLETE, this.onStopLearningAskDialogCompleted );
			TinyInputManager.getInstance().setTarget( null );
			
			// Show yes / no selector
			this.yesNoSelectList.show();
			
			// Pass control to yes / no selector
			this.passControlToYesNoSelector( this.onStopLearningYesSelected, this.onStopLearningNoSelected );	
		}
		
		/**
		 * Listener for selecting "yes" on the "stop learning?" prompt.
		 * 
		 * After "yes" is selected, the "didn't learn" dialog is shown, and the level-up process
		 * continues as normal.
		 */
		private function onStopLearningYesSelected( event : Event = null ) : void
		{
			TinyLogManager.log('onStopLearningYesSelected', this);
			
			// Clean up
			this.cleanYesNoSelector( this.onStopLearningYesSelected, this.onStopLearningNoSelected );	
			this.yesNoSelectList.hide();
			this.stopLearningAskDialog.hide();
			
			// Show "didn't learn" dialog
			this.didNotLearnDialog.show();
			
			// Pass control to "didn't learn" dialog
			this.didNotLearnDialog.addEventListener( Event.COMPLETE, this.onDidntLearnDialogCompleted );
			TinyInputManager.getInstance().setTarget( this.didNotLearnDialog );
		}
				
		/**
		 * Listener for when the "did not learn" dialog is done drawing in.
		 * 
		 * This marks the end of the flow if the player rejects learing the move.
		 * After this, control is returned to the level-up sequence and the game 
		 * proceeds normally. 
		 */
		private function onDidntLearnDialogCompleted( event : Event = null ) : void
		{
			TinyLogManager.log('onDidntLearnDialogCompleted', this);
			
			// Clean up
			this.didNotLearnDialog.removeEventListener( Event.COMPLETE, this.onDidntLearnDialogCompleted );
			this.didNotLearnDialog.hide();
			TinyInputManager.getInstance().setTarget( null );

			// Finished			
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}

		/**
		 * Listener for selecting "no" after the "stop learning?" prompt.
		 * 
		 * After "no" is selected, the "delete move" flow is restarted from the beginning.
		 */
		private function onStopLearningNoSelected( event : TinyInputEvent = null ) : void
		{
			TinyLogManager.log('onStopLearningNoSelected', this);
			
			// Clean up
			this.cleanYesNoSelector( this.onStopLearningYesSelected, this.onStopLearningNoSelected );	
			this.yesNoSelectList.hide();
			this.stopLearningAskDialog.hide();
						
			// Return to start
			this.show();
		}
		
		/** 
		 * Listener called when the "choose a move" dialog is done drawing in.
		 * 
		 * The move selection dialog is shown and control is passed to it. 
		 */
		private function onChooseMoveAskDialogCompleted( event : Event = null ) : void
		{
			TinyLogManager.log('onChooseMoveAskDialogCompleted', this);
			
			// Clean up
			this.chooseMoveAskDialog.removeEventListener( Event.COMPLETE, this.onChooseMoveAskDialogCompleted );
			TinyInputManager.getInstance().setTarget( null );

			// Show the move selection menu
			this.moveSelector.setCurrentMon( this.mon );
			this.moveSelector.show();
					
			// Pass control to the move selector
			this.moveSelector.addEventListener( TinyBattleEvent.MOVE_SELECTED, this.onChooseMoveMoveChosen );
			this.moveSelector.addEventListener( TinyInputEvent.CANCEL, this.onChooseMoveCancelled );
			TinyInputManager.getInstance().setTarget( this.moveSelector );
		}
		
		/**
		 * Listener called when the move to replace has been chosen.
		 * 
		 * After picking a move, the user must confirm this with another yes / no prompt.
		 */
		private function onChooseMoveMoveChosen( event : TinyBattleEvent ) : void
		{
			TinyLogManager.log('onChooseMoveMoveChosen: ' + event.move, this );
			
			// Save the move that is to be replaced
			this.moveToDelete = event.move;
			
			// Clean up
			this.moveSelector.removeEventListener( TinyBattleEvent.MOVE_SELECTED, this.onChooseMoveMoveChosen );
			this.moveSelector.removeEventListener( TinyInputEvent.CANCEL, this.onChooseMoveCancelled );
			this.moveSelector.hide();
			this.chooseMoveAskDialog.hide();
			TinyInputManager.getInstance().setTarget( null );
			
			// Make "forgot move" dialog
			this.forgotMoveDialog = TinyDialogBox.newFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.DELETED_MOVE, this.mon, null, this.moveToDelete ) );
			this.forgotMoveDialog.visible = false;
			
			// Make "you sure?" dialog
			this.deleteConfirmAskDialog = TinyDialogBox.newFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.CONFIRM_DELETE, this.mon, null, this.moveToDelete ) );
			this.deleteConfirmAskDialog.visible = false;
			
			// Add 'em up (below the yes / no window)
			this.addChildAt( this.forgotMoveDialog, 0 );
			this.addChildAt( this.deleteConfirmAskDialog, 0 );
			
			// Show "you sure?" dialog
			this.deleteConfirmAskDialog.show();
			
			// Pass control to "you sure?" dialog
			this.deleteConfirmAskDialog.addEventListener( Event.COMPLETE, this.onConfirmDeleteAskDialogCompleted );
			TinyInputManager.getInstance().setTarget( this.deleteConfirmAskDialog );
		}
		
		/**
		 * Listener for pressing the cancel button when prompted to choose a move to replace.
		 * 
		 * After the cancel button is pressed, the "delete move" flow is restarted from the beginning.
		 */
		private function onChooseMoveCancelled( event : TinyInputEvent = null ) : void
		{
			TinyLogManager.log('onChooseMoveCancelled', this);
			
			// Clean up
			this.moveSelector.removeEventListener( TinyBattleEvent.MOVE_SELECTED, this.onChooseMoveMoveChosen );
			this.moveSelector.removeEventListener( TinyInputEvent.CANCEL, this.onChooseMoveCancelled );
			this.moveSelector.hide();
			this.chooseMoveAskDialog.hide();
			
			// Return to start
			this.show();
		}
		
		/** 
		 * Listener called when the "you sure?" dialog is done drawing in.
		 * 
		 * The yes / no prompt is shown and the player must confirm whether or not to replace the 
		 * previously-selected move. 
		 */
		private function onConfirmDeleteAskDialogCompleted( event : Event = null ) : void
		{
			TinyLogManager.log('onConfirmDeleteAskDialogCompleted', this);
			
			// Clean up
			this.deleteConfirmAskDialog.removeEventListener( Event.COMPLETE, this.onConfirmDeleteAskDialogCompleted );
			TinyInputManager.getInstance().setTarget( null );
			
			// Show yes / no selector
			this.yesNoSelectList.show();
			
			// Pass control to yes / no selector
			this.passControlToYesNoSelector( this.onConfirmDeleteYesSelected, this.onConfirmDeleteNoSelected );	
		}

		/**
		 * Listener called when "yes" is selected after choosing a move to replace.
		 * 
		 * A series of dialogs is then shown to illustrate the move replacement process.
		 * The first of these is an "and it's gone" message. 
		 */
		private function onConfirmDeleteYesSelected( event : Event = null ) : void
		{
			TinyLogManager.log('onConfirmDeleteYesSelected', this);
			
			// Clean up
			this.removeChild( this.deleteConfirmAskDialog );
			this.cleanYesNoSelector( this.onConfirmDeleteYesSelected, this.onConfirmDeleteNoSelected );	
			this.yesNoSelectList.hide();
			this.deleteConfirmAskDialog.hide();
			
			// Show "and it's gone" dialog
			this.andItsGoneDialog.show();
			
			// Pass control to "and it's gone" dialog
			this.andItsGoneDialog.addEventListener( Event.COMPLETE, this.onAndItsGoneDialogCompleted );
			TinyInputManager.getInstance().setTarget( this.andItsGoneDialog );
		}
		
		/**
		 * Listener called when "no" is selected after chosing a move to replace.
		 * 
		 * After "no" is selected, the "delete move" flow is restarted from the beginning.
		 */
		private function onConfirmDeleteNoSelected( event : TinyInputEvent = null ) : void
		{
			TinyLogManager.log('onConfirmDeleteNoSelected', this);
			
			// Clean up
			this.removeChild( this.deleteConfirmAskDialog );
			this.cleanYesNoSelector( this.onConfirmDeleteYesSelected, this.onConfirmDeleteNoSelected );	
			this.yesNoSelectList.hide();
			this.deleteConfirmAskDialog.hide();
			
			// Return to start
			this.show();	
		}

		/**
		 * Listener for when the "and it's gone" dialog is done drawing in.
		 * 
		 * After this is done, the second dialog in the sequence is shown, alerting the player of the 
		 * forgotten move.
		 */
		private function onAndItsGoneDialogCompleted( event : Event = null ) : void
		{
			TinyLogManager.log('onAndItsGoneDialogCompleted', this);
			
			// Clean up
			this.andItsGoneDialog.removeEventListener( Event.COMPLETE, this.onAndItsGoneDialogCompleted );
			this.andItsGoneDialog.hide();
			TinyInputManager.getInstance().setTarget( null );
				
			// Show "mon forgot" dialog
			this.forgotMoveDialog.show();
			
			// Pass control to "mon forgot" dialog
			this.forgotMoveDialog.addEventListener( Event.COMPLETE, this.onMonForgotDialogCompleted );
			TinyInputManager.getInstance().setTarget( this.forgotMoveDialog );
		}

		/**
		 * Listener for when the "mon forgot" dialog is done drawing in.
		 * 
		 * After this is done, the third dialog in the sequence is shown, alerting the player of the
		 * newly-learned move. 
		 */
		private function onMonForgotDialogCompleted( event : Event = null ) : void
		{
			TinyLogManager.log('onMonForgotDialogCompleted', this);
			
			this.forgotMoveDialog.removeEventListener( Event.COMPLETE, this.onMonForgotDialogCompleted );
			this.forgotMoveDialog.hide();
			this.removeChild( this.forgotMoveDialog );
			TinyInputManager.getInstance().setTarget( null );
			
			// Show "mon learned" dialog
			this.learnedMoveDialog.show();
			
			// Pass control to "mon learned" dialog
			this.learnedMoveDialog.addEventListener( Event.COMPLETE, this.onMonLearnedDialogCompleted );
			TinyInputManager.getInstance().setTarget( this.learnedMoveDialog );
		}
		
		/**
		 * Listener for when the "mon learned" dialog is done drawing in.
		 * 
		 * After this is done, the move replacement is complete and the flow is complete.
		 * Control is returned to the leve-up sequence and the game proceeds normally.
		 */
		private function onMonLearnedDialogCompleted( event : Event = null ) : void
		{
			TinyLogManager.log('onMonLearnedDialogCompleted', this);
			
			// Clean up
			this.learnedMoveDialog.removeEventListener( Event.COMPLETE, this.onMonLearnedDialogCompleted );	
			this.learnedMoveDialog.hide();
			TinyInputManager.getInstance().setTarget( null );
			
			// Replace old move with new move
			var replacementSlot : int = this.mon.moveSet.getSlotWithMove( this.moveToDelete );
			if ( replacementSlot > -1 )
			{
				this.mon.moveSet.setMoveInSlot( this.move, replacementSlot ); 
			}
			
			// Finished
			this.dispatchEvent( new Event( Event.COMPLETE ) );	
		}
		
		/**
		 * Binds the given two event listeners to the yes / no selection list and passes control to it.
		 */
		private function passControlToYesNoSelector( yesCallback : Function, noCallback : Function ) : void
		{
			TinyLogManager.log('passControlToYesNoSelector', this);
			
			this.yesNoSelectList.addEventListener( Event.COMPLETE, yesCallback );
			this.yesNoSelectList.addEventListener( TinyInputEvent.CANCEL, noCallback );
			TinyInputManager.getInstance().setTarget( this.yesNoSelectList );
		}
		
		/**
		 * Unbinds the given two event listeners from the yes / no selection list and removes control from it.
		 */
		private function cleanYesNoSelector( yesCallback : Function, noCallback : Function ) : void
		{
			TinyLogManager.log('cleanYesNoSelector', this);
			
			this.yesNoSelectList.removeEventListener( Event.COMPLETE, yesCallback );
			this.yesNoSelectList.removeEventListener( TinyInputEvent.CANCEL, noCallback );
			TinyInputManager.getInstance().setTarget( null );		
		}
	}
}
