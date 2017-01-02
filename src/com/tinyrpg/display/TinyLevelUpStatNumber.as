package com.tinyrpg.display 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;

	import flash.events.Event;
	import flash.display.Sprite;
	import flash.text.TextField;

	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyLevelUpStatNumber extends Sprite 
	{
		private var currentStatNumber : int;
		private var additionalStatNumber : int;
		private var currentStatNumberField : TextField;
		private var plusField : TextField;
		private var additionStatNumberField : TextField;
		
		public var countTime : int = 0;
		public var difference : int = 0;
			
		public function TinyLevelUpStatNumber( currentStatNumber : int, additionalStatNumber : int )
		{
			var width : int = 50;
			
			this.currentStatNumber = currentStatNumber;
			this.additionalStatNumber = additionalStatNumber;
			
			// Make plus sign field
			this.plusField = TinyFontManager.returnTextField();
			this.plusField.htmlText = TinyFontManager.returnHtmlText( '+', 'battleItemHP' );
			this.plusField.x = Math.floor( ( width / 2 ) - ( this.plusField.width / 2 ) );
			
			// Make current stat number field
			this.additionStatNumberField = TinyFontManager.returnTextField( 'right' );
			this.additionStatNumberField.width = Math.floor( ( width  / 2 ) - this.plusField.width );
			this.additionStatNumberField.htmlText = TinyFontManager.returnHtmlText( this.additionalStatNumber.toString(), 'battleItemHP' );
			this.additionStatNumberField.x = this.plusField.x - Math.floor( this.additionStatNumberField.width ) + 3;
			
			// Make additional stat number field
			this.currentStatNumberField = TinyFontManager.returnTextField( 'left' );
			this.currentStatNumberField.width = Math.floor( ( width / 2 ) + this.plusField.width );
			this.currentStatNumberField.htmlText = TinyFontManager.returnHtmlText( this.currentStatNumber.toString(), 'battleItemHP' );
			this.currentStatNumberField.x = this.plusField.x + Math.floor( this.plusField.width / 2 ) + 2;
			
			// If the additional stat number is zero, don't show it
			if ( this.additionalStatNumber == 0 )
			{
				this.plusField.visible = 
				this.additionStatNumberField.visible = false;
			}
			
			// Add 'em up
			this.addChild( this.currentStatNumberField );
			this.addChild( this.plusField );
			this.addChild( this.additionStatNumberField );
		}

		public function playRollup() : void
		{
			TinyLogManager.log('playRollup', this);	
			
			// If the additional stat number is 0, don't bother animating, just finish
			if ( this.additionalStatNumber != 0 )
			{
				// Animate number which is the difference between the left and right numbers. This way only one property needs to be tweened
				TweenLite.to( this, this.additionalStatNumber * 2, { difference: this.additionalStatNumber, useFrames: true, ease: Linear.easeNone, roundProps: [difference], onUpdate: this.onRollupUpdate, onComplete: this.onRollupComplete } );
				this.countTime = this.additionalStatNumber * 2;
			}
			else
			{
				this.onRollupComplete();
			}
		}
		
		private function onRollupUpdate() : void
		{
			var rightNumber : int = this.currentStatNumber + this.difference;
			var leftNumber : int = this.additionalStatNumber - this.difference;
			
			// Update text fields
			this.currentStatNumberField.htmlText = TinyFontManager.returnHtmlText( rightNumber.toString(), 'battleItemHP' );
			this.additionStatNumberField.htmlText = TinyFontManager.returnHtmlText( leftNumber.toString(), 'battleItemHP' );
			
			// If the left number is zero, hide the plus sign and the right number
			if ( leftNumber == 0 )
			{
				this.plusField.visible = 
				this.additionStatNumberField.visible = false; 			
			}
		}
		
		private function onRollupComplete() : void
		{
			TinyLogManager.log('onRollupComplete', this);
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}
