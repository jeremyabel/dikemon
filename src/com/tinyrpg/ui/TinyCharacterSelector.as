package com.tinyrpg.ui 
{
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;

	/**
	 * @author jeremyabel
	 */
	public class TinyCharacterSelector extends Sprite 
	{
		private var itemHolder 	: Sprite;
		private var itemArray	: Array = [];
		
		public var selectedItem : TinySelectableItem;
		
		public function TinyCharacterSelector() : void
		{
			this.itemHolder = new Sprite;
			
			// Add 'em up
			this.addChild(this.itemHolder);
		}
		
		protected function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlAdded', this);
			
			// Only select first item the first time
			if (!this.selectedItem) { 
				this.selectedItem = this.itemArray[0];
			}
			
			if (this.selectedItem) {
				this.selectedItem.selected = true;
			}
			
			// Add events
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ARROW_UP, onArrowUp);
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ARROW_DOWN, onArrowDown);
			//TinyInputManager.getInstance().addEventListener(TinyInputEvent.ACCEPT, onAccept);
			//TinyInputManager.getInstance().addEventListener(TinyInputEvent.CANCEL, onCancel);
			this.addEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.removeEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}

		protected function onControlRemoved(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlRemoved', this);
			
			// Remove selection
			if (this.selectedItem) 
				this.selectedItem.selected = false;
			
			// Remove events
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_UP, onArrowUp);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_DOWN, onArrowDown);
			//TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ACCEPT, onAccept);
			//TinyInputManager.getInstance().removeEventListener(TinyInputEvent.CANCEL, onCancel);
			this.removeEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}

		private function onArrowUp(event : TinyInputEvent) : void 
		{	
			this.selectedItem.selected = false;
			var oldSelectID : int = this.selectedItem.selectID;

			// Try is used to prevent errors if there are no items in the list
			try {			
				if (oldSelectID == 0) {
					this.selectedItem = this.itemArray[this.itemArray.length - 1];
				} else {					
					this.selectedItem = this.itemArray[(oldSelectID - 1) % this.itemArray.length];
				}
				this.selectedItem.selected = true;
			} catch(error : Error) { }
			
			TinyLogManager.log('onKeyDown: UP   Selected Item: ' + this.selectedItem.textString, this);
		}
		
		private function onArrowDown(event : TinyInputEvent) : void 
		{
			// Try is used to prevent errors if there are no items in the list
			try {
				this.selectedItem.selected = false;
				var oldSelectID : int = this.selectedItem.selectID;
				this.selectedItem = this.itemArray[(oldSelectID + 1) % this.itemArray.length];
				this.selectedItem.selected = true;
			} catch (error : Error) { }
			
			TinyLogManager.log('onKeyDown: DOWN   Selected Item: ' + this.selectedItem.textString, this);
		}
	}
}
