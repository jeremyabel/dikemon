package com.tinyrpg.ui 
{
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.display.IShowHideObject;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.display.TinySelectableMonItem;
	import com.tinyrpg.display.TinyOneLineBox;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyMonMenu extends TinySelectList implements IShowHideObject 
	{
		protected var trainer : TinyTrainer; 
		protected var chooseInstructionBox : TinyOneLineBox;
		protected var selectableMonItems : Array = [];
		protected var selectedMonSubmenu : TinyMonSubMenu;
		protected var selectableCancelItem : TinySelectableItem;
		protected var isInSubmenu : Boolean = false;
		
		public function TinyMonMenu( trainer : TinyTrainer ) 
		{
			super( '', null, 144, 130, 16, 6, 1 );
			
			this.trainer = trainer;
			
			// Add mons from trainer squad
			var newItemArray : Array = [];
			for each ( var mon : TinyMon in this.trainer.squad )
			{	
				var newSelectableMonItem : TinySelectableMonItem = new TinySelectableMonItem( mon, newItemArray.length );
				this.selectableMonItems.push( newSelectableMonItem );
				newItemArray.push( newSelectableMonItem );
			}
			
			// Add cancel item
			this.selectableCancelItem = new TinySelectableItem( TinyCommonStrings.CANCEL, newItemArray.length ); 
			newItemArray.push( this.selectableCancelItem );
			
			// Populate the list
			this.resetListItems( newItemArray );
			
			// Make "choose a dikŽmon" instruction box
			this.chooseInstructionBox = new TinyOneLineBox( 'Choose a DIKƒMON.', 144 );
			this.chooseInstructionBox.y = 130 - ( this.chooseInstructionBox.height / 2 );
			
			// Add 'em up
			this.addChild( this.chooseInstructionBox );
			this.createSubMenu();
		}


		override public function show() : void
		{
			TinyLogManager.log( 'show', this );	
			
			// Update mon stat displays
			for each ( var selectableMonItem : TinySelectableMonItem in this.selectableMonItems )
			{
				selectableMonItem.update();
			}
			
			this.visible = true;
		}
		

		override public function hide() : void
		{
			TinyLogManager.log( 'hide', this );
			
			this.visible = false;	
		}
		
		
		override protected function onControlAdded( event : TinyInputEvent ) : void
		{
			super.onControlAdded( event );
			
			// Reset selected item to the top if we're coming from the main battle menu
			if ( !this.isInSubmenu && this.itemArray.length > 0 )
			{
				this.setSelectedItemIndex( 0 );
			}
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
		
		
		protected function showSubMenu() : void
		{
			TinyLogManager.log( 'showSubMenu', this );
			
			var selectedMon : TinyMon = ( this.selectedItem as TinySelectableMonItem ).mon;
			this.selectedMonSubmenu.currentMon = selectedMon;
			this.selectedMonSubmenu.show();
			
			// Transfer control to submenu
			this.isInSubmenu = true;
			this.selectedMonSubmenu.addEventListener( TinyInputEvent.CANCEL, this.onSubmenuCancelled );	
			TinyInputManager.getInstance().setTarget( this.selectedMonSubmenu );
			
			// Show selected item as inactive-selected	
			this.selectedItem.autoSelected = true;
		}
		
		
		protected function createSubMenu() : void
		{
			this.selectedMonSubmenu = new TinyMonSubMenu();
			this.selectedMonSubmenu.x = 130 - Math.floor( 47 / 2 ) - 6;
			this.selectedMonSubmenu.y = 141 - 33 - 11;
			this.selectedMonSubmenu.visible = false;
			
			this.addChild( this.selectedMonSubmenu );
		}


		protected function onSubmenuCancelled( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onSubmenuCancelled', this );
			
			// Hide submenu
			this.selectedMonSubmenu.hide();
			
			// Restore active-selected state
			this.selectedItem.autoSelected = false;
			this.selectedItem.selected = true;
			
			// Return control
			this.selectedMonSubmenu.removeEventListener( TinyInputEvent.CANCEL, this.onSubmenuCancelled );
			TinyInputManager.getInstance().setTarget( this );	
			this.isInSubmenu = false;
		}
	}
}
