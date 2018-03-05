package com.tinyrpg.ui
{
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.events.Event;
	import flash.system.fscommand;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyGameMenuQuitFlow extends TinyGameMenuBaseFlow 
	{
		private var confirmQuitDialog : TinyDialogSelectList;
		
		public function TinyGameMenuQuitFlow() : void
		{
			var confirmQuitOptions : Array = [
				new TinySelectableItem( TinyCommonStrings.YES.toUpperCase(), 0 ),
				new TinySelectableItem( TinyCommonStrings.NO.toUpperCase(),  1 )
			];
			
			this.confirmQuitDialog = new TinyDialogSelectList( confirmQuitOptions, 'Are you sure?', true, 32 );
			
			this.addChild( this.confirmQuitDialog );
		}
		
		
		override public function execute() : void
		{
			TinyLogManager.log( 'execute', this );
			
			this.confirmQuitDialog.addEventListener( TinyInputEvent.OPTION_ONE, this.onConfirmQuitYes );
			this.confirmQuitDialog.addEventListener( TinyInputEvent.OPTION_TWO, this.onConfirmQuitNo );
			this.confirmQuitDialog.show();
			
			// Pass control to the confirmation dialog
			TinyInputManager.getInstance().setTarget( this.confirmQuitDialog );
		}
		
		
		private function onConfirmQuitYes( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onConfirmQuitYes', this );
			
			// Exit the application
			fscommand( 'Quit' );
			
			// This will only be called when testing in the Flash IDE, which ignores the "Quit" system command.
			this.onFlowComplete( null );
		}
		
		
		private function onConfirmQuitNo( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onConfirmQuitNo', this );
			this.onFlowComplete( null );
		}
		
	
		override protected function onFlowComplete( event : Event = null ) : void
		{
			// Cleanup
			this.confirmQuitDialog.removeEventListener( TinyInputEvent.OPTION_ONE, this.onConfirmQuitYes );
			this.confirmQuitDialog.removeEventListener( TinyInputEvent.OPTION_TWO, this.onConfirmQuitNo );
			
			super.onFlowComplete( event );
		}
	}
}
