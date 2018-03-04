package com.tinyrpg.ui
{
	import com.greensock.TweenLite;
	
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.events.TinyItemEvent;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.events.Event;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyGameMenuItemsFlow extends TinyGameMenuBaseFlow
	{
		private var itemMenu 		: TinyItemMenu;
		private var usedItemDialog	: TinyDialogBox;
		private var itemResultDialog: TinyDialogBox;
		private var confirmDialog	: TinyDialogSelectList;
		private var monMenu			: TinyUseItemMonMenu;
		private var item 			: TinyItem;
		private var mon				: TinyMon;
		private var showingMonMenu	: Boolean = false;
		
		
		public function TinyGameMenuItemsFlow() : void
		{
			this.itemMenu = new TinyItemMenu( TinyGameManager.getInstance().playerTrainer );
			this.addChild( this.itemMenu );
		}
		
		
		override public function execute() : void
		{
			TinyLogManager.log( 'execute', this );
			
			// Pass control to the item menu
			this.itemMenu.show();
			this.itemMenu.addEventListener( TinyItemEvent.ITEM_USED, this.onItemUsed );
			this.itemMenu.addEventListener( TinyItemEvent.ITEM_REQUIRES_MON, this.onItemRequiresMon );
			this.itemMenu.addEventListener( TinyInputEvent.CANCEL, this.onFlowComplete );
			TinyInputManager.getInstance().setTarget( this.itemMenu );
		}
		
		
		private function onItemUsed( event : TinyItemEvent ) : void
		{
			this.item = event.param;
			
			TinyLogManager.log( 'onItemUsed: ' + this.item.name, this );
			
			this.itemMenu.setStickySelection();
			
			var confirmOptions : Array = [ 
				new TinySelectableItem( TinyCommonStrings.YES.toUpperCase(), 0 ),
				new TinySelectableItem( TinyCommonStrings.NO.toUpperCase(), 1 )
			];
			
			// Create the choice confirmation dialog
			this.confirmDialog = new TinyDialogSelectList( confirmOptions, 'Use ' + this.item.name + '?', true, 32 );
			this.confirmDialog.cancelOptionEvent = TinyInputEvent.OPTION_TWO;
			this.confirmDialog.x = 0;
			this.confirmDialog.y = 104 - 8;
			this.confirmDialog.show();
			this.addChild( this.confirmDialog );
			
			this.confirmDialog.addEventListener( TinyInputEvent.OPTION_ONE, this.onConfirmYes );
			this.confirmDialog.addEventListener( TinyInputEvent.OPTION_TWO, this.onConfirmNo );			 
			
			TinyInputManager.getInstance().setTarget( this.confirmDialog );
		}
		
		
		private function onItemRequiresMon( event : TinyItemEvent ) : void
		{
			this.item = event.param;
			
			TinyLogManager.log( 'onItemRequiresMon: ' + this.item.name, this );
			
			this.itemMenu.setStickySelection();
			
			// Create the mon menu
			this.monMenu = new TinyUseItemMonMenu( TinyGameManager.getInstance().playerTrainer, this.item );
			this.addChild( this.monMenu );
			
			// Pass control to the mon menu
			this.monMenu.show();
			this.showingMonMenu = true;
			this.monMenu.addEventListener( TinyItemEvent.MON_FOR_ITEM_CHOSEN, this.onMonChosen );
			this.monMenu.addEventListener( TinyInputEvent.CANCEL, this.onMonMenuCancelled );
			TinyInputManager.getInstance().setTarget( this.monMenu );			 
		}
		
		
		private function onMonChosen( event : TinyItemEvent ) : void
		{
			TinyLogManager.log( 'onMonChosen: ' + event.param.name, this );
			
			this.mon = event.param;
			this.onItemUsed( new TinyItemEvent( TinyItemEvent.ITEM_USED, this.item ) );
		}
		
		
		private function onMonMenuCancelled( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onMonMenuCancelled', this );
		
			this.removeMonMenu();			
			this.returnControlToItemMenu();
		}

		
		private function onConfirmYes( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onConfirmYes', this );
			
			this.removeConfirmDialog();
			
			// Create the "you used this item" dialog
			this.usedItemDialog = TinyDialogBox.newFromString( '[name] used the ' + this.item.name + '!    [end]' );
			this.usedItemDialog.x = 0;
			this.usedItemDialog.y = 104 - 8;
			this.usedItemDialog.show();
			this.addChild( this.usedItemDialog );
			
			// When the "used item" dialog is complete, control returns to the item list.
			this.usedItemDialog.addEventListener( Event.COMPLETE, this.onUsedItemDialogComplete );
			TinyInputManager.getInstance().setTarget( this.usedItemDialog );
		}
		
		
		private function onConfirmNo( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onConfirmNo', this );
			
			this.removeConfirmDialog();
			
			if ( this.showingMonMenu )
			{	
				this.mon = null;
				TinyInputManager.getInstance().setTarget( this.monMenu );					
			}
			else
			{
				this.returnControlToItemMenu();			
			}
		}
		
		
		private function onUsedItemDialogComplete( event : Event ) : void
		{
			TinyLogManager.log( 'onUsedItemDialogComplete', this );
			
			this.removeUsedItemDialog();
			
			// Use the item, which returns a string that says what the item did
			var itemResultString : String = this.item.useItem( this.mon );
			
			// Show the item results dialog, if required
			if ( itemResultString )
			{
				// Create the item results dialog
				this.itemResultDialog = TinyDialogBox.newFromString( itemResultString );
				this.itemResultDialog.x = 0;
				this.itemResultDialog.y = 104 - 8;
				this.itemResultDialog.show();
				this.addChild( this.itemResultDialog );
				
				// Update the selected mon to reflect any changes caused by using the item
				this.monMenu.refreshSelectedMon( true );
				
				// Add a delay before passing control to the dialog, otherwise it feels too fast
				TweenLite.delayedCall( 10, this.enableItemResultDialog, null, true );
			}
			else
			{
				this.onItemResultDialogComplete( null );		
			}
		}
		
		
		private function enableItemResultDialog() : void
		{
			TinyLogManager.log( 'enableItemResultDialog', this );
			
			this.itemResultDialog.addEventListener( Event.COMPLETE, this.onItemResultDialogComplete );
			TinyInputManager.getInstance().setTarget( this.itemResultDialog );
		}
		
		
		private function onItemResultDialogComplete( event : Event ) : void
		{
			TinyLogManager.log( 'onItemResultDialogComplete', this );
			
			// Delay removing the item results dialog, otherwise it feels too fast
			TweenLite.delayedCall( 13, this.onDelayedItemResultDialogComplete, null, true );
		}
		
		
		private function onDelayedItemResultDialogComplete() : void
		{
			TinyLogManager.log( 'onDelayedItemResultDialogComplete', this );
				
			// Remove the item from the player's inventory
			TinyGameManager.getInstance().playerTrainer.removeItem( this.item );
			this.itemMenu.refreshItems();
			
			// Cleanup
			if ( this.itemResultDialog )
			{
				this.itemResultDialog.removeEventListener( Event.COMPLETE, this.onItemResultDialogComplete );
				this.removeChild( this.itemResultDialog );
				this.itemResultDialog = null;
			}
			
			this.removeMonMenu();
			
			this.returnControlToItemMenu();
		}
		
		
		private function removeUsedItemDialog() : void
		{
			TinyLogManager.log( 'removeUsedItemDialog', this );
			
			// Cleanup
			this.usedItemDialog.removeEventListener( Event.COMPLETE, this.onUsedItemDialogComplete );
			this.removeChild( this.usedItemDialog );
			this.usedItemDialog = null;
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
		
		
		private function removeMonMenu() : void
		{
			if ( !this.monMenu ) return;
			
			TinyLogManager.log( 'removeMonMenu', this );
			
			// Cleanup
			this.monMenu.removeEventListener( TinyItemEvent.MON_FOR_ITEM_CHOSEN, this.onMonChosen );
			this.monMenu.removeEventListener( TinyInputEvent.CANCEL, this.onMonMenuCancelled );
			this.removeChild( this.monMenu );
			this.showingMonMenu = false;
			this.monMenu = null;
			this.mon = null;
		}
		
		
		private function returnControlToItemMenu() : void
		{
			TinyLogManager.log( 'returnControlToItemMenu', this );
			
			// Cleanup
			this.mon = null;
			this.item = null;
			
			TinyInputManager.getInstance().setTarget( this.itemMenu );
		}
		
		
		override protected function onFlowComplete( event : Event ) : void
		{
			// Cleanup
			this.itemMenu.removeEventListener( TinyItemEvent.ITEM_USED, this.onItemUsed );
			this.itemMenu.removeEventListener( TinyItemEvent.ITEM_REQUIRES_MON, this.onItemRequiresMon );
			this.itemMenu.removeEventListener( TinyInputEvent.CANCEL, this.onFlowComplete );
			
			super.onFlowComplete( event );
		}
	}
}
