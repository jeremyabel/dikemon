package com.tinyrpg.ui 
{
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.events.TinyItemEvent;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyUseDropMenu extends TinySelectList 
	{
		private var useString  : String = 'Use';
		private var dropString : String = 'Drop';
		
		public function TinyUseDropMenu() : void
		{
			// Make labels manually
			var useLabel  : TinySelectableItem = new TinySelectableItem(useString,  0);			var dropLabel : TinySelectableItem = new TinySelectableItem(dropString, 1);
			var newItems  : Array = [useLabel, dropLabel];
			
			super('', newItems, 80, 13, 15, 6, 0, true, 30, true);
			
			// Reposition
			this.itemHolder.y = -9;
			
			// Hide
			this.hide();
		}
		
		public function show() : void
		{
			TinyLogManager.log('show', this);
			this.visible = true;
		}

		public function hide() : void
		{			TinyLogManager.log('hide', this);
			this.visible = false;
		}
		
		override protected function onAccept(event : TinyInputEvent) : void
		{
			super.onAccept(event);
			
			switch (this.selectedItem.textString)
			{
				case this.useString:
					this.dispatchEvent(new TinyItemEvent(TinyItemEvent.ITEM_USED));
					break;
				case this.dropString:
					this.dispatchEvent(new TinyItemEvent(TinyItemEvent.ITEM_DROPPED));
					break;
			}
		}
	}
}
