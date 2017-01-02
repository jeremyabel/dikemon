package com.tinyrpg.ui 
{
	import com.tinyrpg.core.TinyBattle;
	import com.tinyrpg.core.TinyParty;
	import com.tinyrpg.core.TinyPlayer;
	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.display.TinyCharacterLabel;
	import com.tinyrpg.events.TinyBattleEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyFriendList extends TinySelectList 
	{
		private var player : TinyPlayer;
		private var _turnCharacter : TinyCharacterLabel;
		
		public function TinyFriendList()
		{
			this.player = TinyPlayer.getInstance();
			
			// Add friend labels
			var party : TinyParty = this.player.party;
			
			var i : int = 0;
			var newItems : Array = [];
			for each (var partyMember : TinyStatsEntity in party.party)
			{
				var newLabel : TinyCharacterLabel = new TinyCharacterLabel(partyMember, i);
				newItems.push(newLabel);
				i++;
			}

			super("Friends           HP", newItems, 106, 56 + TinyBattle.finalBattleSize);
		}
		
		public function updateCharacter(target : TinyStatsEntity) : void
		{
			TinyLogManager.log('updateCharacter: ' + target.name, this);
			
			var updateLabel : TinyCharacterLabel = this.findCharByName(target.name);
			if (!updateLabel) 
			{
				// Yeah, this is bad.
				TinyLogManager.log('upateCharacter: COULD NOT FIND CHARACTER!', this);
				return;
			} 
			else 
			{
				// Call update
				updateLabel.update();
			}
		}
		
		public function set turnCharacter(target : TinyStatsEntity) : void
		{
			TinyLogManager.log('set turnCharacter: ' + target, this);
			
			var label : TinyCharacterLabel;
			
			// Remove arrow if there's no target
			if (!target) {
				for each (label in this.itemArray) 
					label.autoSelected = false;
				return;
			}
			
			var turnCharacter : TinyCharacterLabel = this.findCharByName(target.name);
			
			if (!turnCharacter) 
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
				turnCharacter.autoSelected = true;
				this._turnCharacter = turnCharacter;
			}
		}
		
		public function update() : void 
		{
			TinyLogManager.log('update', this);
			
			for each (var player : TinyStatsEntity in TinyPlayer.getInstance().party.party)
			{
				// Find the appropriate label
				var targetLabel : TinyCharacterLabel = this.findCharByName(player.name);
				if (!targetLabel) {
					TinyLogManager.log('CANNOT FIND LABEL!', this);
					return;
				}
				
				// Update
				targetLabel.update();
			}
		}
		
		override protected function onControlAdded(e : TinyInputEvent) : void
		{
			// Unselect the current turn character
			this._turnCharacter.selected = false;
			TinyBattle.partyDisplay.selectCharacter = null;
			
			// Proceed as normal
			super.onControlAdded(e);
			
			// Select corresponding sprite
			TinyBattle.partyDisplay.selectCharacter = player.party.getCharByID(this.selectedItem.idNumber);
		}

		override protected function onControlRemoved(e : TinyInputEvent) : void
		{
			// Unselect currently selected sprite
			TinyBattle.partyDisplay.selectCharacter = null;
			
			// Proceed as normal
			super.onControlRemoved(e);
		}
		
		override protected function onArrowUp(e : TinyInputEvent) : void
		{
			super.onArrowUp(e);
			
			// Select corresponding display sprite
			if (TinyBattle.partyDisplay) {
				TinyBattle.partyDisplay.selectCharacter = player.party.getCharByID(this.selectedItem.idNumber);
			}

			// Ensure that the turn character's arrow stays
			if (this.selectedItem == this._turnCharacter) {
				this._turnCharacter.selected = true;
			} else {
				this._turnCharacter.autoSelected = true;
			}
		}
		
		override protected function onArrowDown(e : TinyInputEvent) : void
		{
			super.onArrowDown(e);
			
			// Select corresponding display sprite
			if (TinyBattle.partyDisplay) {
				TinyBattle.partyDisplay.selectCharacter = player.party.getCharByID(this.selectedItem.idNumber);
			}
						// Ensure that the turn character's arrow stays
			if (this.selectedItem == this._turnCharacter) {
				this._turnCharacter.selected = true;
			} else {
				this._turnCharacter.autoSelected = true;
			}
		}
		
		override protected function onAccept(e : TinyInputEvent) : void
		{
			super.onAccept(e);
			var target : TinyStatsEntity = player.party.getCharByID(this.selectedItem.idNumber);
			
			// Clean up
			if (TinyBattle.staticCurrentItem) {
				if ((!target.dead && !TinyBattle.staticCurrentItem.revive) ||
					(target.dead && TinyBattle.staticCurrentItem.revive)) {
					this.clearSelectedItem();					
					TinyBattle.partyDisplay.selectCharacter = null;
				}
			} else if (!target.dead) {
				this.clearSelectedItem();					
				TinyBattle.partyDisplay.selectCharacter = null;
			}
			
			// Tell the others!			
			this.dispatchEvent(new TinyBattleEvent(TinyBattleEvent.ENEMY_SELECTED, target));
		}
		
		private function findCharByName(targetName : String) : TinyCharacterLabel
		{
			// Find function
			var findFunction : Function = function(item : *, index : int, array : Array) : Boolean
				{ index; array; return (TinyCharacterLabel(item).textString == targetName); };
			
			// Search for character
			return this.itemArray.filter(findFunction)[0];
		}
	}
}
