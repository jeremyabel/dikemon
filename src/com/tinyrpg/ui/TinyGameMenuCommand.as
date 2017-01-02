package com.tinyrpg.ui 
{
	import com.tinyrpg.core.TinyPlayer;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.events.TinyMenuEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyGameMenuCommand extends TinySelectList 
	{
		private var itemString 		: String = 'Items';
		private var statsString		: String = 'Stats';
		private var partyString		: String = 'Party';
		private var saveString		: String = 'Save';
		
		public function TinyGameMenuCommand() : void
		{
			var newItems : Array = [];
			newItems[0] = new TinySelectableItem(this.itemString,   0);
			newItems[1] = new TinySelectableItem(this.statsString,  1);			newItems[2] = new TinySelectableItem(this.partyString,  2);
			newItems[3] = new TinySelectableItem(this.saveString,   3);
			
			super('MAIN MENU', newItems, 66, 56, 11, 5);
		}
		
		override protected function onControlAdded(event : TinyInputEvent) : void
		{
			// Clear stuff if it's been autoselected
			TinySelectableItem(this.itemArray[0]).autoSelected = false;
			TinySelectableItem(this.itemArray[1]).autoSelected = false;			TinySelectableItem(this.itemArray[2]).autoSelected = false;			TinySelectableItem(this.itemArray[3]).autoSelected = false;
			
			// Disable the party button if we don't have enough to swap with
			if (TinyPlayer.getInstance().fullParty.lengthRecruited >= 4) {
				TinySelectableItem(this.itemArray[2]).disabled = false;			} else {
				TinySelectableItem(this.itemArray[2]).disabled = true;
			}
						super.onControlAdded(event);
		}
		
		override protected function onControlRemoved(event : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlRemoved', this);
			
			// Remove events
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_UP, onArrowUp);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_DOWN, onArrowDown);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ACCEPT, onAccept);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.CANCEL, onCancel);
			this.removeEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}
		
		override protected function onAccept(event : TinyInputEvent) : void 
		{
			// Play sound
			TinyAudioManager.play(TinyAudioManager.SELECT);
			
			switch (this.selectedItem.textString) 
			{
				case this.itemString:
					TinyLogManager.log('onAccept: ' + this.itemString, this);
					TinySelectableItem(this.itemArray[0]).autoSelected = true;
					this.dispatchEvent(new TinyMenuEvent(TinyMenuEvent.ITEM_SELECTED));
					break;
				case this.statsString:
					TinyLogManager.log('onAccept: ' + this.statsString, this);
					TinySelectableItem(this.itemArray[1]).autoSelected = true;
					this.dispatchEvent(new TinyMenuEvent(TinyMenuEvent.STATS_SELECTED));
					break;
				case this.partyString:
					TinyLogManager.log('onAccept: ' + this.partyString, this);
					if (TinySelectableItem(this.itemArray[2]).disabled) {
						// Play error sound
						TinyAudioManager.play(TinyAudioManager.ERROR);
					} else {
						TinySelectableItem(this.itemArray[2]).autoSelected = true;
						this.dispatchEvent(new TinyMenuEvent(TinyMenuEvent.PARTY_SELECTED));
					}
					break;
				case this.saveString: 
					TinyLogManager.log('onAccept: ' + this.saveString, this);
					this.dispatchEvent(new TinyMenuEvent(TinyMenuEvent.SAVE_SELECTED));
					break;
			}
		}
		
		override protected function onCancel(event : TinyInputEvent) : void
		{
			super.onCancel(event);
			this.dispatchEvent(new TinyInputEvent(TinyInputEvent.CANCEL));
		}
	}
}
