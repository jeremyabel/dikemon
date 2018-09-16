package com.tinyrpg.ui 
{
	import com.greensock.TweenMax;
	import com.tinyrpg.data.TinySaveData;
	import com.tinyrpg.display.TinyOneLineBox;
	import com.tinyrpg.display.TinySaveGameLabel;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinySaveLoadMenu extends Sprite 
	{
		private var helpBox 		: TinyOneLineBox;
		private var gameSelectList  : TinySelectList;
		private var saving			: Boolean;
		private var saveList		: Array = [];
		
		public var selectedSlot 	: int;
		
		public function TinySaveLoadMenu(saving : Boolean) : void
		{
			// Set properties
			this.saving = saving;
			
			// One line help box
			this.helpBox = new TinyOneLineBox((this.saving) ? 'Select a save location.' : 'Select a game to load.', 180);
			
			// Figure out what to show
			if (TinySaveData.doesSaveExist(1)) this.addGameData(1); else this.addEmptySlot(1);			if (TinySaveData.doesSaveExist(2)) this.addGameData(2); else this.addEmptySlot(2);			if (TinySaveData.doesSaveExist(3)) this.addGameData(3); else this.addEmptySlot(3);
			
			// Make select list
			this.gameSelectList = new TinySelectList( this.saveList, 0, 0, 37 );
			this.gameSelectList.y = this.helpBox.height - 7;
			this.gameSelectList.containerBox.visible = false;
			
			// Add 'em up
			this.addChild(this.helpBox);
			this.addChild(this.gameSelectList);		
			
			// Add events
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);	
		}
		
		public function show() : void
		{
			TinyLogManager.log('show', this);
			this.visible =
			this.helpBox.visible = 
			this.gameSelectList.visible = true;
		}

		public function hide() : void
		{
			TinyLogManager.log('hide', this);
			this.visible =
			this.helpBox.visible = 
			this.gameSelectList.visible = false;
		}
		
		private function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlAdded', this);
			
			this.addEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.removeEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
			
			// Give control to the select list
			TinyInputManager.getInstance().setTarget(this.gameSelectList);
			this.gameSelectList.addEventListener(TinyInputEvent.ACCEPT, onAccept);			this.gameSelectList.addEventListener(TinyInputEvent.CANCEL, onCancel);
		}

		private function onControlRemoved(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlRemoved', this);
			
			this.removeEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}
		
		private function onAccept(event : TinyInputEvent) : void 
		{
			this.selectedSlot = this.gameSelectList.selectedItem.selectID + 1;

			TinyLogManager.log('onAccept: ' + this.selectedSlot, this);
			
			// Is this a valid slot to save / load?
			if (!this.saving && TinySaveGameLabel(this.gameSelectList.selectedItem).empty)
			{
				// Play error sfx
				TinyAudioManager.play(TinyAudioManager.ERROR);
				
				// Shake it!
				TinyInputManager.getInstance().setTarget(null);
				TweenMax.to(this, 1, { delay:1, x:this.x + 1, repeat:3, yoyo:true, roundProps:["x", "y"], useFrames:true, onComplete:TinyInputManager.getInstance().setTarget, onCompleteParams:[this.gameSelectList] });
			} else {
				
				if (this.saving) 
				{
					var newSaveData : TinySaveData = new TinySaveData;
					newSaveData.saveAndCompressData(this.selectedSlot);
					newSaveData.addEventListener(Event.COMPLETE, onSaveComplete);
					
					// Show new save data picture thingy
					this.saveList = [];
					this.removeChild(this.gameSelectList);
					
					// Figure out what to show
					if (TinySaveData.doesSaveExist(1)) this.addGameData(1); else this.addEmptySlot(1);
					if (TinySaveData.doesSaveExist(2)) this.addGameData(2); else this.addEmptySlot(2);
					if (TinySaveData.doesSaveExist(3)) this.addGameData(3); else this.addEmptySlot(3);
					
					// Make select list
					this.gameSelectList = new TinySelectList( this.saveList, 0, 0, 37 );
					this.gameSelectList.y = this.helpBox.height - 7;
					this.gameSelectList.containerBox.visible = false;
					
					// Add 'em up
					this.addChild(this.gameSelectList);
					
					TinyInputManager.getInstance().setTarget(this.gameSelectList);
					this.gameSelectList.addEventListener(TinyInputEvent.ACCEPT, onAccept);
					this.gameSelectList.addEventListener(TinyInputEvent.CANCEL, onCancel);
					
					// Play sound
					TinyAudioManager.play(TinyAudioManager.SELECT);
				}
				else
				{
					// Play sound
					TinyAudioManager.play(TinyAudioManager.SELECT);
					
					// Tell the others!
					this.dispatchEvent(new TinyInputEvent(TinyInputEvent.ACCEPT));
				
					// Clean up
					this.gameSelectList.removeEventListener(TinyInputEvent.ACCEPT, onAccept);
					this.gameSelectList.removeEventListener(TinyInputEvent.CANCEL, onCancel);
				}
			}		}

		private function onSaveComplete(event : Event) : void 
		{
			TinyLogManager.log('onSaveComplete', this);
			
			
			
			// Set input back
			//TinyInputManager.getInstance().setTarget(this);
		}

		private function onCancel(event : TinyInputEvent) : void 
		{
			TinyLogManager.log('onCancel', this);
			
			this.dispatchEvent(new TinyInputEvent(TinyInputEvent.CANCEL));
			
			// Clean up
			this.gameSelectList.removeEventListener(TinyInputEvent.ACCEPT, onAccept);
			this.gameSelectList.removeEventListener(TinyInputEvent.CANCEL, onCancel);
		}
		
		override public function get width() : Number 
		{ 
			return this.helpBox.width; 
		}
		
		private function addGameData(slot : int) : void
		{
			TinyLogManager.log('addGameData: Slot ' + slot, this);
			
			var newSaveLabel : TinySaveGameLabel = new TinySaveGameLabel(TinySaveData.loadCompressedData(slot), slot - 1);
			saveList.push(newSaveLabel);
		}
		
		private function addEmptySlot(slot : int) : void
		{
			TinyLogManager.log('addEmptySlot: Slot ' + slot, this);
			
			var newSaveLabel : TinySaveGameLabel = new TinySaveGameLabel(null, slot - 1);
			saveList.push(newSaveLabel);
		}
	}
}
