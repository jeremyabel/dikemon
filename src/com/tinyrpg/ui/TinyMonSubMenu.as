package com.tinyrpg.ui 
{
	import flash.events.Event;

	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.display.IShowHideObject;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyMonSubMenu extends TinySelectList implements IShowHideObject
	{
		protected var mon : TinyMon;
		protected var fullStatDisplay : TinyMonFullStatDisplay;
		protected var isInStatsDisplay : Boolean = false;
		
		public function TinyMonSubMenu()
		{	
			var newItemArray : Array = [
				new TinySelectableItem( TinyCommonStrings.STATS.toUpperCase(),  0 ),
				new TinySelectableItem( TinyCommonStrings.CANCEL.toUpperCase(), 1 ),					
			];
			
			super( '', newItemArray, 43, 33, 12, 1, 1 );
			
			this.fullStatDisplay = new TinyMonFullStatDisplay();
			this.fullStatDisplay.x = -130 + 24 + 5;
			this.fullStatDisplay.y = -144 + 33 + 14;
			this.fullStatDisplay.hide();
			
			// Add 'em up
			this.addChild( this.fullStatDisplay );
		}
		
		
		public function set currentMon( mon : TinyMon ) : void
		{
			this.mon = mon;
		}
		
		
		override public function show() : void
		{
			this.setSelectedItemIndex( 0 );
			super.show();
		}
		
		
		override protected function onAccept( event : TinyInputEvent ) : void
		{
			super.onAccept( event );
			
			// Send cancel event if the cancel option is picked, otherwise show the stats display
			if ( this.selectedItem.textString.toUpperCase() == TinyCommonStrings.CANCEL.toUpperCase() )
			{
				this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );
			}
			else if ( this.selectedItem.textString.toUpperCase() == TinyCommonStrings.STATS.toUpperCase() )
			{
				// Transfer control to stat display
				this.isInStatsDisplay = true;
				this.fullStatDisplay.addEventListener( TinyInputEvent.CANCEL, this.onStatDisplayCancelled );	
				TinyInputManager.getInstance().setTarget( this.fullStatDisplay );
				
				// Show selected item as inactive-selected	
				this.selectedItem.autoSelected = true;
				
				// Show stats display	
				this.fullStatDisplay.currentMon = this.mon;
				this.fullStatDisplay.show();
			}
		}
		
		
		protected function onStatDisplayCancelled( event : Event ) : void
		{
			TinyLogManager.log( 'onStatDisplayCancelled', this );
			
			// Hide the stats display
			this.fullStatDisplay.hide();
			
			// Restore active-selected state
			this.selectedItem.autoSelected = false;
			this.selectedItem.selected = true;
			
			// Return control
			this.fullStatDisplay.removeEventListener( TinyInputEvent.CANCEL, this.onStatDisplayCancelled );
			TinyInputManager.getInstance().setTarget( this );	
			this.isInStatsDisplay = false;
		}
	}
}
