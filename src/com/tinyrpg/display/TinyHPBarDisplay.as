package com.tinyrpg.display 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.RoundPropsPlugin;
	
	import com.tinyrpg.utils.TinyColor;
	import com.tinyrpg.utils.TinyMath;
	
	import flash.display.Sprite;

	/**
	 * Display class which provides a 3-color health bar.
	 * 
	 * As HP decreases, the color changes from green, to yellow, to red. 
	 * Used in {@link TinyBattleMonStatDisplay}.
	 * 
	 * @author jeremyabel
	 */
	public class TinyHPBarDisplay extends Sprite 
	{
		private var barWidth : int;
		private var barContainer : Sprite;
		private var greenBar : Sprite;
		private var yellowBar : Sprite;
		private var redBar : Sprite;
		private var redColor : TinyColor;
		private var yellowColor : TinyColor;
		private var greenColor : TinyColor;
		
		public var color : TinyColor;
		
		private const GREEN_COLOR	: uint = 0x00B800;
		private const YELLOW_COLOR	: uint = 0xF8A800;
		private const RED_COLOR		: uint = 0xF80000; 
		
		public function TinyHPBarDisplay( width : int )
		{
			TweenPlugin.activate( [ RoundPropsPlugin ] );
			
			this.barWidth = width;
			
			// Make colors
			this.redColor = TinyColor.newFromHex( RED_COLOR );
			this.yellowColor = TinyColor.newFromHex( YELLOW_COLOR );
			this.greenColor = TinyColor.newFromHex( GREEN_COLOR );
			this.color = this.greenColor;
			
			// Make green hp bar sprite
			this.greenBar = new Sprite();
			this.greenBar.graphics.beginFill(this.GREEN_COLOR);
			this.greenBar.graphics.drawRect(0, 0, 1, 2);
			this.greenBar.graphics.endFill();
			
			// Make yellow hp bar sprite
			this.yellowBar = new Sprite();
			this.yellowBar.graphics.beginFill(this.YELLOW_COLOR);
			this.yellowBar.graphics.drawRect(0, 0, 1, 2);
			this.yellowBar.graphics.endFill();
			
			// Make red hp bar sprite
			this.redBar = new Sprite();
			this.redBar.graphics.beginFill(this.RED_COLOR);
			this.redBar.graphics.drawRect(0, 0, 1, 2);
			this.redBar.graphics.endFill();
			
			// Make bar container
			this.barContainer = new Sprite();
			this.barContainer.addChild(this.greenBar);
			this.barContainer.addChild(this.yellowBar);
			this.barContainer.addChild(this.redBar);
			this.barContainer.scaleX = this.barWidth;
			this.addChild(this.barContainer);
		}

		/**
		 * Sets the width ratio of the bar, from 0..1. By default the bar is set immediately, 
		 * but can be tweened by setting the second parameter. The color of the bar will
		 * automatically be updated based on the ratio given.
		 */
		public function setRatio( ratio : Number, tween : Boolean = false ) : void
		{
			if ( tween )
			{
				TweenLite.to( this.barContainer, 8, {
					scaleX: Math.floor( ratio * this.barWidth ),
					ease: Linear.easeNone, 
					useFrames: true,
					roundProps:  [ 'scaleX' ]
				});
			}
			else
			{
				this.barContainer.scaleX = Math.floor(ratio * this.barWidth);
			}
			
			// Below 10%, the bar is red
			if (this.barContainer.scaleX <= 10) 
			{
				this.setVisibleBar( this.redBar );
				this.color = this.redColor;
			} 
			// Below 24%, the bar is yellow
			else if (this.barContainer.scaleX <= 24) 
			{
				this.setVisibleBar(this.yellowBar);
				this.color = this.yellowColor;
			} 
			// Otherwise, the bar is green
			else 
			{
				this.setVisibleBar(this.greenBar);
				this.color = this.greenColor;
			}
		}
		
		private function setVisibleBar( barSprite : Sprite ) : void
		{
			this.greenBar.visible = 
			this.yellowBar.visible = 
			this.redBar.visible = false;
			
			barSprite.visible = true;
		}
	}
}
