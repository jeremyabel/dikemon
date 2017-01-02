package com.tinyrpg.ui 
{
	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.data.TinyEventFlagData;
	import com.tinyrpg.display.TinyQuickStats;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;

	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author jeremyabel
	 */
	public class TinyPartySwapList extends TinySelectList 
	{
		private var partyArray : Array = [];
		
		public function TinyPartySwapList(partyArray : Array) : void
		{
			// Set properties
			this.partyArray = partyArray;
			
			var newItems : Array = [];
			
			// Populate with the current party
			for each (var character : TinyStatsEntity in this.partyArray) 
			{
				// Only if it's a party character though
				if (character.name.toUpperCase() != 'EVAN?' && 
					character.name.toUpperCase() != 'EVAN'  &&
					character.name.toUpperCase() != 'HYBRID' )//&&
					//TinyEventFlagData.getRecruitFlagByName(character.name).value)
				{
					var newQuickStats : TinyQuickStats = new TinyQuickStats(character);
					newQuickStats.selectID = newItems.length;
					newItems.push(newQuickStats);
				}
			}
			
			super('', newItems, 109, (partyArray.length == 3 ? 80 : 128), 26, 0, 17, false, 20, true);
		}
		
		public function swapItems(charOne : TinySelectableItem, charTwo : TinySelectableItem, partnerList : TinyPartySwapList = null) : int 
		{
			TinyLogManager.log('swapItems: ' + charOne.textString + ' and ' + charTwo.textString, this);
			
			// Are they both in the same place?
			if (!this.itemHolder.contains(charOne) && !this.itemHolder.contains(charTwo)) {
				return -1;
			} 
			else if (this.itemHolder.contains(charOne) && this.itemHolder.contains(charTwo)) 
			{
				// Swap positions
				var charOnePos : Point = new Point(TinyMath.deepCopyInt(charOne.x), TinyMath.deepCopyInt(charOne.y));
				var charTwoPos : Point = new Point(TinyMath.deepCopyInt(charTwo.x), TinyMath.deepCopyInt(charTwo.y));
				charOne.x = charTwoPos.x;
				charOne.y = charTwoPos.y;
				charTwo.x = charOnePos.x;
				charTwo.y = charOnePos.y;
				
				// Swap array indecies				
				var charOneIndex : int = TinyMath.deepCopyInt(this.itemArray.indexOf(charOne));				var charTwoIndex : int = TinyMath.deepCopyInt(this.itemArray.indexOf(charTwo));
				this.itemArray[charOneIndex] = charTwo;
				this.itemArray[charTwoIndex] = charOne;
				
				// Swap select IDs
				var charOneID : int = TinyMath.deepCopyInt(charOne.selectID);				var charTwoID : int = TinyMath.deepCopyInt(charTwo.selectID);
				charOne.selectID = charTwoID;
				charTwo.selectID = charOneID;
				
				// Deselect everything
				charOne.selected = false;
				charTwo.selected = false;
				this.selectedItem = null;
				
				return 0;
			} 
			else if (partnerList) 
			{
				var itemToAdd	 : TinySelectableItem;
				var itemToRemove : TinySelectableItem;
				
				// Figure out what we're doing with these
				if (this.itemHolder.contains(charOne)) {
					itemToAdd = charTwo;
					itemToRemove = charOne;
				} else {
					itemToAdd = charOne;
					itemToRemove = charTwo;
				}
				
				// Swap positions
				var removeItemPos : Point = new Point(TinyMath.deepCopyInt(itemToRemove.x), TinyMath.deepCopyInt(itemToRemove.y));
				var addItemPos    : Point = new Point(TinyMath.deepCopyInt(itemToAdd.x), TinyMath.deepCopyInt(itemToAdd.y));
				itemToAdd.x = removeItemPos.x;
				itemToAdd.y = removeItemPos.y;
				itemToRemove.x = addItemPos.x;
				itemToRemove.y = addItemPos.y;
				
				// Swap array indecies
				var removeIndex : int = TinyMath.deepCopyInt(this.itemArray.indexOf(itemToRemove));
				var addIndex 	: int = TinyMath.deepCopyInt(partnerList.itemList.indexOf(itemToAdd));
				this.itemArray[removeIndex] = itemToAdd;
				partnerList.itemList[addIndex] = itemToRemove;
				
				// Swap select ID;s
				var removeSelectID 	: int = TinyMath.deepCopyInt(itemToRemove.selectID);
				var addSelectID		: int = TinyMath.deepCopyInt(itemToAdd.selectID);
				itemToAdd.selectID = removeSelectID;
				itemToRemove.selectID = addSelectID;
				
				// Take children
				partnerList.itemSprite.addChild(itemToRemove);
				this.itemHolder.addChild(itemToAdd);
				
				// Deselect everything
				itemToRemove.selected = false;
				itemToAdd.selected = false;
				this.selectedItem = null;
				partnerList.selectedItem = null;
			}
			return 0;
		}

		override protected function onControlAdded(event : TinyInputEvent) : void
		{
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ARROW_LEFT, onArrowLeft);
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ARROW_RIGHT, onArrowRight);
			
			super.onControlAdded(event);
			
			// Ensure that the turn character's arrow stays
			if (TinyGameMenuParty.charToSwap) {
				if (this.selectedItem == TinyGameMenuParty.charToSwap) {
					TinyGameMenuParty.charToSwap.selected = true;
				} else {
					TinyGameMenuParty.charToSwap.autoSelected = true;
				}
			}
		}
		
		override protected function onControlRemoved(event : TinyInputEvent) : void
		{
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_LEFT, onArrowLeft);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_RIGHT, onArrowRight);
			
			super.onControlRemoved(event);
			
			// Ensure that the turn character's arrow stays
			if (TinyGameMenuParty.charToSwap) {
				if (this.selectedItem == TinyGameMenuParty.charToSwap) {
					TinyGameMenuParty.charToSwap.selected = true;
				} else {
					TinyGameMenuParty.charToSwap.autoSelected = true;
				}
			}
		}
		
		override protected function onArrowUp(event : TinyInputEvent) : void
		{
			super.onArrowUp(event);
			
			// Ensure that the turn character's arrow stays
			if (TinyGameMenuParty.charToSwap) {
				if (this.selectedItem == TinyGameMenuParty.charToSwap) {
					TinyGameMenuParty.charToSwap.selected = true;
				} else {
					TinyGameMenuParty.charToSwap.autoSelected = true;
				}
			}
		}
		
		override protected function onArrowDown(event : TinyInputEvent) : void
		{
			super.onArrowDown(event);
			
			// Ensure that the turn character's arrow stays
			if (TinyGameMenuParty.charToSwap) {
				if (this.selectedItem == TinyGameMenuParty.charToSwap) {
					TinyGameMenuParty.charToSwap.selected = true;
				} else {
					TinyGameMenuParty.charToSwap.autoSelected = true;
				}
			}
		}
		
		override protected function onArrowLeft(event : TinyInputEvent) : void
		{
			TinyLogManager.log('onArrowLeft', this);
			this.dispatchEvent(new TinyInputEvent(TinyInputEvent.ARROW_LEFT));
		}
		
		override protected function onArrowRight(event : TinyInputEvent) : void
		{
			TinyLogManager.log('onArrowRight', this);
			this.dispatchEvent(new TinyInputEvent(TinyInputEvent.ARROW_RIGHT));
		}
		
		public function get itemSprite() : Sprite { return this.itemHolder; }
		public function get itemList()   : Array { return this.itemArray; }
	}
}
