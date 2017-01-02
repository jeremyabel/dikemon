package com.tinyrpg.display 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.SteppedEase;
	import com.tinyrpg.display.misc.CampfireCard;
	import com.tinyrpg.display.misc.CreditsCard;
	import com.tinyrpg.display.misc.ForeshadowCard;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyEnding extends Sprite 
	{
		private var campfireCard : TinyFinalEndCard;
		private var foreshadowCard : Sprite;
		private var creditsCard : TinyFinalEndCard;
		
		public function TinyEnding() : void
		{
			// Make cards
			this.campfireCard = new TinyFinalEndCard(new CampfireCard, 2);			this.creditsCard = new TinyFinalEndCard(new CreditsCard);
			this.foreshadowCard = new Sprite;
			this.foreshadowCard.addChild(new Bitmap(new ForeshadowCard));
			this.foreshadowCard.alpha = 0;
			
			// Add 'em up				this.addChild(this.creditsCard);			this.addChild(this.foreshadowCard);
			this.addChild(this.campfireCard);
		}

		public function show() : void
		{
			TinyLogManager.log('show', this);
			
			// Play music
			TinyAudioManager.getInstance().setSong(TinyAudioManager.getInstance().musicFriendship, false);
			
			this.campfireCard.show();
			this.campfireCard.addEventListener(Event.COMPLETE, onCampfireComplete);
		}

		private function onCampfireComplete(event : Event) : void 
		{
			TinyLogManager.log('onCampfireComplete', this);
			this.removeChild(this.campfireCard);
			TweenLite.to(this.foreshadowCard, 40, { alpha:1, ease:SteppedEase.create(6), useFrames:true });
			TweenLite.to(this.foreshadowCard, 40, { alpha:0, ease:SteppedEase.create(6), useFrames:true, delay:200, onComplete:this.onForeshadowComplete });
		}
		
		private function onForeshadowComplete() : void
		{
			TinyLogManager.log('onForeshadowComplete', this);
			this.removeChild(this.foreshadowCard);
			
			// Play music
			TinyAudioManager.getInstance().setSong(TinyAudioManager.getInstance().TITLE, false);
			
			this.creditsCard.show();
			this.creditsCard.addEventListener(Event.COMPLETE, onCreditsComplete);
		}

		private function onCreditsComplete(event : Event) : void 
		{
			TinyLogManager.log('onCreditsComplete', this);
		}
	}
}
