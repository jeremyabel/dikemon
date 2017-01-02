package com.tinyrpg.ui 
{
	import com.tinyrpg.display.TinyOneLineBox;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyNoticeBox extends TinyOneLineBox 
	{
		public function TinyNoticeBox(text : String, width : int = 180) : void
		{
			super(text, width);
			
			// Add event
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}
		
		private function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlAdded', this);

			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ACCEPT, onAccept);
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.CANCEL, onAccept);			
			this.addEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.removeEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}


		private function onControlRemoved(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlRemoved', this);
			
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ACCEPT, onAccept);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.CANCEL, onAccept);
			this.removeEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}

		private function onAccept(event : TinyInputEvent) : void 
		{
			TinyLogManager.log('onAccept', this);
			this.dispatchEvent(new TinyInputEvent(TinyInputEvent.ACCEPT));
		}
	}
}
