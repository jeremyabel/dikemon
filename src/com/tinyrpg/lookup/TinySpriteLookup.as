package com.tinyrpg.lookup 
{
	import com.tinyrpg.display.monsters.*;
	import com.tinyrpg.display.trainers.*;
	
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.BitmapData;

	/**
	 * @author jeremyabel
	 */
	public class TinySpriteLookup 
	{
		public static var PLAYER_1				: int = 0;
		public static var PLAYER_1_BIKE 		: int = 6;
		public static var PLAYER_2				: int = 457;
		public static var PLAYER_2_BIKE			: int = 463;		
		public static var PLAYER_3				: int = 27;
		public static var PLAYER_4				: int = 387;
		public static var NPC_PROF_OAK			: int = 21;
		public static var NPC_GARY_RIVAL		: int = 33;
		public static var NPC_OLD_MAN_1 		: int = 45;
		public static var NPC_OLD_MAN_2			: int = 132;
		public static var NPC_OLD_MAN_3			: int = 171;
		public static var NPC_OLD_MAN_4			: int = 183;
		public static var NPC_OLD_MAN_5			: int = 256;
		public static var NPC_OLD_MAN_6			: int = 268;
		public static var NPC_OLD_MAN_7			: int = 351;
		public static var NPC_OLD_LADY			: int = 274;
		public static var NPC_HEADBAND_GIRL_1	: int = 51;
		public static var NPC_HEADBAND_GIRL_2	: int = 177;
		public static var NPC_MOHAWK_GUY		: int = 57;
		public static var NPC_MOM_1				: int = 63;
		public static var NPC_MOM_2 			: int = 75; 
		public static var NPC_SCIENTIST_1		: int = 69;
		public static var NPC_SCIENTIST_2		: int = 87;
		public static var NPC_SCIENTIST_3		: int = 339;
		public static var NPC_LONG_HAIR_GIRL_1	: int = 81;
		public static var NPC_LONG_HAIR_GIRL_2 	: int = 138;
		public static var NPC_LONG_HAIR_GIRL_3	: int = 189;
		public static var NPC_LONG_HAIR_GIRL_5	: int = 231;
		public static var NPC_LONG_HAIR_GIRL_6	: int = 237;
		public static var NPC_PONY_TAIL_GIRL_1	: int = 102;
		public static var NPC_PONY_TAIL_GIRL_2	: int = 126;
		public static var NPC_PONY_TAIL_GIRL_3	: int = 201;
		public static var NPC_PONY_TAIL_GIRL_4	: int = 225;		 		 
		public static var NPC_EMO_GUY			: int = 96;
		public static var NPC_SCRUFFY_GUY		: int = 39;
		public static var NPC_SCRUFFY_GIRL		: int = 108;
		public static var NPC_HEADBAND_GUY_1	: int = 114;
		public static var NPC_HEADBAND_GUY_2	: int = 369;
		public static var NPC_BANDANA_GUY		: int = 408;
		public static var NPC_MOTORCYCLE_GUY	: int = 414;
		public static var NPC_SUNGLASSES_GUY	: int = 420;
		public static var NPC_ANGRY_GUY			: int = 120;
		public static var NPC_KARATE_GUY		: int = 153;
		public static var NPC_EVIL_CAPE_GUY		: int = 165;
		public static var NPC_BROCK				: int = 144;
		public static var NPC_MISTY				: int = 159;
		public static var NPC_CASUAL_GUY_1		: int = 195;
		public static var NPC_CASUAL_GUY_2		: int = 219;
		public static var NPC_CASUAL_GUY_3		: int = 243;
		public static var NPC_CASUAL_GUY_4		: int = 321;
		public static var NPC_CASUAL_GUY_5		: int = 327;
		public static var NPC_NERD_GUY			: int = 402;
		public static var NPC_LITTLE_BOY		: int = 207;
		public static var NPC_LITTLE_GIRL		: int = 213;
		public static var NPC_GERMAN_GUY		: int = 249;
		public static var NPC_GERMAN_GIRL		: int = 262;
		public static var NPC_SWIMMER_GUY		: int = 280;
		public static var NPC_SWIMMER_GIRL		: int = 286;
		public static var NPC_PIKA_SURFER		: int = 294;
		public static var NPC_ROCKET_GUY		: int = 300;
		public static var NPC_ROCKET_GIRL		: int = 306;
		public static var NPC_SAFARI_GUY		: int = 333;
		public static var NPC_KIMONO_GIRL		: int = 345;
		public static var NPC_TOPHAT_MAN		: int = 363;
		public static var NPC_CONDUCTOR_GUY		: int = 381;
		public static var NPC_SUNHAT_GIRL		: int = 375;
		public static var NPC_NURSE				: int = 315;
		public static var NPC_GROUND_MON		: int = 426;
		public static var NPC_FAIRY_MON			: int = 432;
		public static var NPC_BIRD_MON			: int = 438;
		public static var NPC_DRAGON_MON		: int = 444;

		public static function getMonsterSprite(name : String) : BitmapData
		{
			TinyLogManager.log('getMonsterSprite: ' + name, null);
			
			var newSprite : BitmapData;

			switch (name) 
			{
				case 'Box'				: newSprite = new Box; break;
				case 'Bucket'			: newSprite = new Bucket; break;
				case 'Shorts Kid'		: newSprite = new ComfyShortsKid; break;
				case 'Egg'				: newSprite = new Egg; break;
				case 'Shoe'				: newSprite = new Shoe; break;
				case 'Tall Grass'		: newSprite = new TallGrass; break;
				case 'Computer'			: newSprite = new Computer; break;
				case 'Four Of Clubs'	: newSprite = new FourOfClubs; break;
				case 'Ace Of Spades'	: newSprite = new AceOfSpades; break;
				default					: newSprite = new ComfyShortsKid; break;
			}
			
			return newSprite;	
		}
		
		public static function getTrainerSprite(name : String) : BitmapData
		{
			TinyLogManager.log('getTrainerSprite: ' + name, null);
			
			var newSprite : BitmapData;
			
			switch (name) 
			{
				case 'Player': newSprite = new TrainerPlayer; break;	
				default: newSprite = new TrainerPlayer; break;
			}
			
			return newSprite;
		}
	}
}
