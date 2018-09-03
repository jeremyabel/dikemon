package com.tinyrpg.debug 
{
	import com.tinyrpg.data.TinyAppSettings;
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.lookup.TinySpriteLookup;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.misc.TinyCSS;
	import com.tinyrpg.utils.TinyMath;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;

	/**
	 * @author jeremyabel
	 */
	public class TinySpriteTester extends MovieClip
	{
		public function TinySpriteTester() : void
		{
			var appSettings : TinyAppSettings = new TinyAppSettings(stage);
			var inputManager : TinyInputManager = TinyInputManager.getInstance();
			
			// Init font manager
			var tinyCSS : TinyCSS = new TinyCSS();
			TinyFontManager.initWithCSS(TinyCSS.cssString);
			
			var spriteNames : Array = [
				"PLAYER 1",		
				"PLAYER 1 BIKE",
				"PLAYER 2",	
				"PLAYER 2 BIKE",
				"PLAYER 3",	
				"PLAYER 4",	
				"PROF OAK",	
				"GARY RIVAL",	
				"OLD MAN 1",	
				"OLD MAN 2",	
				"OLD MAN 3",	
				"OLD MAN 4",	
				"OLD MAN 5",	
				"OLD MAN 6",	
				"OLD MAN 7",	
				"OLD LADY",	
				"HEADBAND GIRL 1",
				"HEADBAND GIRL 2",
				"MOHAWK GUY",	
				"MOM 1",		
				"MOM 2",		
				"SCIENTIST 1",	
				"SCIENTIST 2",	
				"SCIENTIST 3",	
				"LONG HAIR GIRL 1",
				"LONG HAIR GIRL 2",
				"LONG HAIR GIRL 3",
				"LONG HAIR GIRL 5",
				"LONG HAIR GIRL 6",
				"PONY TAIL GIRL 1",
				"PONY TAIL GIRL 2",
				"PONY TAIL GIRL 3",
				"PONY TAIL GIRL 4",
				"EMO GUY",		
				"SCRUFFY GUY",	
				"SCRUFFY GIRL",
				"HEADBAND GUY 1",
				"HEADBAND GUY 2",
				"BANDANA GUY",	
				"MOTORCYCLE GUY",
				"SUNGLASSES GUY",
				"ANGRY GUY",	
				"KARATE GUY",	
				"EVIL CAPE GUY",
				"BROCK",		
				"MISTY",		
				"CASUAL GUY 1",
				"CASUAL GUY 2",
				"CASUAL GUY 3",
				"CASUAL GUY 4",
				"CASUAL GUY 5",
				"NERD GUY",	
				"LITTLE BOY",	
				"LITTLE GIRL",	
				"GERMAN GUY",	
				"GERMAN GIRL",	
				"SWIMMER GUY",	
				"SWIMMER GIRL",
				"PIKA SURFER",	
				"ROCKET GUY",	
				"ROCKET GIRL",	
				"SAFARI GUY",	
				"KIMONO GIRL",	
				"TOPHAT MAN",	
				"CONDUCTOR GUY",
				"SUNHAT GIRL",	
				"NURSE",		
				"GROUND MON",	
				"FAIRY MON",
				"BIRD MON",	
				"DRAGON MON",	
				"CAT MON",
				"DIKEBALL"
			];
			
			// Resize to fit the screen
			var scaleFactor : Number = stage.stageHeight / 144;
			TinyAppSettings.SCALE_FACTOR = scaleFactor;
			
			var x : int = 0;
			var y : int = 0;
			var spacing : int = 52;
			
			for ( var i : int = 0; i < spriteNames.length; i++ )
			{
				var spriteName : String = spriteNames[ i ];
				var spriteId : int = TinySpriteLookup.getFieldSpriteId( spriteName );
				var walkSprite : TinyWalkSprite = new TinyWalkSprite( spriteId, "DOWN" );
				
				x++;
				if ( i % 10 == 0 ) x = 0;
				if ( x == 0 ) y++;
				
				walkSprite.x = (x * spacing) + spacing;
				walkSprite.y = (y * spacing) + (spacing / 2);
				walkSprite.scaleX = 3;
				walkSprite.scaleY = 3;
				
				walkSprite.addEventListener( MouseEvent.MOUSE_DOWN, this.onSpriteClicked );
				
				this.addChild( walkSprite );
			}
//			this.addChild();
		}
		
		private function onSpriteClicked( event : MouseEvent ) : void
		{
			trace( TinySpriteLookup.getSpriteNameFromId( event.currentTarget.id ) );
		}
	}
}
