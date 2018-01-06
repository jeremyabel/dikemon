package com.tinyrpg.display 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Sine;
	import com.greensock.easing.SteppedEase;
	import com.greensock.plugins.RoundPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.tinyrpg.display.TinyBattleTurnArrow;
	import com.tinyrpg.display.TinyDamageNumbers;
//	import com.tinyrpg.display.TinyFXAnim;
	import com.tinyrpg.display.TinyModalSelectArrow;
	import com.tinyrpg.display.TinySpriteSheet;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.misc.TinySpriteConfig;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author jeremyabel
	 */
	public class TinyWalkSprite extends Sprite
	{
		public static var LEFT : String = 'LEFT';
		public static var RIGHT : String = 'RIGHT';
		public static var UP : String = 'UP';
		public static var DOWN : String = 'DOWN';
		public static var VERT_SPEED : uint = 2;
		public static var HORIZ_SPEED : uint = 2;

		private var directions : Array = [ 'LEFT', 'UP', 'RIGHT', 'DOWN' ];
		private var debugDirectionIndex : int = -1;

		private var spritesheet : TinyWalkSpriteSheet;

		public var hitBox : Sprite;
		public var facing : String;
		public var defaultFacing : String;
		public var charName : String;		
		public var spriteHolder : Sprite;

		public function TinyWalkSprite( id : uint ) : void
		{
			TweenPlugin.activate( [ RoundPropsPlugin ] );
			
			this.spritesheet = new TinyWalkSpriteSheet( id, TinyWalkSprite.DOWN );
			
			this.hitBox = new Sprite;
			this.hitBox.name = 'hitBox_' + name;
			this.hitBox.graphics.beginFill(0xFF00FF, 0.25);
			this.hitBox.graphics.drawRect( -8, -8, 16, 16 );
			this.hitBox.graphics.endFill();
			this.hitBox.visible = false;
			
			// Add 'em up
			this.addChild( this.spritesheet );
			this.addChild( this.hitBox );

			// Wait for control
			this.addEventListener( TinyInputEvent.CONTROL_ADDED, onControlAdded );
		}
		
		public function debugWalkCycles() : void
		{
			this.spritesheet.startWalking( 5 );
			TweenMax.delayedCall( 40, this.updateDebugWalkCycles, null, true );
		}
		
		private function updateDebugWalkCycles() : void
		{	
			this.debugDirectionIndex = ( this.debugDirectionIndex + 1 ) % 4;
			this.spritesheet.setFacing( this.directions[ this.debugDirectionIndex ] );
			TweenMax.delayedCall( 40, this.updateDebugWalkCycles, null, true );
		}

		// For making NPCs
//		public static function newFromXML(xmlData : XML) : TinyFriendSprite
//		{
//			var name : String = xmlData.child('NAME').toString().toUpperCase();
//			
//			// See if we can get sprite lengths from character data
//			var idleLength : int = 1;
//			var attackLength : int = 1;
//			if (TinyPlayer.getInstance().fullParty.getCharByName(name)) {
//				var tempEntity : TinyStatsEntity = TinyPlayer.getInstance().fullParty.getCharByName(name);
//				idleLength = TinyFriendSprite(tempEntity.graphics).idleLength;
//				attackLength = TinyFriendSprite(tempEntity.graphics).attackLength;
//			}
//			
//			var newFriendSprite : TinyFriendSprite = new TinyFriendSprite(0, name, attackLength, idleLength, true);
//			newFriendSprite.event = xmlData.child('EVENT').toString(); 
//			
//			TinyLogManager.log('newFromXML: ' + name, TinyFriendSprite);
//			
//			return newFriendSprite;
//		}

		protected function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log( 'onControlAdded', this );
			
			// Add events
//			TinyInputManager.getInstance().addEventListener(TinyInputEvent.MENU, TinyFieldMap.getInstance().showMenu);
//			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ARROW_UP, onArrowUp);
//			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ARROW_DOWN, onArrowDown);
//			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ARROW_LEFT, onArrowLeft);
//			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ARROW_RIGHT, onArrowRight);
//			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ACCEPT, onAccept);
//			
//			this.addEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
//			this.removeEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}

		protected function onControlRemoved( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onControlRemoved', this );
			
			// Remove events
//			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_UP, 	onArrowUp);
//			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_DOWN, 	onArrowDown);
//			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_LEFT, 	onArrowLeft);
//			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_RIGHT, 	onArrowRight);
//			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ACCEPT, 		onAccept);
//			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_UP, 	idleWalk);
//			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_DOWN, 	idleWalk);
//			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_RIGHT, idleWalk);
//			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_LEFT, 	idleWalk);
//			
//			this.removeEventListener( TinyInputEvent.CONTROL_REMOVED, onControlRemoved );
//			this.removeEventListener( Event.ENTER_FRAME, moveChar );
			
//			this.addEventListener( TinyInputEvent.CONTROL_ADDED, onControlAdded );
//			this.idleWalk();
		}

		private function onAccept(event : TinyInputEvent) : void 
		{
//			TinyLogManager.log(this.charName + ': ' + 'onAccept', this);
//
//			// Are we even touching anything?
//			if (this.amIInvolved) 
//			{
//				// Check if this is something we can interact with
//				if (this.lastTouch != '') 
//				{
//					var interactSprite : TinyFriendSprite = TinyFieldMap.getNPCSpriteByName(this.lastTouch);
//					
//					if (interactSprite) {
//						// Let's try communicatin' with it!
//						if (interactSprite.event != '') 
//						{	 
//							// Set facing towards player
//							switch (this.facing) {
//								case TinyFriendSprite.UP:
//									interactSprite.facing = TinyFriendSprite.DOWN;
//									break;
//								case TinyFriendSprite.DOWN:
//									interactSprite.facing = TinyFriendSprite.UP;
//									break;
//								case TinyFriendSprite.LEFT:
//									interactSprite.facing = TinyFriendSprite.RIGHT;
//									break;
//								case TinyFriendSprite.RIGHT:
//									interactSprite.facing = TinyFriendSprite.LEFT;
//									break;
//								
//								// Face player	
//								interactSprite.idleWalk();
//							}
//							
//							// Start event
//							TinyFieldMap.getInstance().addEventSequence(interactSprite.event);
//							TinyFieldMap.getInstance().startCurrentEvent();
//						} 
//						else 
//						{
//							TinyLogManager.log(this.charName + ': ' + 'onAccept: target ' + this.lastTouch + ' has no specified event!', this);
//						}
//					} 
//					// This is a event object, then
//					else 
//					{
//						// Start event
//						TinyLogManager.log(this.charName + ': ' + 'onAccept: ' + this.lastTouch + ', event: ' + TinyFieldMap.objectEvents[this.lastTouch], this);
//						TinyFieldMap.getInstance().addEventSequence(TinyFieldMap.objectEvents[this.lastTouch]);
//						TinyFieldMap.getInstance().startCurrentEvent();
//					}
//				}
//			}
		}

		private function onArrowUp(event : TinyInputEvent) : void 
		{
//			if (!TinyInputManager.getInstance().hasEventListener(TinyInputEvent.KEY_UP_UP)) 
//				TinyInputManager.getInstance().addEventListener(TinyInputEvent.KEY_UP_UP, idleWalk);
//			
//			this.walkBack( 1 );
		}

		private function onArrowDown(event : TinyInputEvent) : void 
		{
//			if (!TinyInputManager.getInstance().hasEventListener(TinyInputEvent.KEY_UP_DOWN)) 
//				TinyInputManager.getInstance().addEventListener(TinyInputEvent.KEY_UP_DOWN, idleWalk);
//		
//			this.walkForward( 1 );
		}

		private function onArrowLeft(event : TinyInputEvent) : void 
		{
//			if (!TinyInputManager.getInstance().hasEventListener(TinyInputEvent.KEY_UP_LEFT)) 
//				TinyInputManager.getInstance().addEventListener(TinyInputEvent.KEY_UP_LEFT, idleWalk);
//			
//			this.walkLeft();
		}

		private function onArrowRight(event : TinyInputEvent) : void 
		{
//			if (!TinyInputManager.getInstance().hasEventListener(TinyInputEvent.KEY_UP_RIGHT)) 
//				TinyInputManager.getInstance().addEventListener(TinyInputEvent.KEY_UP_RIGHT, idleWalk);
//			
//			this.walkRight();
		}

		public function walkForward(speed : uint = 2) : void
		{
//			this.facing = TinyFriendSprite.DOWN;
//			this.idling = false;
//
//			if ( !this.spriteWalkFwd.isPlaying || this.spriteWalkBack.isPlaying || this.spriteWalkLeft.isPlaying || this.spriteWalkRight.isPlaying ) 
//			{
//				TinyLogManager.log(this.charName + ': ' + 'walkForward', this);
//				this.spriteWalkBack.stopAndRemove();
//				this.spriteWalkLeft.stopAndRemove();
//				this.spriteWalkRight.stopAndRemove();
//				this.showSprite(this.spriteWalkFwd);
//				this.spriteWalkFwd.play(speed);
//				this.spriteHolder.scaleX = 1;
//				this.hitBox.scaleX = 1;
//				
//				if ( !this.hasEventListener( Event.ENTER_FRAME ) )
//				{ 
//					this.addEventListener( Event.ENTER_FRAME, moveChar );
//				}
//			}
		}

		public function walkBack(speed : uint = 2) : void
		{
//			this.facing = TinyFriendSprite.UP;
//			this.idling = false;
//
//			if (!this.spriteWalkBack.isPlaying || this.spriteWalkFwd.isPlaying || this.spriteWalkLeft.isPlaying || this.spriteWalkRight.isPlaying) {
//				TinyLogManager.log(this.charName + ': ' + 'walkBack', this);
//				this.spriteWalkFwd.stopAndRemove();
//				this.spriteWalkLeft.stopAndRemove();
//				this.spriteWalkRight.stopAndRemove();
//				this.showSprite(this.spriteWalkBack);
//				this.spriteWalkBack.play(speed);
//				this.spriteHolder.scaleX = 1;
//				this.hitBox.scaleX = 1;
//				
//				if (!this.hasEventListener(Event.ENTER_FRAME)) 
//					this.addEventListener(Event.ENTER_FRAME, moveChar);
//			}
		}

		public function walkLeft(speed : uint = 2) : void
		{
//			this.facing = TinyFriendSprite.LEFT;
//			this.idling = false;
//
//			if (!this.spriteWalkLeft.isPlaying || this.spriteWalkRight.isPlaying || this.spriteWalkFwd.isPlaying || this.spriteWalkBack.isPlaying) {
//				TinyLogManager.log(this.charName + ': ' + 'walkLeft', this);
//				this.spriteWalkFwd.stopAndRemove();
//				this.spriteWalkBack.stopAndRemove();
//				this.spriteWalkRight.stopAndRemove();
//				this.showSprite(this.spriteWalkLeft);
//				this.spriteWalkLeft.play(speed);
//				this.spriteHolder.scaleX = -1;
//				
//				if (!this.hasEventListener(Event.ENTER_FRAME)) 
//					this.addEventListener(Event.ENTER_FRAME, moveChar);
//			}
		}

		public function walkRight(speed : uint = 2) : void
		{
//			this.facing = TinyFriendSprite.RIGHT;
//			this.idling = false;
//
//			if ( !this.spriteWalkRight.isPlaying || this.spriteWalkFwd.isPlaying || this.spriteWalkBack.isPlaying || this.spriteWalkLeft.isPlaying ) 
//			{
//				TinyLogManager.log(this.charName + ': ' + 'walkRight', this);
//				this.spriteWalkFwd.stopAndRemove();
//				this.spriteWalkBack.stopAndRemove();
//				this.spriteWalkLeft.stopAndRemove();
//				this.showSprite(this.spriteWalkRight);
//				this.spriteWalkRight.play(speed);
//				this.spriteHolder.scaleX = 1;
//				
//				if (!this.hasEventListener(Event.ENTER_FRAME)) 
//					this.addEventListener(Event.ENTER_FRAME, moveChar);
//			}
		}
		
//		public function walkToPlayer() : int
//		{
//			TinyLogManager.log(this.charName + ': ' + 'walkToPlayer', this);
			
//			// How far away are we from the player?
//			var deltaX : int = TinyStatsEntity(TinyPlayer.getInstance().fullParty.party[0]).graphics.x - this.x;
//			var deltaY : int = TinyStatsEntity(TinyPlayer.getInstance().fullParty.party[0]).graphics.y - this.y;
//			
//			// Time it takes to get there
//			var timeX : int = int(deltaX / TinyFriendSprite.HORIZ_SPEED) + 1;
//			var timeY : int = int(deltaY / TinyFriendSprite.VERT_SPEED) + 1;
//			
//			// Direction to go in
//			var directionX : String = deltaX < 0 ? 'LEFT' : 'RIGHT';
//			var directionY : String = deltaY < 0 ? 'UP' : 'DOWN';
//			
//			// Horiz walk
//			if (directionX == 'LEFT') {
//				this.walkLeft();
//			} else {
//				this.walkRight();
//			}
//			TweenMax.delayedCall(timeX, this.idleWalk, null, true);
//			
//			// Vert walk
//			if (directionY == 'UP') {
//				TweenMax.delayedCall(timeX + 1, this.walkBack, null, true); 
//			} else {
//				TweenMax.delayedCall(timeX + 1, this.walkForward, null, true); 
//			}
//			TweenMax.delayedCall(timeX + timeY + 1, this.idleWalk, null, true);
//			
//			// Done
//			return timeX + timeY + 2;
//		}

		public function moveChar(event : Event = null) : void
		{
//			// Check draw order
//			if (!this.npc) {
//				TinyFieldMap.getInstance().checkSpriteDepth();
//			}
//			
//			// Just to be sure.
//			this.amIInvolved = false;
//			
//			// Move, depending on our facing
//			switch (this.facing) {
//				case TinyFriendSprite.UP:
//					this.y -= TinyFriendSprite.VERT_SPEED;
//					break;
//				case TinyFriendSprite.DOWN:
//					this.y += TinyFriendSprite.VERT_SPEED;
//					break;
//				case TinyFriendSprite.LEFT:
//					this.x -= TinyFriendSprite.HORIZ_SPEED;
//					break;
//				case TinyFriendSprite.RIGHT:
//					this.x += TinyFriendSprite.HORIZ_SPEED;
//					break;
//			}
//			
//			var collisions : Array = TinyFieldMap.collisionList.checkCollisions();
//
//			if (collisions.length > 0 ) 
//			{
//				for each ( var collision : Object in collisions ) 
//				{
//					//trace(collision['object1']['name'], collision['object2']['name']);
//					
//					// Really, only do these things if the player's sprite is involved
//					if (String( collision[ 'object1' ][ 'name' ] ).toUpperCase() == 'HITBOX_' + TinyPlayer.getInstance().playerName.toUpperCase() || 
//						String( collision[ 'object2' ][ 'name' ] ).toUpperCase() == 'HITBOX_' + TinyPlayer.getInstance().playerName.toUpperCase() )	
//					{
//						this.amIInvolved = true;
//					
//						if ( !(collision['object1']['name'] != this.hitBox.name && collision['object2']['name'] == 'HIT' ) ) {
//							
//							switch (this.facing) {
//								case TinyWalkSprite.UP:
//									this.y += TinyWalkSprite.VERT_SPEED;
//									break;
//								case TinyWalkSprite.DOWN:
//									this.y -= TinyWalkSprite.VERT_SPEED;
//									break;
//								case TinyWalkSprite.LEFT:
//									this.x += TinyWalkSprite.HORIZ_SPEED;
//									break;
//								case TinyWalkSprite.RIGHT:
//									this.x -= TinyWalkSprite.HORIZ_SPEED;
//									break;
//							}
//							
//							this.lastTouch = ''; 
//							
//							// Check for NPCs
//							if (String(collision['object1']['name']) != this.hitBox.name && String(collision['object1']['name']).substr(0, 6) == 'hitBox') { 
//								this.lastTouch = String(collision['object1']['name']).substr(7);
//								TinyLogManager.log(this.charName + ': ' + 'LAST TOUCH: ' + this.lastTouch, this);
//							// Check for named event objects - they must start with the word "EVENT"
//							} else if (String(collision['object1']['name']) == this.hitBox.name && String(collision['object2']['name']).substr(0, 5) == 'EVENT') {
//								this.lastTouch = String(collision['object2']['name']);
//								TinyLogManager.log(this.charName + ': ' + 'LAST TOUCH: ' + this.lastTouch, this);
//							} else if (String(collision['object2']['name']) == this.hitBox.name && String(collision['object1']['name']).substr(0, 5) == 'EVENT') {
//								this.lastTouch = String(collision['object1']['name']);
//								TinyLogManager.log(this.charName + ': ' + 'LAST TOUCH: ' + this.lastTouch, this);
//							}
//							
//							if (!this.idling) {
//								this.idleWalk();
//							}
//						}
//					}
//				}
//				//trace('==========================');
//			}
		}

		public function idleWalk(event : TinyInputEvent = null) : void
		{
//			TinyLogManager.log(this.charName + ': ' + 'idleWalk', this);
			
//			if ((!event) || (this.facing == TinyFriendSprite.UP && event.type == TinyInputEvent.KEY_UP_UP   ) || (this.facing == TinyFriendSprite.DOWN && event.type == TinyInputEvent.KEY_UP_DOWN ) || (this.facing == TinyFriendSprite.LEFT && event.type == TinyInputEvent.KEY_UP_LEFT ) || (this.facing == TinyFriendSprite.RIGHT && event.type == TinyInputEvent.KEY_UP_RIGHT)) {
//				this.idling = true;
//				
//				// Clean up
//				this.removeEventListener(Event.ENTER_FRAME, moveChar);
//				
//				switch (this.facing) {
//					case TinyFriendSprite.UP:
//						TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_UP, idleWalk);
//						this.showSprite(this.spriteIdleBack);
//						this.spriteHolder.scaleX = 1;
//						this.spriteIdleBack.play();
//						this.spriteWalkBack.stopAndRemove();
//						break;
//					default:
//					case TinyFriendSprite.DOWN:
//						TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_DOWN, idleWalk);
//						this.showSprite(this.spriteIdleFront);
//						this.spriteHolder.scaleX = 1;
//						this.spriteIdleFront.play();
//						this.spriteWalkFwd.stopAndRemove();
//						break;
//					case TinyFriendSprite.LEFT:
//						TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_LEFT, idleWalk);
//						this.showSprite(this.spriteIdleSide);
//						this.spriteHolder.scaleX = -1;
//						this.spriteIdleSide.play();
//						this.spriteWalkLeft.stopAndRemove();
//						break;
//					case TinyFriendSprite.RIGHT:
//						TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_RIGHT, idleWalk);
//						this.showSprite(this.spriteIdleSide);
//						this.spriteHolder.scaleX = 1;
//						this.spriteIdleSide.play();
//						this.spriteWalkRight.stopAndRemove();
//						break;
//				}
//			}
		}

		public function idleDirection(direction : String) : void
		{
//			TinyLogManager.log(this.charName + ': ' + 'idleDirection: ' + direction, this);
//			
//			this.facing = direction;
//			this.idleWalk();
		}

//		public function showSprite(targetSprite : TinySpriteSheet) : void
//		{
//			// Hide all sprites
//			this.spriteWalkFwd.visible = this.spriteWalkBack.visible = this.spriteWalkLeft.visible = this.spriteWalkRight.visible = this.spriteIdleFront.visible = this.spriteIdleBack.visible = this.spriteIdleSide.visible = this.spriteIdleFight.visible = this.spriteAttack.visible = this.spriteUseItem.visible = this.spriteHit.visible = this.spriteDead.visible = false;
//			
//			// Show the one we want
//			targetSprite.visible = true;
//			this.currentSprite = targetSprite;
//		}

		public function setPosition(x : int, y : int) : void
		{
//			this.spriteHolder.x = x;
//			this.spriteHolder.y = y;	
		}
		
		public function get actualX() : Number
		{
			return this.x;
		}

		public function get actualY() : Number
		{
			return this.y;
		}
	}
}
		