package com.tinyrpg.ui 
{
	import com.greensock.TweenMax;
	import com.tinyrpg.core.TinyPlayer;
	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.events.TinyMenuEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;
	import flash.utils.ByteArray;

	/**
	 * @author jeremyabel
	 */
	public class TinyGameMenuParty extends Sprite 
	{
		private var currentPartyList : TinyPartySwapList;
		private var extraPartyList	 : TinyPartySwapList;
		private var hasControl		 : TinyPartySwapList;
		
		public static var charToSwap : TinySelectableItem;
		
		public function TinyGameMenuParty() : void
		{
			// Things that go in the two lists
			var currentArray : Array = TinyPlayer.getInstance().fullParty.party.slice(0, 3);
			var extraArray 	 : Array = TinyPlayer.getInstance().fullParty.party.slice(3);
			
			// The two lists			
			this.currentPartyList = new TinyPartySwapList(currentArray);
			this.extraPartyList   = new TinyPartySwapList(extraArray);	
			
			// Position
			this.extraPartyList.x = -int(this.extraPartyList.width);
			this.currentPartyList.x = -1;
			
			// Add 'em up
			this.addChild(this.currentPartyList);
			this.addChild(this.extraPartyList);
			
			this.hide();
			
			// Add event
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}

		public function show() : void
		{
			TinyLogManager.log('show', this);
			this.visible = true;
			TinyGameMenu.menuOneLiner.text = 'Select two friends to swap.';
		}

		public function hide() : void
		{
			TinyLogManager.log('hide', this);
			this.visible = false;
			
			// Try / catch to avoid some weird timing issue
			try { TinyGameMenu.menuOneLiner.text = ''; } catch (error : Error) { }
			
			// Clean up
			this.extraPartyList.removeEventListener(TinyInputEvent.ARROW_LEFT, onSideSwap);			this.extraPartyList.removeEventListener(TinyInputEvent.ARROW_RIGHT, onSideSwap);
			this.currentPartyList.removeEventListener(TinyInputEvent.ARROW_LEFT, onSideSwap);			this.currentPartyList.removeEventListener(TinyInputEvent.ARROW_RIGHT, onSideSwap);
		}
		
		private function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlAdded', this);
			
			this.addEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.removeEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
			
			// Give control to the menu
			this.extraPartyList.addEventListener(TinyInputEvent.ARROW_LEFT, onSideSwap);			this.extraPartyList.addEventListener(TinyInputEvent.ARROW_RIGHT, onSideSwap);
			this.extraPartyList.addEventListener(TinyInputEvent.ACCEPT, onListAccept);
			this.extraPartyList.addEventListener(TinyInputEvent.CANCEL, onListCancel);
			this.currentPartyList.addEventListener(TinyInputEvent.ARROW_LEFT, onSideSwap);			this.currentPartyList.addEventListener(TinyInputEvent.ARROW_RIGHT, onSideSwap);
			this.currentPartyList.addEventListener(TinyInputEvent.ACCEPT, onListAccept);
			this.currentPartyList.addEventListener(TinyInputEvent.CANCEL, onListCancel);
			
			this.hasControl = this.extraPartyList;			TinyInputManager.getInstance().setTarget(this.extraPartyList);
		}


		private function onControlRemoved(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlRemoved', this);
			
			this.removeEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}
		
		private function onSideSwap(event : TinyInputEvent) : void 
		{
			TinyLogManager.log('onSideSwap', this);
			
			// Switch control
			if (this.hasControl == this.extraPartyList) {
				TinyInputManager.getInstance().setTarget(this.currentPartyList);
				this.hasControl = this.currentPartyList;			} else {
				TinyInputManager.getInstance().setTarget(this.extraPartyList);				this.hasControl = this.extraPartyList;
			}
		}
		
		private function onListAccept(event : TinyInputEvent) : void 
		{
						// Swap character or select the one to swap
			if (TinyGameMenuParty.charToSwap) {
				
				TinyInputManager.getInstance().setTarget(null);
				
				TinyLogManager.log('onListAccept: Swapping ' + TinyGameMenuParty.charToSwap.textString + ' with ' + this.hasControl.selectedItem.textString, this);
				
				// Get characters to swap
				var charOne : TinyStatsEntity = TinyPlayer.getInstance().fullParty.getCharByID(this.hasControl.selectedItem.idNumber);
				var charTwo : TinyStatsEntity = TinyPlayer.getInstance().fullParty.getCharByID(TinyGameMenuParty.charToSwap.idNumber);
				
				// Can't swap the first player 
				if (charOne == TinyPlayer.getInstance().fullParty.party[0] || charTwo == TinyPlayer.getInstance().fullParty.party[0]) {
					// Play error sound
					TinyAudioManager.play(TinyAudioManager.ERROR);
					// Shake it!
					TinyInputManager.getInstance().setTarget(null);
					TweenMax.to(this, 1, { delay:1, x:this.x + 1, repeat:3, yoyo:true, roundProps:["x", "y"], useFrames:true, onComplete:TinyInputManager.getInstance().setTarget, onCompleteParams:[this.hasControl] });
				} else {
					// Do the swapping
					TinyPlayer.getInstance().fullParty.party[charOne.idNumber] = charTwo;
					TinyPlayer.getInstance().fullParty.party[charTwo.idNumber] = charOne;
					
					// Deep copy character ID numbers
					var copier : ByteArray = new ByteArray();
					copier.writeObject(charOne.idNumber);
					copier.position = 0;
					var copyID_One : int = int(copier.readObject());
					copier = new ByteArray();
					copier.writeObject(charTwo.idNumber);
					copier.position = 0;
					var copyID_Two : int = int(copier.readObject());
					
					// Swap ID numbers
					charOne.idNumber = copyID_Two;
					charTwo.idNumber = copyID_One;
					
					// Update active party
					TinyPlayer.getInstance().party.party[0] = TinyPlayer.getInstance().fullParty.party[0];					TinyPlayer.getInstance().party.party[1] = TinyPlayer.getInstance().fullParty.party[1];					TinyPlayer.getInstance().party.party[2] = TinyPlayer.getInstance().fullParty.party[2];
					
					// Rejigger positions of everything
					var firstSwap : int = this.currentPartyList.swapItems(TinyGameMenuParty.charToSwap, this.hasControl.selectedItem);
					var secondSwap : int = -1;
					if (firstSwap == -1) {
						secondSwap = this.extraPartyList.swapItems(TinyGameMenuParty.charToSwap, this.hasControl.selectedItem);
					} else if (secondSwap == -1) {
						this.currentPartyList.swapItems(TinyGameMenuParty.charToSwap, this.hasControl.selectedItem, this.extraPartyList);
					}
				
					// Reset stuff
					TinyGameMenuParty.charToSwap.autoSelected = false;
					TinyGameMenuParty.charToSwap = null;
					TinyLogManager.log('NEW PARTY: ' + TinyStatsEntity(TinyPlayer.getInstance().party.party[0]).name + ', ' + TinyStatsEntity(TinyPlayer.getInstance().party.party[1]).name + ', ' + TinyStatsEntity(TinyPlayer.getInstance().party.party[2]).name, this);
					
					// Return control
					this.dispatchEvent(new TinyMenuEvent(TinyMenuEvent.PARTY_CHANGED));
					TinyInputManager.getInstance().setTarget(this.hasControl);
				}
			} else {
				TinyLogManager.log('onListAccept: Character To Swap: ' + this.hasControl.selectedItem.textString, this);
				TinyGameMenuParty.charToSwap = this.hasControl.selectedItem;
				TinyGameMenuParty.charToSwap.autoSelected = true;			}
		}

		private function onListCancel(event : TinyInputEvent) : void 
		{
			TinyLogManager.log('onListCancel', this);
			
			// Clear selected character if there is one
			if (TinyGameMenuParty.charToSwap) {
				TinyGameMenuParty.charToSwap.autoSelected = false;
				TinyGameMenuParty.charToSwap = null;
			} else {
				this.dispatchEvent(new TinyInputEvent(TinyInputEvent.CANCEL));
			}
		}
		
		override public function get width() : Number
		{
			return this.currentPartyList.width * 2;
		}
	}
}
