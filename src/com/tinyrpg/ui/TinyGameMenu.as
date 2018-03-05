package com.tinyrpg.ui
{
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.events.TinyMenuEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.fscommand;

	public class TinyGameMenu extends Sprite
	{
		private var mainMenu 			: TinyGameMenuMainMenu;
		private var currentSubMenuFlow	: TinyGameMenuBaseFlow;
		
		
		public function TinyGameMenu() : void
		{
			this.mainMenu = new TinyGameMenuMainMenu();
			this.mainMenu.x = 160 - this.mainMenu.width + 2;
			this.mainMenu.y = 8;
			this.mainMenu.visible = false;
			
			this.mainMenu.addEventListener( TinyMenuEvent.MONS_SELECTED, this.onMonsSelected );
			this.mainMenu.addEventListener( TinyMenuEvent.ITEM_SELECTED, this.onItemSelected );
			this.mainMenu.addEventListener( TinyMenuEvent.SAVE_SELECTED, this.onSaveSelected );
			this.mainMenu.addEventListener( TinyMenuEvent.QUIT_SELECTED, this.onQuitSelected );
			this.mainMenu.addEventListener( TinyInputEvent.CANCEL, this.onCancel );
			
			// Add 'em up
			this.addChild( this.mainMenu );
			
			// Events
			this.addEventListener( TinyInputEvent.CONTROL_ADDED, onControlAdded );
		}
		
		
		private function onControlAdded( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onControlAdded', this );
			
			this.addEventListener( TinyInputEvent.CONTROL_REMOVED, this.onControlRemoved );
			this.removeEventListener( TinyInputEvent.CONTROL_ADDED, this.onControlAdded );
			
			this.mainMenu.show();
			
			// Give control to the main menu
			TinyInputManager.getInstance().setTarget( this.mainMenu );
		}
		

		private function onControlRemoved( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onControlRemoved', this );
			
			this.addEventListener( TinyInputEvent.CONTROL_ADDED, onControlAdded );
			this.removeEventListener( TinyInputEvent.CONTROL_REMOVED, onControlRemoved );
		}
		
		
		private function onMonsSelected( event : TinyMenuEvent ) : void
		{
			TinyLogManager.log( 'onMonsSelected', this );

			var monMenuFlow : TinyGameMenuMonsFlow = new TinyGameMenuMonsFlow();
			monMenuFlow.x = 8;
			monMenuFlow.y = 8;
			
			this.executeSubMenuFlow( monMenuFlow );
		}
		
		
		private function onItemSelected( event : TinyMenuEvent ) : void
		{
			TinyLogManager.log( 'onItemSelected', this );
			
			var itemsMenuFlow : TinyGameMenuItemsFlow = new TinyGameMenuItemsFlow();
			itemsMenuFlow.x = 8;
			itemsMenuFlow.y = 8;
			
			this.executeSubMenuFlow( itemsMenuFlow );
		}
		
		
		private function onSaveSelected( event : TinyMenuEvent ) : void
		{
			TinyLogManager.log( 'onSaveSelected', this );
			
			var saveMenuFlow : TinyGameMenuSaveFlow = new TinyGameMenuSaveFlow();
			saveMenuFlow.x = 8;
			saveMenuFlow.y = 8;
			
			this.executeSubMenuFlow( saveMenuFlow );
		}
		
		
		private function onQuitSelected( event : TinyMenuEvent ) : void
		{
			TinyLogManager.log( 'onQuitSelected', this );
			
			var quitMenuFlow : TinyGameMenuQuitFlow = new TinyGameMenuQuitFlow();
			quitMenuFlow.x = 8;
			quitMenuFlow.y = 104;
			
			this.executeSubMenuFlow( quitMenuFlow );
		}
		
		
		private function executeSubMenuFlow( flow : TinyGameMenuBaseFlow ) : void
		{
			TinyLogManager.log( 'executeSubMenuFlow', this );
			
			// Remove the existing submenu flow if there is one
			if ( this.currentSubMenuFlow ) 
			{
				this.onSubMenuFlowComplete( null );
			}
			
			this.currentSubMenuFlow = flow;
			this.currentSubMenuFlow.addEventListener( Event.COMPLETE, this.onSubMenuFlowComplete );
			
			this.addChild( this.currentSubMenuFlow );
			this.currentSubMenuFlow.execute();
		}
		
		
		private function onSubMenuFlowComplete( event : Event ) : void
		{
			TinyLogManager.log( 'onSubMenuFlowComplete', this );
			
			// Cleanup	
			this.removeChild( this.currentSubMenuFlow );
			this.currentSubMenuFlow.removeEventListener( Event.COMPLETE, this.onSubMenuFlowComplete );
			this.currentSubMenuFlow = null;
			
			// Give control back to the main menu
			TinyInputManager.getInstance().setTarget( this.mainMenu );
		}
	
	
		private function onCancel( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onCancel', this );
			
			this.mainMenu.hide();
			this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );
		}
	}
}
