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
		public static var NPC_DIKEBALL			: int = 472;
		
		public static function getFieldSpriteId( name : String ) : int
		{
			TinyLogManager.log( 'getFieldSpriteId: ' + name, null );
			
			switch ( name )
			{
				default:
				case "PLAYER 1":			return PLAYER_1;
				case "PLAER 1 BIKE":		return PLAYER_1_BIKE;
				case "PLAYER 2":			return PLAYER_2;
				case "PLAYER 2 BIKE":		return PLAYER_2_BIKE;
				case "PLAYER 3":			return PLAYER_3;
				case "PLAYER 4":			return PLAYER_4;
				case "PROF OAK":			return NPC_PROF_OAK;
				case "GARY RIVAL":			return NPC_GARY_RIVAL;
				case "OLD MAN 1":			return NPC_OLD_MAN_1;
				case "OLD MAN 2":			return NPC_OLD_MAN_2;
				case "OLD MAN 3":			return NPC_OLD_MAN_3;
				case "OLD MAN 4":			return NPC_OLD_MAN_4;
				case "OLD MAN 5":			return NPC_OLD_MAN_5;
				case "OLD MAN 6":			return NPC_OLD_MAN_6;
				case "OLD MAN 7":			return NPC_OLD_MAN_7;
				case "OLD LADY":			return NPC_OLD_LADY;
				case "HEADBAND GIRL 1":		return NPC_HEADBAND_GIRL_1;
				case "HEADBAND GIRL 2":		return NPC_HEADBAND_GIRL_2;
				case "MOHAWK GUY":			return NPC_MOHAWK_GUY;
				case "MOM 1":				return NPC_MOM_1;
				case "MOM 2":				return NPC_MOM_2;
				case "SCIENTIST 1":			return NPC_SCIENTIST_1;
				case "SCIENTIST 2":			return NPC_SCIENTIST_2;
				case "SCIENTIST 3":			return NPC_SCIENTIST_3;
				case "LONG HAIR GIRL 1":	return NPC_LONG_HAIR_GIRL_1;
				case "LONG HAIR GIRL 2":	return NPC_LONG_HAIR_GIRL_2;
				case "LONG HAIR GIRL 3":	return NPC_LONG_HAIR_GIRL_3;
				case "LONG HAIR GIRL 5":	return NPC_LONG_HAIR_GIRL_5;
				case "LONG HAIR GIRL 6":	return NPC_LONG_HAIR_GIRL_6;
				case "PONY TAIL GIRL 1":	return NPC_PONY_TAIL_GIRL_1;
				case "PONY TAIL GIRL 2":	return NPC_PONY_TAIL_GIRL_2;
				case "PONY TAIL GIRL 3":	return NPC_PONY_TAIL_GIRL_3;
				case "PONY TAIL GIRL 4":	return NPC_PONY_TAIL_GIRL_4;
				case "EMO GUY":				return NPC_EMO_GUY;
				case "SCRUFFY GUY":			return NPC_SCRUFFY_GUY;
				case "SCRUFFY GIRL":		return NPC_SCRUFFY_GIRL;
				case "HEADBAND GUY 1":		return NPC_HEADBAND_GUY_1;
				case "HEADBAND GUY 2":		return NPC_HEADBAND_GUY_2;
				case "BANDANA GUY":			return NPC_BANDANA_GUY;
				case "MOTORCYCLE GUY":		return NPC_MOTORCYCLE_GUY;
				case "SUNGLASSES GUY":		return NPC_SUNGLASSES_GUY;
				case "ANGRY GUY":			return NPC_ANGRY_GUY;
				case "KARATE GUY":			return NPC_KARATE_GUY;
				case "EVIL CAPE GUY":		return NPC_EVIL_CAPE_GUY;
				case "BROCK":				return NPC_BROCK;
				case "MISTY":				return NPC_MISTY;
				case "CASUAL GUY 1":		return NPC_CASUAL_GUY_1;
				case "CASUAL GUY 2":		return NPC_CASUAL_GUY_2;
				case "CASUAL GUY 3":		return NPC_CASUAL_GUY_3;
				case "CASUAL GUY 4":		return NPC_CASUAL_GUY_4;
				case "CASUAL GUY 5":		return NPC_CASUAL_GUY_5;
				case "NERD GUY":			return NPC_NERD_GUY;
				case "LITTLE BOY":			return NPC_LITTLE_BOY;
				case "LITTLE GIRL":			return NPC_LITTLE_GIRL;
				case "GERMAN GUY":			return NPC_GERMAN_GUY;
				case "GERMAN GIRL":			return NPC_GERMAN_GIRL;
				case "SWIMMER GUY":			return NPC_SWIMMER_GUY;
				case "SWIMMER GIRL":		return NPC_SWIMMER_GIRL;
				case "PIKA SURFER":			return NPC_PIKA_SURFER;
				case "ROCKET GUY":			return NPC_ROCKET_GUY;
				case "ROCKET GIRL":			return NPC_ROCKET_GIRL;
				case "SAFARI GUY":			return NPC_SAFARI_GUY;
				case "KIMONO GIRL":			return NPC_KIMONO_GIRL;
				case "TOPHAT MAN":			return NPC_TOPHAT_MAN;
				case "CONDUCTOR GUY":		return NPC_CONDUCTOR_GUY;
				case "SUNHAT GIRL":			return NPC_SUNHAT_GIRL;
				case "NURSE":				return NPC_NURSE;
				case "GROUND MON":			return NPC_GROUND_MON;
				case "FAIRY MON":			return NPC_FAIRY_MON;
				case "BIRD MON":			return NPC_BIRD_MON;
				case "DRAGON MON":			return NPC_DRAGON_MON;
				case "DIKEBALL":			return NPC_DIKEBALL;
			}
		}

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
		
		public static function getTrainerSprite( name : String ) : BitmapData
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
