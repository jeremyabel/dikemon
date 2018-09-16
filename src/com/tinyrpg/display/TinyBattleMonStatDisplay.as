package com.tinyrpg.display 
{

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.display.status.icons.*;
	import com.tinyrpg.display.PlayerStatsContainer;
	import com.tinyrpg.display.EnemyStatsContainer;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyColor;
	import com.tinyrpg.utils.TinyFourColorPalette;
	import com.tinyrpg.utils.TinyMath;

	/**
	 * Display class for the indiviual mon stat display used during battle.
	 * 
	 * For the player, the stat display shows the current mon's name, current / max HP, EXP, level, 
	 * and status-effect information. The enemy's stat display only shows their HP as a bar, 
	 * along with their level. 
	 * 
	 * @author jeremyabel
	 */
	public class TinyBattleMonStatDisplay extends Sprite implements IShowHideObject
	{
		private var mon : TinyMon;
		private var isEnemy : Boolean;
		private var statsContainer : Bitmap;
		private var nameField : TextField; 
		private var levelField : TextField;
		private var hpField : TextField;
		private var hpBarDisplay : TinyHPBarDisplay;
		private var expBarSprite : Sprite;
		private var initialMonLevel : int;
		private var statusIconContainer : Sprite;
		private var statusIconBitmap : Bitmap = null;
		
		public var displayedCurrentHP : Number = 0;
		
		/**
		 * @param	isEnemy		Whether or not the stat display should be formatted for the enemy or not.
		 * 						The enemy display contains less info than the player display.
		 */
		public function TinyBattleMonStatDisplay( isEnemy : Boolean )
		{
			this.isEnemy = isEnemy;
			
			// Make stat container graphic
			this.statsContainer = new Bitmap( this.isEnemy? new EnemyStatsContainer : new PlayerStatsContainer );		
			
			// Make name textfield
			this.nameField = TinyFontManager.returnTextField('none');
			this.nameField.width = this.statsContainer.width;
			this.nameField.x = this.isEnemy ? -2 : 3;
			
			// Make level textfield
			this.levelField = TinyFontManager.returnTextField('none');
			this.levelField.width = this.statsContainer.width;
			this.levelField.x = this.isEnemy ? -1 : 2;
			this.levelField.y = 10;
			
			// Make HP textfield
			this.hpField = TinyFontManager.returnTextField('none');
			this.hpField.width = this.statsContainer.width;
			this.hpField.x = -4;
			this.hpField.y = 25;
			this.hpField.visible = !this.isEnemy;
			
			this.statsContainer.y = this.isEnemy ? 21 : 20;

			// Make HP bar sprite
			this.hpBarDisplay = new TinyHPBarDisplay( 48 );
			this.hpBarDisplay.x = this.isEnemy ? 23 : 24;
			this.hpBarDisplay.y = this.statsContainer.y + 2;
			
			// Make EXP bar sprite
			this.expBarSprite = new Sprite();
			this.expBarSprite.graphics.beginFill(0x2088F8);
			this.expBarSprite.graphics.drawRect(0, 0, 1, 2);
			this.expBarSprite.graphics.endFill();
			this.expBarSprite.scaleX = 0;
			this.expBarSprite.x = this.statsContainer.width - 7;
			this.expBarSprite.y = this.statsContainer.y + 16;
			this.expBarSprite.visible = !this.isEnemy;
			
			// Make status icon container
			this.statusIconContainer = new Sprite();
			this.statusIconContainer.x = this.isEnemy ? this.hpBarDisplay.x + this.hpBarDisplay.width + 6 : 1;
			this.statusIconContainer.y = this.hpBarDisplay.y - 2;
			
			// Add 'em up
			this.addChild( this.statsContainer );
			this.addChild( this.nameField );
			this.addChild( this.levelField );
			this.addChild( this.hpField );
			this.addChild( this.hpBarDisplay );
			this.addChild( this.expBarSprite );
			this.addChild( this.statusIconContainer );
		}
		
		/**
		 * Returns the four-color palette for this display.
		 * Used for color shifting move FX.
		 */
		public function get palette() : TinyFourColorPalette
		{
			var color1 : TinyColor = new TinyColor( 0, 0, 0 );
			var color2 : TinyColor = this.hpBarDisplay.color;
			var color3 : TinyColor = new TinyColor( 239, 207, 126 );
			var color4 : TinyColor = new TinyColor( 255, 255, 255 );
			
			return new TinyFourColorPalette( color1, color2, color3, color4 );
		}
		
		/**
		 * Sets the info shown in the status bar to match a given mon.
		 */
		public function setCurrentMon( mon : TinyMon ) : void
		{
			this.mon = mon;
			TinyLogManager.log('setCurrentMon: ' + this.mon.name + ', ' + (this.isEnemy ? 'Enemy' : 'Player'), this);
			
			// Copy the mon's current level when it is set. The "grew a level" dialog happens for each single level up, 
			// so store the original value so that it can be incremented by one for each new level,
			// instead of just updating all at once, in case there are multiple level-ups.
			this.initialMonLevel = TinyMath.deepCopyInt( this.mon.level );
			
			// Set name, level, and HP labels
			this.nameField.htmlText = TinyFontManager.returnHtmlText( this.mon.name.toUpperCase(), 'selecterText', this.isEnemy ? 'left' : 'right' );	
			this.levelField.htmlText = TinyFontManager.returnHtmlText( 'LV: ' + this.mon.level, 'battleBoxTitle', this.isEnemy ? 'left' : 'right' );
			this.hpField.htmlText = TinyFontManager.returnHtmlText( this.mon.currentHP + '/' + this.mon.maxHP, 'battleItemHP', 'right');
			
			this.displayedCurrentHP = this.mon.currentHP;
			
			// Set hp and exp bar lengths
			this.hpBarDisplay.setRatio( this.mon.currentHP / this.mon.maxHP );
			
			// Update the status icon
			this.updateStatusIcon();
		}

		/**
		 * Sets the status display as visible.
		 */
		public function show() : void
		{
			TinyLogManager.log("show: " + (this.isEnemy ? 'Enemy' : 'Player'), this);	
			this.visible = true;
		}
		
		/**
		 * Sets the status display as hidden.
		 */
		public function hide() : void
		{
			TinyLogManager.log("hide: " + (this.isEnemy ? 'Enemy' : 'Player'), this);
			this.visible = false;	
		}
		
		public function incrementLevelDisplay() : void
		{
			// TODO: Implement??
//			TinyLogManager.log('incrementLevelDisplay', this);
			
//			this.initialMonLevel++;
//			this.levelField.htmlText = TinyFontManager.returnHtmlText( 'LV: ' + this.initialMonLevel, 'battleBoxTitle', this.isEnemy ? 'left' : 'right' );
		}
		
		/**
		 * Updates the status effect icon display. 
		 * If the mon has no status effect, the icon will be removed.
		 */
		public function updateStatusIcon() : void
		{
			TinyLogManager.log( "update Status: " + (this.isEnemy ? 'Enemy' : 'Player'), this );
			
			// Remove previous icon bitmap, if there is one
			if ( this.statusIconBitmap )
			{
				this.statusIconContainer.removeChild( this.statusIconBitmap );
				this.statusIconBitmap = null;
			}
			
			// Add new icon, if required
			if ( !this.mon.isRegularStatus )
			{
				if ( this.mon.isBurned ) 	this.statusIconBitmap = new Bitmap( new IconBurn() );
				if ( this.mon.isConfused ) 	this.statusIconBitmap = new Bitmap( new IconConfusion() );
				if ( this.mon.isSleeping ) 	this.statusIconBitmap = new Bitmap( new IconSleep() );
				if ( this.mon.isParalyzed ) this.statusIconBitmap = new Bitmap( new IconParalysis() );
				if ( this.mon.isPoisoned ) 	this.statusIconBitmap = new Bitmap( new IconPoison() ); 
				
				this.statusIconContainer.addChild( this.statusIconBitmap );
			}
		}
		
		/**
		 * Updates the HP bar to a given value.
		 * 
		 * @param 	value		The value to update to.
		 * @param	highSpeed	Whether or not to animate the bar at double speed.
		 */
		public function updateHP( value : int, highSpeed : Boolean = false ) : void
		{
			TinyLogManager.log( "update HP: " + (this.isEnemy ? 'Enemy' : 'Player'), this );
			
			this.updateStatusIcon();
			
			// Only start the tween if animation is necessary
			if ( this.displayedCurrentHP != this.mon.currentHP )
			{
				// Scale the tween duration by the change in HP so that the speed is constant
				var deltaHP : Number = Math.abs( value - this.displayedCurrentHP ) / this.mon.maxHP;
				var tweenTime : Number = deltaHP * ( highSpeed ? 0.5 : 1.0 );
				
				TweenLite.to( this, tweenTime, { 
					displayedCurrentHP: value, 
					ease: Linear.easeNone, 
					onUpdate: this.onUpdateHPTweenUpdate, 
					onComplete: this.onUpdateHPComplete 
				});				
			}
			else
			{
				this.onUpdateHPComplete();
			}
		}
		
		/**
		 * Listener which is called each frame as the HP bar tween is updated.
		 * Updates both the bar display and the text display simultaniously.
		 */
		private function onUpdateHPTweenUpdate() : void
		{
			// Update HP bar and text displays
			this.hpBarDisplay.setRatio( this.displayedCurrentHP / Number( this.mon.maxHP ) );
			this.hpField.htmlText = TinyFontManager.returnHtmlText( Math.ceil( displayedCurrentHP ) + '/' + this.mon.maxHP, 'battleItemHP', 'right');
		}

		/**
		 * Listener which is called when the HP bar tween is complete.
		 */
		private function onUpdateHPComplete() : void
		{
			TinyLogManager.log( "onUpdateHPComplete: " + (this.isEnemy ? 'Enemy' : 'Player'), this );
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		/**
		 * Animates the EXP bar to the mon's latest currentEXP value. 
		 */
		public function updateEXP( toFull : Boolean = false ) : void
		{
			TinyLogManager.log( "update EXP: " + (this.isEnemy ? 'Enemy' : 'Player'), this );
			
			var x : int = toFull ? 64 : Math.floor( ( Math.min( 1.0, this.mon.currentEXP / this.mon.getEXPForNextLevel() ) ) * 64 );
			
			// Scale the tween duration by the change in EXP so that the speed is constant
			var deltaX : Number = Math.abs( x - this.expBarSprite.scaleX ) / 64;
			var tweenTime : Number = deltaX;
			
			TweenLite.to( this.expBarSprite, tweenTime, { 
				scaleX: -x, 
				roundProps: ['scaleX'], 
				ease: Linear.easeNone, 
				onComplete: this.onUpdateEXPComplete
			});
		}
		
		/**
		 * Listener which is called when the EXP bar tween is complete.
		 */
		private function onUpdateEXPComplete() : void
		{
			TinyLogManager.log("onUpdateEXPComplete: " + (this.isEnemy ? 'Enemy' : 'Player'), this);
			this.dispatchEvent( new Event( Event.COMPLETE ) );		
		}
		
		/**
		 * Instantly clears the EXP bar.
		 * Called by the battle event sequencer in a level-up sequence created by {@link TinyLevelUpSequencer}. 
		 */
		public function clearEXPBar() : void
		{
			TinyLogManager.log('clearEXPBar', this);
			this.expBarSprite.scaleX = 0;
		}
	}
}
