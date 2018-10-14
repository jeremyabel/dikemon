package com.tinyrpg.lookup 
{
	import com.tinyrpg.display.monsters.*;
	import com.tinyrpg.display.trainers.*;
	import com.tinyrpg.display.objects.*;
	
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.BitmapData;

	/**
	 * @author jeremyabel
	 */
	public class TinySpriteLookup 
	{
		public static var PLAYER_1				: int = 27;
		public static var PLAYER_1_BIKE 		: int = 6;
		public static var PLAYER_2				: int = 457;
		public static var PLAYER_2_BIKE			: int = 463;		
		public static var PLAYER_3				: int = 0;
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
		public static var NPC_CAT_MON			: int = 450;
		public static var NPC_DIKEBALL			: int = 472;
		
		public static function getFieldSpriteId( name : String ) : int
		{
			TinyLogManager.log( 'getFieldSpriteId: ' + name, null );
			
			switch ( name.toUpperCase() )
			{
				default:
				case "PLAYER 1":			return PLAYER_1;
				case "PLAYER 1 BIKE":		return PLAYER_1_BIKE;
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
				case "CAT MON":				return NPC_CAT_MON;
				case "DIKEBALL":			return NPC_DIKEBALL;
			}
		}
		
		public static function getSpriteNameFromId( id : int ) : String
		{
			switch ( id )
			{
				default:
				case PLAYER_1: return "PLAYER 1";
				case PLAYER_1_BIKE: return "PLAYER 1 BIKE";
				case PLAYER_2: return "PLAYER 2";
				case PLAYER_2_BIKE: return "PLAYER 2 BIKE";
				case PLAYER_3: return "PLAYER 3";
				case PLAYER_4: return "PLAYER 4";
				case NPC_PROF_OAK: return "PROF OAK";
				case NPC_GARY_RIVAL: return "GARY RIVAL";
				case NPC_OLD_MAN_1: return "OLD MAN 1";
				case NPC_OLD_MAN_2: return "OLD MAN 2";
				case NPC_OLD_MAN_3: return "OLD MAN 3";
				case NPC_OLD_MAN_4: return "OLD MAN 4";
				case NPC_OLD_MAN_5: return "OLD MAN 5";
				case NPC_OLD_MAN_6: return "OLD MAN 6";
				case NPC_OLD_MAN_7: return "OLD MAN 7";
				case NPC_OLD_LADY: return "OLD LADY";
				case NPC_HEADBAND_GIRL_1: return "HEADBAND GIRL 1";
				case NPC_HEADBAND_GIRL_2: return "HEADBAND GIRL 2";
				case NPC_MOHAWK_GUY: return "MOHAWK GUY";
				case NPC_MOM_1: return "MOM 1";
				case NPC_MOM_2: return "MOM 2";
				case NPC_SCIENTIST_1: return "SCIENTIST 1";
				case NPC_SCIENTIST_2: return "SCIENTIST 2";
				case NPC_SCIENTIST_3: return "SCIENTIST 3";
				case NPC_LONG_HAIR_GIRL_1: return "LONG HAIR GIRL 1";
				case NPC_LONG_HAIR_GIRL_2: return "LONG HAIR GIRL 2";
				case NPC_LONG_HAIR_GIRL_3: return "LONG HAIR GIRL 3";
				case NPC_LONG_HAIR_GIRL_5: return "LONG HAIR GIRL 5";
				case NPC_LONG_HAIR_GIRL_6: return "LONG HAIR GIRL 6";
				case NPC_PONY_TAIL_GIRL_1: return "PONY TAIL GIRL 1";
				case NPC_PONY_TAIL_GIRL_2: return "PONY TAIL GIRL 2";
				case NPC_PONY_TAIL_GIRL_3: return "PONY TAIL GIRL 3";
				case NPC_PONY_TAIL_GIRL_4: return "PONY TAIL GIRL 4";
				case NPC_EMO_GUY: return "EMO GUY";
				case NPC_SCRUFFY_GUY: return "SCRUFFY GUY";
				case NPC_SCRUFFY_GIRL: return "SCRUFFY GIRL";
				case NPC_HEADBAND_GUY_1: return "HEADBAND GUY 1";
				case NPC_HEADBAND_GUY_2: return "HEADBAND GUY 2";
				case NPC_BANDANA_GUY: return "BANDANA GUY";
				case NPC_MOTORCYCLE_GUY: return "MOTORCYCLE GUY";
				case NPC_SUNGLASSES_GUY: return "SUNGLASSES GUY";
				case NPC_ANGRY_GUY: return "ANGRY GUY";
				case NPC_KARATE_GUY: return "KARATE GUY";
				case NPC_EVIL_CAPE_GUY: return "EVIL CAPE GUY";
				case NPC_BROCK: return "BROCK";
				case NPC_MISTY: return "MISTY";
				case NPC_CASUAL_GUY_1: return "CASUAL GUY 1";
				case NPC_CASUAL_GUY_2: return "CASUAL GUY 2";
				case NPC_CASUAL_GUY_3: return "CASUAL GUY 3";
				case NPC_CASUAL_GUY_4: return "CASUAL GUY 4";
				case NPC_CASUAL_GUY_5: return "CASUAL GUY 5";
				case NPC_NERD_GUY: return "NERD GUY";
				case NPC_LITTLE_BOY: return "LITTLE BOY";
				case NPC_LITTLE_GIRL: return "LITTLE GIRL";
				case NPC_GERMAN_GUY: return "GERMAN GUY";
				case NPC_GERMAN_GIRL: return "GERMAN GIRL";
				case NPC_SWIMMER_GUY: return "SWIMMER GUY";
				case NPC_SWIMMER_GIRL: return "SWIMMER GIRL";
				case NPC_PIKA_SURFER: return "PIKA SURFER";
				case NPC_ROCKET_GUY: return "ROCKET GUY";
				case NPC_ROCKET_GIRL: return "ROCKET GIRL";
				case NPC_SAFARI_GUY: return "SAFARI GUY";
				case NPC_KIMONO_GIRL: return "KIMONO GIRL";
				case NPC_TOPHAT_MAN: return "TOPHAT MAN";
				case NPC_CONDUCTOR_GUY: return "CONDUCTOR GUY";
				case NPC_SUNHAT_GIRL: return "SUNHAT GIRL";
				case NPC_NURSE: return "NURSE";
				case NPC_GROUND_MON: return "GROUND MON";
				case NPC_FAIRY_MON: return "FAIRY MON";
				case NPC_BIRD_MON: return "BIRD MON";
				case NPC_DRAGON_MON: return "DRAGON MON";
				case NPC_CAT_MON: return "CAT MON";
				case NPC_DIKEBALL: return "DIKEBALL"; 
			}
		}
		
		public static function getPlayerSpriteId( name : String ) : int
		{
			TinyLogManager.log( 'getPlayerSpriteId: ' + name, null );
			
			switch ( name.toUpperCase() ) 
			{	
				case 'ANDY': 	return NPC_GARY_RIVAL;
				case 'BILL':	return NPC_CASUAL_GUY_4;
				case 'BRENTON':	return NPC_GARY_RIVAL;
				case 'CHRIS':	return PLAYER_1;
				case 'DAVE':	return NPC_CASUAL_GUY_2;
				case 'EVAN':	return PLAYER_3;
				case 'JASON':	return PLAYER_4;
				case 'MEGAN':	return NPC_PONY_TAIL_GIRL_1;
				case 'RACHEL':	return NPC_PONY_TAIL_GIRL_4;
				case 'RALPH':	return NPC_SCRUFFY_GUY;
				case 'RON':		return NPC_GERMAN_GUY;
				case 'QUINN':	return NPC_EMO_GUY;
				default:		return PLAYER_1;
			}
		}

		public static function getMonsterSprite( name : String ) : BitmapData
		{
			TinyLogManager.log( 'getMonsterSprite: ' + name, null );
			
			var newSprite : BitmapData;

			switch ( name.toUpperCase() ) 
			{
				// Garbage
				case 'BOX': 			newSprite = new Box; break;
				case 'BUCKET': 			newSprite = new Bucket; break;
				case 'SHORTS KID': 		newSprite = new ComfyShortsKid; break;
				case 'EGG':	 			newSprite = new Egg; break;
				case 'SHOE': 			newSprite = new Shoe; break;
				case 'TALL GRASS': 		newSprite = new TallGrass; break;
				case 'COMPUTER': 		newSprite = new Computer; break;
				case 'FOUR OF CLUBS': 	newSprite = new FourOfClubs; break;
				case 'ACE OF SPADES': 	newSprite = new AceOfSpades; break;
				case 'FAX MACHINE':		newSprite = new FaxMachine; break;
					
				// Humans
				case 'GAGNON': 			newSprite = new HumanGagnon; break;
				case 'MARUSKA': 		newSprite = new HumanMaruska; break;
				case 'ALEX': 			newSprite = new HumanAlex; break;
				case 'BILL': 			newSprite = new HumanBill; break;
				case 'BRENTON': 		newSprite = new HumanBrenton; break;
				case 'CHRIS': 			newSprite = new HumanChris; break;
				case 'DAVE': 			newSprite = new HumanDave; break;
				case 'STARK':			newSprite = new HumanStark; break;
				case 'JASON': 			newSprite = new HumanJason; break;
				case 'KRISTI': 			newSprite = new HumanKristi; break;
				case 'CLEGG': 			newSprite = new HumanClegg; break;
				case 'ZIGGY': 			newSprite = new HumanZiggy; break;
				case 'RACHEL': 			newSprite = new HumanRachel; break;
				case 'RALPH': 			newSprite = new HumanRalph; break;
				case 'RON': 			newSprite = new HumanRon; break;
				case 'QUINN': 			newSprite = new HumanQuinn; break;
				case 'YULIA': 			newSprite = new HumanYulia; break;
				
				default: 				newSprite = new ComfyShortsKid; break;
			}
			
			return newSprite;	
		}
		
		public static function getTrainerSprite( name : String ) : BitmapData
		{
			TinyLogManager.log( 'getTrainerSprite: ' + name, null );
			
			var newSprite : BitmapData;
			
			switch ( name.toUpperCase() ) 
			{
				// Humans
				case 'ANDY': 			newSprite = new HumanMaruska; break;
				case 'BILL': 			newSprite = new HumanBill; break;
				case 'CHRIS': 			newSprite = new HumanChris; break;
				case 'DAVE': 			newSprite = new HumanDave; break;
				case 'EVAN': 			newSprite = new HumanStark; break;
				case 'JASON': 			newSprite = new HumanJason; break;
				case 'GAGNON': 			newSprite = new HumanGagnon; break;
				case 'ALEX': 			newSprite = new HumanAlex; break;
				case 'BRENTON': 		newSprite = new HumanBrenton; break;
				case 'KRISTI': 			newSprite = new HumanKristi; break;
				case 'MEGAN': 			newSprite = new HumanClegg; break;
				case 'ZIGGY': 			newSprite = new HumanZiggy; break;
				case 'RACHEL': 			newSprite = new HumanRachel; break;
				case 'RALPH': 			newSprite = new HumanRalph; break;
				case 'RON': 			newSprite = new HumanRon; break;
				case 'QUINN': 			newSprite = new HumanQuinn; break;
				case 'OAK':				newSprite = new TrainerOak; break;
				
				// Enemy Trainers
				case 'TEAM VOMIT':		newSprite = new TrainerTeamVomit1; break;
				case 'TEAM PROFIT':		newSprite = new TrainerTeamVomit2; break;
				case 'GARY MONTANA': 	newSprite = new TrainerGaryMontana; break;
				case 'STEVE PIZAZZ':	newSprite = new TrainerStevePizazz; break;
				case 'WALLY':			newSprite = new TrainerWally; break;
				
				default: 				newSprite = new TrainerPlayer; break;
			}
			
			return newSprite;
		}
		
		public static function getObjectSprite( name : String ) : BitmapData
		{
			TinyLogManager.log( 'getObjectSprite: ' + name, null );
			
			var newSprite : BitmapData;
			
			switch ( name.toUpperCase() ) 
			{
				case 'BOAT':
				case 'BOAT_DOCKED':
				case 'BOAT_ARRIVING':
				case 'BOAT_SAILING': 	newSprite = new BoatObject; break;
			}
			
			return newSprite;
		}
	}
}
