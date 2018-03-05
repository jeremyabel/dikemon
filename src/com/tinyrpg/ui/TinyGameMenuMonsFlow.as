package com.tinyrpg.ui
{
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.events.Event;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyGameMenuMonsFlow extends TinyGameMenuBaseFlow
	{
		private var monMenu : TinyMonMenu;
		
		public function TinyGameMenuMonsFlow() : void
		{
			this.monMenu = new TinyMonMenu( TinyGameManager.getInstance().playerTrainer );
			this.addChild( this.monMenu );
		}
		
		
		override public function execute() : void
		{
			TinyLogManager.log( 'execute', this );
			
			// Pass control to the mon menu
			this.monMenu.show();
			this.monMenu.addEventListener( TinyInputEvent.CANCEL, this.onFlowComplete );
			TinyInputManager.getInstance().setTarget( this.monMenu );			 
		}
		
		
		override protected function onFlowComplete( event : Event = null ) : void
		{
			// Cleanup
			this.monMenu.removeEventListener( TinyInputEvent.CANCEL, this.onFlowComplete );
			
			super.onFlowComplete( event );
		}
	}
}
