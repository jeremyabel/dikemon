 package com.tinyrpg.ui 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.SteppedEase;
	import com.greensock.plugins.RoundPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.tinyrpg.display.TinySpriteSheet;
	import com.tinyrpg.display.misc.DiksoftLogo;
	import com.tinyrpg.display.misc.GameTitle;
	import com.tinyrpg.display.misc.SlashGradient;
	import com.tinyrpg.display.misc.TitleBackground;
	import com.tinyrpg.events.TinyGameEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.events.TinyMenuEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author jeremyabel
	 */
	public class TinyTitleScreen extends TinyModal 
	{
		private var titleSprite : TinySpriteSheet;
		private var diksoftLogo	: Sprite;
		private var background  : Sprite;
		private var selectList	: TinyTitleMenu;
		private var loadMenu	: TinySaveLoadMenu;
		private var slashMask 	: Sprite;

		public function TinyTitleScreen()
		{
			super();
			TweenPlugin.activate([RoundPropsPlugin]);

			// Diksoft Logo
			this.diksoftLogo = new Sprite;
			this.diksoftLogo.addChild(new Bitmap(new DiksoftLogo));
			this.diksoftLogo.x = int((320 / 2) - (this.diksoftLogo.width / 2));
			this.diksoftLogo.alpha = 0;
			
			// Title Sprite
			this.titleSprite = new TinySpriteSheet(new GameTitle, 120);
			this.titleSprite.x = int((320 / 2) - (this.titleSprite.width / 2));
			this.titleSprite.y = 40;
			this.titleSprite.visible = false;
			
			// Menu
			this.selectList = new TinyTitleMenu;
			this.selectList.x = 128;
			this.selectList.y = 54;
			this.selectList.visible = false;
			
			// Load Menu
			this.loadMenu = new TinySaveLoadMenu(false);
			this.loadMenu.x = int((320 / 2) - (this.loadMenu.width / 2));
			this.loadMenu.y = 40;
			this.loadMenu.hide();
			
			// Slash mask
			this.slashMask = new Sprite;
			this.slashMask.addChild(new Bitmap(new SlashGradient));
			this.slashMask.x = 
			this.slashMask.y = -448;
			this.slashMask.cacheAsBitmap = true;
			
			// Background
			this.background = new Sprite;
			this.background.addChild(new Bitmap(new TitleBackground));
			this.background.mask = this.slashMask;
			this.background.cacheAsBitmap = true;
			this.background.visible = false;
			
			// Add 'em up;
			this.addChild(this.background);
			this.addChild(this.diksoftLogo);
			this.addChild(this.titleSprite);
			this.addChild(this.selectList);
			this.addChild(this.slashMask);
			this.addChild(this.loadMenu);
			
			// Add events
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}
		
		override public function show() : void
		{
			TinyLogManager.log('show', this);
			
			// Start logo sequence
			TweenMax.to(this.diksoftLogo, 18, { alpha:1, useFrames:true, ease:SteppedEase.create(5), onComplete:this.onDikLogoInComplete });
		}

		private function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlAdded', this);
			
			this.addEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.removeEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
			
			this.selectList.addEventListener(TinyMenuEvent.NEW_SELECTED, onNewSelected);			this.selectList.addEventListener(TinyMenuEvent.LOAD_SELECTED, onLoadSelected);			this.selectList.addEventListener(TinyMenuEvent.QUIT_SELECTED, onQuitSelected);
		}
		
		private function onDikLogoInComplete() : void
		{
			TinyLogManager.log('onDikLogoComplete', this);
			
			this.background.visible = true;
			
			// Fade out logo
			TweenMax.to(this.diksoftLogo, 8, { delay:15, alpha:0, useFrames:true, ease:SteppedEase.create(5), onComplete:this.onDikLogoOutComplete });
		}
		
		private function onDikLogoOutComplete() : void
		{
			TinyLogManager.log('onDikLogoOutComplete OH MAN I CHANGED IT', this);
			
			TinyAudioManager.getInstance().playMusic(TinyAudioManager.getInstance().TITLE);
						
			// Transition in title screen
			TweenMax.to(this.slashMask, 8, { x:-84, y:-84, roundProps:["x", "y"], useFrames:true, onComplete:this.onBackgroundInComplete });
		}
		
		private function onBackgroundInComplete() : void
		{
			TinyLogManager.log('onTitleInComplete', this);
		
			// Show game logo
			this.titleSprite.visible = true;
			this.titleSprite.play();
			
			TweenMax.delayedCall(15, this.showMenu, null, true);
					
			// Clean up
			this.removeChild(this.slashMask);
			this.background.mask = null;
			this.slashMask = null;
		}
		
		private function showMenu() : void
		{
			TinyLogManager.log('showMenu', this);
			
			this.selectList.visible = true;
			TinyInputManager.getInstance().setTarget(this.selectList);
		}

		private function onControlRemoved(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlRemoved', this);
			
			this.removeEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}
		
		private function onNewSelected(event : TinyMenuEvent) : void 
		{
			TinyLogManager.log('onNewSelected', this);
			
			// Tell the others!
			this.dispatchEvent(new TinyGameEvent(TinyGameEvent.NEW_GAME));
			
			// Clean up
			this.selectList.removeEventListener(TinyMenuEvent.NEW_SELECTED, onNewSelected);
			this.selectList.removeEventListener(TinyMenuEvent.LOAD_SELECTED, onLoadSelected);
			this.selectList.removeEventListener(TinyMenuEvent.QUIT_SELECTED, onQuitSelected);		}

		private function onLoadSelected(event : TinyMenuEvent) : void 
		{
			TinyLogManager.log('onLoadSelected', this);
			
			// Show load menu
			this.loadMenu.show();
			TinyInputManager.getInstance().setTarget(this.loadMenu);
			
			// Events
			this.loadMenu.addEventListener(TinyInputEvent.ACCEPT, onGameSelected);
			this.loadMenu.addEventListener(TinyInputEvent.CANCEL, onLoadCancel);
			this.selectList.removeEventListener(TinyMenuEvent.NEW_SELECTED, onNewSelected);
			this.selectList.removeEventListener(TinyMenuEvent.LOAD_SELECTED, onLoadSelected);
			this.selectList.removeEventListener(TinyMenuEvent.QUIT_SELECTED, onQuitSelected);
		}

		private function onGameSelected(event : TinyInputEvent) : void 
		{
			TinyLogManager.log('onGameSelected: Slot ' + this.loadMenu.selectedSlot, this);
			
			// Tell the others!
			this.dispatchEvent(new TinyGameEvent(TinyGameEvent.LOAD_GAME, this.loadMenu.selectedSlot));
			
			// Clean up
			this.loadMenu.removeEventListener(TinyInputEvent.ACCEPT, onGameSelected);
			this.loadMenu.removeEventListener(TinyInputEvent.CANCEL, onLoadCancel);
		}

		private function onLoadCancel(event : TinyInputEvent) : void 
		{
			TinyLogManager.log('onLoadCancel', this);
			
			// Give control back
			TinyInputManager.getInstance().setTarget(this.selectList);
				
			// Clean up
			this.loadMenu.hide();
			this.loadMenu.removeEventListener(TinyInputEvent.CANCEL, onLoadCancel);
			
			// Events
			this.selectList.addEventListener(TinyMenuEvent.NEW_SELECTED, onNewSelected);
			this.selectList.addEventListener(TinyMenuEvent.LOAD_SELECTED, onLoadSelected);
			this.selectList.addEventListener(TinyMenuEvent.QUIT_SELECTED, onQuitSelected);
		}

		private function onQuitSelected(event : TinyMenuEvent) : void 
		{
			TinyLogManager.log('onQuitSelected', this);
			
			// Tell the others!
			this.dispatchEvent(new TinyGameEvent(TinyGameEvent.QUIT_GAME));
			
			// Clean up
			this.selectList.removeEventListener(TinyMenuEvent.NEW_SELECTED, onNewSelected);
			this.selectList.removeEventListener(TinyMenuEvent.LOAD_SELECTED, onLoadSelected);
			this.selectList.removeEventListener(TinyMenuEvent.QUIT_SELECTED, onQuitSelected);
		}
	}
}
