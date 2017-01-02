package com.tinyrpg.display 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.misc.TinySpriteConfig;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author jeremyabel
	 */
	public class TinyQuickStats extends TinySelectableItem 
	{
		private var portrait 	 : Sprite;
		private var level	 	 : TextField;
		private var hpText 	 	 : TextField;
		private var hpTitle	 	 : TextField;
		private var hpBarBase 	 : Sprite;
		private var hpBarCurrent : Sprite;
		private var char	 	 : TinyStatsEntity;
		private var hpFollower   : Sprite;

		public function TinyQuickStats(targetChar : TinyStatsEntity) : void
		{
			this.char = targetChar;
			super(this.char.name, this.char.idNumber);
			
			// Change name color if character is dead
			if (this.char.dead) {
				this.itemText.textColor = 0xEC2327;
			}
			
			// Get character portrait
			var spriteData : BitmapData = TinySpriteConfig.getSpriteSheet(this.char.name);
			var portraitSize : Point = new Point(19, 20);
			var newData	: BitmapData = new BitmapData(portraitSize.x, portraitSize.y);
			if (this.char.name.toUpperCase() != 'FISH') {
				newData.copyPixels(spriteData, new Rectangle(50, 392, portraitSize.x, portraitSize.y), new Point(0, 0));			} else {
				newData.copyPixels(spriteData, new Rectangle(50, 530, portraitSize.x, portraitSize.y), new Point(0, 0));
			}
		
			// Position portrait
			this.portrait = new Sprite;
			this.portrait.x = -15;
			this.portrait.y = 1;
			this.portrait.addChild(new Bitmap(newData));
			
			// Level number
			this.level = TinyFontManager.returnTextField();
			this.level.htmlText = TinyFontManager.returnHtmlText('Lv. ' + this.char.stats.LVL, 'battleBoxTitle');
			this.level.x = 6;
			this.level.y = 11;
			
			// HP text
			this.hpText = TinyFontManager.returnTextField("right");	
			this.hpText.htmlText = TinyFontManager.returnHtmlText(String(this.char.stats.HP) + "/" + String(this.char.stats.MHP), "battleItemText", "right");
			this.hpText.x = 53;
			this.hpText.y = 8;
			
			// HP title
			this.hpTitle = TinyFontManager.returnTextField();
			this.hpTitle.htmlText = TinyFontManager.returnHtmlText('HP:', 'battleBoxTitle');
			this.hpTitle.x = 46;
			this.hpTitle.y = 1;

			// HP bar - base
			this.hpBarBase = new Sprite;
			this.hpBarBase.graphics.beginFill(0xEC2327);
			this.hpBarBase.graphics.drawRect(0, 0, 40, 3);
			this.hpBarBase.graphics.endFill();
			this.hpBarBase.x = this.hpTitle.x + 1;
			this.hpBarBase.y = 17;
			
			// HP bar - current
			this.hpBarCurrent = new Sprite;
			this.hpBarCurrent.graphics.beginFill(0x000000);
			this.hpBarCurrent.graphics.drawRect(0, 0, int((this.char.stats.HP / this.char.stats.MHP) * this.hpBarBase.width), 3);
			this.hpBarCurrent.graphics.endFill();
			this.hpBarCurrent.x = this.hpBarBase.x;
			this.hpBarCurrent.y = this.hpBarBase.y;
			
			// HP follower
			this.hpFollower = new Sprite;
			this.hpFollower.x = this.char.stats.HP;
			
			// Add 'em up
			this.addChild(this.portrait);
			this.addChild(this.level);
			this.addChild(this.hpText);
			this.addChild(this.hpTitle);
			this.addChild(this.hpBarBase);
			this.addChild(this.hpBarCurrent);
		}
		
		override public function set autoSelected(value : Boolean) : void
		{
			//TinyLogManager.log(this.textString + ' auto selected: ' + value, this);
			this.selectArrow.visible = value;
			//this.selectArrow.x = value ? 8 : 6;
			MovieClip(this.selectArrow).gotoAndStop('autoselect');
		}

		public function update() : void 
		{
			TinyLogManager.log('update', this);
			
			// Difference in HP. Absolute value is for both damage and healing
			var deltaHP : int = Math.abs(this.char.stats.previousHP - this.char.stats.HP) + 1;
			
			// Overheal!
			if (this.char.stats.HP > this.char.stats.MHP) {
				this.char.stats.HP = this.char.stats.MHP;
			}
			
			// Nothing has changed...
			if (deltaHP == 0) 
				return;
				
			// Update HP text
			TweenLite.to(this.hpFollower, TinyMath.map(deltaHP, 1, this.char.stats.MHP, 1, 50), { x:this.char.stats.HP, onUpdate:updateHPTextNumber, useFrames:true, ease:Circ.easeOut });	
			
			// Update HP bar
			var newWidth : int = ((this.char.stats.HP / this.char.stats.MHP) * this.hpBarBase.width);
			TweenLite.to(this.hpBarCurrent, TinyMath.map(deltaHP, 1, this.char.stats.MHP, 1, 50), { width: newWidth, useFrames: true, ease: Circ.easeOut });
		}
		
		private function updateHPTextNumber() : void
		{
			 this.hpText.htmlText = TinyFontManager.returnHtmlText(String(int(this.hpFollower.x)) + "/" + String(this.char.stats.MHP), "battleItemText");
			
			// Keep number text red if dead
			if (this.char.stats.HP <= 0 ) {
				this.hpText.textColor = 0xEC2327;
			}
		}
	}
}
