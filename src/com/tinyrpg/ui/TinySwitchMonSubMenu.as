package com.tinyrpg.ui 
{
	import flash.events.Event;

	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.display.IShowHideObject;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyBattleMonEvent;
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
						this.dispatchEvent( new TinyBattleMonEvent( TinyBattleMonEvent.MON_SELECTED, null, this.mon ) );
					}	
				}
				else 
				{
					// TODO: Show stats display	
				}
			}
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
