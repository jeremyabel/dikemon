package com.tinyrpg.ui 
{
//	import com.tinyrpg.data.TinySaveData;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.events.TinyMenuEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyTitleMenu extends TinySelectList 
	{
		private var newString 	: String = 'New Game';
		private var loadString	: String = 'Continue';
		private var quitString	: String = 'Quit';
		
		public function TinyTitleMenu()
		{
			var newItemArray : Array = [];
			
//			// Don't put "Continue" in the list unless we have something to continue
//			if (TinySaveData.doesSaveExist(1) || TinySaveData.doesSaveExist(2) || TinySaveData.doesSaveExist(3)) {
//				newItemArray[0] = new TinySelectableItem(this.loadString, 0);//				newItemArray[1] = new TinySelectableItem(this.newString, 1);//			} else {
//				newItemArray.push(new TinySelectableItem(this.newString, 0));
//			}
						newItemArray.push(new TinySelectableItem(this.quitString, newItemArray.length));
			
			super( newItemArray, 100, 100, 10 );
			this.containerBox.visible = false;
		}
		
		override protected function onAccept(event : TinyInputEvent) : void 
		{
			// Play sound
			TinyAudioManager.play(TinyAudioManager.SELECT);
			
			switch (this.selectedItem.textString) 
			{
				case this.newString:
					TinyLogManager.log('onAccept: ' + this.newString, this);
					this.dispatchEvent(new TinyMenuEvent(TinyMenuEvent.NEW_SELECTED));
					break;
				case this.loadString:
					TinyLogManager.log('onAccept: ' + this.loadString, this);
					this.dispatchEvent(new TinyMenuEvent(TinyMenuEvent.LOAD_SELECTED));
					break;
				case this.quitString:
					TinyLogManager.log('onAccept: ' + this.quitString, this);
					this.dispatchEvent(new TinyMenuEvent(TinyMenuEvent.QUIT_SELECTED));
					break;
			}
		}
	}
}
