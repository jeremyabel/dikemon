package com.tinyrpg.display
{
	import com.tinyrpg.display.emotes.*;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * Display class for a emote icon sprite, shown above a {@link TinyWalkSprite}.
	 * 
	 * The sprite can show various emote icons and is used to add some fun to dialog scenes.
	 * The emote icons are shown and hidden using the SHOW_EMOTE and HIDE_EMOTE
	 * events in the event sequencer.
	 * 
	 * @author jeremyabel
	 */
	public class TinyEmoteIcon extends Sprite 
	{
		public static const EMOTE_EXCLAIM 		: String = 'EXCLAIM';
		public static const EMOTE_FISH			: String = 'FISH';
		public static const EMOTE_HAPPY			: String = 'HAPPY';
		public static const EMOTE_HEART			: String = 'HEART';
		public static const EMOTE_QUESTION		: String = 'QUESTION';
		public static const EMOTE_SKULL			: String = 'SKULL';
		public static const EMOTE_SLEEP			: String = 'SLEEP';
		
		private var emoteExclaim				: Bitmap;
		private var emoteFish					: Bitmap;
		private var emoteHappy					: Bitmap;
		private var emoteHeart					: Bitmap;
		private var emoteQuestion				: Bitmap;
		private var emoteSkull					: Bitmap;
		private var emoteSleep					: Bitmap;
		
		public function TinyEmoteIcon() : void
		{			
			this.emoteExclaim 	= new Bitmap( new EmoteExclaim );
			this.emoteFish		= new Bitmap( new EmoteFish );
			this.emoteHappy		= new Bitmap( new EmoteHappy );
			this.emoteHeart		= new Bitmap( new EmoteHeart );
			this.emoteQuestion	= new Bitmap( new EmoteQuestion );
			this.emoteSkull		= new Bitmap( new EmoteSkull );
			this.emoteSleep		= new Bitmap( new EmoteSleep );
			
			this.hide();
			
			// Add 'em up
			this.addChild( this.emoteExclaim );
			this.addChild( this.emoteFish );
			this.addChild( this.emoteHappy );
			this.addChild( this.emoteHeart );
			this.addChild( this.emoteQuestion );
			this.addChild( this.emoteSkull );
			this.addChild( this.emoteSleep );	
		}
		
		/**
		 * Shows the specified emote icon sprite. 
		 */
		public function show( emoteName : String ) : void
		{
			TinyLogManager.log( 'show: ' + emoteName, this );
			
			// Hide all emote icons
			this.hide();
			
			// Show only the one requested
			switch ( emoteName.toUpperCase() ) 
			{
				case EMOTE_EXCLAIM:		this.emoteExclaim.visible = true; break;
				case EMOTE_FISH:		this.emoteFish.visible = true; break;
				case EMOTE_HAPPY:		this.emoteHappy.visible = true; break;
				case EMOTE_HEART:		this.emoteHeart.visible = true; break;
				case EMOTE_QUESTION:	this.emoteQuestion.visible = true; break;
				case EMOTE_SKULL:		this.emoteSkull.visible = true; break;
				case EMOTE_SLEEP:		this.emoteSleep.visible = true; break;
			}
		}
		
		/**
		 * Hides the emote icon sprite.
		 */
		public function hide() : void
		{
			this.emoteExclaim.visible = false;
			this.emoteFish.visible = false;
			this.emoteHappy.visible = false;
			this.emoteHeart.visible = false;
			this.emoteQuestion.visible = false;
			this.emoteSkull.visible = false;
			this.emoteSleep.visible = false;
		}
	}
}
