package com.tinyrpg.ui 
{
	import flash.media.Sound;
	import flash.text.TextField;
	
	import com.tinyrpg.battle.TinyBattleStrings;
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.data.TinyItemUseResult;
	import com.tinyrpg.data.TinyItemDataList;
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.display.TinyContentBox;
	import com.tinyrpg.display.IShowHideObject;	
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.display.TinySelectableItemItem;
	import com.tinyrpg.display.TinyOneLineBox;
	import com.tinyrpg.events.TinyBattleEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.media.sfx.SoundErrorBuzz;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleItemList extends TinyScrollableSelectList implements IShowHideObject 
	{
		private var trainer : TinyTrainer;
		private var moveInfoBox : TinyOneLineBox;
		private var moveSelectMenu : TinyMoveSelectMenu;
		private var descriptionTextField : TextField;
		private var descriptionBox : TinyContentBox;
		private var m_currentMon : TinyMon;
		private var item : TinyItem;
		

		public function TinyBattleItemList( trainer : TinyTrainer )
		{
			this.trainer = trainer;
			
			var newItemArray : Array = [];
			
			// Add items to selection array
			var i : int = 0;
			for each ( var item : TinyItem in this.trainer.inventory )
			{
				item.itemID = i;
				var newLabel : TinySelectableItemItem = new TinySelectableItemItem( item, item.itemID );
				newItemArray.push( newLabel );
				i++;
			}
			
			// Add CANCEL item
			newItemArray.push( new TinySelectableItem( TinyCommonStrings.CANCEL, newItemArray.length ) );
			
			super( '', newItemArray, 130, 49, 12, 2, 0, 4 );
			
			// Make description text field
			this.descriptionTextField = TinyFontManager.returnTextField('left', false, true, true);
			this.descriptionTextField.width = 141;
			this.descriptionTextField.height = 20;
			this.descriptionTextField.y = -4;
			
			// Make description content box
			this.descriptionBox = new TinyContentBox( this.descriptionTextField, 144, 33 );
			this.descriptionBox.x = -14;
			this.descriptionBox.y = 56;
			
			// Make move selection menu (for PP restoring)
			this.moveSelectMenu = new TinyMoveSelectMenu( null, true );
			this.moveSelectMenu.visible = false;
			this.moveSelectMenu.x = 46;
			this.moveSelectMenu.y = this.descriptionBox.y;
			
			this.moveInfoBox = new TinyOneLineBox( TinyBattleStrings.ASK_MOVE_RESTORE_PP, 144 );
			this.moveInfoBox.visible = false;
			this.moveInfoBox.x = this.descriptionBox.x;
			this.moveInfoBox.y = this.moveSelectMenu.y - 18;
			
			// Add 'em up
			this.addChild( this.descriptionBox );
			this.addChild( this.moveInfoBox );
			this.addChild( this.moveSelectMenu );
		}
		
		
		public function setCurrentMon( mon : TinyMon ) : void
		{
			TinyLogManager.log('setCurrentMon: ' + mon.name, this );
			
			this.m_currentMon = mon;
			this.moveSelectMenu.setCurrentMon( this.m_currentMon );
		}


		public function removeItem( targetItem : TinyItem ) : void
		{
			TinyLogManager.log('removeItem: ' + targetItem.name, this);
			
			var targetLabel : TinySelectableItem = this.getItemByID( targetItem.itemID );
			this.removeListItem( targetLabel );
		}


		override public function show() : void
		{
			super.show();
			
			// Update item quantities
			for each ( var selectableItem : TinySelectableItem in this.itemArray )
			{
				if ( selectableItem is TinySelectableItemItem )
				{
					( selectableItem as TinySelectableItemItem ).updateQuantity();	
				}
			}	
		}

		
		override protected function onControlAdded( e : TinyInputEvent ) : void
		{
			super.onControlAdded(e);
			
			if ( this.itemArray.length > 0 ) 
			{
				// Update or clear description box
				if ( this.selectedItem.textString != TinyCommonStrings.CANCEL)
				{
					var itemText : String = TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString ).description;
					this.setDescriptionText( itemText );
				}
				else
				{
					this.setDescriptionText( '' );
				}
			}
		}


		override protected function onControlRemoved( e : TinyInputEvent ) : void
		{
			super.onControlRemoved( e );
			
			// Empty the description dialog box
			this.setDescriptionText( '' );
			
			// Clear the selected item
			this.selectedItem = null;
		}


		override protected function onArrowUp( e : TinyInputEvent ) : void
		{
			if ( this.itemArray.length > 0 )
			{
				super.onArrowUp( e );
								
				// Update or clear description box
				if ( this.selectedItem.textString != TinyCommonStrings.CANCEL )
				{
					var itemText : String = TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString ).description;
					this.setDescriptionText( itemText );
				}
				else
				{
					this.setDescriptionText( '' );	
				}
			}
		}
		
		
		override protected function onArrowDown( e : TinyInputEvent ) : void
		{
			if ( this.itemArray.length > 0 ) 
			{
				super.onArrowDown( e );
								
				// Update or clear description box			
				if ( this.selectedItem.textString != TinyCommonStrings.CANCEL )
				{
					var itemText : String = TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString ).description;
					this.setDescriptionText( itemText );
				}
				else
				{
					this.setDescriptionText( '' );
				}
			}
		}
		
		
		override protected function onAccept( e : TinyInputEvent ) : void
		{
			if ( this.itemArray.length > 0 ) 
			{
				super.onAccept( e );
				
				if ( this.selectedItem.textString == TinyCommonStrings.CANCEL )
				{
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );	
				}
				else
				{
					// Get the item to be used
					this.item = TinyItemDataList.getInstance().getItemByName( this.selectedItem.textString );
					
					// Check if the item can be used in the current battle on the current mon
					var canUseResult : TinyItemUseResult = this.item.checkCanUse( TinyItem.ITEM_CONTEXT_BATTLE, m_currentMon );
					
					// If the item cannot be used, show the error string and exit
					if ( !canUseResult.canUse ) 
					{
						TinyAudioManager.play( new SoundErrorBuzz() as Sound );
						this.setDescriptionText( canUseResult.errorString );
						
						return;
					}
					
					// If thie item restores PP, show the move selection box and one-line info box and exit
					if ( item.healPP )
					{
						// Pass control to the move selection menu
						this.moveSelectMenu.setCurrentMon( this.m_currentMon );
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
			TinyLogManager.log("onMoveSelectCancelled", this);
			
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
		
		
		private function setDescriptionText( description : String ) : void 
		{
			this.descriptionTextField.htmlText = TinyFontManager.returnHtmlText( description, 'dialogText' );
		}
		
		
		private function getItemByID( targetID : int ) : TinySelectableItem
		{
			// Find function
			var findFunction : Function = function(item : *, index : int, array : Array) : Boolean
				{ index; array; return (TinySelectableItem(item).idNumber == targetID); };
			
			// Search for character
			return this.itemArray.filter( findFunction )[ 0 ];
		}
	}
}
