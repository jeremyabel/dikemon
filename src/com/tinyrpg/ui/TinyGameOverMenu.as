package com.tinyrpg.ui 
{
	import com.tinyrpg.TinyMain;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyGameOverMenu extends TinySelectList 
	{
		private const continueString : String = 'Continue';
		private const quitString	 : String = 'Quit';
		
		public function TinyGameOverMenu() : void
		{
			var newItems : Array = [];
			newItems[0] = new TinySelectableItem(this.continueString, 0);			newItems[1] = new TinySelectableItem(this.quitString, 1);
			
			super( newItems );
			this.containerBox.visible = false;
		}
		
		override protected function onAccept(event : TinyInputEvent) : void 
		{
			TinyLogManager.log('onAccept: ' + this.selectedItem.textString, this);
			
			switch (this.selectedItem.textString)
			{
				case this.continueString:
					TinyMain.getInstance().showLoadGame();
					break;
				case this.quitString:
					TinyMain.getInstance().onQuitGame(null);
					break;
			}
		}
	}
}
