package com.tinyrpg.display 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.RoundPropsPlugin;

	import flash.display.Bitmap;
	import flash.text.TextField;
	
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.display.TinyPartyMonSprite;
	import com.tinyrpg.display.TinyHPBarDisplay;
	import com.tinyrpg.display.misc.MonPartyHPBar;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinySelectableMonItem extends TinySelectableItem 
	{
		public var mon : TinyMon;
		
		private var monIcon : TinyPartyMonSprite;
		private var iconJumpTween : TweenMax;
		private var hpBarContainer : Bitmap;
		private var hpBarDisplay : TinyHPBarDisplay;
		private var hpField : TextField;
		private var levelField : TextField;
		
		private const MON_ICON_Y_OFFSET : int = 9;
		
		public function TinySelectableMonItem( mon : TinyMon, idNumber : int = 0 )
		{
			TweenPlugin.activate([RoundPropsPlugin]);

			this.mon = mon;
			
			// Make mon icon
			this.monIcon = new TinyPartyMonSprite( 10 );
			this.monIcon.x = 8 + 8 + 1;
			this.monIcon.y = MON_ICON_Y_OFFSET;
			this.monIcon.play( 10 );
						
			// Make selection jump tween
			this.iconJumpTween = new TweenMax( this.monIcon, 0.3, { y:"-2", ease: Linear.easeNone, roundProps: ['y'], paused: true, yoyo: true, repeat: -1 } );			
			
			// Make HP bar container
			this.hpBarContainer = new Bitmap( new MonPartyHPBar );
			this.hpBarContainer.x = (144 - this.hpBarContainer.width) + 1;
			this.hpBarContainer.y = 11;
			
			// Make HP bar display
			this.hpBarDisplay = new TinyHPBarDisplay( 48 );
			this.hpBarDisplay.x = this.hpBarContainer.x + 16;
			this.hpBarDisplay.y = this.hpBarContainer.y + 2;
			
			// Make HP text display
			this.hpField = TinyFontManager.returnTextField( 'none' );
			this.hpField.width = 144;
			this.hpField.x = 3;
			this.hpField.y = 1;
			
			// Make level text display
			this.levelField = TinyFontManager.returnTextField();
			this.levelField.x = (this.hpBarContainer.x - this.levelField.width) + 1;
			this.levelField.y = this.hpBarContainer.y - 4;
			
			// Populate initial data
			this.update(); 
						
			// Add 'em up
			this.addChild( this.monIcon );
			this.addChild( this.hpBarContainer );
			this.addChild( this.hpBarDisplay );
			this.addChild( this.hpField );
			this.addChild( this.levelField );

			// Make the rest of the stuff
			super( this.mon.name.toUpperCase(), idNumber );
			
			// Realign main item text
			this.itemText.x += this.monIcon.x + 3;
			this.itemText.y -= 3;
		}
		
		override public function set selected(value : Boolean) : void
		{
			super.selected = value;
			
			if (value) 
			{
				this.monIcon.y = MON_ICON_Y_OFFSET;
				this.iconJumpTween.restart();
				this.iconJumpTween.play();
			} 
			else
			{
				this.iconJumpTween.pause();
				this.monIcon.y = MON_ICON_Y_OFFSET;	
			}
		}
		
		public function update() : void
		{
			TinyLogManager.log('update: ' + this.mon.name, this);
			
			// Update HP field
			this.hpField.htmlText = TinyFontManager.returnHtmlText( this.mon.currentHP + '/' + this.mon.maxHP, 'battleItemHP', 'right' );
			
			// Update level field
			this.levelField.htmlText = TinyFontManager.returnHtmlText( 'LV: ' + this.mon.level, 'battleLevelText', 'right' );
			this.levelField.x = (this.hpBarContainer.x - this.levelField.width) + 1;
			
			// Update HP bar
			this.hpBarDisplay.setRatio( this.mon.currentHP / this.mon.maxHP );	
		}
	}
}