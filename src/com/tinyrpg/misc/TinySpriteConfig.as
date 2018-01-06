package com.tinyrpg.misc 
{
	import com.tinyrpg.display.monsters.*;
	import com.tinyrpg.display.trainers.*;
	
//	import com.tinyrpg.display.enemies.ATaxi;
//	import com.tinyrpg.display.enemies.AbstractArt;
//	import com.tinyrpg.display.enemies.AnnoyingMan;
//	import com.tinyrpg.display.enemies.BaldingWoman;
//	import com.tinyrpg.display.enemies.BigGayRat;
//	import com.tinyrpg.display.enemies.BigGaySlug;
//	import com.tinyrpg.display.enemies.BrainSlug;
//	import com.tinyrpg.display.enemies.Computer;
//	import com.tinyrpg.display.enemies.DarkEvanSheet;
//	import com.tinyrpg.display.enemies.Derpadillo;
//	import com.tinyrpg.display.enemies.Derpfish;
//	import com.tinyrpg.display.enemies.DirtyBush;
//	import com.tinyrpg.display.enemies.DiscoTree;
//	import com.tinyrpg.display.enemies.FatBird;
//	import com.tinyrpg.display.enemies.FatEagle;
//	import com.tinyrpg.display.enemies.Flusterhorse;
//	import com.tinyrpg.display.enemies.FuriousDuck;
//	import com.tinyrpg.display.enemies.FuriousFlower;
//	import com.tinyrpg.display.enemies.GoopyGoop;
//	import com.tinyrpg.display.enemies.GreedyMouse;
//	import com.tinyrpg.display.enemies.GrinningNerd;
//	import com.tinyrpg.display.enemies.Jambot;
//	import com.tinyrpg.display.enemies.JealousBass;
//	import com.tinyrpg.display.enemies.JustABoar;
//	import com.tinyrpg.display.enemies.Ladybull;
//	import com.tinyrpg.display.enemies.Mom;
//	import com.tinyrpg.display.enemies.Nooseman;
//	import com.tinyrpg.display.enemies.PooBug;
//	import com.tinyrpg.display.enemies.Pukeman;
//	import com.tinyrpg.display.enemies.Robomoose;
//	import com.tinyrpg.display.enemies.RonsMoldyMilk;
//	import com.tinyrpg.display.enemies.SadBox;
//	import com.tinyrpg.display.enemies.Smile;
//	import com.tinyrpg.display.enemies.SpaceMarine;
//	import com.tinyrpg.display.enemies.ViolentRoach;
//	import com.tinyrpg.display.friends.AndySheet;
//	import com.tinyrpg.display.friends.AsaSheet;
//	import com.tinyrpg.display.friends.DickEvanSheet;
//	import com.tinyrpg.display.friends.DrunkEvanSheet;
//	import com.tinyrpg.display.friends.FishAbelSheet;
//	import com.tinyrpg.display.friends.HybridSheet;
//	import com.tinyrpg.display.friends.JasonSheet;
//	import com.tinyrpg.display.friends.MeganSheet;
//	import com.tinyrpg.display.friends.RachelSheet;
//	import com.tinyrpg.display.friends.RalphSheet;
//	import com.tinyrpg.display.friends.RonSheet;
//	import com.tinyrpg.display.npcs.AkikoSheet;
//	import com.tinyrpg.display.npcs.AndrewSheet;
//	import com.tinyrpg.display.npcs.BunnySheet;
//	import com.tinyrpg.display.npcs.ComputerSheet;
//	import com.tinyrpg.display.npcs.EllenSheet;
//	import com.tinyrpg.display.npcs.EnemyBarf;
//	import com.tinyrpg.display.npcs.Green;
//	import com.tinyrpg.display.npcs.JRSheet;
//	import com.tinyrpg.display.npcs.Jeremy;
//	import com.tinyrpg.display.npcs.NicoleSheet;
//	import com.tinyrpg.display.npcs.RobotSheet;
	
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.BitmapData;

	/**
	 * @author jeremyabel
	 */
	public class TinySpriteConfig 
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
		
//		public static function getCharacterSprite( id : int ) : BitmapData
//		{
//			TinyLogManager.log('getSpriteSheet: ' + name, null);
//			
//			switch ( id )
//			{
//				case PLAYER
//				
//				default:
//					TinyLogManager.log( 'CHARACTER DOES NOT EXIST!', null );
//					break;
//			}
//		}
		
		public static function getMonsterSprite(name : String) : BitmapData
		{
			TinyLogManager.log('getMonsterSprite: ' + name, null);
			
			var newSprite : BitmapData;
			
//			newSprite = new ScaleTester;
//			return newSprite;
			
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
		
		public static function getEnemySprite(name : String) : BitmapData
		{
//			TinyLogManager.log('getEnemySprite: ' + name, null);
//			
			var newSprite : BitmapData;
//			
//			switch (name) 
//			{
//				// Bosses
//				case '$ERT+X_C0MPBARF':
//					newSprite = new Pukeman; break;
//				case '"Space Marine"':
//					newSprite = new SpaceMarine; break;
//				case 'Brain Slug':
//					newSprite = new BrainSlug; break;
//					
//				// Normal enemies
//				case 'A Taxi':
//					newSprite = new ATaxi; break;
//				case 'Abstract Art':
//					newSprite = new AbstractArt; break;
//				case 'Annoying Man':
//					newSprite = new AnnoyingMan; break;
//				case 'Balding Woman':
//					newSprite = new BaldingWoman; break;
//				case 'Big Gay Rat':
//					newSprite = new BigGayRat; break;
//				case 'Big Gay Slug':
//					newSprite = new BigGaySlug; break;
//				case 'Derpadillo': 
//					newSprite = new Derpadillo; break;
//				case 'Derpfish':
//					newSprite = new Derpfish; break;
//				case 'Dirty Bush':
//					newSprite = new DirtyBush; break;
//				case 'Disco Tree':
//					newSprite = new DiscoTree; break;
//				case 'Enraged Bass':
//					newSprite = new JealousBass; break;
//				case 'Fat Bird':
//					newSprite = new FatBird; break;
//				case 'Fat Eagle':
//					newSprite = new FatEagle; break;
//				case 'Flusterhorse':
//					newSprite = new Flusterhorse; break;
//				case 'Furious Duck':
//					newSprite = new FuriousDuck; break;
//				case 'Furious Flower':
//					newSprite = new FuriousFlower; break;
//				case 'Goopy Goop':
//					newSprite = new GoopyGoop; break;
//				case 'Greedy Mouse':
//					newSprite = new GreedyMouse; break;
//				case 'Grinning Nerd' :
//					newSprite = new GrinningNerd; break;
//				case 'Jambot':
//					newSprite = new Jambot; break;
//				case 'Just A Boar':
//					newSprite = new JustABoar; break;
//				case 'Ladybull':
//					newSprite = new Ladybull; break;
//				case 'Moldy Milk':
//					newSprite = new RonsMoldyMilk; break;
//				case 'Mom':
//					newSprite = new Mom; break;
//				case 'Nooseman':
//					newSprite = new Nooseman; break;
//				case 'Poo Bug':
//					newSprite = new PooBug; break;
//				case 'Robomoose':
//					newSprite = new Robomoose; break;
//				case 'Sad Box':
//					newSprite = new SadBox; break;
//				case 'Smile':
//					newSprite = new Smile; break;
//				case 'Violent Roach':
//					newSprite = new ViolentRoach; break;
//			}
//			
			return newSprite;
		}
	}
}
