package com.tinyrpg.display 
{
	import flash.events.Event;
	import com.greensock.*;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;

	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author jeremyabel
	 */
	public class TinyCharacterLabel extends TinySelectableItem 
	{
		private var character 	 : TinyStatsEntity;
		private var hpText		 : TextField;
		private var hpBarBase	 : Sprite;
		private var hpBarCurrent : Sprite;
		private var hpFollower	 : Sprite;
		private var frameCount	 : int = 0;		
		public function TinyCharacterLabel(character : TinyStatsEntity, idNumber : int)
		{
			TweenPlugin.activate([EndArrayPlugin]);
			
			this.character = character;
			
			// Name text
			super(this.character.name, idNumber);
			
			// HP text
			this.hpText = TinyFontManager.returnTextField("right");	
			this.hpText.htmlText = TinyFontManager.returnHtmlText(String(this.character.stats.HP) + "/" + String(this.character.stats.MHP), "battleCharName", "right");
			this.hpText.x = 60;
			
			// HP bar - base
			this.hpBarBase = new Sprite;
			this.hpBarBase.graphics.beginFill(0xEC2327);			this.hpBarBase.graphics.drawRect(0, 0, 40, 3);			this.hpBarBase.graphics.endFill();
			this.hpBarBase.x = 57;
			this.hpBarBase.y = 15;
			
			// HP bar - current
			this.hpBarCurrent = new Sprite;
			this.hpBarCurrent.graphics.beginFill(0x000000);
			this.hpBarCurrent.graphics.drawRect(0, 0, int((this.character.stats.HP / this.character.stats.MHP) * this.hpBarBase.width), 3);
			this.hpBarCurrent.graphics.endFill();
			this.hpBarCurrent.x = this.hpBarBase.x;
			this.hpBarCurrent.y = this.hpBarBase.y;
			
			// HP follower
			this.hpFollower = new Sprite;
			this.hpFollower.x = this.character.stats.HP;
			
			// Add 'em up
			this.addChild(this.hpText);
			this.addChild(this.hpBarBase);
			this.addChild(this.hpBarCurrent);
		}

		public function update() : void
		{
			TinyLogManager.log('update', this);
			
			// Difference in HP. Absolute value is for both damage and healing
			var deltaHP : int = Math.abs(this.character.stats.previousHP - this.character.stats.HP) + 1;
			
			// Overkill...
			if (deltaHP > this.character.stats.HP && this.character.stats.HP < 0) {
				deltaHP = 10;
				this.character.stats.HP = 0;
			}
			
			// Overheal!
			if (this.character.stats.HP > this.character.stats.MHP) {
				this.character.stats.HP = this.character.stats.MHP;
				//deltaHP = Math.abs(this.character.stats.previousHP - this.character.stats.HP);
			}
			
			// Nothing has changed...
			if (deltaHP == 0) 
				return;
				
			// Update HP text
			TweenLite.to(this.hpFollower, TinyMath.map(deltaHP, 1, this.character.stats.MHP, 1, 50), { x:this.character.stats.HP, onUpdate:updateHPTextNumber, useFrames:true, ease:Circ.easeOut });	
			
			// Update HP bar
			var newWidth : int = ((this.character.stats.HP / this.character.stats.MHP) * this.hpBarBase.width);
			TweenLite.to(this.hpBarCurrent, TinyMath.map(deltaHP, 1, this.character.stats.MHP, 1, 50), { width: newWidth, useFrames: true, ease: Circ.easeOut });
		}
		
		private function updateHPTextNumber() : void
		{
			 this.hpText.htmlText = TinyFontManager.returnHtmlText(String(int(this.hpFollower.x)) + "/" + String(this.character.stats.MHP), "battleCharName");
			
			this.hpBarCurrent.alpha = 1;
			this.hpText.textColor = 0x000000;
			
			// Enable flashing bar if necessary
			if (this.hpFollower.x / this.character.stats.MHP < 0.25 && this.character.stats.HP > 0 && !this.hasEventListener(Event.ENTER_FRAME)) {
				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			} else if (this.hpFollower.x / this.character.stats.MHP > 0.25 && this.hasEventListener(Event.ENTER_FRAME)) {
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				this.hpBarCurrent.alpha = 1;
				this.hpText.textColor = 0x000000;
			}
			
			// Keep number text red if dead
			if (this.character.stats.HP <= 0 ) {
				this.hpText.textColor = 0xEC2327;
			}
		}
		
		private function onEnterFrame(e : Event) : void
		{
			this.frameCount = (1 + this.frameCount) % 8;
			
			// Flash hp bar
			if (this.frameCount == 0) {
				this.hpBarCurrent.alpha = 0;
				this.hpText.textColor = 0xEC2327;
			} 
			
			if (this.frameCount == 2) {
				this.hpBarCurrent.alpha = 1;
				this.hpText.textColor = 0x000000;
			}
		}
	}
}
