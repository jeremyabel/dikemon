package com.tinyrpg.ui
{
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyGameMenuBaseFlow extends Sprite 
	{
		public function TinyGameMenuBaseFlow() : void
		{
			
		}
		
		public function execute() : void 
		{
			
		}
		
		protected function onFlowComplete( event : Event = null ) : void
		{
			TinyLogManager.log( 'onFlowComplete', this );
			this.dispatchEvent( new Event( Event.COMPLETE ) );			
		}
	}
}