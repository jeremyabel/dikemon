package com.tinyrpg.ui 
{
	import com.tinyrpg.core.TinyFriendSprite;
	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.display.TinyContentBox;
	import com.tinyrpg.display.TinySpriteSheet;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.misc.TinySpriteConfig;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author jeremyabel
	 */
	public class TinyGameMenuStats extends TinyContentBox 
	{
		private var char 		 : TinyStatsEntity;
		private var charSprite   : TinySpriteSheet;
		private var textName	 : TextField;
		private var textLvl		 : TextField;
		private var textStrLabel : TextField;
		private var textStr		 : TextField;
		private var textDefLabel : TextField;
		private var textDef		 : TextField;
		private var textAgiLabel : TextField;
		private var textAgi		 : TextField;
		private var textVitLabel : TextField;
		private var textVit		 : TextField;
		private var textXP		 : TextField;
		private var hpText 		 : TextField;
		private var hpTitle 	 : TextField;
		private var hpBarBase 	 : Sprite;
		private var hpBarCurrent : Sprite;

		public function TinyGameMenuStats()
		{
			super(content, 109, 80);
			
			// Make text fields
			this.textName		 = TinyFontManager.returnTextField();
			this.textLvl		 = TinyFontManager.returnTextField();
			this.textStrLabel	 = TinyFontManager.returnTextField();
			this.textDefLabel	 = TinyFontManager.returnTextField();
			this.textAgiLabel 	 = TinyFontManager.returnTextField();
			this.textVitLabel	 = TinyFontManager.returnTextField();
			this.textStr		 = TinyFontManager.returnTextField();
			this.textDef 		 = TinyFontManager.returnTextField();
			this.textAgi		 = TinyFontManager.returnTextField();
			this.textVit		 = TinyFontManager.returnTextField();
			this.textXP		  	 = TinyFontManager.returnTextField();
			this.hpTitle		 = TinyFontManager.returnTextField();
			this.hpText		 	 = TinyFontManager.returnTextField("right");	
			 
			// Position stuff
			this.textName.x = 37;
			this.textName.y = 3;
			this.textLvl.x = this.textName.x;
			this.textLvl.y = this.textName.y + 11;
			this.hpTitle.x = this.textLvl.x;
			this.hpTitle.y = this.textLvl.y + 6;
			this.hpText.x  = this.hpTitle.x + 34;
			this.hpText.y  = this.hpTitle.y + 8;
			this.textStrLabel.x = 2;
			this.textStrLabel.y = 42;
			this.textStr.x = this.textStrLabel.x + 44;
			this.textStr.y = this.textStrLabel.y;
			this.textDefLabel.x = this.textStrLabel.x;
			this.textDefLabel.y = this.textStrLabel.y + 8;
			this.textDef.x = this.textStr.x;
			this.textDef.y = this.textDefLabel.y;
			this.textAgiLabel.x = this.textStrLabel.x;
			this.textAgiLabel.y = this.textDefLabel.y + 8;
			this.textAgi.x = this.textStr.x;
			this.textAgi.y = this.textAgiLabel.y;
			this.textVitLabel.x = this.textStrLabel.x;
			this.textVitLabel.y = this.textAgiLabel.y + 8;
			this.textVit.x = this.textStr.x;
			this.textVit.y = this.textVitLabel.y;
			this.textXP.x  = this.textStrLabel.x + 61;
			this.textXP.y  = this.textStrLabel.y;

			// HP bar - base
			this.hpBarBase = new Sprite;
			this.hpBarBase.graphics.beginFill(0xEC2327);
			this.hpBarBase.graphics.drawRect(0, 0, 40, 3);
			this.hpBarBase.graphics.endFill();
			this.hpBarBase.x = this.hpTitle.x + 2;
			this.hpBarBase.y = this.hpTitle.y + 18;
			
			// HP bar - current
			this.hpBarCurrent = new Sprite;
			
			// Set static text
			this.hpTitle.htmlText = TinyFontManager.returnHtmlText('HP:', 'battleBoxTitle');
			this.textStrLabel.htmlText = TinyFontManager.returnHtmlText('Strength:', 'battleItemText');			this.textDefLabel.htmlText = TinyFontManager.returnHtmlText('Defence:',  'battleItemText');			this.textAgiLabel.htmlText = TinyFontManager.returnHtmlText('Agility:',  'battleItemText');			this.textVitLabel.htmlText = TinyFontManager.returnHtmlText('Vitality:', 'battleItemText');
			
			// Add 'em up
			this.addChild(this.textName);
			this.addChild(this.hpText);
			this.addChild(this.hpTitle);			this.addChild(this.hpBarBase);			this.addChild(this.hpBarCurrent);			this.addChild(this.textLvl);
			this.addChild(this.textStrLabel);			this.addChild(this.textDefLabel);			this.addChild(this.textAgiLabel);			this.addChild(this.textVitLabel);			this.addChild(this.textStr);			this.addChild(this.textDef);			this.addChild(this.textAgi);			this.addChild(this.textVit);			this.addChild(this.textXP);			
			// Start hidden
			this.hide();
			
			// Events
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}
		public function showCharacter(targetCharacter : TinyStatsEntity) : void
		{
			this.char = targetCharacter;
			TinyLogManager.log('showCharacter: ' + this.char.name, this);
			
			// Clean up
			if (this.charSprite) {
				this.removeChild(this.charSprite);
			}
			
			// Find battle idle sprite
			var idleLength : int = TinyFriendSprite(this.char.graphics).idleLength;
			var spriteData : BitmapData = TinySpriteConfig.getSpriteSheet(this.char.name.toUpperCase());
			var idleSprite : TinySpriteSheet = TinySpriteSheet.newFromBitmapCopy(spriteData, new Rectangle(0, 480, 120 * idleLength, 120), 120, idleLength, true, 2);
			
			// Show sprite
			this.charSprite = idleSprite;
			this.charSprite.play();
			this.charSprite.x = 18;
			this.charSprite.y = 28;
			this.addChild(this.charSprite);
			
			// Update text
			this.textName.htmlText = TinyFontManager.returnHtmlText(this.char.name, 'dialogText');
			this.textStr.htmlText  = TinyFontManager.returnHtmlText(String(this.char.stats.STR), 'battleItemText');
			this.textDef.htmlText  = TinyFontManager.returnHtmlText(String(this.char.stats.DEF), 'battleItemText');
			this.textAgi.htmlText  = TinyFontManager.returnHtmlText(String(this.char.stats.AGI), 'battleItemText');
			this.textVit.htmlText  = TinyFontManager.returnHtmlText(String(this.char.stats.VIT), 'battleItemText');
			this.textLvl.htmlText  = TinyFontManager.returnHtmlText('Lvl. ' + this.char.stats.LVL, 'battleBoxTitle');
			this.textXP.htmlText   = TinyFontManager.returnHtmlText('XP: '  + this.char.stats.XP,  'battleItemText');
			this.hpText.htmlText   = TinyFontManager.returnHtmlText(String(this.char.stats.HP) + '/' + String(this.char.stats.MHP), 'battleItemText', 'right');
			
			// Update HP bar
			this.hpBarCurrent.graphics.clear();
			this.hpBarCurrent.graphics.beginFill(0);
			this.hpBarCurrent.graphics.drawRect(0, 0, int((this.char.stats.HP / this.char.stats.MHP) * this.hpBarBase.width), 3);
			this.hpBarCurrent.graphics.endFill();
			this.hpBarCurrent.x = this.hpBarBase.x;
			this.hpBarCurrent.y = this.hpBarBase.y;
			
			// Show
			this.visible = true;
		}

		public function hide() : void
		{
			TinyLogManager.log('hide', this);
			this.visible = false;
		}
		
		private function onControlAdded(event : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlAdded', this);			
			// Events
			this.addEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.removeEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.CANCEL, onCancel);
		}
		
		private function onControlRemoved(event : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlRemoved', this);
			
			// Events
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
			this.removeEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.CANCEL, onCancel);
		}

		private function onCancel(event : TinyInputEvent) : void 
		{
			TinyLogManager.log('onCancel', this);
			this.dispatchEvent(new TinyInputEvent(TinyInputEvent.CANCEL));
			
			// Play sound
			TinyAudioManager.play(TinyAudioManager.CANCEL);
		}
	}
}
