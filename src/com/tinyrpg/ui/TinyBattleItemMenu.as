package com.tinyrpg.ui 
{
	import flash.media.Sound;
	
	import com.tinyrpg.battle.TinyBattleStrings;
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.data.TinyItemUseResult;
	import com.tinyrpg.data.TinyItemDataList;
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.display.TinyOneLineBox;
	import com.tinyrpg.events.TinyBattleEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.media.sfx.SoundErrorBuzz;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleItemMenu extends TinyItemMenu 
	{
		protected var moveInfoBox : TinyOneLineBox;
		protected var moveSelectMenu : TinyMoveSelectMenu;
		protected var currentMon : TinyMon;
		

		public function TinyBattleItemMenu( trainer : TinyTrainer )
		{
			super( trainer, 130, 49, 4 );
			
			// Make move selection menu (for PP restoring)
			this.moveSelectMenu = new TinyMoveSelectMenu( null, true );
			this.moveSelectMenu.visible = false;
			this.moveSelectMenu.x = 46;
			this.moveSelectMenu.y = this.descriptionBox.y;
			
			// Make move information box
			this.moveInfoBox = new TinyOneLineBox( TinyBattleStrings.ASK_MOVE_RESTORE_PP, 144 );
			this.moveInfoBox.visible = false;
			this.moveInfoBox.x = this.descriptionBox.x;
			this.moveInfoBox.y = this.moveSelectMenu.y - 18;
			
			this.descriptionBox.x = -14;
			this.descriptionBox.y = 56;
			
			// Add 'em up
			this.addChild( this.moveInfoBox );
			this.addChild( this.moveSelectMenu );
		}
		
		
		public function setCurrentMon( mon : TinyMon ) : void
		{
			TinyLogManager.log('setCurrentMon: ' + mon.name, this );
			
			this.currentMon = mon;
			this.moveSelectMenu.setCurrentMon( this.currentMon );
		}


		override protected function onAccept( event : TinyInputEvent ) : void
		{
			if ( this.selectedItem.textString == TinyCommonStrings.CANCEL )
			{
				this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );	
			}
			else
			{
				// Get the item to be used
				this.item = TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString );
				
				// Check if the item can be used in the current battle on the current mon
				var canUseResult : TinyItemUseResult = this.item.checkCanUse( TinyItem.ITEM_CONTEXT_BATTLE, this.currentMon );
				
				// If the item cannot be used, show the error string and exit
				if ( !canUseResult.canUse ) 
				{
					TinyAudioManager.play( new SoundErrorBuzz() as Sound );
					this.setDescriptionText( canUseResult.errorString );
					
					return;
				}
				
				// If the item restores PP, show the move selection box and one-line info box and exit
				if ( item.healPP )
				{
					// Pass control to the move selection menu
					this.moveSelectMenu.setCurrentMon( this.currentMon );
					this.moveSelectMenu.show();
					this.moveInfoBox.show();
					TinyInputManager.getInstance().setTarget( this.moveSelectMenu );
					
					// Wait for move to be selected or cancelled
					this.moveSelectMenu.addEventListener( TinyBattleEvent.MOVE_SELECTED, this.onMoveSelected );
					this.moveSelectMenu.addEventListener( TinyInputEvent.CANCEL, this.onMoveSelectCancelled );
					this.moveSelectMenu.addEventListener( TinyInputEvent.SELECTED, this.onMoveSelectionChanged );
					
					return;
				}
					
				// Dispatch item used event
				this.dispatchEvent( new TinyBattleEvent( TinyBattleEvent.ITEM_USED, null, null, this.item ) );
			}
		}
		
		
		private function onMoveSelected( event : TinyBattleEvent ) : void
		{
			var selectedMove : TinyMoveData = event.move;
			
			TinyLogManager.log('onMoveSelected: ' + selectedMove.name, this);
			
			// If the move's PP is maxed, this item cannot be used. Show the error message and exit.
			if ( selectedMove.currentPP == selectedMove.maxPP )
			{
				TinyAudioManager.play( new SoundErrorBuzz() as Sound );
				this.moveInfoBox.text = TinyBattleStrings.CANT_USE_MAX_PP;
				return;
			}
			
			// Hide the move selection menu
			this.moveSelectMenu.hide();
			this.moveInfoBox.hide();
			
			// Remove event listeners
			this.moveSelectMenu.removeEventListener( TinyBattleEvent.MOVE_SELECTED, this.onMoveSelected );
			this.moveSelectMenu.removeEventListener( TinyInputEvent.CANCEL, this.onMoveSelectCancelled );
			this.moveSelectMenu.removeEventListener( TinyInputEvent.SELECTED, this.onMoveSelectionChanged );
			
			// Dispatch item used event
			this.dispatchEvent( new TinyBattleEvent( TinyBattleEvent.ITEM_USED, selectedMove, null, this.item ) );
		}
		
		
		private function onMoveSelectCancelled( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onMoveSelectCancelled', this );
			
			// Hide the move selection menu
			this.moveSelectMenu.hide();
			this.moveInfoBox.hide();
			
			// Remove event listeners
			this.moveSelectMenu.removeEventListener( TinyBattleEvent.MOVE_SELECTED, this.onMoveSelected );
			this.moveSelectMenu.removeEventListener( TinyInputEvent.CANCEL, this.onMoveSelectCancelled );
			this.moveSelectMenu.removeEventListener( TinyInputEvent.SELECTED, this.onMoveSelectionChanged );
			
			// Restore control to the item selector
			TinyInputManager.getInstance().setTarget( this );
		}
		
		
		private function onMoveSelectionChanged( event : TinyInputEvent ) : void
		{
			this.moveInfoBox.text = TinyBattleStrings.ASK_MOVE_RESTORE_PP;
		}
	}
}
