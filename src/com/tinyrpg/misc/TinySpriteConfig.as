package com.tinyrpg.misc 
{
	import com.tinyrpg.display.monsters.Box;
	import com.tinyrpg.display.monsters.Bucket;
	import com.tinyrpg.display.monsters.ComfyShortsKid;
	import com.tinyrpg.display.monsters.Egg;
	import com.tinyrpg.display.monsters.Shoe;
	import com.tinyrpg.display.monsters.TallGrass;
	
	import com.tinyrpg.display.trainers.TrainerPlayer;
	
	import com.tinyrpg.display.enemies.ATaxi;
	import com.tinyrpg.display.enemies.AbstractArt;
	import com.tinyrpg.display.enemies.AnnoyingMan;
	import com.tinyrpg.display.enemies.BaldingWoman;
	import com.tinyrpg.display.enemies.BigGayRat;
	import com.tinyrpg.display.enemies.BigGaySlug;
	import com.tinyrpg.display.enemies.BrainSlug;
	import com.tinyrpg.display.enemies.Computer;
	import com.tinyrpg.display.enemies.DarkEvanSheet;
	import com.tinyrpg.display.enemies.Derpadillo;
	import com.tinyrpg.display.enemies.Derpfish;
	import com.tinyrpg.display.enemies.DirtyBush;
	import com.tinyrpg.display.enemies.DiscoTree;
	import com.tinyrpg.display.enemies.FatBird;
	import com.tinyrpg.display.enemies.FatEagle;
	import com.tinyrpg.display.enemies.Flusterhorse;
	import com.tinyrpg.display.enemies.FuriousDuck;
	import com.tinyrpg.display.enemies.FuriousFlower;
	import com.tinyrpg.display.enemies.GoopyGoop;
	import com.tinyrpg.display.enemies.GreedyMouse;
	import com.tinyrpg.display.enemies.GrinningNerd;
	import com.tinyrpg.display.enemies.Jambot;
	import com.tinyrpg.display.enemies.JealousBass;
	import com.tinyrpg.display.enemies.JustABoar;
	import com.tinyrpg.display.enemies.Ladybull;
	import com.tinyrpg.display.enemies.Mom;
	import com.tinyrpg.display.enemies.Nooseman;
	import com.tinyrpg.display.enemies.PooBug;
	import com.tinyrpg.display.enemies.Pukeman;
	import com.tinyrpg.display.enemies.Robomoose;
	import com.tinyrpg.display.enemies.RonsMoldyMilk;
	import com.tinyrpg.display.enemies.SadBox;
	import com.tinyrpg.display.enemies.Smile;
	import com.tinyrpg.display.enemies.SpaceMarine;
	import com.tinyrpg.display.enemies.ViolentRoach;
	import com.tinyrpg.display.friends.AndySheet;
	import com.tinyrpg.display.friends.AsaSheet;
	import com.tinyrpg.display.friends.DickEvanSheet;
	import com.tinyrpg.display.friends.DrunkEvanSheet;
	import com.tinyrpg.display.friends.FishAbelSheet;
	import com.tinyrpg.display.friends.HybridSheet;
	import com.tinyrpg.display.friends.JasonSheet;
	import com.tinyrpg.display.friends.MeganSheet;
	import com.tinyrpg.display.friends.RachelSheet;
	import com.tinyrpg.display.friends.RalphSheet;
	import com.tinyrpg.display.friends.RonSheet;
	import com.tinyrpg.display.npcs.AkikoSheet;
	import com.tinyrpg.display.npcs.AndrewSheet;
	import com.tinyrpg.display.npcs.BunnySheet;
	import com.tinyrpg.display.npcs.ComputerSheet;
	import com.tinyrpg.display.npcs.EllenSheet;
	import com.tinyrpg.display.npcs.EnemyBarf;
	import com.tinyrpg.display.npcs.Green;
	import com.tinyrpg.display.npcs.JRSheet;
	import com.tinyrpg.display.npcs.Jeremy;
	import com.tinyrpg.display.npcs.NicoleSheet;
	import com.tinyrpg.display.npcs.RobotSheet;
	
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.BitmapData;

	/**
	 * @author jeremyabel
	 */
	public class TinySpriteConfig 
	{
		// PARTY MEMBERS
		public static var ANDY			: String = 'ANDY';
		public static var ASA			: String = 'ASA';
		public static var DICK_EVAN		: String = 'EVAN';
		public static var DRUNK_EVAN	: String = 'EVAN?';
		public static var HYBRID		: String = 'HYBRID';
		public static var JASON 		: String = 'JASON';
		public static var FISH			: String = 'FISH';		public static var FISHABEL		: String = 'FISHABEL';		public static var MEGAN			: String = 'MEGAN';
		public static var RACHEL		: String = 'RACHEL';
		public static var RALPH			: String = 'RALPH';
		public static var RON			: String = 'RON';
		
		public static function getSpriteSheet(name : String) : BitmapData
		{
			TinyLogManager.log('getSpriteSheet: ' + name, null);
			
			var newSheet : BitmapData;
			
			switch (name.toUpperCase())
			{
				// PARTY MEMBERS
				case TinySpriteConfig.ANDY:
					newSheet = new AndySheet;
					break;				case TinySpriteConfig.ASA:
					newSheet =  new AsaSheet;
					break;				case TinySpriteConfig.DICK_EVAN:
					newSheet =  new DickEvanSheet;
					break;				case TinySpriteConfig.DRUNK_EVAN:
					newSheet =  new DrunkEvanSheet;
					break;				case TinySpriteConfig.HYBRID:
					newSheet =  new HybridSheet;
					break;				case TinySpriteConfig.JASON:
					newSheet =  new JasonSheet;
					break;
				case TinySpriteConfig.FISH:
					newSheet =  new FishAbelSheet;					break;
				case TinySpriteConfig.MEGAN:
					newSheet =  new MeganSheet;					break;
				case TinySpriteConfig.RACHEL:
					newSheet =  new RachelSheet;					break;				case TinySpriteConfig.RALPH:
					newSheet =  new RalphSheet;
					break;
				case TinySpriteConfig.RON:
					newSheet =  new RonSheet;
					break;
				
				// NPCS
				case 'AKIKO':
					newSheet = new AkikoSheet;		break;
				case 'ANDREW':
					newSheet = new AndrewSheet;		break;
				case 'ELLEN':
					newSheet = new EllenSheet;		break;
				case 'JR':
					newSheet = new JRSheet;			break;
				case 'NICOLE':
					newSheet = new NicoleSheet;		break;
				case 'GREEN':
					newSheet = new Green;			break;
				case 'BUNNY':
					newSheet = new BunnySheet;		break;
				case 'SPACE MARINE':
					newSheet = new RobotSheet;		break;
				case 'COMPUTER NPC':
					newSheet = new ComputerSheet;	break;
				case 'JEREMY':
					newSheet = new Jeremy;			break;
				case 'PUKE_LEFT':				case 'PUKE_RIGHT':
					newSheet = new EnemyBarf;		break;
				
				// Special Enemies
				case 'BRAIN SLUG':
					newSheet = new BrainSlug;	break;
				case 'COMPUTER':
					newSheet = new Computer; break;
				case 'DRUNK EVAN':
					newSheet = new DrunkEvanSheet; break;
				case 'DARK EVAN':
					newSheet = new DarkEvanSheet; break;
				
				default:
					TinyLogManager.log('CHARACTER DOES NOT EXIST!', null);
					break;
			}
			
			return newSheet;
		}
		
		public static function getMonsterSprite(name : String) : BitmapData
		{
			TinyLogManager.log('getMonsterSprite: ' + name, null);
			
			var newSprite : BitmapData;
			
			switch (name) 
			{
				case 'Box': newSprite = new Box; break;
				case 'Bucket': newSprite = new Bucket; break;
				case 'ComfyShortsKid': newSprite = new ComfyShortsKid; break;
				case 'Egg': newSprite = new Egg; break;
				case 'Shoe': newSprite = new Shoe; break;
				case 'TallGrass': newSprite = new TallGrass; break;
				default: newSprite = new ComfyShortsKid; break;
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
			TinyLogManager.log('getEnemySprite: ' + name, null);
			
			var newSprite : BitmapData;
			
			switch (name) 
			{
				// Bosses
				case '$ERT+X_C0MPBARF':
					newSprite = new Pukeman; break;
				case '"Space Marine"':
					newSprite = new SpaceMarine; break;
				case 'Brain Slug':
					newSprite = new BrainSlug; break;
					
				// Normal enemies
				case 'A Taxi':
					newSprite = new ATaxi; break;
				case 'Abstract Art':
					newSprite = new AbstractArt; break;
				case 'Annoying Man':
					newSprite = new AnnoyingMan; break;
				case 'Balding Woman':
					newSprite = new BaldingWoman; break;
				case 'Big Gay Rat':
					newSprite = new BigGayRat; break;
				case 'Big Gay Slug':
					newSprite = new BigGaySlug; break;
				case 'Derpadillo': 
					newSprite = new Derpadillo; break;
				case 'Derpfish':
					newSprite = new Derpfish; break;
				case 'Dirty Bush':
					newSprite = new DirtyBush; break;
				case 'Disco Tree':
					newSprite = new DiscoTree; break;
				case 'Enraged Bass':
					newSprite = new JealousBass; break;
				case 'Fat Bird':
					newSprite = new FatBird; break;
				case 'Fat Eagle':
					newSprite = new FatEagle; break;
				case 'Flusterhorse':
					newSprite = new Flusterhorse; break;
				case 'Furious Duck':
					newSprite = new FuriousDuck; break;
				case 'Furious Flower':
					newSprite = new FuriousFlower; break;
				case 'Goopy Goop':
					newSprite = new GoopyGoop; break;
				case 'Greedy Mouse':
					newSprite = new GreedyMouse; break;
				case 'Grinning Nerd' :
					newSprite = new GrinningNerd; break;
				case 'Jambot':
					newSprite = new Jambot; break;
				case 'Just A Boar':
					newSprite = new JustABoar; break;
				case 'Ladybull':
					newSprite = new Ladybull; break;
				case 'Moldy Milk':
					newSprite = new RonsMoldyMilk; break;
				case 'Mom':
					newSprite = new Mom; break;
				case 'Nooseman':
					newSprite = new Nooseman; break;
				case 'Poo Bug':
					newSprite = new PooBug; break;
				case 'Robomoose':
					newSprite = new Robomoose; break;
				case 'Sad Box':
					newSprite = new SadBox; break;
				case 'Smile':
					newSprite = new Smile; break;
				case 'Violent Roach':
					newSprite = new ViolentRoach; break;
			}
			
			return newSprite;
		}
	}
}
