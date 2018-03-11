package com.tinyrpg.ui 
{
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;

	/**
	 * @author jeremyabel
	 */
	public class TinyStorageMonSubMenu extends TinyMonSubMenu
	{
		private var warningDialogBox : TinyDialogBox;
		private var actionString : String;
		private var isWithdraw : Boolean;
		
		public function TinyStorageMonSubMenu( isWithdraw : Boolean )
		{	
			super( 60 );
			
			this.isWithdraw = isWithdraw;
			this.actionString = isWithdraw ? TinyCommonStrings.WITHDRAW : TinyCommonStrings.DEPOSIT;  
			
			var newItemArray : Array = [
				new TinySelectableItem( this.actionString.toUpperCase(), 0 ),
				new TinySelectableItem( TinyCommonStrings.STATS.toUpperCase(), 1 ),
				new TinySelectableItem( TinyCommonStrings.CANCEL.toUpperCase(), 2 ),					
			];
			
			this.resetListItems( newItemArray );
			
			this.fullStatDisplay.x += 5 + 12;
			this.fullStatDisplay.y += 22;
		}
		
		
		override protected function onAccept( event : TinyInputEvent ) : void
		{
			if ( this.selectedItem.textString.toUpperCase() == TinyCommonStrings.CANCEL.toUpperCase() )
			{
				this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );
			}
			else if ( this.selectedItem.textString.toUpperCase() == this.actionString.toUpperCase() )
			{
				this.dispatchEvent( new TinyInputEvent( TinyInputEvent.ACCEPT, true ) );
			}
			else
			{
				super.onAccept( event );
			}
		}
	}
}
