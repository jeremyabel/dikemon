package com.tinyrpg.ui 
{
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.data.TinyItemUseResult;
	import com.tinyrpg.display.TinyContentBox;
	import com.tinyrpg.display.TinySelectableMonItem;
	import com.tinyrpg.events.TinyItemEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.media.sfx.SoundErrorBuzz;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.media.Sound;
	import flash.text.TextField;

	/**
	 * @author jeremyabel
	 */
	public class TinyUseItemMonMenu extends TinyMonMenu 
	{
		private var item : TinyItem;
		protected var errorTextField : TextField;
		protected var errorBox : TinyContentBox;
		
		public function TinyUseItemMonMenu( trainer : TinyTrainer, item : TinyItem ) 
		{
			super( trainer );
			
			this.item = item;
			
			// Make error text field
			this.errorTextField = TinyFontManager.returnTextField( 'left', false, true, true );
			this.errorTextField.width = 141;
			this.errorTextField.height = 20;
			this.errorTextField.y = -6;
			
			// Make error content box
			this.errorBox = new TinyContentBox( this.errorTextField, 144, 33 );
			this.errorBox.x = 0;
			this.errorBox.y = 104 - 8;
			this.errorBox.visible = false;
			
			// Add 'em up
			this.addChild( this.errorBox );
		}
		
		
		override protected function createSubMenu() : void
		{
			// nop, no submenu required for this version of the mon menu
		}
		
		
		override protected function onAccept( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onAccept', this );
			
			// Just hide the error box if it is visible when the player presses the accept button
			if ( this.errorBox.visible ) 
			{
				this.errorBox.visible = false;
				return;
			}
			
			if ( this.selectedItem.textString.toUpperCase() == TinyCommonStrings.CANCEL.toUpperCase() )
			{
				this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );
			}
			else
			{
				var selectedMon : TinyMon = ( this.selectedItem as TinySelectableMonItem ).mon;
				
				// Check if the item can be used in the current battle on the current mon
				var canUseResult : TinyItemUseResult = this.item.checkCanUse( TinyItem.ITEM_CONTEXT_FIELD, selectedMon );
				
				// If the item cannot be used, show the error string and exit
				if ( !canUseResult.canUse ) 
				{
					TinyAudioManager.play( new SoundErrorBuzz() as Sound );
					this.setErrorText( canUseResult.errorString );
					this.errorBox.visible = true;
					
					return;
				}
				
				this.dispatchEvent( new TinyItemEvent( TinyItemEvent.MON_FOR_ITEM_CHOSEN, selectedMon ) );
			}
		}
		
		
		override protected function onCancel( event : TinyInputEvent ) : void
		{
			// Just hide the error box if it is visible when the player presses the cancel button
			if ( this.errorBox.visible ) 
			{
				this.errorBox.visible = false;
				return;
			}
			
			super.onCancel( event );
		}
		
		
		override protected function onArrowUp( event : TinyInputEvent ) : void
		{
			this.errorBox.visible = false; 
			super.onArrowUp( event );
		}
		
		
		override protected function onArrowDown( event : TinyInputEvent ) : void
		{
			this.errorBox.visible = false; 
			super.onArrowDown( event );
		}
		
		
		private function setErrorText( error : String ) : void
		{
			this.errorTextField.htmlText = TinyFontManager.returnHtmlText( error, 'dialogText' );
		}
	}
}
