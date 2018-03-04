package com.tinyrpg.managers 
{
	import com.tinyrpg.data.TinyAppSettings;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * @author jeremyabel
	 */
	public class TinyInputManager extends EventDispatcher
	{
		private static var instance : TinyInputManager = new TinyInputManager();
		
		public static const ARROW_UP 	= 'UP';
		public static const ARROW_DOWN	= 'DOWN';
		public static const ARROW_LEFT	= 'LEFT';
		public static const ARROW_RIGHT	= 'RIGHT';
		
		private var keyUp		: int = 38;					// Up Arrow
		private var keyDown 	: int = 40;					// Down Arrow
		private var keyLeft		: int = 37;					// Left Arrow
		private var keyRight	: int = 39;					// Right Arrow
		private var keyAccept	: int = 90;					// Z
		private var keyCancel	: int = 88;					// X
		private var keyMenu		: int = Keyboard.SHIFT;		// SHIFT
		
		private var target 			: EventDispatcher = null;
		private var previousTarget	: EventDispatcher = null;
		private var arrowQueue 		: Array = [];
		
		public var holdingAccept : Boolean = false;
		
		public function TinyInputManager() : void
		{
			TinyAppSettings.STAGE_REF.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);			TinyAppSettings.STAGE_REF.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		// Singleton
		public static function getInstance() : TinyInputManager
		{
			return instance;
		}
		
		public function setTarget(newTarget : EventDispatcher) : void
		{
			TinyLogManager.log('setTarget : ' + newTarget, this);
			
			// Notify previous target
			if (this.target) {
				this.previousTarget = this.target;
				this.previousTarget.dispatchEvent(new TinyInputEvent(TinyInputEvent.CONTROL_REMOVED));
			}
			
			// Only add a new target if there is one
			if (newTarget) {
				// Notify new target
				this.target = newTarget;
				this.target.dispatchEvent(new TinyInputEvent(TinyInputEvent.CONTROL_ADDED));
			}
		}
		
		public function get hasTarget() : Boolean
		{
			if (this.target) 
				return true;
			else 
				return false;
		}
		
		public function onKeyDown( event : KeyboardEvent ) : void
		{
			switch( event.keyCode ) 
			{
				case keyMenu:
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.MENU ) );
					break;
					
				case keyUp:
					this.tryUpdateArrowQueue( TinyInputManager.ARROW_UP );
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.ARROW_UP ) );
					break;
					
				case keyDown:
					this.tryUpdateArrowQueue( TinyInputManager.ARROW_DOWN );
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.ARROW_DOWN ) );
					break;
					
				case keyLeft:
					this.tryUpdateArrowQueue( TinyInputManager.ARROW_LEFT );
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.ARROW_LEFT ) );
					break;
					
				case keyRight:
					this.tryUpdateArrowQueue( TinyInputManager.ARROW_RIGHT );
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.ARROW_RIGHT ) );
					break;
					
				case keyAccept:
					if (!this.holdingAccept) {
						this.dispatchEvent( new TinyInputEvent( TinyInputEvent.ACCEPT ) );
					}
					this.holdingAccept = true;
					break;
					
				case keyCancel:
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.CANCEL ) );
					break;
					
				default:
					break;
			}
		}
		
		public function onKeyUp( event : KeyboardEvent ) : void 
		{
			switch( event.keyCode ) 
			{
				case keyUp:
					this.tryRemoveFromArrowQueue( TinyInputManager.ARROW_UP );
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.KEY_UP_UP ) );
					break;
					
				case keyDown:
					this.tryRemoveFromArrowQueue( TinyInputManager.ARROW_DOWN );
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.KEY_UP_DOWN ) );
					break;
					
				case keyLeft:
					this.tryRemoveFromArrowQueue( TinyInputManager.ARROW_LEFT );
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.KEY_UP_LEFT ) );
					break;
					
				case keyRight:
					this.tryRemoveFromArrowQueue( TinyInputManager.ARROW_RIGHT );
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.KEY_UP_RIGHT ) );
					break;
					
				case keyAccept:
					this.holdingAccept = false;
					this.dispatchEvent( new TinyInputEvent( TinyInputEvent.KEY_UP_ACCEPT ) );
					break;
			}
		}
		
		public function tryRemoveFromArrowQueue( direction : String ) : void
		{
			var index : int = this.arrowQueue.indexOf( direction );
			
			if ( index > -1 ) 
			{
				this.arrowQueue.removeAt( index );
			}
		}
		
		public function tryUpdateArrowQueue( direction : String ) : void
		{
			if ( this.getCurrentArrowKey() != direction )
			{
				this.arrowQueue.push( direction );
			}
		}
		
		public function getCurrentArrowKey() : String
		{
			if ( this.arrowQueue.length > 0 ) 
			{
				return this.arrowQueue[ this.arrowQueue.length - 1 ];
			}
			
			return null;
		}
	}
}
