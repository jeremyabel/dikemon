package com.tinyrpg.display 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	import com.greensock.TweenLite;
	
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.battle.TinyBattleStrings;
	import com.tinyrpg.display.IShowHideObject;
	import com.tinyrpg.display.TinyContentBox;
	import com.tinyrpg.display.TinyLevelUpStatNumber;
	import com.tinyrpg.data.TinyStatSet;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyStatsDisplay extends TinyContentBox implements IShowHideObject
	{
		private var mon : TinyMon;
		
		private var attackLabel : TextField;
		public var attackValue : TinyLevelUpStatNumber; 
		
		private var defenseLabel : TextField;
		public var defenseValue : TinyLevelUpStatNumber;
		
		private var spAttackLabel : TextField;
		public var spAttackValue : TinyLevelUpStatNumber;
		
		private var spDefenseLabel : TextField;
		public var spDefenseValue : TinyLevelUpStatNumber;
		
		private var speedLabel : TextField;
		public var speedValue : TinyLevelUpStatNumber;
		
		private var hasPopulatedStats : Boolean = false;
		private var container : Sprite;
	
		private var ySpacing : int = 11;
		private var panelWidth : int = 82;
		private var numberYOffset : int = 3;
			
		public function TinyStatsDisplay( mon : TinyMon = null )
		{			
			// Make Attack label
			this.attackLabel = TinyFontManager.returnTextField();
			this.attackLabel.x = -1;
			this.attackLabel.y = -4;
			this.attackLabel.htmlText = TinyFontManager.returnHtmlText('ATTACK:', 'dialogText');
			
			// Make Defense label
			this.defenseLabel = TinyFontManager.returnTextField();
			this.defenseLabel.x = this.attackLabel.x;
			this.defenseLabel.y = this.attackLabel.y + this.ySpacing;
			this.defenseLabel.htmlText = TinyFontManager.returnHtmlText('DEFENSE:', 'dialogText');
			
			// Make Sp. Attack label
			this.spAttackLabel = TinyFontManager.returnTextField();
			this.spAttackLabel.x = this.attackLabel.x;
			this.spAttackLabel.y = this.defenseLabel.y + this.ySpacing;
			this.spAttackLabel.htmlText = TinyFontManager.returnHtmlText('SP.ATTACK:', 'dialogText');
			
			// Make Sp. Defense label
			this.spDefenseLabel = TinyFontManager.returnTextField();
			this.spDefenseLabel.x = this.attackLabel.x;
			this.spDefenseLabel.y = this.spAttackLabel.y + this.ySpacing;
			this.spDefenseLabel.htmlText = TinyFontManager.returnHtmlText('SP.DEFENSE:', 'dialogText');
			
			// Make Speed label
			this.speedLabel = TinyFontManager.returnTextField();
			this.speedLabel.x = this.attackLabel.x;
			this.speedLabel.y = this.spDefenseLabel.y + this.ySpacing;
			this.speedLabel.htmlText = TinyFontManager.returnHtmlText('SPEED:', 'dialogText');
			
			// Make container
			this.container = new Sprite();

			// Add 'em up
			this.container.addChild( this.attackLabel );
			this.container.addChild( this.defenseLabel );
			this.container.addChild( this.spAttackLabel );
			this.container.addChild( this.spDefenseLabel );
			this.container.addChild( this.speedLabel );
			
			super( this.container, this.panelWidth, 56 );
				
			// Populate stats if a mon is provided
			if ( mon ) this.setCurrentMon( mon ); 
		}
		
		public function setCurrentMon( mon : TinyMon ) : void 
		{
			this.mon = mon;
			TinyLogManager.log('set currentMon: ' + this.mon.name, this);
			
			// Remove old stat values
			if ( this.hasPopulatedStats ) 
			{
				this.container.removeChild( this.attackValue );
				this.container.removeChild( this.defenseValue );
				this.container.removeChild( this.spAttackValue );
				this.container.removeChild( this.spDefenseValue );
				this.container.removeChild( this.speedValue );
			}	
			
			// Make Attack value 
			this.attackValue = new TinyLevelUpStatNumber( this.mon.attack );
			this.attackValue.x = Math.floor( this.panelWidth / 2 );
			this.attackValue.y = this.attackLabel.y + this.numberYOffset;
			
			// Make Defense value
			this.defenseValue = new TinyLevelUpStatNumber( this.mon.defense );
			this.defenseValue.x = this.attackValue.x;
			this.defenseValue.y = this.defenseLabel.y + this.numberYOffset;
			
			// Make Sp. Attack value
			this.spAttackValue = new TinyLevelUpStatNumber( this.mon.spAttack );
			this.spAttackValue.x = this.attackValue.x;
			this.spAttackValue.y = this.spAttackLabel.y + this.numberYOffset;
			
			// Make Sp. Defense value
			this.spDefenseValue = new TinyLevelUpStatNumber( this.mon.spDefense );
			this.spDefenseValue.x = this.attackValue.x;
			this.spDefenseValue.y = this.spDefenseLabel.y + this.numberYOffset;
			
			// Make Speed value
			this.speedValue = new TinyLevelUpStatNumber( this.mon.speed );
			this.speedValue.x = this.attackValue.x;
			this.speedValue.y = this.speedLabel.y + this.numberYOffset;
			
			// Add 'em up
			this.container.addChild( this.attackValue );
			this.container.addChild( this.defenseValue );
			this.container.addChild( this.spAttackValue );
			this.container.addChild( this.spDefenseValue );
			this.container.addChild( this.speedValue );
			
			this.hasPopulatedStats = true;
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
	}
}
