package com.tinyrpg.ui 
{
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;

	/**
	 * @author jeremyabel
	 */
	public class TinyTwoChoiceList extends TinySelectList 
	{
		public function TinyTwoChoiceList(title : String, newItemArray : Array = null, width : uint = 0, height : uint = 0, spacing : uint = 15, startingY : uint = 6, startingX : uint = 0, horizontal : Boolean = false, horizontalSpacing : int = 20, opaque : Boolean = false)
		{
			super(title, newItemArray, width, height, spacing, startingY, startingX, horizontal, horizontalSpacing, opaque);
		}
		
		override protected function onAccept(event : TinyInputEvent) : void
		{
			super.onAccept(event);
			
			switch (this.selectedItem)
			{
				case this.itemArray[0]:
					this.dispatchEvent(new TinyInputEvent(TinyInputEvent.OPTION_ONE));					break;
				case this.itemArray[1]:
					this.dispatchEvent(new TinyInputEvent(TinyInputEvent.OPTION_TWO));
					break; 
			}
		}
		
		public function getSelectedItem() : TinySelectableItem
		{
			return this.selectedItem;
		}
	}
}
