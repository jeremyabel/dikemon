package com.tinyrpg.ui 
{
	import com.greensock.TweenLite;
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyPlayer;
	import com.tinyrpg.display.TinyOneLineBox;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyBattleEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.events.TinyItemEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleItemGetBox extends Sprite 
	{
		private var targetItem			: TinyItem;
		private var discardedItem		: TinyItem;
		private var getItemBox			: TinyOneLineBox;
		private var cantHoldBox			: TinyOneLineBox;
		private var itemDiscardedBox 	: TinyOneLineBox;
		private var discardBox			: TinyDialogSelectList;
		private var inventoryList		: TinyGameMenuInventory;
		
		// Event checks
		private var showingCantHold 	 : Boolean = false;
		private var showingItemDiscarded : Boolean = false;
		
		/*
		 * TODO THIS CLASS IS PRETTY HACKY... 
		 */
		public function TinyBattleItemGetBox(item : TinyItem, inBattle : Boolean = true) : void
		{
			// Set properties
			this.targetItem = item;
			
			// Get item box
			var getItemText : String = inBattle ? 'You found 1 ' + this.targetItem.name + ' inside the enemy!' : 'You got 1 ' + this.targetItem.name +'!';
			this.getItemBox = new TinyOneLineBox(getItemText);
			
			// Can't hold this much box
			this.cantHoldBox = new TinyOneLineBox('...But you\'re already carrying too much!');
			
			// Item discarded box
			this.itemDiscardedBox = new TinyOneLineBox('You discarded the ' + this.targetItem.name + '.');
			
			// Discard question box
			var discardChoices : Array = [];
			discardChoices.push(new TinySelectableItem('Yes', 0));			discardChoices.push(new TinySelectableItem('No', 1));
			this.discardBox = new TinyDialogSelectList(discardChoices, 'Discard an item to make room?', true, 30, '', 288, 13);
			
			// Inventory menu
			this.inventoryList = new TinyGameMenuInventory(true);
			this.inventoryList.y = this.cantHoldBox.height;
			
			// Hide things
			this.cantHoldBox.hide();
			this.discardBox.hide();
			this.itemDiscardedBox.hide();
			this.inventoryList.hide();
			
			// Add 'em up
			this.addChild(this.getItemBox);
			this.addChild(this.cantHoldBox);
			this.addChild(this.discardBox);
			this.addChild(this.itemDiscardedBox);
			this.addChild(this.inventoryList);
			
			// Add event
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}
		
		public function show() : void
		{
			TinyLogManager.log('show', this);
			this.getItemBox.show();
		}

		public function hide() : void
		{
			TinyLogManager.log('hide', this);
			this.getItemBox.hide();
			this.cantHoldBox.hide();
			this.discardBox.hide();
		}
		
		private function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlAdded', this);
			
			// Add events
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ACCEPT, onAccept);
			this.addEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.removeEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}

		private function onControlRemoved(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlRemoved', this);
			
			// Remove events
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ACCEPT, onAccept);
			this.removeEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}

		private function onAccept(event : TinyInputEvent = null) : void 
		{
			TinyLogManager.log('onAccept', this);
			
			if (!this.showingCantHold) {
				// Try to add the item
				TinyPlayer.getInstance().inventory.addEventListener(TinyItemEvent.INVENTORY_FULL, onInventoryFull);
				TinyPlayer.getInstance().inventory.addEventListener(TinyItemEvent.ITEM_ADDED, onItemAdded);
				TinyPlayer.getInstance().inventory.addItem(this.targetItem);
			} else if (!this.showingItemDiscarded) {
				// Show yes / no dialog
				TinyInputManager.getInstance().setTarget(null);
				TweenLite.delayedCall(2, this.cantHoldBox.hide, null, true);
				TweenLite.delayedCall(2, this.removeChild, [this.cantHoldBox], true);
				TweenLite.delayedCall(6, this.discardBox.show, [true], true);
				this.discardBox.selectList.addEventListener(TinyInputEvent.OPTION_ONE, onYesSelected);				this.discardBox.selectList.addEventListener(TinyInputEvent.OPTION_TWO, onNoSelected);
				TweenLite.delayedCall(6, TinyInputManager.getInstance().setTarget, [this.discardBox], true);
			} else {
				// Remove discarded item, add target item
				if (this.discardedItem) {
					TinyPlayer.getInstance().inventory.removeItem(this.discardedItem);
					TinyPlayer.getInstance().inventory.addItem(this.targetItem);
				}
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}


		private function onItemAdded(event : TinyItemEvent) : void 
		{
			TinyLogManager.log('onItemAdded', this);
			this.dispatchEvent(new Event(Event.COMPLETE));
			
			// Clean up
			TinyPlayer.getInstance().inventory.removeEventListener(TinyItemEvent.ITEM_ADDED, onItemAdded);			TinyPlayer.getInstance().inventory.removeEventListener(TinyItemEvent.INVENTORY_FULL, onInventoryFull);
		}

		private function onInventoryFull(event : TinyItemEvent) : void 
		{
			TinyLogManager.log('onInventoryFull', this);
			
			this.showingCantHold = true;
			
			// Show Can't Hold box
			TinyInputManager.getInstance().setTarget(null);
			TweenLite.delayedCall(2, this.getItemBox.hide, null, true);
			TweenLite.delayedCall(2, this.removeChild, [this.getItemBox], true);
			TweenLite.delayedCall(6, this.cantHoldBox.show, null, true);			TweenLite.delayedCall(6, TinyInputManager.getInstance().setTarget, [this], true);
			
			// Clean up
			TinyPlayer.getInstance().inventory.removeEventListener(TinyItemEvent.INVENTORY_FULL, onInventoryFull);			TinyPlayer.getInstance().inventory.removeEventListener(TinyItemEvent.ITEM_ADDED, onItemAdded);		}
		
		private function onYesSelected(event : TinyInputEvent) : void 
		{
			TinyLogManager.log('onYesSelected', this);
			
			// Show inventory box
			TinyInputManager.getInstance().setTarget(null);
			TweenLite.delayedCall(6, this.inventoryList.show, null, true);
			TweenLite.delayedCall(6, TinyInputManager.getInstance().setTarget, [this.inventoryList], true);
			
			// Events
			this.inventoryList.addEventListener(TinyInputEvent.CANCEL, onItemCancel);
			this.inventoryList.addEventListener(TinyBattleEvent.ITEM_USED, onItemSelected);
			
			// Clean up
			this.discardBox.selectList.removeEventListener(TinyInputEvent.OPTION_ONE, onYesSelected);
			this.discardBox.selectList.removeEventListener(TinyInputEvent.OPTION_TWO, onNoSelected);		}
		
		private function onItemSelected(event : TinyBattleEvent) : void
		{
			TinyLogManager.log('onItemSelected', this);
			
			// Get the item we're discarding
			this.discardedItem = TinyItem(event.item);
			
			// Change discard message text
			this.itemDiscardedBox.text = 'You discarded 1 ' + this.discardedItem.name + '.';
			this.showingItemDiscarded = true;
			
			// Show item discarded box and clean up
			TinyInputManager.getInstance().setTarget(null);
			TweenLite.delayedCall(2, this.discardBox.hide, null, true);			TweenLite.delayedCall(2, this.inventoryList.hide, null, true);
			TweenLite.delayedCall(2, this.removeChild, [this.discardBox], true);			TweenLite.delayedCall(2, this.removeChild, [this.inventoryList], true);
			TweenLite.delayedCall(6, this.itemDiscardedBox.show, null, true);
			TweenLite.delayedCall(6, TinyInputManager.getInstance().setTarget, [this], true);
			
			// More clean up
			this.inventoryList.removeEventListener(TinyInputEvent.CANCEL, onItemCancel);
			this.inventoryList.removeEventListener(TinyBattleEvent.ITEM_USED, onItemSelected);		
		}
		
		private function onItemCancel(event : TinyInputEvent) : void
		{
			TinyLogManager.log('onItemCancel', this);
			
			// Show item discarded box and clean up
			TinyInputManager.getInstance().setTarget(null);
			TweenLite.delayedCall(2, this.inventoryList.hide, null, true);
			TweenLite.delayedCall(6, TinyInputManager.getInstance().setTarget, [this], true);
			this.discardBox.selectList.addEventListener(TinyInputEvent.OPTION_ONE, onYesSelected);
			this.discardBox.selectList.addEventListener(TinyInputEvent.OPTION_TWO, onNoSelected);
			TweenLite.delayedCall(6, TinyInputManager.getInstance().setTarget, [this.discardBox], true);
				
			// Clean up
			this.inventoryList.removeEventListener(TinyInputEvent.CANCEL, onItemCancel);
			this.inventoryList.removeEventListener(TinyBattleEvent.ITEM_USED, onItemSelected);	
		}

		private function onNoSelected(event : TinyInputEvent) : void 
		{
			TinyLogManager.log('onNoSelected', this);
			
			this.showingItemDiscarded = true;
			
			// Show item discarded box
			TinyInputManager.getInstance().setTarget(null);
			TweenLite.delayedCall(2, this.removeChild, [this.discardBox], true);
			TweenLite.delayedCall(2, this.discardBox.hide, null, true);
			TweenLite.delayedCall(6, this.itemDiscardedBox.show, null, true);
			TweenLite.delayedCall(6, TinyInputManager.getInstance().setTarget, [this], true);			
				
			this.discardBox.selectList.removeEventListener(TinyInputEvent.OPTION_ONE, onYesSelected);
			this.discardBox.selectList.removeEventListener(TinyInputEvent.OPTION_TWO, onNoSelected);
		}
	}
}
