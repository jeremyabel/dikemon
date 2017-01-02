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
		
		private var keyUp		: int = 38;		// Up Arrow
		private var keyDown 	: int = 40;		// Down Arrow
		private var keyLeft		: int = 37;		// Left Arrow
		private var keyRight	: int = 39;		// Right Arrow
		private var keyAccept	: int = 90;		// Z
		private var keyCancel	: int = 88;		// X
		private var keyMenu		: int = Keyboard.SHIFT;		// SHIFT
		
		private var target 			: EventDispatcher = null;
		private var previousTarget	: EventDispatcher = null;
		
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
		
		public function onKeyDown(e : KeyboardEvent) : void
		{
			switch(e.keyCode) 
			{
				case keyMenu:
					this.dispatchEvent(new TinyInputEvent(TinyInputEvent.MENU));
					break;
				case keyUp:
					this.dispatchEvent(new TinyInputEvent(TinyInputEvent.ARROW_UP));
					break;
				case keyDown:
					this.dispatchEvent(new TinyInputEvent(TinyInputEvent.ARROW_DOWN));
					break;
				case keyLeft:
					this.dispatchEvent(new TinyInputEvent(TinyInputEvent.ARROW_LEFT));
					break;
				case keyRight:
					this.dispatchEvent(new TinyInputEvent(TinyInputEvent.ARROW_RIGHT));
					break;
				case keyAccept:
					if (!this.holdingAccept) {
						this.dispatchEvent(new TinyInputEvent(TinyInputEvent.ACCEPT));
					}
					this.holdingAccept = true;
					break;
				case keyCancel:
					this.dispatchEvent(new TinyInputEvent(TinyInputEvent.CANCEL));
					break;
				default:
					break;
			}
		}
		
		public function onKeyUp(e : KeyboardEvent) : void 
		{
			switch(e.keyCode) 
			{
				case keyUp:
					this.dispatchEvent(new TinyInputEvent(TinyInputEvent.KEY_UP_UP));
					break;
				case keyDown:
					this.dispatchEvent(new TinyInputEvent(TinyInputEvent.KEY_UP_DOWN));
					break;
				case keyLeft:
					this.dispatchEvent(new TinyInputEvent(TinyInputEvent.KEY_UP_LEFT));
					break;
				case keyRight:
					this.dispatchEvent(new TinyInputEvent(TinyInputEvent.KEY_UP_RIGHT));
					break;
				case keyAccept:
					this.holdingAccept = false;
					this.dispatchEvent(new TinyInputEvent(TinyInputEvent.KEY_UP_ACCEPT));
					break;
			}
		}
	}
}
