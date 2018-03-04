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

//package com.tinyrpg.ui 
//{
//	import com.greensock.TweenLite;
//	import com.tinyrpg.core.TinyItem;
//	import com.tinyrpg.core.TinyPlayer;
//	import com.tinyrpg.core.TinyStatsEntity;
//	import com.tinyrpg.display.TinyOneLineBox;
//	import com.tinyrpg.display.TinyQuickStats;
//	import com.tinyrpg.events.TinyBattleEvent;
//	import com.tinyrpg.events.TinyInputEvent;
//	import com.tinyrpg.events.TinyMenuEvent;
//	import com.tinyrpg.managers.TinyAudioManager;
//	import com.tinyrpg.managers.TinyInputManager;
//	import com.tinyrpg.utils.TinyLogManager;
//	import com.tinyrpg.utils.TinyMath;
//
//	import flash.display.Sprite;
//	import flash.system.fscommand;
//
//	/**
//	 * @author jeremyabel
//	 */
//	public class TinyGameMenu extends Sprite 
//	{
//		public static var menuOneLiner	: TinyOneLineBox;
//		
//		private var itemToUse		: TinyItem;
//		private var itemTarget		: TinyStatsEntity;
//		private var statsTarget		: TinyStatsEntity;
//		private var menuMenu		: TinyGameMenuCommand;
//		private var menuInventory 	: TinyGameMenuInventory;
//		private var menuQuickStats	: TinyGameMenuQuickStats;
//		private var menuStats		: TinyGameMenuStats;
//		private var menuParty		: TinyGameMenuParty;
//		private var menuGPLine 		: TinySelectList;
//		private var menuSave		: TinySaveLoadMenu;
//
//		public function TinyGameMenu()
//		{
//			// Make new sub-menus
//			this.menuMenu 		= new TinyGameMenuCommand;
//			this.menuInventory 	= new TinyGameMenuInventory;
//			this.menuQuickStats	= new TinyGameMenuQuickStats;
//			this.menuStats 		= new TinyGameMenuStats;
//			this.menuParty		= new TinyGameMenuParty;
//			this.menuSave 		= new TinySaveLoadMenu(true);
//			TinyGameMenu.menuOneLiner = new TinyOneLineBox(null, 180, true);
//			
//			// Make gp box
//			var gpItem : TinySelectableItem = new TinySelectableItem(String('$' + TinyPlayer.getInstance().inventory.gold));
//			this.menuGPLine	= new TinySelectList('Bucks:', [gpItem], this.menuMenu.width - 6, 19, 15, 4);
//						
//			// Position stuff
//			this.menuMenu.x = (this.width - this.menuMenu.width) + 6;
//			this.menuMenu.y = TinyGameMenu.menuOneLiner.height - 1;
//			this.menuQuickStats.y = this.menuMenu.y;
//			this.menuGPLine.x = this.menuMenu.x;
//			this.menuGPLine.y = (this.menuMenu.y + this.menuMenu.height) - 1;
//			this.menuInventory.y = this.menuMenu.y;
//			this.menuStats.y = this.menuMenu.y;
//			this.menuParty.x = int(TinyGameMenu.menuOneLiner.width / 2);
//			this.menuParty.y = this.menuMenu.y;
//			//this.menuSave.x = int((320 / 2) - (this.menuSave.width / 2));
//			this.menuSave.y = this.menuMenu.y;
//						
//			// Hide stuff
//			this.hide();
//
//			// Add 'em up
//			this.addChild(TinyGameMenu.menuOneLiner);//			this.addChild(this.menuMenu);
//			this.addChild(this.menuQuickStats);//			this.addChild(this.menuGPLine);
//			this.addChild(this.menuInventory);
//			this.addChild(this.menuStats);//			this.addChild(this.menuParty);
//			this.addChild(this.menuSave);
//			
//			// Events
//			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
//		}
//		
//		public function show() : void
//		{
//			TinyLogManager.log('show', this);
//			
//			// Update GP line
//			var gpLineIndex : int = TinyMath.deepCopyInt(this.getChildIndex(this.menuGPLine));
//			this.removeChild(this.menuGPLine);
//			var gpItem : TinySelectableItem = new TinySelectableItem(String('$' + TinyPlayer.getInstance().inventory.gold));
//			this.menuGPLine	= new TinySelectList('Bucks:', [gpItem], this.menuMenu.width - 6, 19, 15, 4);
//			this.menuGPLine.x = this.menuMenu.x;
//			this.menuGPLine.y = (this.menuMenu.y + this.menuMenu.height) - 1;
//			this.addChildAt(this.menuGPLine, gpLineIndex);
//			
//			// Update quick stats
//			var quickStatsIndex : int = TinyMath.deepCopyInt(this.getChildIndex(this.menuQuickStats));//			this.removeChild(this.menuQuickStats);
//			this.menuQuickStats = new TinyGameMenuQuickStats();
//			this.menuQuickStats.y = this.menuMenu.y;
//			this.addChildAt(this.menuQuickStats, quickStatsIndex);
//			
//			// Update save menu
//			var saveIndex : int = TinyMath.deepCopyInt(this.getChildIndex(this.menuSave));
//			this.removeChild(this.menuSave);
//			this.menuSave = new TinySaveLoadMenu(true);
//			//this.menuSave.x = int((320 / 2) - (this.menuSave.width / 2));
//			this.menuSave.y = this.menuMenu.y;
//			this.addChildAt(this.menuSave, saveIndex);
//			this.menuSave.visible = false;
//			
//			// Show stuff			
//			this.menuMenu.visible = true;
//			this.menuQuickStats.visible = true;
//			this.menuGPLine.visible = true;
//			TinyGameMenu.menuOneLiner.visible = true;
//			
//			// Add event listeners
//			this.menuMenu.addEventListener(TinyMenuEvent.ITEM_SELECTED,   onItemSelected);//			this.menuMenu.addEventListener(TinyMenuEvent.STATS_SELECTED,  onStatsSelected);//			this.menuMenu.addEventListener(TinyMenuEvent.PARTY_SELECTED,  onPartySelected);
//			this.menuMenu.addEventListener(TinyMenuEvent.SAVE_SELECTED,   onSaveSelected);//			this.menuMenu.addEventListener(TinyMenuEvent.QUIT_SELECTED,   onQuitSelected);//			this.menuMenu.addEventListener(TinyInputEvent.CANCEL, 		  onCancel);
//		}
//		public function hide() : void
//		{
//			TinyLogManager.log('hide', this);
//					
//			this.menuMenu.visible = false;
//			this.menuQuickStats.visible = false;
//			this.menuGPLine.visible = false;
//			this.menuSave.visible = false;
//			this.menuSave.hide();
//			TinyGameMenu.menuOneLiner.visible = false;
//			
//			// Clean up
//			this.menuMenu.removeEventListener(TinyMenuEvent.ITEM_SELECTED,   onItemSelected);
//			this.menuMenu.removeEventListener(TinyMenuEvent.STATS_SELECTED,  onStatsSelected);
//			this.menuMenu.removeEventListener(TinyMenuEvent.PARTY_SELECTED,  onPartySelected);//			this.menuMenu.removeEventListener(TinyMenuEvent.SAVE_SELECTED, 	 onSaveSelected);
//			this.menuMenu.removeEventListener(TinyMenuEvent.QUIT_SELECTED,   onQuitSelected);
//			this.menuMenu.removeEventListener(TinyInputEvent.CANCEL,		 onCancel);
//		}
//
//		override public function get width() : Number
//		{
//			return 180;
//		}
//		
//		private function onControlAdded(e : TinyInputEvent) : void
//		{
//			TinyLogManager.log('onControlAdded', this);
//			
//			// Events
//			this.addEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
//			this.removeEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
//			
//			// Give control to command menu
//			TinyInputManager.getInstance().setTarget(this.menuMenu);
//		}
//
//		private function onControlRemoved(e : TinyInputEvent) : void
//		{
//			TinyLogManager.log('onControlRemoved', this);
//			
//			// Events
//			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
//			this.removeEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
//		}
//		
//		private function onItemSelected(event : TinyMenuEvent = null) : void 
//		{
//			// Update inventory
//			this.removeChild(this.menuInventory);
//			this.menuInventory = new TinyGameMenuInventory;
//			this.menuInventory.y = this.menuMenu.y;
//			this.addChild(this.menuInventory);
//			
//			TinyLogManager.log('onItemSelected', this);
//			TinyInputManager.getInstance().setTarget(this.menuInventory);
//			this.menuInventory.show();
//			this.menuInventory.addEventListener(TinyInputEvent.CANCEL, onInventoryCancel);//			this.menuInventory.addEventListener(TinyBattleEvent.ITEM_USED, onItemUsed);//		}
//
//		private function onItemUsed(event : TinyBattleEvent = null) : void 
//		{
//			if (event) {
//				this.itemToUse = event.item;
//			}
//			TinyLogManager.log('onItemUsed: ' + this.itemToUse.name, this);
//			
//			// Hide inventory
//			this.menuInventory.hide();
//			
//			// Pass control to party selector
//			TinyInputManager.getInstance().setTarget(this.menuQuickStats);
//			
//			// Events
//			this.menuQuickStats.addEventListener(TinyInputEvent.CANCEL, onItemUsedCancel);
//			this.menuQuickStats.addEventListener(TinyBattleEvent.ENEMY_SELECTED, onItemTargetSelected);
//			this.menuInventory.removeEventListener(TinyInputEvent.ACCEPT, onItemUsed);
//			this.menuInventory.removeEventListener(TinyInputEvent.CANCEL, onInventoryCancel);
//		}
//
//		private function onItemUsedCancel(event : TinyInputEvent) : void
//		{
//			TinyLogManager.log('onItemUsedCancel', this);
//			
//			// Back to the inventory
//			this.menuInventory.show();
//			TinyInputManager.getInstance().setTarget(this.menuInventory);
//			
//			// Events
//			this.menuQuickStats.removeEventListener(TinyInputEvent.CANCEL, onItemUsedCancel);
//			this.menuQuickStats.removeEventListener(TinyBattleEvent.ENEMY_SELECTED, onItemTargetSelected);
//			this.menuInventory.addEventListener(TinyInputEvent.CANCEL, onInventoryCancel);
//			this.menuInventory.addEventListener(TinyBattleEvent.ITEM_USED, onItemUsed);
//		}
//
//		private function onItemTargetSelected(event : TinyBattleEvent) : void 
//		{
//			this.itemTarget = event.defender;
//			TinyLogManager.log('onItemTargetSelected: ' + this.itemTarget.name, this);
//			
//			// Hooray, we finally use the item! ...Or can we?
//			if ((this.itemToUse.revive && !this.itemTarget.dead) || (this.itemTarget.dead && !this.itemToUse.revive)) {
//				// Play error sfx
//				TinyAudioManager.play(TinyAudioManager.ERROR);
//
//				// Can't revive a living player
//				TinyLogManager.log('CAN\'T USE THIS ITEM', this);
//				
//				// Go back to the selected phase
//				TinyInputManager.getInstance().setTarget(null);
//				this.onItemUsed();
//				return;
//			}
//		
//			// Apply item effects
//			var healAmount : int = int( this.itemTarget.stats.MHP * ( this.itemToUse.effectAmount / 100 ) );
//			this.itemTarget.stats.HP += healAmount;
//			
//			// Update QuickStats display
//			TinyQuickStats(this.menuQuickStats.selectedItem).update();
//			
//			// Remove item from inventory
//			TinyPlayer.getInstance().inventory.removeItem(this.itemToUse);
//		
//			// Remove item from inventory display
//			this.menuInventory.removeItem(this.itemToUse);
//			
//			// Play item sfx
//			TinyAudioManager.play(TinyAudioManager.HEAL_A);
//			
//			// Clean up
//			this.menuQuickStats.removeEventListener(TinyInputEvent.ACCEPT, onItemTargetSelected);
//			this.menuQuickStats.removeEventListener(TinyInputEvent.CANCEL, onItemUsedCancel);
//			
//			TweenLite.delayedCall(15, this.onItemSelected, null, true);
//		}
//
//		private function onInventoryCancel(event : TinyInputEvent) : void
//		{
//			TinyLogManager.log('onInventoryCancel', this);
//			
//			// Clean up and return control
//			this.menuInventory.removeEventListener(TinyInputEvent.CANCEL, onInventoryCancel);
//			this.menuInventory.hide();
//			TinyInputManager.getInstance().setTarget(this);
//		}
//
//		private function onStatsSelected(event : TinyMenuEvent = null) : void 
//		{
//			TinyLogManager.log('onStatsSelected', this);
//			
//			// Pass control to party selector
//			TinyInputManager.getInstance().setTarget(this.menuQuickStats);
//			
//			// Events
//			this.menuQuickStats.addEventListener(TinyInputEvent.CANCEL, onStatsTargetCancel);
//			this.menuQuickStats.addEventListener(TinyBattleEvent.ENEMY_SELECTED, onStatsTargetSelected);
//		}
//
//		private function onStatsTargetCancel(event : TinyInputEvent) : void 
//		{
//			TinyLogManager.log('onStatsTargetCancel', this);
//			
//			// Return control to the main menu
//			TinyInputManager.getInstance().setTarget(this.menuMenu);
//			
//			// Clean up
//			this.menuQuickStats.removeEventListener(TinyInputEvent.CANCEL, onStatsTargetCancel);
//			this.menuQuickStats.removeEventListener(TinyBattleEvent.ENEMY_SELECTED, onStatsTargetSelected);
//		}
//
//		private function onStatsTargetSelected(event : TinyBattleEvent) : void 
//		{
//			this.statsTarget = event.defender;
//			TinyLogManager.log('onStatsTargetSelected: ' + this.statsTarget.name, this);
//			
//			TinyInputManager.getInstance().setTarget(this.menuStats);
//			this.menuStats.showCharacter(this.statsTarget);
//			this.menuStats.addEventListener(TinyInputEvent.CANCEL, onStatsCancel);//		}
//
//		private function onStatsCancel(event : TinyInputEvent) : void
//		{
//			TinyLogManager.log('onStatsCanceled', this);
//			
//			// Return control to the target selector
//			this.menuStats.hide();
//			this.onStatsSelected();
//			
//			// Clean up
//			this.menuStats.removeEventListener(TinyInputEvent.CANCEL, onStatsCancel);
//			this.statsTarget = null;
//		}
//		
//		private function onPartySelected(event : TinyMenuEvent) : void
//		{
//			TinyLogManager.log('onPartySelected', this);
//			
//			// Update party menu
//			this.removeChild(this.menuParty);
//			this.menuParty = new TinyGameMenuParty;
//			this.menuParty.x = int(TinyGameMenu.menuOneLiner.width / 2);
//			this.menuParty.y = this.menuMenu.y;
//			this.addChild(this.menuParty);
//			
//			this.menuParty.show();
//			TinyInputManager.getInstance().setTarget(this.menuParty);
//			this.menuParty.addEventListener(TinyMenuEvent.PARTY_CHANGED, onPartyChanged);
//			this.menuParty.addEventListener(TinyInputEvent.CANCEL, onPartyCancel);
//		}
//
//		private function onPartyCancel(event : TinyInputEvent) : void 
//		{
//			TinyLogManager.log('onPartyCancel', this);
//			
//			this.menuParty.hide();
//			TinyInputManager.getInstance().setTarget(this);
//			
//			// Clean up
//			this.menuParty.removeEventListener(TinyMenuEvent.PARTY_CHANGED, onPartyChanged);
//			this.menuParty.removeEventListener(TinyInputEvent.CANCEL, onPartyCancel);
//		}
//
//		private function onPartyChanged(event : TinyMenuEvent) : void 
//		{
//			TinyLogManager.log('onPartyChanged', this);
//			
//			// Reset QuickStats
//			var quickStatsIndex : int = TinyMath.deepCopyInt(this.getChildIndex(this.menuQuickStats));
//			this.removeChild(this.menuQuickStats);
//			this.menuQuickStats = new TinyGameMenuQuickStats();
//			this.menuQuickStats.y = this.menuMenu.y;
//			this.addChildAt(this.menuQuickStats, quickStatsIndex);
//		}
//		
//		private function onSaveCancel(event : TinyInputEvent) : void 
//		{
//			TinyLogManager.log('onLoadCancel', this);
//			
//			// Give control back
//			TinyInputManager.getInstance().setTarget(this);
//				
//			// Clean up
//			this.menuSave.hide();
//			this.menuSave.removeEventListener(TinyInputEvent.CANCEL, onSaveCancel);
//		}
//		
//		private function onSaveSelected(event : TinyMenuEvent) : void 
//		{
//			TinyLogManager.log('onSaveSelected', this);
//			
//			this.menuSave.show();
//			TinyInputManager.getInstance().setTarget(this.menuSave);
//			
//			// Events
//			this.menuSave.addEventListener(TinyInputEvent.CANCEL, onSaveCancel);
//		}
//
//		private function onQuitSelected(event : TinyMenuEvent) : void 
//		{
//			TinyLogManager.log('onQuitSelected', this);
//			
//			// Quit projector app after a short delay
//			// TODO Maybe we should let the base class quit?
//			TweenLite.delayedCall(5, fscommand, ["Quit"], true);
//		}
//		
//		private function onCancel(event : TinyInputEvent) : void 
//		{
//			TinyLogManager.log('onCancel', this);
//			
//			// Tell stuff we've canceled out of the entire menu
//			this.dispatchEvent(new TinyInputEvent(TinyInputEvent.CANCEL));
//		}
//	}
//}
