package com.tinyrpg.ui 
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
	public class TinyLevelUpStatsDisplay extends TinyContentBox implements IShowHideObject
	{
		private var mon : TinyMon;
		private var newLevel : int;
		private var initialStats : TinyStatSet;
		private var newStats : TinyStatSet;
		
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
		
		private var container : Sprite;
		private var grewLevelDialog : TinyDialogBox;
			
		public function TinyLevelUpStatsDisplay( mon : TinyMon, newLevel : int, initialStats : TinyStatSet, newStats : TinyStatSet )
		{
			this.mon = mon;
			this.newLevel = newLevel;
			this.initialStats = initialStats;
			this.newStats = newStats;
			
			var width : int = 110;
			var ySpacing : int = 11;
			var numberYOffset : int = 3;
			
			// Make Attack label
			this.attackLabel = TinyFontManager.returnTextField();
			this.attackLabel.x = -1;
			this.attackLabel.y = -4;
			this.attackLabel.htmlText = TinyFontManager.returnHtmlText('ATTACK:', 'dialogText');
			
			// Make Attack value 
			this.attackValue = new TinyLevelUpStatNumber( this.initialStats.attack, this.newStats.attack - this.initialStats.attack );
			this.attackValue.x = Math.floor( width / 2 ) + 8;
			this.attackValue.y = this.attackLabel.y + numberYOffset;
			
			// Make Defense label
			this.defenseLabel = TinyFontManager.returnTextField();
			this.defenseLabel.x = this.attackLabel.x;
			this.defenseLabel.y = this.attackLabel.y + ySpacing;
			this.defenseLabel.htmlText = TinyFontManager.returnHtmlText('DEFENSE:', 'dialogText');
			
			// Make Defense value
			this.defenseValue = new TinyLevelUpStatNumber( this.initialStats.defense, this.newStats.defense - this.initialStats.defense );
			this.defenseValue.x = this.attackValue.x;
			this.defenseValue.y = this.defenseLabel.y + numberYOffset;
			
			// Make Sp. Attack label
			this.spAttackLabel = TinyFontManager.returnTextField();
			this.spAttackLabel.x = this.attackLabel.x;
			this.spAttackLabel.y = this.defenseLabel.y + ySpacing;
			this.spAttackLabel.htmlText = TinyFontManager.returnHtmlText('SP.ATTACK:', 'dialogText');
			
			// Make Sp. Attack value
			this.spAttackValue = new TinyLevelUpStatNumber( this.initialStats.spAttack, this.newStats.spAttack - this.initialStats.spAttack );
			this.spAttackValue.x = this.attackValue.x;
			this.spAttackValue.y = this.spAttackLabel.y + numberYOffset;
			
			// Make Sp. Defense label
			this.spDefenseLabel = TinyFontManager.returnTextField();
			this.spDefenseLabel.x = this.attackLabel.x;
			this.spDefenseLabel.y = this.spAttackLabel.y + ySpacing;
			this.spDefenseLabel.htmlText = TinyFontManager.returnHtmlText('SP.DEFENSE:', 'dialogText');
			
			// Make Sp. Defense value
			this.spDefenseValue = new TinyLevelUpStatNumber( this.initialStats.spDefense, this.newStats.spDefense - this.initialStats.spDefense );
			this.spDefenseValue.x = this.attackValue.x;
			this.spDefenseValue.y = this.spDefenseLabel.y + numberYOffset;
			
			// Make Speed label
			this.speedLabel = TinyFontManager.returnTextField();
			this.speedLabel.x = this.attackLabel.x;
			this.speedLabel.y = this.spDefenseLabel.y + ySpacing;
			this.speedLabel.htmlText = TinyFontManager.returnHtmlText('SPEED:', 'dialogText');
			
			// Make Speed value
			this.speedValue = new TinyLevelUpStatNumber( this.initialStats.speed, this.newStats.speed - this.initialStats.speed);
			this.speedValue.x = this.attackValue.x;
			this.speedValue.y = this.speedLabel.y + numberYOffset;
			
			// Make container
			this.container = new Sprite();
			
			// Make "grew to level" dialog box
			this.grewLevelDialog = TinyDialogBox.newFromString( TinyBattleStrings.getBattleString( TinyBattleStrings.GREW_LEVEL, this.mon, null, null, null, this.newLevel ) );
			
			// Add 'em up
			this.container.addChild( this.attackLabel );
			this.container.addChild( this.attackValue );
			this.container.addChild( this.defenseLabel );
			this.container.addChild( this.defenseValue );
			this.container.addChild( this.spAttackLabel );
			this.container.addChild( this.spAttackValue );
			this.container.addChild( this.spDefenseLabel );
			this.container.addChild( this.spDefenseValue );
			this.container.addChild( this.speedLabel );
			this.container.addChild( this.speedValue );
			this.addChild( this.grewLevelDialog );
			
			super( this.container, width, 56 );
				
			// Move "grew level" dialog lower
			this.grewLevelDialog.y = this.container.height + 4;
			
			// Move stats box over
			this.containerBox.x = this.grewLevelDialog.width - this.containerBox.width;
			this.content.x = this.containerBox.x;
		}
		
		public function show() : void
		{
			TinyLogManager.log('show', this);
			this.visible = true;
			
			// Give control to the dialog box	
			TinyInputManager.getInstance().setTarget( this.grewLevelDialog );
			this.grewLevelDialog.addEventListener( Event.COMPLETE, this.onDialogComplete );
			this.grewLevelDialog.show(); 
		}

		public function hide() : void
		{
			TinyLogManager.log('hide', this);
			this.visible = false;	
		}
		
		private function onDialogComplete( event : Event ) : void
		{
			TinyLogManager.log('onDialogComplete', this);
			
			// Clean up
			this.grewLevelDialog.removeEventListener( Event.COMPLETE, this.onDialogComplete );
			
			// Listen for complete event from the last item in the sequence
			this.speedValue.addEventListener( Event.COMPLETE, this.onRollupComplete );
			
			var countIncrement : int = 2;
			var countTimes : Array = [];
			
			// Increment all the stat numbers
			TweenLite.delayedCall( countIncrement * 0, this.attackValue.playRollup, null, true );
			TweenLite.delayedCall( countIncrement * 1, this.defenseValue.playRollup, null, true );
			TweenLite.delayedCall( countIncrement * 2, this.spAttackValue.playRollup, null, true );
			TweenLite.delayedCall( countIncrement * 3, this.spDefenseValue.playRollup, null, true );
			TweenLite.delayedCall( countIncrement * 4, this.speedValue.playRollup, null, true );
			
			countTimes.push( this.attackValue.countTime );
			countTimes.push( this.defenseValue.countTime );
			countTimes.push( this.spAttackValue.countTime );
			countTimes.push( this.spDefenseValue.countTime );
			countTimes.push( this.speedValue.countTime );
			
			// Find which counter takes the longest to complete
			var maxCountTime : int = 0;
			for each ( var countTime : int in countTimes )
 			{
				if ( countTime > maxCountTime ) maxCountTime = countTime;
			}
			
			// Delay completion until the longest counter is done
			TweenLite.delayedCall( maxCountTime + countIncrement * 4, this.onRollupComplete, null, true );
		}
		
		private function onRollupComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onRollupComplete', this);
			
			// Clean up
			this.speedValue.removeEventListener( Event.COMPLETE, this.onRollupComplete );
			
			// Listen for next complete event from the "grew level" dialog
			this.grewLevelDialog.addEventListener( Event.COMPLETE, this.onPostRollupDialogComplete );
		}
		
		private function onPostRollupDialogComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onPostRollupDialogComplete', this);
			
			// Clean up
			this.grewLevelDialog.removeEventListener( Event.COMPLETE, this.onPostRollupDialogComplete );
			
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}
