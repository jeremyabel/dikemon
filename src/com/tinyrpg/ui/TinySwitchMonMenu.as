package com.tinyrpg.ui 
{
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.display.IShowHideObject;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.display.TinySelectableMonItem;
	import com.tinyrpg.display.TinyOneLineBox;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.events.TinyBattleEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.ui.TinySwitchMonSubMenu;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinySwitchMonMenu extends TinySelectList implements IShowHideObject 
	{
		private var trainer : TinyTrainer; 
		private var chooseInstructionBox : TinyOneLineBox;
		private var selectableMonItems : Array = [];
		private var selectedMonSubmenu : TinySwitchMonSubMenu;
		private var selectableCancelItem : TinySelectableItem;
		private var isInSubmenu : Boolean = false;
		private var isSwitchForced : Boolean = false;
		
		private const CANCEL_STRING : String = 'CANCEL';
		
		public function TinySwitchMonMenu( trainer : TinyTrainer ) 
		{
			super( '', null, 144, 130, 16, 6, 1 );
			
			this.trainer = trainer;
			
			// Add mons from trainer squad
			var newItemArray : Array = [];
			for each (var mon : TinyMon in this.trainer.squad)
			{	
				var newSelectableMonItem : TinySelectableMonItem = new TinySelectableMonItem( mon, newItemArray.length );
				this.selectableMonItems.push( newSelectableMonItem );
				newItemArray.push( newSelectableMonItem );
			}
			
			// Add cancel item
			this.selectableCancelItem = new TinySelectableItem( this.CANCEL_STRING, newItemArray.length); 
			newItemArray.push( this.selectableCancelItem );
			
			// Populate the list
			this.resetListItems( newItemArray );
			
			// Make "choose a dikémon" instruction box
			this.chooseInstructionBox = new TinyOneLineBox( 'Choose a DIKéMON.', 144 );
			this.chooseInstructionBox.y = 130 - (this.chooseInstructionBox.height / 2);
			
			// Make selected mon submenu
			this.selectedMonSubmenu = new TinySwitchMonSubMenu();
			this.selectedMonSubmenu.x = 130 - Math.floor(47 / 2) - 6;
			this.selectedMonSubmenu.y = 141 - 33 - 11;
			this.selectedMonSubmenu.visible = false;
			
			// Add 'em up
			this.addChild( this.chooseInstructionBox );
			this.addChild( this.selectedMonSubmenu );
		}

		public function show() : void
		{
			TinyLogManager.log("show", this);	
			
			// Update mon stat displays
			for each ( var selectableMonItem : TinySelectableMonItem in this.selectableMonItems )
			{
				selectableMonItem.update();
			}
			
			this.visible = true;
		}
		
		public function showForced() : void
		{
			TinyLogManager.log('showForced', this);
			
			// SHow only the selectable mons, without the cancel button
			this.resetListItems( this.selectableMonItems );
			
			this.isSwitchForced = true;
			this.isCancellable = true;
			this.show();
		}

		public function hide() : void
		{
			TinyLogManager.log("hide", this);
			
			this.visible = false;	
			this.isSwitchForced = false;
			this.isCancellable = true;
			
			// Restore the cancel button if it has been removed due to a forced switch 
			if ( this.isSwitchForced )
			{
				var newItemArray : Array = this.selectableMonItems.concat( [ this.selectableCancelItem ] );
				this.resetListItems( newItemArray ); 	
			}
		}
		
		override protected function onControlAdded(e : TinyInputEvent) : void
		{
			super.onControlAdded(e);
			
			// Reset selected item to the top if we're coming from the main battle menu
			if (!this.isInSubmenu && this.itemArray.length > 0)
			{
				this.setSelectedItemIndex(0);
			}
		}
		
		override protected function onAccept( e : TinyInputEvent ) : void
		{
			if (this.itemArray.length > 0) 
			{
				super.onAccept( e );
				
				// Send cancel event if the cancel option is picked, otherwise show the submenu
				if ( this.selectedItem.textString == this.CANCEL_STRING && this.isCancellable )
				{
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );
				}
				else
				{
					// Show selected mon submenu
					var selectedMon : TinyMon = (this.selectedItem as TinySelectableMonItem).mon;
					this.selectedMonSubmenu.currentMon = selectedMon;
					this.selectedMonSubmenu.show();
					
					// Transfer control to submenu
					this.isInSubmenu = true;
					this.selectedMonSubmenu.addEventListener( TinyBattleEvent.MON_SELECTED, this.onSubmenuAccepted );
					this.selectedMonSubmenu.addEventListener( TinyInputEvent.CANCEL, this.onSubmenuCancelled );	
					TinyInputManager.getInstance().setTarget( this.selectedMonSubmenu );
					
					// Show selected item as inactive-selected	
					this.selectedItem.autoSelected = true;
				}
			}
		}
		
		private function onSubmenuAccepted( event : TinyBattleEvent ) : void
		{	
			TinyLogManager.log('onSubmenuAccepted: ' + event.mon.name, this);
			this.isInSubmenu = false;
		
			// Hide submenu
			this.selectedMonSubmenu.hide();
			
			// Remove inactive-selected state
			this.selectedItem.autoSelected = false;
			
			// Dispatch selected mon event
			this.dispatchEvent( new TinyBattleEvent( TinyBattleEvent.MON_SELECTED, null, event.mon) );
		}

		private function onSubmenuCancelled( event : TinyInputEvent ) : void
		{
			TinyLogManager.log('onSubmenuCancelled', this);
			
			// Hide submenu
			this.selectedMonSubmenu.hide();
			
			// Restore active-selected state
			this.selectedItem.autoSelected = false;
			this.selectedItem.selected = true;
			
			// Return control
			this.selectedMonSubmenu.removeEventListener( TinyBattleEvent.MON_SELECTED, this.onSubmenuAccepted );
			this.selectedMonSubmenu.removeEventListener( TinyInputEvent.CANCEL, this.onSubmenuCancelled );
			TinyInputManager.getInstance().setTarget( this );	
			this.isInSubmenu = false;
		}
	}
	

	
}
