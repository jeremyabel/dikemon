package com.tinyrpg.ui 
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.display.IShowHideObject;	
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.display.TinyMoveDetailBox;
	import com.tinyrpg.events.TinyBattleEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyMoveSelectMenu extends TinySelectList implements IShowHideObject 
	{
		private var currentMon : TinyMon;
		private var moveDetailDisplay : TinyMoveDetailBox;
		
		private const NO_MOVE_LABEL : String = '-';
		
		public function TinyMoveSelectMenu( targetMon : TinyMon = null, showDetailDisplay : Boolean = true )
		{
			super( '', null, 84, 33, 8, 1, 0);
			
			this.moveDetailDisplay = new TinyMoveDetailBox(144 - 94, 33);
			this.moveDetailDisplay.x = -this.moveDetailDisplay.width;
			
			if ( showDetailDisplay ) this.addChild( this.moveDetailDisplay );
			
			if (targetMon) this.setCurrentMon( targetMon );
		}
		
		public function setCurrentMon( targetMon : TinyMon ) : void
		{
			TinyLogManager.log('setCurrentMon: ' + targetMon.name, this);
			
			this.currentMon = targetMon;
			
			var newItems : Array = [];
			newItems[0] = new TinySelectableItem(this.currentMon.moveSet.move1 ? this.currentMon.moveSet.move1.name : NO_MOVE_LABEL, 0 );
			newItems[1] = new TinySelectableItem(this.currentMon.moveSet.move2 ? this.currentMon.moveSet.move2.name : NO_MOVE_LABEL, 1 );
			newItems[2] = new TinySelectableItem(this.currentMon.moveSet.move3 ? this.currentMon.moveSet.move3.name : NO_MOVE_LABEL, 2 );
			newItems[3] = new TinySelectableItem(this.currentMon.moveSet.move4 ? this.currentMon.moveSet.move4.name : NO_MOVE_LABEL, 3 );
			
			this.resetListItems( newItems );
		}
		
		public function show() : void
		{
			TinyLogManager.log('show', this);
			this.visible = true;
		}

		public function hide() : void
		{
			TinyLogManager.log('hide', this);
			this.visible = false;
		}
		
		override protected function onControlAdded(e : TinyInputEvent) : void
		{
			super.onControlAdded(e);
			
			// Update move details box
			if (this.itemArray.length > 0) 
			{
				this.moveDetailDisplay.setMove( this.getSelectedMove() );
			}
		}
		
		override protected function onArrowUp(e : TinyInputEvent) : void
		{
			if (this.itemArray.length > 0) 
			{
				super.onArrowUp(e);
				
				// Move past any empty move slots
				while (this.selectedItem.textString == NO_MOVE_LABEL)	
				{
					this.muteAudio = true;
					super.onArrowUp(e);
				}
				
				this.muteAudio = false;
				this.moveDetailDisplay.setMove( this.getSelectedMove() );
			}
		}
		
		override protected function onArrowDown(e : TinyInputEvent) : void
		{
			if (this.itemArray.length > 0) 
			{
				super.onArrowDown(e);
				
				// Move past any empty move slots
				while (this.selectedItem.textString == NO_MOVE_LABEL)	
				{
					this.muteAudio = true;
					super.onArrowDown(e);
				}	
				
				this.muteAudio = false;
				this.moveDetailDisplay.setMove( this.getSelectedMove() );	
			}
		}
		
		override protected function onAccept( e : TinyInputEvent ) : void
		{
			if (this.itemArray.length > 0) 
			{
				super.onAccept( e );

				var selectedMove : TinyMoveData = this.getSelectedMove();
				TinyLogManager.log('onAccept: ' + selectedMove.name, this);				
				this.dispatchEvent( new TinyBattleEvent( TinyBattleEvent.MOVE_SELECTED, selectedMove ) );
			}
		}
		
		private function getSelectedMove() : TinyMoveData
		{
			switch (this.selectedItem.idNumber)
			{
				default:
				case 0: return this.currentMon.moveSet.move1;
				case 1: return this.currentMon.moveSet.move2;
				case 2: return this.currentMon.moveSet.move3;
				case 3: return this.currentMon.moveSet.move4;	
			}
		}
	}
}
