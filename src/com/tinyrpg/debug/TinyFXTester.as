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

				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'ABSORB' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'AGILITY' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'ANCIENT POWER' ), isEnemy, palette ),	// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'ASTONISH' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'BITE' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'BLAZE KICK' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'BUBBLE' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'BULK UP' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'CLAMP' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'CONFUSE RAY' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'CONFUSION' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'COSMIC POWER' ), isEnemy, palette ),	// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'DETECT' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'DOUBLE EDGE' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'DOUBLE KICK' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'DRAGON BREATH' ), isEnemy, palette ),	// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'DRAGON DANCE' ), isEnemy, palette ),	// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'DREAM EATER' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'DYNAMIC PUNCH' ), isEnemy, palette ),	// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'EMBER' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'EXPLOSION' ), isEnemy, palette ),		// OK 
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'FALSE SWIPE' ), isEnemy, palette ), 	// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'FEINT ATTACK' ), isEnemy, palette ), 	// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'FIRE PUNCH' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'FLAMETHROWER' ), isEnemy, palette ),	// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'FOCUS ENERGY' ), isEnemy, palette ),	// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'FURY SWIPES' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'GROWL' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'HEAL BELL' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'HOWL' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'HYDRO PUMP' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'HYPER BEAM' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'HYPNOSIS' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'KARATE CHOP' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'LEAF BLADE' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'LEER' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'LICK' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'LOW KICK' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'LUSTER PURGE' ), isEnemy, palette ),	// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'MEAN LOOK' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'MEGA PUNCH' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'METAL CLAW' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'METEOR MASH' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'METRONOME' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'MUD SLAP' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'MUD SPORT' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'MUDDY WATER' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'NIGHT SHADE' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'POUND' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'PROTECT' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'PSYCHIC' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'PSYWAVE' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'QUICK ATTACK' ), isEnemy, palette ), 	// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'RAIN DANCE' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'RAPID SPIN' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'RECOVER' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'REST' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SAFEGUARD' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SAND ATTACK' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SCARY FACE' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SCRATCH' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SCREECH' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SELF-DESTRUCT' ), isEnemy, palette ),	// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SLAM' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SLASH' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SMOG' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SMOKESCREEN' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SNORE' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SPITE' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'STRUGGLE' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SUBMISSION' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SUPERSONIC' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'SWIFT' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'TACKLE' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'TAIL WHIP' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'TAKE-DOWN' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'THRASH' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'THUNDER' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'THUNDER SHOCK' ), isEnemy, palette ),	// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'TWISTER' ), isEnemy, palette ),			// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'WATER GUN' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'WATER PULSE' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'WATER SPORT' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'WING ATTACK' ), isEnemy, palette ),		// OK
				new TinyMoveFXAnimation( TinyMoveDataList.getInstance().getMoveByName( 'WISH' ), isEnemy, palette )				// OK
			);
			
			testBattle.debugPlayMoveFX( fxArray );
		}
	}
}
