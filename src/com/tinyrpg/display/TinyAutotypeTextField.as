package com.tinyrpg.display 
{
	import com.greensock.TweenLite;
	
	import com.tinyrpg.events.TinyAutotypeTextEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author jeremyabel
	 */
	public class TinyAutotypeTextField extends Sprite 
	{
		private var text				: String;
		private var textField 			: TextField;
		private var textMask  			: Sprite;
		private var styleClass			: String;
		private var lineMasks			: Array = []; 
		private var currentLineIndex	: int = 0;
		private var frameCount 			: int = 0;
		private var maxLinesAtOnce 		: int = 3;
		private var numCharsToPrint		: uint = 0; 
		private var printingEnabled		: Boolean = false;
		private var textBeepEnabled 	: Boolean = true;
		
		public var originalY			: int;
		public var fastText				: Boolean = false;
		
		public const CHAR_W 			: uint = 6;
		public const CHAR_H 			: uint = 11;
		
		public function TinyAutotypeTextField( width : int, height : int, styleClass : String, maxLinesAtOnce : int = 3 )
		{
			// Set properties
			this.styleClass = styleClass;
			this.maxLinesAtOnce = maxLinesAtOnce;
			
			// Text field
			this.textField = TinyFontManager.returnTextField( 'left', false, true, true );
			this.textField.width = width;
			this.textField.height = height;
			
			// Text field mask container
			this.textMask = new Sprite;
//			this.textMask.alpha = 0.6;
			
			// Set mask
			this.textMask.cacheAsBitmap = 
			this.textField.cacheAsBitmap = true;
			this.textField.mask = this.textMask;
			
			// Add 'em up
			this.addChild( this.textField );
			this.addChild( this.textMask );
		}
		
		public function setText( text : String, noBeep : Boolean = false ) : void
		{
			this.text = text;
			TinyLogManager.log( 'setText: ' + this.text, this );
			
			if ( this.text == '' ) return; 
			
			this.textBeepEnabled = !noBeep;
			this.textField.htmlText += TinyFontManager.returnHtmlText( this.text, this.styleClass, 'left', true );
			
			// Set up mask objects for each line
			for ( var i : uint = 0; i < this.textField.numLines; i++ )
			{
				var newLineMask : TinyAutotypeLineMask = new TinyAutotypeLineMask( this.textField.getLineLength( i ), CHAR_W, CHAR_H );
				newLineMask.addEventListener( TinyAutotypeTextEvent.LINE_COMPLETE, this.onLineMaskComplete );
				newLineMask.x = 2;
				newLineMask.y = i * CHAR_H + ( CHAR_H / 2 );
				
				this.lineMasks.push( newLineMask );
				this.textMask.addChild( newLineMask );
			}
			
			this.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		public function clear() : void
		{
			TinyLogManager.log('clear', this);
			
			this.currentLineIndex = 0;
			this.frameCount = 0;
			this.lineMasks = [];
			this.textField.htmlText = '';
			this.y = TinyMath.deepCopyInt( this.originalY );
			
			while ( this.textMask.numChildren ) this.textMask.removeChildAt( 0 );
		}
		
		public function printNumberOfChars( numChars : uint ) 
		{
			TinyLogManager.log( 'printCharacters: ' + numChars, this );
			
			// Complete instantly if no characters need to be printed
			if ( numChars <= 0 ) 
			{
				this.dispatchEvent( new TinyAutotypeTextEvent( TinyAutotypeTextEvent.TEXT_ENTRY_COMPLETE ) );
				return;
			}
			
			this.numCharsToPrint = numChars;
			this.enablePrinting();	
		}
		
		public function enablePrinting() : void
		{
			TinyLogManager.log( 'enablePrinting', this );
			this.printingEnabled = true;
		}
		
		public function disablePrinting() : void
		{
			TinyLogManager.log( 'disablePrinting', this );
			this.printingEnabled = false;
		}

		public function onEnterFrame( event : Event ) : void
		{
			if ( !this.printingEnabled ) return;
			
			// Skip every other frame unless fast text is active
			this.frameCount++;
			if ( this.frameCount % 2 != 0 && !this.fastText ) return;
			
			this.numCharsToPrint--;
			
			var currentLineMask : TinyAutotypeLineMask = this.lineMasks[ this.currentLineIndex ];
			var currentLineOffset : uint =  this.textField.getLineOffset( this.currentLineIndex );
			var currentCharIndex : uint = currentLineOffset + currentLineMask.charIndex;
			
			// Get the code number for the last character in the current line
			var lastCharIndexInCurrentLine : uint = currentLineOffset + this.textField.getLineLength( this.currentLineIndex ) - 1;
			var lastCharCodeInCurrentLine : uint = this.textField.text.charAt( lastCharIndexInCurrentLine ).charCodeAt( 0 );
			
			// When a textfield needs to break the text to fit the field's width, it inserts a newline character at that point in the line.
			// However, the textfield's character count does not reflect this added newline character, so we need to compensate for this 
			// extra character that is not accounted for in the numCharsToPrint variable. Therefore, if the current character index is at 
			// the end of the current line, and that character matches the code for a newline, advance the mask twice instead of once.   
			if ( currentCharIndex == lastCharIndexInCurrentLine && lastCharCodeInCurrentLine == 32 ) 
			{
				currentLineMask.showNextChar();
			}
			
			currentLineMask.showNextChar();
			
			// Play a little blippy sound on non-whitespace characters. If fast text is active, the blip is played every other frame.
			if ( this.textField.text.charAt( currentCharIndex ) != ' ' && this.frameCount % 2 == 0 && this.textBeepEnabled ) 
			{
				TinyAudioManager.play( TinyAudioManager.TEXT );
			}
			
			// If there are no more characters left to print, this entry is complete
			if ( this.numCharsToPrint <= 0 )
			{
				this.disablePrinting();
				this.dispatchEvent( new TinyAutotypeTextEvent( TinyAutotypeTextEvent.TEXT_ENTRY_COMPLETE ) );
			}
		}
		
		private function onLineMaskComplete( event : Event ) : void
		{
			TinyLogManager.log( 'onLineMaskComplete', this );
			
			this.currentLineIndex++;
			
			if ( this.currentLineIndex < this.textField.numLines ) 
			{
				// If this next line is past the line limit, move the whole text up a bit to accomodate the next line
				if ( this.currentLineIndex >= this.maxLinesAtOnce )
				{
					TinyLogManager.log( 'scrolling text', this );
					TweenLite.to( this, 0.25, { y: "-11", roundProps: [ 'y' ] } );
				}
			} 
			else
			{
				TinyLogManager.log( 'dialog complete', this );
				this.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
				this.dispatchEvent( new TinyAutotypeTextEvent( TinyAutotypeTextEvent.DIALOG_COMPLETE ) );
			}
		}
	}
}
