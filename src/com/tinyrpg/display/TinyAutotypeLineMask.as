package com.tinyrpg.display
{
	import com.tinyrpg.events.TinyAutotypeTextEvent;	

	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Display class for a rectangle mask used for masking a single line of text in
	 * an {@link TinyAutotypeTextField}. 
	 * 
	 * The mask is used for displaying characters one at a time, typewriter-style. 
	 * This only works with monospaced characters, since it assumes a constant width 
	 * and height for each character.
	 * 
	 * @author jeremyabel
	 */
	public class TinyAutotypeLineMask extends Sprite 
	{
		public var charIndex 	: uint = 0;
		
		private var numChars 	: uint = 0;
		private var charW 		: uint = 0;
		private var charH		: uint = 0; 
		
		/**
		 * @param 	numChars	The number of characters in the line.
		 * @param	charWidth	The width of a single character.
		 * @param	charHeight	The height of a single character.
		 */
		public function TinyAutotypeLineMask( numChars : uint, charWidth : uint, charHeight : uint ) : void
		{
			this.numChars = numChars;
			this.charW = charWidth;
			this.charH = charHeight;
		}
		
		/**
		 * Draws an additional rectangle into the mask, exposing the next character.
		 * When all characters in the line have been exposed, the LINE_COMPLETE event
		 * is dispatched.
		 */
		public function showNextChar() : void
		{
			this.graphics.beginFill( Math.random() * 0xFFFFFF );
			this.graphics.drawRect( this.charIndex * this.charW, 0, this.charW, this.charH );
			this.graphics.endFill();
			
			this.charIndex++;
			
			if ( this.charIndex > numChars ) 
			{
				this.dispatchEvent( new TinyAutotypeTextEvent( TinyAutotypeTextEvent.LINE_COMPLETE ) );
			}
		}
	}
}
