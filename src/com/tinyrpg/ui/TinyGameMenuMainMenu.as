package com.tinyrpg.ui 
{
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.events.TinyMenuEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyGameMenuMainMenu extends TinySelectList 
	{
		public function TinyGameMenuMainMenu() : void
		{
			var newItems : Array = [
				new TinySelectableItem( TinyCommonStrings.DIKEMON.toUpperCase(), 0 ),
				new TinySelectableItem( TinyCommonStrings.ITEMS.toUpperCase(), 1 ),
				new TinySelectableItem( TinyCommonStrings.SAVE.toUpperCase(), 2 ),
				new TinySelectableItem( TinyCommonStrings.QUIT.toUpperCase(), 3 )
			];
			
			super( '', newItems, 50, 64 );
		}

		
		override protected function onControlAdded( event : TinyInputEvent ) : void
		{
			// Clear stuff if it's been autoselected
			TinySelectableItem( this.itemArray[ 0 ] ).autoSelected = false;
			TinySelectableItem( this.itemArray[ 1 ] ).autoSelected = false;			TinySelectableItem( this.itemArray[ 2 ] ).autoSelected = false;			TinySelectableItem( this.itemArray[ 3 ] ).autoSelected = false;
			
			super.onControlAdded( event );
			
			// Pressing the menu button again while using the main menu will close it
			TinyInputManager.getInstance().addEventListener( TinyInputEvent.MENU, this.onCancel );
		}
		
		
		override protected function onControlRemoved( event : TinyInputEvent ) : void
		{
			super.onControlRemoved( event );
			
			// Cleanup
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.MENU, this.onCancel );	
		}

		
		override protected function onAccept( event : TinyInputEvent ) : void 
		{
			TinyAudioManager.play( TinyAudioManager.SELECT );
			
			TinyLogManager.log( 'onAccept: ' + this.selectedItem.textString, this );
					
			switch ( this.selectedItem.textString.toUpperCase() ) 
			{
				case TinyCommonStrings.DIKEMON.toUpperCase():
				{
					TinySelectableItem( this.itemArray[ 0 ] ).autoSelected = true;
					this.dispatchEvent( new TinyMenuEvent( TinyMenuEvent.MONS_SELECTED ) );
					break;
				}
					
				case TinyCommonStrings.ITEMS.toUpperCase():
				{
					TinySelectableItem( this.itemArray[ 1 ] ).autoSelected = true;
					this.dispatchEvent( new TinyMenuEvent( TinyMenuEvent.ITEM_SELECTED ) );
					break;
				}
					
				case TinyCommonStrings.SAVE.toUpperCase():
				{
					TinySelectableItem( this.itemArray[ 2 ] ).autoSelected = true;
					this.dispatchEvent( new TinyMenuEvent( TinyMenuEvent.SAVE_SELECTED ) );
					break;
				}					
					
				case TinyCommonStrings.QUIT.toUpperCase():
				{ 
					TinySelectableItem( this.itemArray[ 3 ] ).autoSelected = true;
					this.dispatchEvent( new TinyMenuEvent( TinyMenuEvent.QUIT_SELECTED ) );
					break;
				}
			}
		}
	}
}
