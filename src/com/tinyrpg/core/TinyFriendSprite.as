package com.tinyrpg.core 
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
	import com.tinyrpg.display.TinyFXAnim;
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
	public class TinyFriendSprite extends Sprite implements ITinySprite
	{
		public static var LEFT : String = 'LEFT';
		public static var RIGHT : String = 'RIGHT';
		public static var UP : String = 'UP';
		public static var DOWN : String = 'DOWN';

		public static var VERT_SPEED : uint = 2;
		public static var HORIZ_SPEED : uint = 2;
		public static var HIT_RECT : Rectangle;	

		private var _idNumber : int;
		private var _damageNumbers : TinyDamageNumbers;
		private var _damageTime : uint;
		
		private var directions : Array = [ 'LEFT', 'UP', 'RIGHT', 'DOWN' ];

		// Sprites
		private var spriteData : BitmapData;
		private var spriteWalkFwd : TinySpriteSheet;
		private var spriteWalkBack : TinySpriteSheet;
		private var spriteWalkLeft : TinySpriteSheet;
		private var spriteWalkRight : TinySpriteSheet;
		public  var spriteIdleFront : TinySpriteSheet;		public  var spriteIdleBack : TinySpriteSheet;
		public  var spriteIdleSide : TinySpriteSheet;
		private var spriteIdleFight : TinySpriteSheet;
		private var spriteAttack : TinySpriteSheet;
		private var spriteUseItem : TinySpriteSheet;
		private var spriteHit : TinySpriteSheet;
		private var spriteDead : TinySpriteSheet;

		private var selectArrow : TinyModalSelectArrow;
		private var damageAnim : TinyFXAnim;
		private var turnArrow : TinyBattleTurnArrow;
		private var currentSprite : TinySpriteSheet;
		private var loopTween : TweenMax;
		private var idling : Boolean = false;
		public  var lastTouch : String = '';
		private var amIInvolved : Boolean = false;
		private var fireFlailing : Boolean = false;
		private var totalDistanceMoved : int;
		
		private var shakeFollower : Sprite;
		private var lastShakePos : int;
		private var lastShakeDir : int;
		private var postShakeTime : int;
		private var keepSpinning  : Boolean = false;

		public var hitBox : Sprite;
		public var facing : String;
		public var defaultFacing : String;
		public var event : String;
		public var charName : String;		
		public var spriteHolder : Sprite;
		public var npc : Boolean;
		public var attackLength : int;
		public var idleLength : int;

		public function TinyFriendSprite(idNumber : int = 0, name : String = 'JASON', attackLength : uint = 9, idleLength : uint = 13, npc : Boolean = false) : void
		{
			TweenPlugin.activate([ RoundPropsPlugin ]);
			
			// Set properties
			this.idNumber = idNumber;
			this.attackLength = attackLength;
			this.idleLength = idleLength;
			this.charName = name;
			this.npc = npc;
			
			// Sprite holder
			this.spriteHolder = new Sprite;
			
			// Make sprites - THIS USED TO HAVE NICE SPACING. STUPID AUTO-FORMATTER :(
			this.spriteData = TinySpriteConfig.getSpriteSheet(name);
			this.spriteWalkFwd = TinySpriteSheet.newFromBitmapCopy(this.spriteData, new Rectangle(0, 0, 120 * 11, 120), 120, 11, true, 2);
			this.spriteWalkBack = TinySpriteSheet.newFromBitmapCopy(this.spriteData, new Rectangle(0, 120, 120 * 11, 120), 120, 11, true, 2);
			this.spriteWalkLeft = TinySpriteSheet.newFromBitmapCopy(this.spriteData, new Rectangle(0, 240, 120 * 6, 120), 120, 6, true, 2, true);			this.spriteWalkRight = TinySpriteSheet.newFromBitmapCopy(this.spriteData, new Rectangle(0, 240, 120 * 6, 120), 120, 6, true, 2, true);
			this.spriteIdleFront = TinySpriteSheet.newFromBitmapCopy(this.spriteData, new Rectangle(0, 360, 120, 120), 120, 1, false, 2);
			this.spriteIdleBack = TinySpriteSheet.newFromBitmapCopy(this.spriteData, new Rectangle(120, 360, 120, 120), 120, 1, false, 2);
			this.spriteIdleSide = TinySpriteSheet.newFromBitmapCopy(this.spriteData, new Rectangle(240, 360, 120, 120), 120, 1, false, 2, true);			this.spriteDead = TinySpriteSheet.newFromBitmapCopy(this.spriteData, new Rectangle(360, 360, 120, 120), 120, 1, false, 2);
			this.spriteIdleFight = TinySpriteSheet.newFromBitmapCopy(this.spriteData, new Rectangle(0, 480, 120 * idleLength, 120), 120, idleLength, true, 2);
			this.spriteAttack = TinySpriteSheet.newFromBitmapCopy(this.spriteData, new Rectangle(0, 600, 120 * attackLength, 120), 120, attackLength, false, 2);
			this.spriteUseItem = TinySpriteSheet.newFromBitmapCopy(this.spriteData, new Rectangle(0, 720, 120 * 6, 120), 120, 6, false, 2);
			this.spriteHit = TinySpriteSheet.newFromBitmapCopy(this.spriteData, new Rectangle(0, 840, 120 * 4, 120), 120, 4, false, 2);
			
			// Hide sprites
			this.spriteWalkFwd.visible = this.spriteWalkBack.visible = this.spriteWalkLeft.visible = this.spriteWalkRight.visible = this.spriteIdleFront.visible = this.spriteAttack.visible = this.spriteUseItem.visible = this.spriteHit.visible = this.spriteDead.visible = false;
			
			// Add to container
			this.spriteHolder.addChild(this.spriteWalkFwd);			this.spriteHolder.addChild(this.spriteWalkBack);			this.spriteHolder.addChild(this.spriteWalkLeft);			this.spriteHolder.addChild(this.spriteWalkRight);			this.spriteHolder.addChild(this.spriteIdleFront);
			this.spriteHolder.addChild(this.spriteIdleBack);			this.spriteHolder.addChild(this.spriteIdleSide);			this.spriteHolder.addChild(this.spriteIdleFight);			this.spriteHolder.addChild(this.spriteAttack);			this.spriteHolder.addChild(this.spriteUseItem);			this.spriteHolder.addChild(this.spriteHit);			this.spriteHolder.addChild(this.spriteDead);
			
			// Select arrow
			this.selectArrow = new TinyModalSelectArrow;
			this.selectArrow.x = -15;
			this.selectArrow.y = 0;
			this.selectArrow.visible = false;
			
			// Turn arrow
			this.turnArrow = new TinyBattleTurnArrow;
			this.turnArrow.x = 3;
			this.turnArrow.y = -30;
			this.turnArrow.visible = false;
			
			// Animation tween for turn arrow
			this.loopTween = new TweenMax(this.turnArrow, 0.4, { y:-32, repeat:-1, yoyo:true, roundProps:[ "x", "y" ], ease:Sine.easeInOut });
			
			// Damage numbers
			this._damageNumbers = new TinyDamageNumbers;
			this._damageNumbers.x = 3;
			this._damageNumbers.y = -38;
			
			this.hitBox = new Sprite;
			this.hitBox.name = 'hitBox_' + name;
			this.hitBox.graphics.beginFill(0xFF00FF, 0.75);
			this.hitBox.graphics.drawRect(-8, 7, 16, 7);			this.hitBox.graphics.endFill();
			this.hitBox.visible = false;
			
			// Set some defaults
			this.facing = TinyFriendSprite.DOWN;
			this.currentSprite = this.spriteIdleFront;
			this.idleWalk();
			
			// Add 'em up
			this.addChild(this.spriteHolder);
			this.addChild(this.selectArrow);
			this.addChild(this.turnArrow);
			this.addChild(this._damageNumbers);
			this.addChild(this.hitBox);

			// Add events
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}
		
		public function swapArrow() : void
		{
			// Turn arrow
			this.turnArrow = new TinyBattleTurnArrow;
			this.turnArrow.scaleX *= -1;
			this.turnArrow.x = -3;
			this.turnArrow.y = -30;
			this.turnArrow.visible = false;
		}

		// For making NPCs
		public static function newFromXML(xmlData : XML) : TinyFriendSprite
		{
			var name : String = xmlData.child('NAME').toString().toUpperCase();
			
			// See if we can get sprite lengths from character data
			var idleLength : int = 1;
			var attackLength : int = 1;
			if (TinyPlayer.getInstance().fullParty.getCharByName(name)) {
				var tempEntity : TinyStatsEntity = TinyPlayer.getInstance().fullParty.getCharByName(name);
				idleLength = TinyFriendSprite(tempEntity.graphics).idleLength;
				attackLength = TinyFriendSprite(tempEntity.graphics).attackLength;
			}
			
			var newFriendSprite : TinyFriendSprite = new TinyFriendSprite(0, name, attackLength, idleLength, true);
			newFriendSprite.event = xmlData.child('EVENT').toString(); 
			
			TinyLogManager.log('newFromXML: ' + name, TinyFriendSprite);			
			return newFriendSprite;
		}

		public static function newFromName(name : String) : TinyFriendSprite
		{
			TinyLogManager.log('newFromName: ' + name, TinyFriendSprite);
			
			// See if we can get sprite lengths from character data
			var idleLength : int = 1;
			var attackLength : int = 1;
			if (TinyPlayer.getInstance().fullParty.getCharByName(name)) {
				var tempEntity : TinyStatsEntity = TinyPlayer.getInstance().fullParty.getCharByName(name);
				idleLength = TinyFriendSprite(tempEntity.graphics).idleLength;
				attackLength = TinyFriendSprite(tempEntity.graphics).attackLength;
			}
			
			var newFriendSprite : TinyFriendSprite = new TinyFriendSprite(0, name, attackLength, idleLength, true);
			return newFriendSprite;
		}

		protected function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log(this.charName + ': ' + 'onControlAdded', this);
			
			// Add events
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.MENU, TinyFieldMap.getInstance().showMenu);
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ARROW_UP, onArrowUp);			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ARROW_DOWN, onArrowDown);			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ARROW_LEFT, onArrowLeft);			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ARROW_RIGHT, onArrowRight);			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ACCEPT, onAccept);			this.addEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.removeEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}

		protected function onControlRemoved(e : TinyInputEvent) : void
		{
			TinyLogManager.log(this.charName + ': ' + 'onControlRemoved', this);
			
			// Remove events
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.MENU, TinyFieldMap.getInstance().showMenu);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_UP, onArrowUp);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_DOWN, onArrowDown);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_LEFT, onArrowLeft);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_RIGHT, onArrowRight);			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ACCEPT, onAccept);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_UP, idleWalk);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_DOWN, idleWalk);			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_RIGHT, idleWalk);			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_LEFT, idleWalk);			this.removeEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.removeEventListener(Event.ENTER_FRAME, moveChar);
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
			this.idleWalk();
		}

		private function onAccept(event : TinyInputEvent) : void 
		{
			TinyLogManager.log(this.charName + ': ' + 'onAccept', this);

			// Are we even touching anything?
			if (this.amIInvolved) 
			{
				// Check if this is something we can interact with
				if (this.lastTouch != '') 
				{
					var interactSprite : TinyFriendSprite = TinyFieldMap.getNPCSpriteByName(this.lastTouch);
					
					if (interactSprite) {
						// Let's try communicatin' with it!
						if (interactSprite.event != '') 
						{	 
							// Set facing towards player
							switch (this.facing) {
								case TinyFriendSprite.UP:
									interactSprite.facing = TinyFriendSprite.DOWN;
									break;
								case TinyFriendSprite.DOWN:
									interactSprite.facing = TinyFriendSprite.UP;
									break;
								case TinyFriendSprite.LEFT:
									interactSprite.facing = TinyFriendSprite.RIGHT;
									break;
								case TinyFriendSprite.RIGHT:
									interactSprite.facing = TinyFriendSprite.LEFT;
									break;
								
								// Face player	
								interactSprite.idleWalk();
							}
							
							// Start event
							TinyFieldMap.getInstance().addEventSequence(interactSprite.event);
							TinyFieldMap.getInstance().startCurrentEvent();
						} 
						else 
						{
							TinyLogManager.log(this.charName + ': ' + 'onAccept: target ' + this.lastTouch + ' has no specified event!', this);
						}
					} 
					// This is a event object, then
					else 
					{
						// Start event
						TinyLogManager.log(this.charName + ': ' + 'onAccept: ' + this.lastTouch + ', event: ' + TinyFieldMap.objectEvents[this.lastTouch], this);
						TinyFieldMap.getInstance().addEventSequence(TinyFieldMap.objectEvents[this.lastTouch]);
						TinyFieldMap.getInstance().startCurrentEvent();
					}
				}
			}
		}

		private function onArrowUp(event : TinyInputEvent) : void 
		{
			if (!TinyInputManager.getInstance().hasEventListener(TinyInputEvent.KEY_UP_UP)) 
				TinyInputManager.getInstance().addEventListener(TinyInputEvent.KEY_UP_UP, idleWalk);
			this.walkBack(1);
		}

		private function onArrowDown(event : TinyInputEvent) : void 
		{			if (!TinyInputManager.getInstance().hasEventListener(TinyInputEvent.KEY_UP_DOWN)) 
				TinyInputManager.getInstance().addEventListener(TinyInputEvent.KEY_UP_DOWN, idleWalk);
			this.walkForward(1);
		}

		private function onArrowLeft(event : TinyInputEvent) : void 
		{			if (!TinyInputManager.getInstance().hasEventListener(TinyInputEvent.KEY_UP_LEFT)) 
				TinyInputManager.getInstance().addEventListener(TinyInputEvent.KEY_UP_LEFT, idleWalk);
			this.walkLeft();
		}

		private function onArrowRight(event : TinyInputEvent) : void 
		{			if (!TinyInputManager.getInstance().hasEventListener(TinyInputEvent.KEY_UP_RIGHT)) 
				TinyInputManager.getInstance().addEventListener(TinyInputEvent.KEY_UP_RIGHT, idleWalk);
			this.walkRight();		}

		public function walkForward(speed : uint = 2) : void
		{
			this.facing = TinyFriendSprite.DOWN;
			this.idling = false;

			if (!this.spriteWalkFwd.isPlaying || this.spriteWalkBack.isPlaying || this.spriteWalkLeft.isPlaying || this.spriteWalkRight.isPlaying) {
				TinyLogManager.log(this.charName + ': ' + 'walkForward', this);
				this.spriteWalkBack.stopAndRemove();
				this.spriteWalkLeft.stopAndRemove();
				this.spriteWalkRight.stopAndRemove();
				this.showSprite(this.spriteWalkFwd);
				this.spriteWalkFwd.play(speed);
				this.spriteHolder.scaleX = 1;
				this.hitBox.scaleX = 1;
				
				if (!this.hasEventListener(Event.ENTER_FRAME)) 
					this.addEventListener(Event.ENTER_FRAME, moveChar);
			}
		}

		public function walkBack(speed : uint = 2) : void
		{
			this.facing = TinyFriendSprite.UP;
			this.idling = false;

			if (!this.spriteWalkBack.isPlaying || this.spriteWalkFwd.isPlaying || this.spriteWalkLeft.isPlaying || this.spriteWalkRight.isPlaying) {
				TinyLogManager.log(this.charName + ': ' + 'walkBack', this);
				this.spriteWalkFwd.stopAndRemove();
				this.spriteWalkLeft.stopAndRemove();				this.spriteWalkRight.stopAndRemove();
				this.showSprite(this.spriteWalkBack);
				this.spriteWalkBack.play(speed);
				this.spriteHolder.scaleX = 1;
				this.hitBox.scaleX = 1;
				
				if (!this.hasEventListener(Event.ENTER_FRAME)) 
					this.addEventListener(Event.ENTER_FRAME, moveChar);
			}
		}

		public function walkLeft(speed : uint = 2) : void
		{
			this.facing = TinyFriendSprite.LEFT;
			this.idling = false;

			if (!this.spriteWalkLeft.isPlaying || this.spriteWalkRight.isPlaying || this.spriteWalkFwd.isPlaying || this.spriteWalkBack.isPlaying) {
				TinyLogManager.log(this.charName + ': ' + 'walkLeft', this);
				this.spriteWalkFwd.stopAndRemove();
				this.spriteWalkBack.stopAndRemove();
				this.spriteWalkRight.stopAndRemove();
				this.showSprite(this.spriteWalkLeft);
				this.spriteWalkLeft.play(speed);
				this.spriteHolder.scaleX = -1;
				
				if (!this.hasEventListener(Event.ENTER_FRAME)) 
					this.addEventListener(Event.ENTER_FRAME, moveChar);
			}
		}

		public function walkRight(speed : uint = 2) : void
		{
			this.facing = TinyFriendSprite.RIGHT;
			this.idling = false;

			if (!this.spriteWalkRight.isPlaying || this.spriteWalkFwd.isPlaying || this.spriteWalkBack.isPlaying || this.spriteWalkLeft.isPlaying) {
				TinyLogManager.log(this.charName + ': ' + 'walkRight', this);
				this.spriteWalkFwd.stopAndRemove();
				this.spriteWalkBack.stopAndRemove();
				this.spriteWalkLeft.stopAndRemove();
				this.showSprite(this.spriteWalkRight);
				this.spriteWalkRight.play(speed);
				this.spriteHolder.scaleX = 1;
				
				if (!this.hasEventListener(Event.ENTER_FRAME)) 
					this.addEventListener(Event.ENTER_FRAME, moveChar);
			}
		}

		public function runFromBattle() : void
		{
			this.facing = TinyFriendSprite.RIGHT;
			this.idling = false;
			
			TinyLogManager.log(this.charName + ': ' + 'runFromBattle', this);
			this.spriteWalkFwd.stopAndRemove();
			this.spriteWalkBack.stopAndRemove();
			this.spriteWalkLeft.stopAndRemove();
			this.showSprite(this.spriteWalkRight);
			this.spriteWalkRight.play(1);
			this.spriteHolder.scaleX = 1;
		}
		
		public function walkToPlayer() : int
		{
			TinyLogManager.log(this.charName + ': ' + 'walkToPlayer', this);
			
			// How far away are we from the player?
			var deltaX : int = TinyStatsEntity(TinyPlayer.getInstance().fullParty.party[0]).graphics.x - this.x;
			var deltaY : int = TinyStatsEntity(TinyPlayer.getInstance().fullParty.party[0]).graphics.y - this.y;
			
			// Time it takes to get there
			var timeX : int = int(deltaX / TinyFriendSprite.HORIZ_SPEED) + 1;
			var timeY : int = int(deltaY / TinyFriendSprite.VERT_SPEED) + 1;
			
			// Direction to go in
			var directionX : String = deltaX < 0 ? 'LEFT' : 'RIGHT';
			var directionY : String = deltaY < 0 ? 'UP' : 'DOWN';
			
			// Horiz walk
			if (directionX == 'LEFT') {
				this.walkLeft();
			} else {
				this.walkRight();
			}
			TweenMax.delayedCall(timeX, this.idleWalk, null, true);
			
			// Vert walk
			if (directionY == 'UP') {
				TweenMax.delayedCall(timeX + 1, this.walkBack, null, true); 
			} else {
				TweenMax.delayedCall(timeX + 1, this.walkForward, null, true); 
			}
			TweenMax.delayedCall(timeX + timeY + 1, this.idleWalk, null, true);
			
			// Done
			return timeX + timeY + 2;
		}

		public function moveChar(event : Event = null) : void
		{
			// Check draw order
			if (!this.npc) {
				TinyFieldMap.getInstance().checkSpriteDepth();
			}
			
			// Just to be sure.
			this.amIInvolved = false;
			
			// Move, depending on our facing
			switch (this.facing) {
				case TinyFriendSprite.UP:
					this.y -= TinyFriendSprite.VERT_SPEED;
					break;				case TinyFriendSprite.DOWN:
					this.y += TinyFriendSprite.VERT_SPEED;
					break;				case TinyFriendSprite.LEFT:
					this.x -= TinyFriendSprite.HORIZ_SPEED;
					break;				case TinyFriendSprite.RIGHT:
					this.x += TinyFriendSprite.HORIZ_SPEED;
					break;			}
			
			var collisions : Array = TinyFieldMap.collisionList.checkCollisions();

			if (collisions.length > 0 && !this.npc && TinyFieldMap.mapName.toUpperCase() != 'MAP_COMPUTER_ROOM') {
				for each (var collision : Object in collisions) 
				{
					//trace(collision['object1']['name'], collision['object2']['name']);
					
					// Really, only do these things if the player's sprite is involved
					if (String(collision['object1']['name']).toUpperCase() == 'HITBOX_' + TinyPlayer.getInstance().playerName.toUpperCase() || 
						String(collision['object2']['name']).toUpperCase() == 'HITBOX_' + TinyPlayer.getInstance().playerName.toUpperCase())	
					{
						this.amIInvolved = true;
					
						if ( !(collision['object1']['name'] != this.hitBox.name && collision['object2']['name'] == 'HIT')) {
							switch (this.facing) {
								case TinyFriendSprite.UP:
									this.y += TinyFriendSprite.VERT_SPEED;
									break;
								case TinyFriendSprite.DOWN:
									this.y -= TinyFriendSprite.VERT_SPEED;
									break;
								case TinyFriendSprite.LEFT:
									this.x += TinyFriendSprite.HORIZ_SPEED;
									break;
								case TinyFriendSprite.RIGHT:
									this.x -= TinyFriendSprite.HORIZ_SPEED;
									break;
							}
							
							this.lastTouch = ''; 
							
							// Check for NPCs
							if (String(collision['object1']['name']) != this.hitBox.name && String(collision['object1']['name']).substr(0, 6) == 'hitBox') { 
								this.lastTouch = String(collision['object1']['name']).substr(7);
								TinyLogManager.log(this.charName + ': ' + 'LAST TOUCH: ' + this.lastTouch, this);
							// Check for named event objects - they must start with the word "EVENT"
							} else if (String(collision['object1']['name']) == this.hitBox.name && String(collision['object2']['name']).substr(0, 5) == 'EVENT') {
								this.lastTouch = String(collision['object2']['name']);
								TinyLogManager.log(this.charName + ': ' + 'LAST TOUCH: ' + this.lastTouch, this);
							} else if (String(collision['object2']['name']) == this.hitBox.name && String(collision['object1']['name']).substr(0, 5) == 'EVENT') {
								this.lastTouch = String(collision['object1']['name']);
								TinyLogManager.log(this.charName + ': ' + 'LAST TOUCH: ' + this.lastTouch, this);
							}
							
							if (!this.idling) {
								this.idleWalk();
							}
						}
					}
				}
				//trace('==========================');
			}
			// Increment random encounter counter 
			else if (!this.npc)
			{
				// Determine how far we've walked
				switch (this.facing) 
				{
					case TinyFriendSprite.UP:
					case TinyFriendSprite.DOWN:
						this.totalDistanceMoved += TinyFriendSprite.VERT_SPEED;
						break;
					case TinyFriendSprite.LEFT:
					case TinyFriendSprite.RIGHT:
						this.totalDistanceMoved += TinyFriendSprite.HORIZ_SPEED;
						break;
				}
			
				// We've moved enough to count as one step				
				if (this.totalDistanceMoved > 9)
				 {
				 	// No encounters near map edges
				 	if (this.x >= 16 && this.x <= 308 && this.y > 16 && this.y <= 228) 
				 	{
						this.totalDistanceMoved = 0;
						
						// How evil is this area?
						switch (TinyFieldMap.evilLevel) 
						{
							case 0: break;
							case 1: TinyFieldMap.encounterCount += 100;	break;
							case 2: TinyFieldMap.encounterCount += 190;	break;
						}
						
						// Do random thingy to see if an encounter occurs					
						if (TinyMath.randomInt(0, 255) < int(TinyFieldMap.encounterCount / 256) && TinyFieldMap.evilLevel > 0) {
							TinyFieldMap.encounterCount = 0;
							TinyFieldMap.getInstance().doRandomEncounter();
						}
				 	}
				}
			}
		}

		public function idleWalk(event : TinyInputEvent = null) : void
		{
			TinyLogManager.log(this.charName + ': ' + 'idleWalk', this);
			
			if ((!event) || (this.facing == TinyFriendSprite.UP && event.type == TinyInputEvent.KEY_UP_UP   ) || (this.facing == TinyFriendSprite.DOWN && event.type == TinyInputEvent.KEY_UP_DOWN ) || (this.facing == TinyFriendSprite.LEFT && event.type == TinyInputEvent.KEY_UP_LEFT ) || (this.facing == TinyFriendSprite.RIGHT && event.type == TinyInputEvent.KEY_UP_RIGHT)) {
				this.idling = true;
				
				// Clean up
				this.removeEventListener(Event.ENTER_FRAME, moveChar);
				
				switch (this.facing) {
					case TinyFriendSprite.UP:
						TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_UP, idleWalk);
						this.showSprite(this.spriteIdleBack);
						this.spriteHolder.scaleX = 1;
						this.spriteIdleBack.play();
						this.spriteWalkBack.stopAndRemove();
						break;
					default:
					case TinyFriendSprite.DOWN:
						TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_DOWN, idleWalk);
						this.showSprite(this.spriteIdleFront);
						this.spriteHolder.scaleX = 1;
						this.spriteIdleFront.play();
						this.spriteWalkFwd.stopAndRemove();
						break;
					case TinyFriendSprite.LEFT:
						TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_LEFT, idleWalk);
						this.showSprite(this.spriteIdleSide);
						this.spriteHolder.scaleX = -1;
						this.spriteIdleSide.play();
						this.spriteWalkLeft.stopAndRemove();
						break;
					case TinyFriendSprite.RIGHT:
						TinyInputManager.getInstance().removeEventListener(TinyInputEvent.KEY_UP_RIGHT, idleWalk);
						this.showSprite(this.spriteIdleSide);
						this.spriteHolder.scaleX = 1;
						this.spriteIdleSide.play();
						this.spriteWalkRight.stopAndRemove();
						break;
				}
			}
		}

		public function attack() : int
		{
			TinyLogManager.log(this.charName + ': ' + 'attack', this);
			
			// Play sprite
			this.showSprite(this.spriteAttack);
			this.spriteAttack.play();
			
			// Play sound
			TinyAudioManager.play(TinyAudioManager.getAttackSoundByName(this.charName));
			
			// Return to idle
			TweenMax.delayedCall(this.spriteAttack.length, this.idleBattle, null, true);
			
			return this.spriteAttack.length;
		}

		public function hit(attackType : String = null) : int
		{
			TinyLogManager.log(this.charName + ': ' + 'hit: ' + attackType, this);
			
			// Show hit state
			this.showSprite(this.spriteHit);
			this.spriteHit.play();
			
			var delay : Number = 1; 
			
			// Play sound
			TinyAudioManager.play(TinyAudioManager.HIT_A);

			// Play battle effect animation
			if (attackType || attackType != '') {
				this.damageAnim = TinyFXAnim.getAnimFromType(attackType);
				this.addChild(this.damageAnim);
				this.damageAnim.playAndRemove();
				this.damageTime = this.damageAnim.length;
				TweenMax.delayedCall(this.damageTime, this.removeChild, [ this.damageAnim ], true);
				delay += this.damageAnim.length;
			}
			
			// Shake it!
			TweenMax.to(this.spriteHolder, 1, { delay:delay, x:1, repeat:7, yoyo:true, roundProps:[ "x", "y" ], useFrames:true, onComplete:this.idleBattle });
			
			return 7 + delay;
		}
		
		public function miss() : int
		{
			TinyLogManager.log(this.charName + ': ' + 'miss', this);
			
			TinyAudioManager.play(TinyAudioManager.MISS);
			TweenMax.to(this.spriteHolder, 5, { x:"10", repeat:1, yoyo:true, roundProps:["x", "y"], useFrames:true, onComplete:this.idleBattle });
			
			return 10;
		}

		public function playFX(fxType : String, loop : Boolean = false) : void 
		{
			TinyLogManager.log(this.charName + ': ' + 'playFX: ' + fxType, this);
			
			// Play fx animation
			this.damageAnim = TinyFXAnim.getAnimFromType(fxType);
			this.addChild(this.damageAnim);
			if (loop) {
				this.damageAnim.play();
			} else {
				this.damageAnim.playAndRemove();
			}
			this.damageTime = this.damageAnim.length;
			
			// Remove if we're not looping
			if (!loop) {
				TweenMax.delayedCall(this.damageTime, this.removeChild, [ this.damageAnim ], true);
			}
		}

		public function run() : void
		{
			TinyLogManager.log(this.charName + ': ' + 'run', this);
			this.walkRight(1);
		}

		public function heal(healType : String) : void 
		{
			TinyLogManager.log(this.charName + ': ' + 'heal: ' + healType, this);
			this.damageTime = 10;
		}

		public function revive(reviveType : String) : void
		{
			TinyLogManager.log(this.charName + ': ' + 'revive: ' + reviveType, this);
			TweenMax.to(this.spriteHolder, 15, { alpha:1, useFrames:true });
			this.damageTime = 15;
		}

		public function useItem() : int
		{
			TinyLogManager.log(this.charName + ': ' + 'useItem', this);
			
			// Play sprite
			this.showSprite(this.spriteUseItem);
			this.spriteUseItem.play();
			
			// Return to idle
			TweenMax.delayedCall(this.spriteUseItem.length, this.idleBattle, null, true);
			
			return this.spriteUseItem.length;
		}

		public function die() : int
		{
			TinyLogManager.log(this.charName + ': ' + ' die', this);
			
			// Play sprite
			this.showSprite(this.spriteDead);
			this.spriteDead.play();
			
			return 15;
		}
		
		public function dieBig() : void
		{
			TinyLogManager.log(this.charName + ': ' + ' dieBig', this);
			
			// Play sound
			TinyAudioManager.play(TinyAudioManager.BOSS_DIE);
			
			// Shake and fade out
			this.deathShake();
			TweenLite.to(this, 60, { delay: 20, alpha:0, ease:SteppedEase.create(6), useFrames:true });
		}

		public function idleBattle() : void
		{
			// Try to prevent an error if the character doesn't have correct stats, in the case of Drunk Evan, I guess...
			try {
				if (!this.npc) {
					if (TinyPlayer.getInstance().party.getCharByID(this.idNumber).stats.HP > 0) {
						TinyLogManager.log(this.charName + ': ' + 'idleBattle 1', this);
					
						// Play sprite
						this.showSprite(this.spriteIdleFight);
						this.spriteIdleFight.play();
					}
				} else {
					TinyLogManager.log(this.charName + ': ' + 'idleBattle 1', this);
					
					// Play sprite
					this.showSprite(this.spriteIdleFight);
					this.spriteIdleFight.play();
				}
			} 
			catch(error : Error) {
				TinyLogManager.log(this.charName + ': ' + 'idleBattle 2', this);
				
				// Play sprite
				this.showSprite(this.spriteIdleFight);
				this.spriteIdleFight.play();
			}
		}

		public function victory() : int
		{
			TinyLogManager.log(this.charName + ': ' + 'victory', this);
				
			this.idleDirection(TinyFriendSprite.UP);
			TweenMax.delayedCall(2, this.idleDirection, [ TinyFriendSprite.RIGHT ], true);			TweenMax.delayedCall(4, this.idleDirection, [ TinyFriendSprite.DOWN ], true);			TweenMax.delayedCall(6, this.idleDirection, [ TinyFriendSprite.LEFT ], true);
			TweenMax.delayedCall(8, this.useItem, null, true);
			
			return 8 + this.spriteUseItem.length;
		}
		
		public function suckToCenter() : void
		{
			TinyLogManager.log(this.charName + ': ' + ' suckToPoint', this);
			
			// 29 - 141
			var targetPoint : Point = new Point(180, 170);
			var distance : int = int(Point.distance(targetPoint, new Point(this.x, this.y)));
			var time : int = TinyMath.map(distance, 29, 141, 24, 60);
			
			// Play hit sprite
			if (this.charName.toUpperCase() != 'JEREMY') {
				this.showSprite(this.spriteHit);
				this.spriteHit.play();
			}
			
			// Tween to center
			TweenLite.to(this, time, { x:targetPoint.x, y:targetPoint.y, ease:Expo.easeIn, roundProps:["x", "y"], useFrames:true, onComplete:onSuckComplete });
			
			// Start spinning after a bit
			this.keepSpinning = true;
			TweenLite.delayedCall(18, this.spin, null, true);
		}
		
		private function onSuckComplete() : void
		{
			TinyLogManager.log(this.charName + ': ' + ' onSuckComplete', this);
			
			// Stop spinning
			this.keepSpinning = false;
		}

		public function spin() : void
		{
			if (this.keepSpinning) {
				var nextDirection : String = this.directions.shift();
				this.directions.push(nextDirection);
				this.idleDirection(nextDirection);
				TweenLite.delayedCall(2, this.spin, null, true);
			}
		}
		
		public function deathShake() : int
		{
			TinyLogManager.log(this.charName + ': ' + ' deathShake', this);
			
			this.lastShakeDir = -1;
			this.shakeFollower = new Sprite;			this.shakeFollower.x = 
			this.shakeFollower.y = 0;
			TweenLite.to(this.shakeFollower, 60, { x:100, ease:Expo.easeIn, useFrames:true, onUpdate:this.onShakeUpdate,  onComplete:this.onShakeComplete });
			
			return 100;
		}
		
		private function onShakeUpdate() : void
		{
			if (this.shakeFollower.x > this.lastShakePos + 0.75) {
				this.lastShakeDir *= -1;
				this.x += int(TinyMath.map(this.shakeFollower.x, 0, 100, 1, 3) * this.lastShakeDir);
			}
			this.lastShakePos = TinyMath.deepCopyInt(this.shakeFollower.x);
		}
		
		private function onShakeComplete() : void
		{
			TinyLogManager.log('onShakeComplete', this);
			
			if (this.postShakeTime < 40) {
				this.lastShakeDir *= -1;
				this.x += int(TinyMath.map(this.shakeFollower.x, 0, 100, 1, 3) * this.lastShakeDir);
				this.postShakeTime++;
				TweenLite.delayedCall(1, this.onShakeComplete, null, true);
			}
		}

		public function idleDirection(direction : String) : void
		{
			TinyLogManager.log(this.charName + ': ' + 'idleDirection: ' + direction, this);
			
			this.facing = direction;
			this.idleWalk();
		}

		public function set selected(value : Boolean) : void
		{
			//TinyLogManager.log(this.name + ' selected: ' + value, this);
			this.selectArrow.visible = value;
			MovieClip(this.selectArrow).gotoAndPlay(1);
		}

		public function set autoSelected(value : Boolean) : void
		{
			TinyLogManager.log(this.name + ' selected: ' + value, this);
			this.selectArrow.visible = value;
			MovieClip(this.selectArrow).gotoAndStop('autoselect');
		}

		public function set active(value : Boolean) : void
		{
			TinyLogManager.log(this.name + ' active: ' + value, this);
			this.turnArrow.visible = value;
			
			if (value) 
				this.loopTween.play();
			else
				this.loopTween.pause(); 
		}

		public function showSprite(targetSprite : TinySpriteSheet) : void
		{
			// Hide all sprites
			this.spriteWalkFwd.visible = this.spriteWalkBack.visible = this.spriteWalkLeft.visible = this.spriteWalkRight.visible = this.spriteIdleFront.visible = this.spriteIdleBack.visible = this.spriteIdleSide.visible = this.spriteIdleFight.visible = this.spriteAttack.visible = this.spriteUseItem.visible = this.spriteHit.visible = this.spriteDead.visible = false;
			
			// Show the one we want
			targetSprite.visible = true;
			this.currentSprite = targetSprite;
		}

		public function setPosition(x : int, y : int) : void
		{
			this.spriteHolder.x = x;
			this.spriteHolder.y = y;	
		}

		public function get idNumber() : int
		{
			return this._idNumber;
		}

		public function get damageNumbers() : TinyDamageNumbers
		{
			return this._damageNumbers;
		}

		public function get damageTime() : uint
		{
			return this._damageTime;
		}

		public function set idNumber(value : int) : void
		{
			TinyLogManager.log(this.charName + ': ' + 'set idNumber: ' + value, this);
			this._idNumber = value;
		}

		public function set damageTime(value : uint) : void
		{
			this._damageTime = value;
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
		