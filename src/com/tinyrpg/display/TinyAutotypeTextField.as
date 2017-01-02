package com.tinyrpg.display 
{
	import com.greensock.TweenLite;
	
	import com.tinyrpg.core.TinyConfig;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;

	/**
	 * @author jeremyabel
	 */
	public class TinyAutotypeTextField extends Sprite 
	{
		private var textField 			: TextField;
		private var textMask  			: Sprite;
		private var styleClass			: String;
		private var lineMasks			: Array = []; 
		private var lineWidths			: Array = [];
		private var currentLine			: int = 0;
		private var currentChar 		: int = 0;
		private var frameCount 			: int = 0;
		private var noBeep				: Boolean = false;
		private var maxLinesAtOnce 		: int = 3;
		
		public var originalY			: int;
		public var textSpeed			: int;
		
		public function TinyAutotypeTextField( width : int, height : int, styleClass : String, maxLinesAtOnce : int = 3 )
		{
			// Set properties
			this.textSpeed = TinyConfig.TEXT_SPEED;
			this.styleClass = styleClass;
			this.maxLinesAtOnce = maxLinesAtOnce;
			
			// Text field
			this.textField = TinyFontManager.returnTextField('left', false, true, true);
			this.textField.width = width;
			this.textField.height = height;
			
			// Text field mask
			this.textMask = new Sprite;
			
			// Set mask
			this.textMask.cacheAsBitmap = 
			this.textField.cacheAsBitmap = true;
			this.textField.mask = this.textMask;
			
			// Add 'em up
			this.addChild(this.textField);
			this.addChild(this.textMask);
		}
		
		public function appendText(text : String, noBeep : Boolean = false, textSpeed : int = 2) : void
		{
			TinyLogManager.log('appendText: ' + text, this);
			
			this.textField.htmlText += TinyFontManager.returnHtmlText(text, this.styleClass, 'left', true);
			
			var newLineMask : Sprite = new Sprite;
			
			this.noBeep = noBeep;
			this.textSpeed = textSpeed;
			
			// Set up text mask
			for (var i : uint = 0; i < this.textField.numLines; i++)
			{
				this.lineMasks.push(newLineMask);
				this.lineWidths.push(0);
				this.textMask.addChild(newLineMask);
			}
		
			if (text != '') {
				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		public function addLineBreak() : void
		{
			this.textField.htmlText += '<br>';
			this.currentLine++;
			this.currentChar++;
		}
		
		public function clear() : void
		{
			TinyLogManager.log('clear', this);
			
			this.currentChar = 0;
			this.currentLine = 0;
			this.frameCount = 0;
			this.lineWidths = [];
			this.lineMasks = [];
			this.textField.htmlText = '';
			this.y = TinyMath.deepCopyInt( this.originalY );
			
			while ( this.textMask.numChildren ) this.textMask.removeChildAt( 0 );
		}

		public function onEnterFrame(event : Event) : void
		{
			// Get mask to edit
			var lineMask : Sprite = this.lineMasks[currentLine];
			var lineMetrics : TextLineMetrics = this.textField.getLineMetrics( currentLine );
			
			// Get width of area to reveal
			var newWidth : int = this.lineWidths[ this.currentLine ];
			for ( var c : Number = 0; c < this.textSpeed; c++ ) 
			{
				if ( this.textField.getCharBoundaries( this.currentChar ) ) 
				{
					var newCharWidth : int = this.textField.getCharBoundaries( this.currentChar ).width; 
					newWidth += newCharWidth;
					this.lineWidths[ this.currentLine ] += newCharWidth;
					this.currentChar++;
				} 
				else
				{
					this.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
					this.dispatchEvent( new Event( Event.COMPLETE ) );
					
					// Return if there's nothing else to show
					if ( newWidth == lineMask.width ) return;
				}
			}
			
			// Every other frame, for beepy sound
			this.frameCount = (this.frameCount + 1) % 2;

			// Play little blip sound
			if ( this.textField.text.charAt( this.currentChar ) != ' ' && this.frameCount == 1 && !this.noBeep ) 
			{
				TinyAudioManager.play( TinyAudioManager.TEXT );
			}
			
			// Draw mask rectangle
			lineMask.graphics.beginFill(0xFF00FF);
			
			try 
			{
				lineMask.graphics.drawRect( this.textField.getCharBoundaries( this.textField.getLineOffset( this.currentLine ) ).x, this.currentLine * lineMetrics.height + 4, newWidth, lineMetrics.height );
			} 
			catch ( error : Error ) 
			{ 
				lineMask.graphics.drawRect( 0, this.currentLine * lineMetrics.height + 4, newWidth, lineMetrics.height ); 
			}
			lineMask.graphics.endFill();
						
			// Move on to next line
			if ( this.currentLine < this.textField.numLines && this.textField.numLines > 1 ) 
			{
				try 
				{
					if ( this.currentChar >= this.textField.getLineOffset( this.currentLine + 1 ) ) 
					{
						this.currentLine++;
						
						// If this next line is past the line limit, move the whole text up a bit to accomidate the next line
						if ( this.currentLine >= this.maxLinesAtOnce )
						{
							TweenLite.to( this, 0.25, { y: "-11", roundProps: ['y'] } );
						}
					}
				} 
				catch (error : Error) {}
			}
		}
	}
}
