package com.tinyrpg.ui 
{
	import flash.events.Event;

	import com.tinyrpg.display.IShowHideObject;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyYesNoSelectList extends TinySelectList implements IShowHideObject 
	{
		private static const YES_ITEM : String = 'YES';
		private static const NO_ITEM : String = 'NO';
		
		private var yesString : String;
		private var noString : String;
		
		public function TinyYesNoSelectList( yesString : String = YES_ITEM, noString : String = NO_ITEM )
		{
			this.yesString = yesString;
			this.noString = noString;
			this.isCancellable = false;
			
			var listItems : Array = [
				new TinySelectableItem( this.yesString, 0 ),
				new TinySelectableItem( this.noString, 1 )
			];
			
			super( '', listItems, 25, 22, 11, 1, 0 );
		}
		
		override public function show() : void
		{
			super.show();
						
			// Reset selected item to the top
			this.setSelectedItemIndex( 0 );
		}

		override protected function onAccept( e : TinyInputEvent ) : void
		{
			if ( this.itemArray.length > 0 ) 
			{
				super.onAccept( e );
				
				TinyLogManager.log('onAccept: ' + this.selectedItem.textString, this );				
				
				// Dispatch accept or cancel event
				if ( this.selectedItem.idNumber == 0 ) {
					this.dispatchEvent( new Event( Event.COMPLETE ) );
				} else {
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );
				}
			}
		}
	}
}
