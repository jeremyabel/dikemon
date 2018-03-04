package com.tinyrpg.ui
{
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
			
			// Create the mon menu
			this.monMenu = new TinyUseItemMonMenu( TinyGameManager.getInstance().playerTrainer, this.item );
			this.addChild( this.monMenu );
			
			// Pass control to the mon menu
			this.monMenu.show();
			this.showingMonMenu = true;
			this.monMenu.addEventListener( TinyItemEvent.MON_FOR_ITEM_CHOSEN, this.onMonChosen );
			this.monMenu.addEventListener( TinyInputEvent.CANCEL, this.onMonMenuCancelled );
			TinyInputManager.getInstance().setTarget( this.monMenu );			 
			
			TinyLogManager.log( 'onItemRequiresMon: ' + this.item.name, this );
		}
		
		
		private function onMonChosen( event : TinyItemEvent ) : void
		{
			TinyLogManager.log( 'onMonChosen: ' + event.param.name, this );
			
			this.mon = event.param;
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
			
			this.usedItemDialog = TinyDialogBox.newFromString( '[name] used the ' + this.item.name + '!   [end]' );
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
			
			// Remove the item from the player's inventory
			TinyGameManager.getInstance().playerTrainer.removeItem( this.item );
			this.itemMenu.refreshItems();
			
			// Cleanup
			this.usedItemDialog.addEventListener( Event.COMPLETE, this.onUsedItemDialogComplete );
			this.removeChild( this.usedItemDialog );
			this.usedItemDialog = null;
			this.removeMonMenu();
			
			this.returnControlToItemMenu();			
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
