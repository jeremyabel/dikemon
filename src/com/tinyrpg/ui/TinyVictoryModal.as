package com.tinyrpg.ui 
{
	import com.greensock.TweenLite;
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyPlayer;
	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.display.TinyOneLineBox;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author jeremyabel
	 */
	public class TinyVictoryModal extends Sprite 
	{
		private var xp			: int;
		private var gp			: int;
		private var items 		: Array;
		private var boxSequence : Array = [];
		private var levelWords  : Array = ['Nice!', 'Sweet!', 'Awesome!'];
		private var currentBox	: *;		
		public function TinyVictoryModal(xp : int, gp : int, levelUps : Array = null, items : Array = null)
		{
			// Set properties
			this.xp = xp;
			this.gp = gp;
			this.items = items;
			
			// Make XP and GP boxes
			var xpString : String = this.xp > 0 ? 'You got ' + this.xp + ' exp. point' + (this.xp > 1 ? 's!' : '!') : 'You gained no experience.';
			var gpString : String = 'You found ' + this.gp + ' buck' + (this.gp == 1 ? '' : 's') + ' inside the enemy!';
			var xpBox : TinyOneLineBox = new TinyOneLineBox(xpString);
			var gpBox : TinyOneLineBox = new TinyOneLineBox(gpString);
			
			// Add to sequence			
			this.boxSequence.push(xpBox);

			// Add level up notices
			var levelCount : int = 0;
			for each (var charName : String in levelUps) {
				var character : TinyStatsEntity = TinyPlayer.getInstance().fullParty.getCharByName(charName);
				var levelString : String = levelWords[levelCount] + ' ' + character.name + ' is now level ' + character.stats.LVL;
				var levelBox : TinyOneLineBox = new TinyOneLineBox(levelString);
				this.boxSequence.push(levelBox);
				levelCount++;
			}
			
			this.boxSequence.push(gpBox);
			
			// Add item drop notices
			for each (var item : TinyItem in this.items) {
				var itemBox : TinyBattleItemGetBox = new TinyBattleItemGetBox(item);
				this.boxSequence.push(itemBox); 
			}
			
			// Add event
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}
		
		public function show() : void
		{
			TinyLogManager.log('show', this);
			this.showNextBox();
		}
		
		private function showNextBox() : void
		{
			TinyLogManager.log('showNextBox', this);
			
			var nextBox : * = boxSequence.shift();
			this.currentBox = nextBox;
			
			// Show next box if there is one
			if (nextBox) {
				if (nextBox is TinyBattleItemGetBox) {
					TinyBattleItemGetBox(this.currentBox).addEventListener(Event.COMPLETE, onAccept);
					TinyInputManager.getInstance().setTarget(TinyBattleItemGetBox(this.currentBox));
					TinyBattleItemGetBox(this.currentBox).show();
				} else {
					TinyOneLineBox(this.currentBox).show();
					TinyInputManager.getInstance().setTarget(this);
				}
				this.addChild(this.currentBox);
			} else {
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlAdded', this);
			
			// Add events
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ACCEPT, onAccept);
			this.addEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.removeEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}

		private function onControlRemoved(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlRemoved', this);
			
			// Remove events
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ACCEPT, onAccept);
			this.removeEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}

		private function onAccept(event : Event) : void 
		{
			TinyLogManager.log('onAccept', this);
			
			// Hide current box then show the next one. Delays slow stuff down a bit for a nice feel
			TinyInputManager.getInstance().setTarget(null);
			TweenLite.delayedCall(2, this.currentBox.hide, null, true);
			TweenLite.delayedCall(2, this.removeChild, [this.currentBox], true);
			TweenLite.delayedCall(6, this.showNextBox, null, true);
			
			// Clean up
			EventDispatcher(this.currentBox).removeEventListener(Event.COMPLETE, onAccept);
		}
	}
}
