package com.tinyrpg.ui
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.display.TinyOneLineBox;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;	
	
	import flash.events.Event;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyStorageMonMenu extends TinyScrollableSelectList 
	{
		private var selectableMonItems 	: Array = [];
		private var selectedMonSubMenu 	: TinyMonSubMenu;
		private var instructionBox 		: TinyOneLineBox;
		private var confirmChoiceDialog : TinyTwoChoiceList;
		private var isInSubMenu 		: Boolean = false;
		private var isWithdraw 			: Boolean = false;
		private var numMons 			: uint = 0;
		
		public function TinyStorageMonMenu( monArray : Array, isWithdraw : Boolean = false ) : void
		{
			this.isWithdraw = isWithdraw;
			this.numMons = monArray.length;
			
			var newItemArray : Array = [];
			for each ( var mon : TinyMon in monArray )
			{	
				var newSelectableMonItem : TinySelectableItem = new TinySelectableItem( mon.name, newItemArray.length );
				newSelectableMonItem.customData = mon;
				this.selectableMonItems.push( newSelectableMonItem );
				newItemArray.push( newSelectableMonItem );
			}
			
			// Add cancel item
			newItemArray.push( new TinySelectableItem( TinyCommonStrings.CANCEL.toUpperCase(), newItemArray.length ) );
			
			super( '', newItemArray, 60, 64, 12, 6, 0, 6 );
			
			// Make the instruction box
			this.instructionBox = new TinyOneLineBox( TinyCommonStrings.CHOOSE_DKMN, 144 );
			this.instructionBox.x = -92 + 8;
			this.instructionBox.y = 130 - ( this.instructionBox.height / 2 );
			
			// Create the submenu
			this.selectedMonSubMenu = new TinyStorageMonSubMenu( this.isWithdraw );
			this.selectedMonSubMenu.x = 0;
			this.selectedMonSubMenu.y = 141 - 33 - 11 - 22;
			this.selectedMonSubMenu.visible = false;
			
			// Add 'em up
			this.addChild( this.instructionBox );
			this.addChild( this.selectedMonSubMenu );
		}
		
		
		override protected function onAccept( event : TinyInputEvent ) : void
		{
			super.onAccept( event );
			
			// Send cancel event if the cancel option is picked, otherwise show the submenu
			if ( this.selectedItem.textString.toUpperCase() == TinyCommonStrings.CANCEL.toUpperCase() )
			{
				this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );
			}
			else
			{
				this.showSubMenu();					
			}
		}
		
		
		private function showSubMenu() : void
		{
			TinyLogManager.log( 'showSubMenu', this );
			
			var selectedMon : TinyMon = this.selectedItem.customData as TinyMon;
			this.selectedMonSubMenu.currentMon = selectedMon;
			this.selectedMonSubMenu.show();
			
			// Transfer control to submenu
			this.isInSubMenu = true;
			this.selectedMonSubMenu.addEventListener( TinyInputEvent.ACCEPT, this.onSubMenuAccepted );
			this.selectedMonSubMenu.addEventListener( TinyInputEvent.CANCEL, this.onSubMenuCancelled );
			this.selectedMonSubMenu.addEventListener( TinyInputEvent.SELECTED, this.onSubMenuSelectionChanged );
			TinyInputManager.getInstance().setTarget( this.selectedMonSubMenu );
			
			// Show selected item as inactive-selected	
			this.selectedItem.autoSelected = true;
		}
		
		
		private function onSubMenuAccepted( event : TinyInputEvent ) : void
		{
			if ( !event.param ) return;
			
			TinyLogManager.log( 'onSubMenuAccepted', this );
			
			// If the player only has one mon, don't allow them to deposit it
			if ( !this.isWithdraw && this.numMons <= 1 )
			{
				this.instructionBox.text = "That's your last guy!";
				TinyAudioManager.play( TinyAudioManager.ERROR );
				return;
			}
			
			TinyAudioManager.play( TinyAudioManager.SELECT );
			
			this.removeSubMenu();
			
			var selectedMon : TinyMon = this.selectedItem.customData as TinyMon;
			this.instructionBox.text = ( this.isWithdraw ? 'Withdraw ' : 'Deposit ' ) + selectedMon.name + '?';
			
			var confirmChoiceItems : Array = [
				new TinySelectableItem( TinyCommonStrings.YES.toUpperCase(), 0 ),
				new TinySelectableItem( TinyCommonStrings.NO.toUpperCase(), 1 )
			];
			
			// Create the confirm choice dialog
			this.confirmChoiceDialog = new TinyTwoChoiceList( '', confirmChoiceItems, 32, 32, 15, 4 );
			this.confirmChoiceDialog.x = this.selectedMonSubMenu.x + 28;
			this.confirmChoiceDialog.y = this.selectedMonSubMenu.y;
			this.addChild( this.confirmChoiceDialog );
			
			// Pass control to the confirm choice dialog
			this.confirmChoiceDialog.addEventListener( TinyInputEvent.OPTION_ONE, this.onConfirmChoiceDialogAccepted );
			this.confirmChoiceDialog.addEventListener( TinyInputEvent.OPTION_TWO, this.onConfirmChoiceDialogCancelled );
			this.confirmChoiceDialog.addEventListener( TinyInputEvent.CANCEL, this.onConfirmChoiceDialogCancelled );
			this.confirmChoiceDialog.show();
			TinyInputManager.getInstance().setTarget( this.confirmChoiceDialog );
		}
		
		
		private function onSubMenuSelectionChanged( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onSubMenuSelectionChanged', this );
			this.instructionBox.text = TinyCommonStrings.CHOOSE_DKMN;
		}


		private function onSubMenuCancelled( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onSubMenuCancelled', this );
	
			this.removeSubMenu();
			this.instructionBox.text = TinyCommonStrings.CHOOSE_DKMN;
			
			// Restore active-selected state
			this.selectedItem.autoSelected = false;
			this.selectedItem.selected = true;
			
			// Return control
			TinyInputManager.getInstance().setTarget( this );
		}
		
		
		private function removeSubMenu() : void
		{
			TinyLogManager.log( 'removeSubMenu', this );
			
			// Hide submenu
			this.selectedMonSubMenu.hide();
			this.instructionBox.text = TinyCommonStrings.CHOOSE_DKMN;
			
			// Cleanup
			this.selectedMonSubMenu.removeEventListener( TinyInputEvent.ACCEPT, this.onSubMenuAccepted );
			this.selectedMonSubMenu.removeEventListener( TinyInputEvent.CANCEL, this.onSubMenuCancelled );
			this.selectedMonSubMenu.removeEventListener( TinyInputEvent.SELECTED, this.onSubMenuSelectionChanged );
			this.isInSubMenu = false;
		}
		
		
		private function onConfirmChoiceDialogAccepted( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onConfirmChoiceDialogAccepted', this );
			
			TinyAudioManager.play( TinyAudioManager.SELECT );
			
			this.removeConfirmDialog();
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		
		private function onConfirmChoiceDialogCancelled( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onConfirmChoiceDialogCancelled', this );
			
			this.removeConfirmDialog();
			this.instructionBox.text = TinyCommonStrings.CHOOSE_DKMN;
			
			// Restore active-selected state
			this.selectedItem.autoSelected = false;
			this.selectedItem.selected = true;
			
			// Return control to the sub menu
			this.showSubMenu();
		}
		
		
		private function removeConfirmDialog() : void
		{
			TinyLogManager.log( 'removeConfirmDialog', this );
			
			// Cleanup
			this.confirmChoiceDialog.removeEventListener( TinyInputEvent.OPTION_ONE, this.onConfirmChoiceDialogAccepted );
			this.confirmChoiceDialog.removeEventListener( TinyInputEvent.OPTION_TWO, this.onConfirmChoiceDialogCancelled );
			this.confirmChoiceDialog.removeEventListener( TinyInputEvent.CANCEL, this.onConfirmChoiceDialogCancelled );
			this.removeChild( this.confirmChoiceDialog );
			this.confirmChoiceDialog = null;
		}
	}
}