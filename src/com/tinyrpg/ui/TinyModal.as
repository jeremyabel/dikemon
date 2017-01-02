package com.tinyrpg.ui 
{
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;

	/**
	 * @author jeremyabel
	 */
	public class TinyModal extends Sprite 
	{
		public function TinyModal()
		{
			//super(content, width, height);	
		}
		
		public function show() : void
		{
			TinyLogManager.log('show', this);	
		}
		
		public function hide() : void
		{
			TinyLogManager.log('hide', this);
		}
	}
}
