package com.tinyrpg.ui
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.events.Event;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyStorageFlow extends TinyBaseFlow  
	{	
		private var monMenu 		: TinyStorageMonMenu;
		private var transferDialog	: TinyDialogBox;
		private var isWithdraw 		: Boolean;
		
		public function TinyStorageFlow( isWithdraw : Boolean ) : void
		{
			this.isWithdraw = isWithdraw;
			
			var targetSquad : Array = this.isWithdraw ? TinyGameManager.getInstance().playerTrainer.squadInPC : TinyGameManager.getInstance().playerTrainer.squad; 
			
			this.monMenu = new TinyStorageMonMenu( targetSquad, this.isWithdraw );
			this.monMenu.x = 92;
			this.monMenu.y = 8;
			
			this.addChild( this.monMenu );
		}
		
		
		override public function execute() : void
		{
			TinyLogManager.log( 'execute', this );
			
			// Pass control to the mon menu
			this.monMenu.show();
			this.monMenu.addEventListener( Event.COMPLETE, this.onTransferRequested );
			this.monMenu.addEventListener( TinyInputEvent.CANCEL, this.onFlowComplete );
			TinyInputManager.getInstance().setTarget( this.monMenu );
		}
		
		
		private function onTransferRequested( event : Event ) : void
		{
			TinyLogManager.log( 'onTransferRequested', this );
			
			var selectedMon : TinyMon = this.monMenu.selectedItem.customData as TinyMon;
			
			// Perform the transfer
			if ( this.isWithdraw ) 
			{
				TinyLogManager.log( 'onTransferRequested: withdrawing' + selectedMon.name, this );
				
				// Add to trainer squad
				TinyGameManager.getInstance().playerTrainer.squad.push( selectedMon );
				
				// Remove from PC squad
				var indexInPC : uint = TinyGameManager.getInstance().playerTrainer.squadInPC.indexOf( selectedMon ); 
				TinyGameManager.getInstance().playerTrainer.squadInPC.removeAt( indexInPC );
			}
			else
			{
				TinyLogManager.log( 'onTransferRequested: depositing ' + selectedMon.name, this );
				
				// Add to PC squad
				TinyGameManager.getInstance().playerTrainer.squadInPC.push( selectedMon );
				
				// Remove from trainer squad
				var indexInTrainer : uint = TinyGameManager.getInstance().playerTrainer.squad.indexOf( selectedMon );
				TinyGameManager.getInstance().playerTrainer.squad.removeAt( indexInTrainer );
			}
			
			// Create the correct "transferring..." dialog string
			var transferString : String = 'Transferring ' + selectedMon.name + ' from ';
			
			if ( this.isWithdraw ) {
				transferString += "the Storage PC to [name]'s backpack."; 
			} else {
				transferString += "[name]'s backpack to the Storage PC.";
			}
			
			transferString += "[delay 8].[delay 8].[delay 8].[delay 8]. All done!   [end]";
			
			this.removeMonMenu();
			
			// Create the "transferring mon" dialog
			this.transferDialog = TinyDialogBox.newFromString( transferString );
			this.transferDialog.enableFastText = false;
			this.transferDialog.x = 8;
			this.transferDialog.y = 104;
			this.transferDialog.show();
			this.addChild( this.transferDialog );
			
			// Pass control to the transfer dialog
			this.transferDialog.addEventListener( Event.COMPLETE, this.onTransferDialogComplete );
			TinyInputManager.getInstance().setTarget( this.transferDialog );
		}
		
		
		private function onTransferDialogComplete( event : Event ) : void
		{
			TinyLogManager.log( 'onTransferRequested', this );
			
			// Remove control
			TinyInputManager.getInstance().setTarget( null );
			
			// Cleanup
			this.transferDialog.removeEventListener( Event.COMPLETE, this.onTransferDialogComplete );
			this.removeChild( this.transferDialog );
			this.transferDialog = null;
			
			// Done!
			this.onFlowComplete();
		}
		
		
		private function removeMonMenu() : void
		{
			if ( !this.monMenu ) return;
			
			TinyLogManager.log( 'removeMonMenu', this );
			
			// Cleanup
			this.monMenu.removeEventListener( Event.COMPLETE, this.onTransferRequested );
			this.monMenu.removeEventListener( TinyInputEvent.CANCEL, this.onFlowComplete );
			this.removeChild( this.monMenu );
			this.monMenu = null;
		}
		
		
		override protected function onFlowComplete( event : Event = null ) : void
		{
			this.removeMonMenu();
			super.onFlowComplete( event );
		}
	}
}