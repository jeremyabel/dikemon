package com.tinyrpg.ui 
{
	import flash.events.Event;

	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.display.IShowHideObject;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyBattleEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.ui.TinyDialogBox;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinySwitchMonSubMenu extends TinySelectList implements IShowHideObject
	{
		private var mon : TinyMon;
		private var warningDialogBox : TinyDialogBox;
		private var fullStatDisplay : TinyMonFullStatDisplay;
		private var isInStatsDisplay : Boolean = false;
		
		private const SWITCH_STRING : String = 'SWITCH';
		private const STATS_STRING	: String = 'STATS';
		private const CANCEL_STRING : String = 'CANCEL';
		
		public function TinySwitchMonSubMenu()
		{	
			var newItemArray : Array = [
				new TinySelectableItem( SWITCH_STRING, 0 ),
				new TinySelectableItem( STATS_STRING,  1 ),
				new TinySelectableItem( CANCEL_STRING, 2 ),					
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
		
		public function show() : void
		{
			TinyLogManager.log("show", this);	
			this.setSelectedItemIndex(0);
			this.visible = true;
		}
		
		public function hide() : void
		{
			TinyLogManager.log("hide", this);
			this.visible = false;	
		}
		
		override protected function onAccept( e : TinyInputEvent ) : void
		{
			if (this.itemArray.length > 0) 
			{
				super.onAccept( e );
				
				// Send cancel event if the cancel option is picked, otherwise show the submenu
				if (this.selectedItem.textString == this.CANCEL_STRING)
				{
					// Dispatch cancel event
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );
				}
				else if (this.selectedItem.textString == this.SWITCH_STRING)
				{
					if ( this.mon.isInBattle )
					{
						this.showWarningDialogBox( 'This DIKéMON is already out, dingus!   [end]' );
					}
					else if ( !this.mon.isHealthy )
					{
						this.showWarningDialogBox( 'This DIKéMON is too dead to fight!   [end]');
					}
					else 
					{
						// Dispatch selected mon event if the SWITCH option is picked
						this.dispatchEvent( new TinyBattleEvent( TinyBattleEvent.MON_SELECTED, null, this.mon ) );
					}	
				}
				else 
				{
					// Transfer control to stat display
					this.isInStatsDisplay = true;
					this.fullStatDisplay.addEventListener( TinyInputEvent.CANCEL, this.onStatDisplayCancelled );	
					TinyInputManager.getInstance().setTarget( this.fullStatDisplay );
					
					// Show selected item as inactive-selected	
					this.selectedItem.autoSelected = true;
					
					// TODO: Show stats display	
					this.fullStatDisplay.currentMon = this.mon;
					this.fullStatDisplay.show();
				}
			}
		}
		
		private function onStatDisplayCancelled( event : Event ) : void
		{
			TinyLogManager.log('onStatDisplayCancelled', this);
			
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
		
		private function showWarningDialogBox( text : String ) : void
		{
			TinyLogManager.log('showWarningDialogBox: ' + text, this);
			
			this.warningDialogBox = TinyDialogBox.newFromString( text );
			this.warningDialogBox.x = -this.x;
			
			// Add and show dialog
			this.warningDialogBox.show();
			this.addChild( this.warningDialogBox );
					
			TinyInputManager.getInstance().setTarget( this.warningDialogBox );		
			this.warningDialogBox.addEventListener(Event.COMPLETE, onWarningDialogBoxComplete);
		}
		
		private function onWarningDialogBoxComplete( event : Event ) : void
		{
			TinyLogManager.log('onWarningDialogBoxComplete', this);
			
			// Cleanup
			this.removeChild( this.warningDialogBox );
			this.warningDialogBox.removeEventListener(Event.COMPLETE, onWarningDialogBoxComplete);
			this.warningDialogBox = null;
			
			// Finishing the dialog is equivilent to a cancel action
			this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );
		}
	}
}
