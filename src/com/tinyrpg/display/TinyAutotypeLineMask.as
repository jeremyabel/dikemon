package com.tinyrpg.display
{
	import com.tinyrpg.events.TinyAutotypeTextEvent;	

	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyAutotypeLineMask extends Sprite 
	{
		public var charIndex 	: uint = 0;
		
		private var numChars 	: uint = 0;
		private var charW 		: uint = 0;
		private var charH		: uint = 0; 
		
		public function TinyAutotypeLineMask( numChars : uint, charWidth : uint, charHeight : uint ) : void
		{
			this.numChars = numChars;
			this.charW = charWidth;
			this.charH = charHeight;
		}
		
		public function showNextChar() : void
		{
			this.graphics.beginFill( Math.random() * 0xFFFFFF );
			this.graphics.drawRect( this.charIndex * this.charW, 0, this.charW, this.charH );
			this.graphics.endFill();
			
			this.charIndex++;
			
			if ( this.charIndex > numChars ) 
			{
				this.dispatchEvent( new TinyAutotypeTextEvent( TinyAutotypeTextEvent.LINE_COMPLETE ) );
				return;	
			}
		}
	}
}
