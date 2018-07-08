package com.tinyrpg.ui 
{
	import flash.events.Event;

	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyCommonStrings;
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
	public class TinySwitchMonSubMenu extends TinyMonSubMenu
	{
		protected var warningDialogBox : TinyDialogBox;
		
		public function TinySwitchMonSubMenu()
		{	
			super();
			
			var newItemArray : Array = [
				new TinySelectableItem( TinyCommonStrings.SWITCH.toUpperCase(), 0 ),
				new TinySelectableItem( TinyCommonStrings.STATS.toUpperCase(),  1 ),
				new TinySelectableItem( TinyCommonStrings.CANCEL.toUpperCase(), 2 ),					
			];
			
			this.resetListItems( newItemArray );
		}
		
		override protected function onAccept( event : TinyInputEvent ) : void
		{
			super.onAccept( event );
			
			if ( this.selectedItem.textString.toUpperCase() == TinyCommonStrings.SWITCH.toUpperCase() )
			{
				if ( !this.mon.isHealthy )
				{
					this.showWarningDialogBox( 'This DIKÉMON is too dead to fight!   [end]');
				}
				else if ( this.mon.isInBattle )
				{
					this.showWarningDialogBox( 'This DIKÉMON is already out, dingus!   [end]' );
				}
				else 
				{
					// Dispatch selected mon event if the SWITCH option is picked and the mon is ready to fight
					this.dispatchEvent( new TinyBattleEvent( TinyBattleEvent.MON_SELECTED, null, this.mon ) );
				}	
			}
		}
		
		
		protected function showWarningDialogBox( text : String ) : void
		{
			TinyLogManager.log( 'showWarningDialogBox: ' + text, this );
			
			this.warningDialogBox = TinyDialogBox.newFromString( text );
			this.warningDialogBox.x = -this.x;
			
			// Add and show dialog
			this.warningDialogBox.show();
			this.addChild( this.warningDialogBox );
					
			TinyInputManager.getInstance().setTarget( this.warningDialogBox );		
			this.warningDialogBox.addEventListener( Event.COMPLETE, onWarningDialogBoxComplete );
		}
		
		
		protected function onWarningDialogBoxComplete( event : Event ) : void
		{
			TinyLogManager.log( 'onWarningDialogBoxComplete', this );
			
			// Cleanup
			this.removeChild( this.warningDialogBox );
			this.warningDialogBox.removeEventListener(Event.COMPLETE, onWarningDialogBoxComplete);
			this.warningDialogBox = null;
			
			// Finishing the dialog is equivilent to a cancel action
			this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );
		}
	}
}
