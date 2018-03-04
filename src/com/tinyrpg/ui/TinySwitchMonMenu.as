package com.tinyrpg.ui 
{
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.events.TinyBattleEvent;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinySwitchMonMenu extends TinyMonMenu 
	{
		protected var isSwitchForced : Boolean = false;
		
		public function TinySwitchMonMenu( trainer : TinyTrainer ) 
		{
			super( trainer );
		}

		
		public function showForced() : void
		{
			TinyLogManager.log( 'showForced', this );
			
			// SHow only the selectable mons, without the cancel button
			this.resetListItems( this.selectableMonItems );
			
			this.isSwitchForced = true;
			this.isCancellable = true;
			this.show();
		}


		override public function hide() : void
		{
			super.hide();

			this.isSwitchForced = false;
			this.isCancellable = true;
			
			// Restore the cancel button if it has been removed due to a forced switch 
			if ( this.isSwitchForced )
			{
				var newItemArray : Array = this.selectableMonItems.concat( [ this.selectableCancelItem ] );
				this.resetListItems( newItemArray ); 	
			}
		}
	
		
		override protected function showSubMenu() : void
		{
			super.showSubMenu();
			
			this.selectedMonSubmenu.addEventListener( TinyBattleEvent.MON_SELECTED, this.onSubmenuAccepted );
		}
		
		
		override protected function createSubMenu() : void
		{
			// Make selected mon submenu
			this.selectedMonSubmenu = new TinySwitchMonSubMenu();
			this.selectedMonSubmenu.x = 130 - Math.floor(47 / 2) - 6;
			this.selectedMonSubmenu.y = 141 - 33 - 11;
			this.selectedMonSubmenu.visible = false;
			
			this.addChild( this.selectedMonSubmenu );
		}
		
		
		protected function onSubmenuAccepted( event : TinyBattleEvent ) : void
		{	
			TinyLogManager.log('onSubmenuAccepted: ' + event.mon.name, this);
			this.isInSubmenu = false;
		
			// Hide submenu
			this.selectedMonSubmenu.hide();
			
			// Remove inactive-selected state
			this.selectedItem.autoSelected = false;
			
			// Dispatch selected mon event
			this.dispatchEvent( new TinyBattleEvent( TinyBattleEvent.MON_SELECTED, null, event.mon) );
		}


		override protected function onSubmenuCancelled( event : TinyInputEvent ) : void
		{
			super.onSubmenuCancelled( event );
			
			// Cleanup
			this.selectedMonSubmenu.removeEventListener( TinyBattleEvent.MON_SELECTED, this.onSubmenuAccepted );
		}
	}
	

	
}
