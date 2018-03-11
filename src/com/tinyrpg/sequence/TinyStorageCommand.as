package com.tinyrpg.sequence
{
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.ui.TinySelectList;
	import com.tinyrpg.ui.TinyStorageFlow;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyStorageCommand extends Sprite
	{
		private var storageMenu			: TinySelectList;
		private var currentStorageFlow	: TinyStorageFlow;
		
		
		public function TinyStorageCommand() : void
		{
			var storageMenuItems : Array = [];
			storageMenuItems[ 0 ] = new TinySelectableItem( TinyCommonStrings.WITHDRAW.toUpperCase(), 0 );
			storageMenuItems[ 1 ] = new TinySelectableItem( TinyCommonStrings.DEPOSIT.toUpperCase(),  1 );
			storageMenuItems[ 2 ] = new TinySelectableItem( TinyCommonStrings.CANCEL.toUpperCase(),   2 );
			
			this.storageMenu = new TinySelectList( '', storageMenuItems, 60, 50 );
			this.storageMenu.x = 8;
			this.storageMenu.y = 8;
		}
		
		
		public function execute() : void
		{
			TinyInputManager.getInstance().setTarget( this.storageMenu );
			
			this.storageMenu.addEventListener( TinyInputEvent.ACCEPT, this.onStorageMenuAccepted );
			this.storageMenu.addEventListener( TinyInputEvent.CANCEL, this.onStorageMenuCancelled );
			
			// Add 'em up
			this.addChild( this.storageMenu );
			
			// Show just the storage menu
			this.storageMenu.show();
		}
		
		
		private function onStorageMenuAccepted( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onStorageMenuAccepted', this );
			
			this.storageMenu.hide();
			
			switch ( this.storageMenu.selectedItem.textString.toUpperCase() )
			{
				case TinyCommonStrings.WITHDRAW.toUpperCase():
					this.currentStorageFlow = new TinyStorageFlow( true );
					break;
					
				case TinyCommonStrings.DEPOSIT.toUpperCase():
					this.currentStorageFlow = new TinyStorageFlow( false );
					break;
					
				case TinyCommonStrings.CANCEL.toUpperCase():
					this.onStorageMenuCancelled( null );
					return;
			}
			
			this.currentStorageFlow.addEventListener( Event.COMPLETE, this.onStorageFlowComplete );
			this.currentStorageFlow.execute();
			this.addChild( this.currentStorageFlow );
		}
		
		
		private function onStorageFlowComplete( event : Event ) : void
		{
			TinyLogManager.log( 'onStorageFlowComplete', this );
			
			// Cleanup
			this.currentStorageFlow.removeEventListener( Event.COMPLETE, this.onStorageFlowComplete );
			this.removeChild( this.currentStorageFlow );
			this.currentStorageFlow = null;
			
			// Return control to the storage menu
			this.storageMenu.show();
			TinyInputManager.getInstance().setTarget( this.storageMenu );
		}
		
		
		private function onStorageMenuCancelled( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onStorageMenuCancelled', this );
			
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}