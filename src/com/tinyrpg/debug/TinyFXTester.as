package com.tinyrpg.debug 
{
	import com.greensock.TweenLite;
	
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyBattle;
	import com.tinyrpg.battle.TinyBattleMon;
	import com.tinyrpg.battle.TinyBattlePalette;
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyPlayer;
	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.data.TinyAppSettings;
	import com.tinyrpg.display.TinyMoveFXAnimation;
	import com.tinyrpg.display.TinyStatusFXAnimation;
	import com.tinyrpg.data.TinyMoveDataList;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.misc.TinyCSS;
	import com.tinyrpg.misc.TinySpriteConfig;
	import com.tinyrpg.data.TinyItemDataList;
	import com.tinyrpg.utils.TinyMath;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.utils.ByteArray;

	/**
	 * @author jeremyabel
	 */
	public class TinyFXTester extends MovieClip
	{
		[Embed(source='../../../../bin/xml/Characters.xml', mimeType='application/octet-stream')]
		public static const Character_Test : Class;

		[Embed(source='../../../../bin/xml/Enemy_Test.xml', mimeType='application/octet-stream')]
		public static const Enemy_Test : Class;

		[Embed(source='../../../../bin/xml/Items.xml', mimeType='application/octet-stream')]
		public static const Item_Test : Class;
		
		[Embed(source='../../../../bin/xml/StartingSave.xml', mimeType='application/octet-stream')]
		public static const Starting_Save : Class;
		
		[Embed(source='../../../../bin/xml/Monsters.xml', mimeType='application/octet-stream')]
		public static const Monsters : Class;
		
		public var testBattle : TinyBattleMon;

		public function TinyFXTester() : void
		{
			var appSettings : TinyAppSettings = new TinyAppSettings(stage);
			var inputManager : TinyInputManager = TinyInputManager.getInstance();
			
			// Init font manager
			var tinyCSS : TinyCSS = new TinyCSS();
			TinyFontManager.initWithCSS(TinyCSS.cssString);
			
			var moveData : TinyMoveDataList = TinyMoveDataList.getInstance();
			
			// Get monster data
			var byteArray : ByteArray = (new TinyFXTester.Monsters()) as ByteArray;
			var string : String = byteArray.readUTFBytes(byteArray.length);
			var monsterXMLData : XML = new XML(string);
			
			var playerTrainer : TinyTrainer = new TinyTrainer(TinySpriteConfig.getTrainerSprite('Player'), 'Player');
			var enemyTrainer : TinyTrainer = new TinyTrainer(TinySpriteConfig.getTrainerSprite('Player'), 'Enemy Guy');
			
			playerTrainer.squad.push(new TinyMon(monsterXMLData.children()[2]));
			enemyTrainer.squad.push(new TinyMon(monsterXMLData.children()[1]));
			
			// Create test battle
			testBattle = new TinyBattleMon( playerTrainer, null, enemyTrainer );
			
			// Resize to fit the screen
			var scaleFactor : Number = stage.stageHeight / 144;
			TinyAppSettings.SCALE_FACTOR = scaleFactor;
			testBattle.scaleX *= scaleFactor;
			testBattle.scaleY *= scaleFactor;
			testBattle.startBattle();
			this.addChild(testBattle);
			
			TweenLite.delayedCall( 120, this.whirlInComplete, null, true);
		}
		
		private function whirlInComplete() : void
		{
 			var palette : TinyBattlePalette = testBattle.getBattlePalette();
			var isEnemy : Boolean = false;
						
			var fxArray : Array = new Array(
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'ABSORB' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'AGILITY' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'ANCIENT POWER' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'ASTONISH' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'BITE' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'BLAZE KICK' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'BUBBLE' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'BULK UP' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'CLAMP' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'CONFUSE RAY' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'CONFUSION' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'COSMIC POWER' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'DETECT' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'DOUBLE EDGE' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'DOUBLE KICK' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'DRAGON BREATH' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'DRAGON DANCE' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'DREAM EATER' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'DYNAMIC PUNCH' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'EMBER' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'EXPLOSION' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'FAKE OUT' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'FAKE TEARS' ), isEnemy, palette ),

//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'FALSE SWIPE' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'FEINT ATTACK' ), isEnemy, palette ),

				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'FIRE PUNCH' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'FLAMETHROWER' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'FOCUS ENERGY' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'FURY SWIPES' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'GROWL' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'HEAL BELL' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'HOWL' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'HYDRO PUMP' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'HYPER BEAM' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'HYPNOSIS' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'IRON DEFENSE' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'KARATE CHOP' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'LEAF BLADE' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'LEER' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'LICK' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'LOW KICK' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'LUSTER PURGE' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'MEAN LOOK' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'MEGA PUNCH' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'METAL CLAW' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'METEOR MASH' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'METRONOME' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'MUD SLAP' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'MUD SPORT' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'MUDDY WATER' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'NIGHT SHADE' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'POUND' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'PROTECT' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'PSYCHIC' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'PSYWAVE' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'QUICK ATTACK' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'RAIN DANCE' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'RAPID SPIN' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'RECOVER' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'REFRESH' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'REST' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SAFEGUARD' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SAND ATTACK' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SCARY FACE' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SCRATCH' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SCREECH' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SELF-DESTRUCT' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SLAM' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SLASH' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SMOG' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SMOKESCREEN' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SNORE' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SPITE' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'STRUGGLE' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SUBMISSION' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SUPERSONIC' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SWIFT' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'TACKLE' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'TAIL WHIP' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'TAKE-DOWN' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'THRASH' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'THUNDER' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'THUNDER SHOCK' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'TWISTER' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'WATER GUN' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'WATER PULSE' ), isEnemy, palette ),
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'WATER SPORT' ), isEnemy, palette ),
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'WING ATTACK' ), isEnemy, palette )
//				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'WISH' ), isEnem, palettey )
			);
			
			testBattle.debugPlayMoveFX( fxArray );
		}
	}
}
