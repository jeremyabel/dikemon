package com.tinyrpg.debug 
{
	import com.tinyrpg.data.TinyAppSettings;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.misc.TinyCSS;
	import com.tinyrpg.core.TinyFieldMap;
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.misc.TinySpriteConfig;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.utils.ByteArray;

	/**
	 * @author jeremyabel
	 */
	public class TinyMapTester extends MovieClip
	{
		public function TinyMapTester() : void
		{
			var appSettings : TinyAppSettings = new TinyAppSettings( stage );
			var inputManager : TinyInputManager = TinyInputManager.getInstance();
			
			// Init font manager
			var tinyCSS : TinyCSS = new TinyCSS();
			TinyFontManager.initWithCSS( TinyCSS.cssString );
			
			var map : TinyFieldMap = new TinyFieldMap( 'City' );
			
			var sprites : Array = [
				new TinyWalkSprite( TinySpriteConfig.PLAYER_1 ),
				new TinyWalkSprite( TinySpriteConfig.PLAYER_1_BIKE ),
				new TinyWalkSprite( TinySpriteConfig.PLAYER_2 ),
				new TinyWalkSprite( TinySpriteConfig.PLAYER_2_BIKE ),
				new TinyWalkSprite( TinySpriteConfig.PLAYER_3 ),
				new TinyWalkSprite( TinySpriteConfig.PLAYER_4 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_PROF_OAK ),
				new TinyWalkSprite( TinySpriteConfig.NPC_GARY_RIVAL ),
				new TinyWalkSprite( TinySpriteConfig.NPC_OLD_MAN_1 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_OLD_MAN_2 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_OLD_MAN_3 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_OLD_MAN_4 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_OLD_MAN_5 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_OLD_MAN_6 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_OLD_MAN_7 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_OLD_LADY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_HEADBAND_GIRL_1 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_HEADBAND_GIRL_2 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_MOHAWK_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_MOM_1 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_MOM_2 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_SCIENTIST_1 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_SCIENTIST_2 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_SCIENTIST_3 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_LONG_HAIR_GIRL_1 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_LONG_HAIR_GIRL_2 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_LONG_HAIR_GIRL_3 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_LONG_HAIR_GIRL_5 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_LONG_HAIR_GIRL_6 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_PONY_TAIL_GIRL_1 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_PONY_TAIL_GIRL_2 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_PONY_TAIL_GIRL_3 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_PONY_TAIL_GIRL_4 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_EMO_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_SCRUFFY_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_SCRUFFY_GIRL ),
				new TinyWalkSprite( TinySpriteConfig.NPC_HEADBAND_GUY_1 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_HEADBAND_GUY_2 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_BANDANA_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_MOTORCYCLE_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_SUNGLASSES_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_ANGRY_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_KARATE_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_EVIL_CAPE_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_BROCK ),
				new TinyWalkSprite( TinySpriteConfig.NPC_MISTY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_CASUAL_GUY_1 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_CASUAL_GUY_2 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_CASUAL_GUY_3 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_CASUAL_GUY_4 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_CASUAL_GUY_5 ),
				new TinyWalkSprite( TinySpriteConfig.NPC_NERD_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_LITTLE_BOY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_LITTLE_GIRL ),
				new TinyWalkSprite( TinySpriteConfig.NPC_GERMAN_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_GERMAN_GIRL ),
				new TinyWalkSprite( TinySpriteConfig.NPC_SWIMMER_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_SWIMMER_GIRL ),
				new TinyWalkSprite( TinySpriteConfig.NPC_PIKA_SURFER ),
				new TinyWalkSprite( TinySpriteConfig.NPC_ROCKET_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_ROCKET_GIRL ),
				new TinyWalkSprite( TinySpriteConfig.NPC_SAFARI_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_KIMONO_GIRL ),
				new TinyWalkSprite( TinySpriteConfig.NPC_TOPHAT_MAN ),
				new TinyWalkSprite( TinySpriteConfig.NPC_CONDUCTOR_GUY ),
				new TinyWalkSprite( TinySpriteConfig.NPC_SUNHAT_GIRL ),
				new TinyWalkSprite( TinySpriteConfig.NPC_NURSE ),
				new TinyWalkSprite( TinySpriteConfig.NPC_GROUND_MON ),
				new TinyWalkSprite( TinySpriteConfig.NPC_FAIRY_MON ),
				new TinyWalkSprite( TinySpriteConfig.NPC_BIRD_MON ),
				new TinyWalkSprite( TinySpriteConfig.NPC_DRAGON_MON )
			];
				
			var yOffset : uint = 12;
			var xOffset : uint = 12; 
			
			for ( var i : uint = 0; i < sprites.length; i++ ) 
			{
				if ( i > 0 && i % 16 == 0 ) 
				{ 
					xOffset += 122;
					yOffset = 12;
				}
				
				sprites[ i ].x = xOffset;
				sprites[ i ].y = yOffset;
				map.addChild( sprites[ i ] );
				
				yOffset += 16;	
			}
			
			var scaleFactor : Number = stage.stageHeight / 144;
			TinyAppSettings.SCALE_FACTOR = scaleFactor;
			map.scaleX *= scaleFactor;
			map.scaleY *= scaleFactor;
			this.addChild( map );
			
		}
	}
}