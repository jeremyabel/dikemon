package com.tinyrpg.core 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Sine;
	import com.greensock.easing.SteppedEase;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.RoundPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.tinyrpg.display.TinyBattleTurnArrow;
	import com.tinyrpg.display.TinyDamageNumbers;
	import com.tinyrpg.display.TinyFXAnim;
	import com.tinyrpg.display.TinyModalSelectArrow;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.misc.TinySpriteConfig;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;

	import flash.display.Bitmap;
	import flash.display.BitmapDataChannel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author jeremyabel
	 */
	public class TinyEnemySprite extends Sprite implements ITinySprite
	{
		private var _idNumber 		: int;
		private var _damageNumbers 	: TinyDamageNumbers;
		private var _damageTime		: uint;
		
		public var spriteHolder	: Sprite;
		
		private var hitSprite		: Sprite;
		private var selectArrow 	: TinyModalSelectArrow;
		private var turnArrow		: TinyBattleTurnArrow;
		private var damageAnim 		: TinyFXAnim;
		private var loopTween 		: TweenMax;
		
		private var shakeFollower : Sprite;
		private var lastShakePos : int;
		private var lastShakeDir : int;
		private var postShakeTime : int;

		public function TinyEnemySprite(idNumber : int = 0, enemyName : String = 'Enraged Bass') : void
		{
			TweenPlugin.activate([RoundPropsPlugin, ColorTransformPlugin]);
			
			TinyLogManager.log('new enemy sprite: ' + enemyName, this);
			this.idNumber = idNumber;
			
			// Sprite bitmap			
			var spriteBitmap : Bitmap = new Bitmap(TinySpriteConfig.getEnemySprite(enemyName));
			spriteBitmap.x = -int(spriteBitmap.width  / 2);
			spriteBitmap.y = -int(spriteBitmap.height / 2);
			
			// Color array, set everything white
			var redArray : Array = [];			var greenArray : Array = [];			var blueArray : Array = [];
			for (var i : int = 0; i < 256; i++) {
				redArray[i] = 0xFFFFFFFF;				greenArray[i] = 0xFFFFFFFF;				blueArray[i] = 0xFFFFFFFF;
			}
			
			// Set black to red - ARGB
			redArray[0] = 0x00FF0000;
			greenArray[0] = 0x00000000;
			blueArray[0] = 0x00000000;
			
			// Hit Sprite bitmap - palette mapped to white with pure black set to red
			var hitBitmap : Bitmap = new Bitmap(TinySpriteConfig.getEnemySprite(enemyName));
			hitBitmap.bitmapData.paletteMap(hitBitmap.bitmapData, hitBitmap.bitmapData.rect, new Point(0, 0), redArray, greenArray, blueArray);
			hitBitmap.bitmapData.copyChannel(spriteBitmap.bitmapData, hitBitmap.bitmapData.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			hitBitmap.x = spriteBitmap.x;
			hitBitmap.y = spriteBitmap.y;
			
			// Hit Sprite
			this.hitSprite = new Sprite;
			this.hitSprite.addChild(hitBitmap);
			this.hitSprite.scaleX = -1;
			this.hitSprite.visible = false;
			
			// Sprite holder
			this.spriteHolder = new Sprite;
			this.spriteHolder.addChild(spriteBitmap);
			this.spriteHolder.scaleX *= -1;
			
			// Select arrow
			this.selectArrow = new TinyModalSelectArrow;
			this.selectArrow.x = int(spriteBitmap.width / 2);
			this.selectArrow.scaleX *= -1;
			this.selectArrow.visible = false;
			
			// Turn arrow
			this.turnArrow = new TinyBattleTurnArrow;
			this.turnArrow.x = 3;
			this.turnArrow.y = -30;
			this.turnArrow.visible = false;
			
			// Animation tween for turn arrow
			this.loopTween = new TweenMax(this.turnArrow, 0.4, { y:-32, repeat:-1, yoyo:true, roundProps:["x", "y"], ease:Sine.easeInOut });
			
			// Damage numbers
			this._damageNumbers = new TinyDamageNumbers;
			this._damageNumbers.x = 3;
			this._damageNumbers.y = -38;
			
			// Add 'em up
			this.addChild(this.spriteHolder);
			this.addChild(this.hitSprite);
			this.addChild(this.selectArrow);
			this.addChild(this.turnArrow);
			this.addChild(this.damageNumbers);
		}
		
		public function attack() : int
		{
			TinyLogManager.log('attack', this);
			
			TinyAudioManager.play(TinyAudioManager.ENEMY_ATTACK);
			
			// Nudge forward and back
			TweenMax.to(this.spriteHolder, 2, { x:6, repeat:1, yoyo:true, roundProps:["x", "y"], ease:Sine.easeInOut, useFrames:true });
			
			return 4;
		}

		public function hit(attackType : String = null) : int
		{
			TinyLogManager.log('hit: ' + attackType, this);
			
			// Play sound
			TinyAudioManager.play(TinyAudioManager.HIT_A);
			
			// Flash
			this.hitSprite.visible = true;
			TweenMax.to(this.hitSprite, 1, { delay:2, visible:false, useFrames:true });
			
			var delay : int = 1;
			
			// Play battle effect animation
			if (attackType && attackType != '') 
			{
				this.damageAnim = TinyFXAnim.getAnimFromType(attackType);
				this.addChild(this.damageAnim);
				this.damageAnim.playAndRemove();
				this.damageTime = this.damageAnim.length;
				TweenMax.delayedCall(this.damageTime, this.removeChild, [this.damageAnim], true);
				delay += this.damageAnim.length;
			}
			
			// Shake it!
			TweenMax.to(this.spriteHolder, 1, { delay:delay, x:1, repeat:7, yoyo:true, roundProps:["x", "y"], useFrames:true });
			
			return 7 + delay;
		}
		
		public function miss() : int
		{
			TinyLogManager.log('miss', this);
			
			TweenMax.to(this.spriteHolder, 5, { x:"10", repeat:1, yoyo:true, roundProps:["x", "y"], useFrames:true });
			
			return 5;
		}

		public function die() : int
		{
			TinyLogManager.log('die', this);
			
			// Play sound			
			TinyAudioManager.play(TinyAudioManager.ENEMY_DIE);
			
			// Fade out w/ red tint
			TweenMax.to(this.spriteHolder, 8, { alpha:0, useFrames:true });
			TweenMax.to(this.spriteHolder, 4, { colorTransform:{tint:0xFF0000, tintAmount:1}, useFrames:true });
			
			return 15;
		}
		
		public function dieBig() : void
		{
			TinyLogManager.log('dieBig', this);
			
			// Play sound
			TinyAudioManager.play(TinyAudioManager.BOSS_DIE);
			
			// Shake and fade out
			this.deathShake();
			TweenLite.to(this, 60, { delay: 40, alpha:0, ease:SteppedEase.create(6), useFrames:true });
		}
		
		public function deathShake() : int
		{
			TinyLogManager.log('deathShake', this);
			
			this.lastShakeDir = -1;
			this.shakeFollower = new Sprite;
			this.shakeFollower.x = 
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
			//TinyLogManager.log(this.name + ' selected: ' + value, this);
			this.turnArrow.visible = value;
			
			if (value) 
				this.loopTween.play();
			else
				this.loopTween.pause(); 
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
			this._idNumber = value;
		}

		public function set damageTime(value : uint) : void
		{
			this._damageTime = value;
		}
	}
}
