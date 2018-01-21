package com.tinyrpg.ui 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	
	import com.tinyrpg.core.TinyConfig;
	import com.tinyrpg.core.TinyPlayer;
	import com.tinyrpg.data.TinyDialogItem;
	import com.tinyrpg.display.TinyAutotypeTextField;
	import com.tinyrpg.display.TinyBattleTurnArrow;
	import com.tinyrpg.display.TinyTitleBox;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author jeremyabel
	 */
	public class TinyDialogBox extends TinyTitleBox
	{
		private var dialogSequence : Array = [];
		private var textField : TinyAutotypeTextField;
		private var textSpeed : int;
		private var nextArrow : TinyBattleTurnArrow;
		private var textMask : Sprite;
		private var arrowTween : TweenMax; 
		private var hasControl : Boolean = false;
		private var atEnd : Boolean = false;
		private var skipping : Boolean = false;
		private var savedDialogSequence : Array = [];

		public var battle : Boolean = false;
		public var time : int = 0;

		private static var dialogXML : XML;

		public function TinyDialogBox(speaker : String, width : int = 144, height : int = 33, time : int = 0)
		{
			super( null, '', width, height );
			
			this.time = time;

			// Set speaker
			var speakerString : String = (speaker == '' || speaker == null) ? '' : speaker + ': ';
			if (speakerString == 'PLAYER') 
			{
				speakerString = TinyPlayer.getInstance( ).playerName.toUpperCase( ) + ': '; 
			}

			// Set properties
			this.textSpeed = TinyConfig.TEXT_SPEED;
			
			// Set up text field
			this.textField = new TinyAutotypeTextField( 141, 20, 'dialogText' );
			this.textField.originalY = 
			this.textField.y = -4;
			
			// Append speaker string if it exists
			if ( speakerString )
			{
				this.textField.appendText( speakerString, true, speakerString.length );
			}
			
			// Next arrow
			this.nextArrow = new TinyBattleTurnArrow;
			this.nextArrow.x = this.width - 20;
			this.nextArrow.y = this.height - 6;
			this.arrowTween = new TweenMax( this.nextArrow, 0.4, { y:this.height - 4, repeat:-1, yoyo:true, roundProps:[ "x", "y" ], ease:Sine.easeInOut } );
			this.arrowTween.play();
			
			// Textfield mask
			this.textMask = new Sprite();
			this.textMask.graphics.beginFill( 0xFF00FF );
			this.textMask.graphics.drawRect( 0, 0, width, height );
			this.textMask.graphics.endFill();
			
			// Set textfield mask (for text scrolling)
			this.textMask.cacheAsBitmap =
			this.textField.cacheAsBitmap = true;
			this.textField.mask = this.textMask;
		
			// Add 'em up
			this.addChild( this.textMask );
			this.addChild( this.textField );
			this.addChild( this.nextArrow );
			
			// Add events
			this.addEventListener( TinyInputEvent.CONTROL_ADDED, onControlAdded );
		}
		
		public static function newFromString(text : String, speaker : String = null, width : int = 144, height : int = 33, time : int = 0) : TinyDialogBox
		{
			var speakerString : String = (speaker != null) ? speaker : '';
			var xmlString : String = "<DIALOG><SPEAKER>" + speakerString + "</SPEAKER><TEXT>" + text + "</TEXT></DIALOG>";
			
			return TinyDialogBox.newFromXML(new XML(xmlString), width, height, time);  
		}

		public static function newFromXML(xmlData : XML, width : int = 144, height : int = 33, time : int = 0) : TinyDialogBox
		{
			TinyLogManager.log( 'newFromXML', newDialogBox );
			
			var dialogText : String = xmlData.child( 'TEXT' ).text( );
			
			var speakerText : String = xmlData.child( 'SPEAKER' ).toString( ).toUpperCase( );
			if (speakerText == 'PLAYER') 
			{
				speakerText = TinyPlayer.getInstance( ).playerName.toUpperCase( );
			}
			
			var newDialogBox : TinyDialogBox = new TinyDialogBox( speakerText, width, height, time );
			
			// Split string by bracketed commands
			var pattern : RegExp = /(\[[^]+?\])/g;
			var dialogArray : Array = dialogText.split( pattern );
			
			// Remove empty values
			var filterFunction : Function = function(element : *, index : int, array : Array):Boolean 
			{ 
				index; 
				array; 
				return (element != ''); 
			};
			
			dialogArray = dialogArray.filter( filterFunction );
			
			// Seperate into commands and process
			for each ( var string : String in dialogArray )
			{
				var newCommand : TinyDialogItem;
				
				// Is it a command, or normal text?
				if ( string.charAt( ) == '[' )
				{
					// Just in case
					string = string.toLowerCase( );
					
					// Is this a delay command?
					var delayPattern : RegExp = /\[delay.?\d*\]/;
					var delayMatch : Array = string.match( delayPattern );
					if ( delayMatch && delayMatch.length > 0 ) 
					{
						// Find the number parameter
						delayPattern = /\d+/;
						var delayArray : Array = string.match( delayPattern );
						
						newCommand = new TinyDialogItem( TinyDialogItem.DELAY, Number( delayArray[0] ) );
						TinyLogManager.log( 'add new DELAY command: ' + newCommand.value, newDialogBox );
					} 
					
					// Is it a player-specific command?
					var playerPattern : RegExp = /\[player.?\w*\]/;
					var playerMatch : Array = string.match( playerPattern );
					if ( playerMatch && playerMatch.length > 0 )
					{
						// Find the dialog name parameter
						playerPattern = /(?<=\[player\s)\w*/;
						var playerArray : Array = string.match( playerPattern );
						
						// Get the string from XML
						var xmlString : String = TinyDialogBox.dialogXML.child( String( playerArray[0] ).toUpperCase( ) ).child( TinyPlayer.getInstance( ).playerName.toUpperCase( ) ).toString( );
						newCommand = new TinyDialogItem( TinyDialogItem.TEXT, xmlString );
						TinyLogManager.log( 'add new TEXT command: ' + newCommand.value, newDialogBox );
					}
				
					// What kind of command is it?
					else 
					{
						switch (string) 
						{
							case '[br]':
								TinyLogManager.log( 'add new BREAK command', newDialogBox );
								newCommand = new TinyDialogItem( TinyDialogItem.BREAK );
								break;
							case '[name]':
								TinyLogManager.log( 'add new NAME command', newDialogBox );
								newCommand = new TinyDialogItem( TinyDialogItem.NAME );
								break;
							case '[halt]':
								TinyLogManager.log( 'add new HALT command', newDialogBox );
								newCommand = new TinyDialogItem( TinyDialogItem.HALT );
								break;
							case '[end]':
								TinyLogManager.log( 'add new END command', newDialogBox );
								newCommand = new TinyDialogItem( TinyDialogItem.END );
								break; 
							case '[end_int]':
								TinyLogManager.log( 'add new END INTERRUPT command', newDialogBox );
								newCommand = new TinyDialogItem( TinyDialogItem.END_INT );
								break;
							default:
								break;
						}
					}
				} 
				else 
				{
					// Normal text
					newCommand = new TinyDialogItem( TinyDialogItem.TEXT, string );
					TinyLogManager.log( 'add new TEXT command: ' + newCommand.value, newDialogBox );
				}
				
				// Put into sequence array
				newDialogBox.dialogSequence.push( newCommand );
			}
			
			return newDialogBox; 
		}

		private function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log( 'onControlAdded', this );
			
			TinyInputManager.getInstance( ).addEventListener( TinyInputEvent.ACCEPT, onAccept );
			this.addEventListener( TinyInputEvent.CONTROL_REMOVED, onControlRemoved );
			this.removeEventListener( TinyInputEvent.CONTROL_ADDED, onControlAdded );
		}

		private function onControlRemoved(e : TinyInputEvent) : void
		{
			TinyLogManager.log( 'onControlRemoved', this );
			
			// Clean up
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.ACCEPT, onAccept );
			TinyInputManager.getInstance().removeEventListener( TinyInputEvent.KEY_UP_ACCEPT, resetSpeed );
			this.removeEventListener( TinyInputEvent.CONTROL_REMOVED, onControlRemoved );
			this.addEventListener( TinyInputEvent.CONTROL_ADDED, onControlAdded );
		}

		private function onAccept( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onAccept: skipping = ' + this.skipping, this );
			
			if ( this.hasControl && !this.skipping ) 
			{
				if ( this.atEnd ) 
				{
					this.dispatchEvent( new Event( Event.COMPLETE ) );
				} 
				else 
				{
					this.doNextCommand();
				}
			} 
			else 
			{
				if ( !TinyInputManager.getInstance().hasEventListener( TinyInputEvent.KEY_UP_ACCEPT ) ) 
				{
					TinyInputManager.getInstance().addEventListener( TinyInputEvent.KEY_UP_ACCEPT, resetSpeed );
				}
					
				this.textSpeed = 3;
				this.textField.textSpeed = this.textSpeed;
				this.skipping = true;
			}
		}

		private function resetSpeed(event : TinyInputEvent) : void 
		{
			TinyLogManager.log( 'resetSpeed', this );
			
			TinyInputManager.getInstance( ).removeEventListener( TinyInputEvent.KEY_UP_ACCEPT, resetSpeed );
			
			this.textSpeed = TinyConfig.TEXT_SPEED;
			this.textField.textSpeed = this.textSpeed;
			this.skipping = false;
		}

		public function show(noCommand : Boolean = false) : void
		{
			TinyLogManager.log( 'show', this );
			this.visible = true;
			this.reset(); 
			
			if (!noCommand) 
			{
				this.doNextCommand( );
			}
		}

		public function hide() : void
		{
			TinyLogManager.log( 'hide', this );
			this.visible = false; 
		}
		
		public function reset() : void
		{
			if ( this.dialogSequence.length <= 0 )
			{
				TinyLogManager.log('reset', this);
				this.dialogSequence = [];
				this.dialogSequence = this.savedDialogSequence.slice();
				this.textField.clear();
				this.savedDialogSequence = [];
			}
		}

		private function doNextCommand(event : Event = null) : void
		{
			TinyLogManager.log( 'doNextCommand', this );
			var activeCommand : TinyDialogItem = this.dialogSequence.shift();
			
			this.savedDialogSequence.push( activeCommand );

			// Clean up
			this.textField.removeEventListener( Event.COMPLETE, doNextCommand );
			this.hasControl = false;
			
			// If there is no next command, end and exit
			if ( !activeCommand )
			{
				this.handleEnd();
				return;
			}
			
			// Process commands
			switch ( activeCommand.type ) 
			{
				default: 
				case TinyDialogItem.END:
					this.handleEnd();
					break;
				case TinyDialogItem.TEXT:
					this.handleText( activeCommand.value );
					break;
				case TinyDialogItem.BREAK:
					this.handleBreak();
					break;
				case TinyDialogItem.NAME:
					this.handleName();
					break;
				case TinyDialogItem.HALT:
					this.handleHalt(); 
					break;
				case TinyDialogItem.DELAY:
					this.handleDelay( activeCommand.value );
					break;
				case TinyDialogItem.END_INT:
					this.handleEndInterrupt( );
					break;
			}
		}

		private function handleText(textString : String) : void
		{
			TinyLogManager.log( 'handleText', this );
			this.textField.addEventListener( Event.COMPLETE, doNextCommand );			this.textField.appendText( textString, false, this.textSpeed );
		}

		private function handleBreak() : void
		{			TinyLogManager.log( 'handleBreak', this );
			this.textField.addLineBreak( );
			var delayTime : int = this.skipping ? 1 : 2;
			TweenLite.delayedCall( delayTime, this.doNextCommand, null, true );
		}

		private function handleName() : void
		{			TinyLogManager.log( 'handleName', this );
			this.handleText( TinyPlayer.getInstance( ).playerName );
		}

		private function handleHalt() : void
		{			TinyLogManager.log( 'handleHalt', this );
			this.hasControl = true;
				
			// Show next arrow
			this.nextArrow.visible = true;
			this.arrowTween.play();
		}

		private function handleDelay(delayTime : int) : void
		{			TinyLogManager.log( 'handleDelay: ' + delayTime, this );

			if (this.skipping) 
				delayTime = 0;

			TweenLite.delayedCall( delayTime, this.doNextCommand, null, true );
		}

		private function handleEnd() : void
		{
			TinyLogManager.log( 'handleEnd', this );
			this.atEnd = true;
			this.hasControl = true;
		}

		private function handleEndInterrupt() : void
		{
			TinyLogManager.log( 'handleEndInterrupt', this );
			this.atEnd = true;
			this.hasControl = false;
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}
