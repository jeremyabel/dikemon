package com.tinyrpg.ui 
{
	import com.tinyrpg.core.TinyBattle;
	import com.tinyrpg.core.TinyParty;
	import com.tinyrpg.core.TinyPlayer;
	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyBattleEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyEnemyList extends TinySelectList 
	{
		private var _turnEnemy : TinySelectableItem;

		public function TinyEnemyList()
		{
			// Add friend labels
			var party : TinyParty = TinyBattle.enemyParty;
			
			var i : int = 0;
			var newItems : Array = [];
			for each (var partyMember : TinyStatsEntity in party.party)
			{
				var newLabel : TinySelectableItem = new TinySelectableItem(partyMember.name, i);
				newItems.push(newLabel);
				i++;
			}
			
			super("Enemies", newItems, 106, 56 + TinyBattle.finalBattleSize);
		}

		public function set turnEnemy(target : TinyStatsEntity) : void
		{
			TinyLogManager.log('set turnCharacter: ' + target, this);
			
			var label : TinySelectableItem;
			
			// Remove arrow if there's no target
			if (!target) {
				for each (label in this.itemArray) 
					label.autoSelected = false;
				return;
			}
			
			var turnEnemy : TinySelectableItem = this.getEnemyByID(target.idNumber);
			
			if (!turnEnemy) 
			{
				// Yeah, this is bad.
				TinyLogManager.log('turnCharacter: COULD NOT FIND CHARACTER!', this);
				return;
			} 
			else 
			{
				// Disable tiny arrow on all
				for each (label in this.itemArray) 
					label.autoSelected = false;
				
				// Enable tiny arrow on one
				turnEnemy.autoSelected = true;
				this._turnEnemy = turnEnemy;
			}
		}
		
		public function removeEnemy(target : TinyStatsEntity) : void
		{
			TinyLogManager.log('removeEnemy: ' + target.name, this);
			
			var targetLabel : TinySelectableItem = this.getEnemyByID(target.idNumber);
			this.removeListItem(targetLabel);
		}

		override protected function onControlAdded(e : TinyInputEvent) : void
		{
			// Unselect the current turn character
			TinyBattle.enemyDisplay.selectCharacter = null;
			
			// Proceed as normal
			super.onControlAdded(e);
			
			// Select corresponding sprite
			TinyBattle.enemyDisplay.selectCharacter = TinyPlayer.getInstance().party.getCharByID(this.selectedItem.idNumber);
		}

		override protected function onControlRemoved(e : TinyInputEvent) : void
		{
			// Unselect currently selected sprite
			TinyBattle.enemyDisplay.selectCharacter = null;
			
			// Proceed as normal
			super.onControlRemoved(e);
		}
		
		override protected function onArrowUp(e : TinyInputEvent) : void
		{
			super.onArrowUp(e);
			
			// Select corresponding display sprite
			if (TinyBattle.enemyDisplay) {
				TinyBattle.enemyDisplay.selectCharacter = TinyPlayer.getInstance().party.getCharByID(this.selectedItem.idNumber);
			}
		}
		
		override protected function onArrowDown(e : TinyInputEvent) : void
		{
			super.onArrowDown(e);
			
			// Select corresponding display sprite
			if (TinyBattle.enemyDisplay) {
				TinyBattle.enemyDisplay.selectCharacter = TinyPlayer.getInstance().party.getCharByID(this.selectedItem.idNumber);
			}
		}
		
		override protected function onAccept(e : TinyInputEvent) : void
		{
			super.onAccept(e);
			this.dispatchEvent(new TinyBattleEvent(TinyBattleEvent.ENEMY_SELECTED, TinyBattle.enemyParty.getCharByID(this.selectedItem.idNumber)));
			
			// Clean up
			this.clearSelectedItem();
			TinyBattle.enemyDisplay.selectCharacter = null;
		}

		private function getEnemyByID(targetID : int) : TinySelectableItem
		{
			// Find function
			var findFunction : Function = function(item : *, index : int, array : Array) : Boolean
				{ index; array; return (TinySelectableItem(item).idNumber == targetID); };
			
			// Search for character
			return this.itemArray.filter(findFunction)[0];
		}
		
		//public function removeEnemy()
	}
}
