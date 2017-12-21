package com.tinyrpg.debug 
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyBattle;
	import com.tinyrpg.battle.TinyBattleMon;
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyPlayer;
	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.data.TinyAppSettings;
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

		public function TinyBattleTester() : void
		{
			var doWildEncounter : Boolean = false;
			
			var appSettings : TinyAppSettings = new TinyAppSettings(stage);
			var inputManager : TinyInputManager = TinyInputManager.getInstance();
			
			// Init font manager
			var tinyCSS : TinyCSS = new TinyCSS();
			TinyFontManager.initWithCSS(TinyCSS.cssString);
			
			var moveData : TinyMoveDataList = TinyMoveDataList.getInstance();
			
			// Get monster data
			var byteArray : ByteArray = (new TinyBattleTester.Monsters()) as ByteArray;
			var string : String = byteArray.readUTFBytes(byteArray.length);
			var monsterXMLData : XML = new XML(string);
			
			var playerTrainer : TinyTrainer = new TinyTrainer(TinySpriteConfig.getTrainerSprite('Player'), 'Player');
			var enemyTrainer : TinyTrainer = new TinyTrainer(TinySpriteConfig.getTrainerSprite('Player'), 'Enemy Guy');
			
			playerTrainer.squad.push(new TinyMon(monsterXMLData.children()[4]));
			playerTrainer.squad.push(new TinyMon(monsterXMLData.children()[1]));
			playerTrainer.squad.push(new TinyMon(monsterXMLData.children()[2]));
			
			enemyTrainer.squad.push(new TinyMon(monsterXMLData.children()[3]));
			enemyTrainer.squad.push(new TinyMon(monsterXMLData.children()[4]));
			enemyTrainer.squad.push(new TinyMon(monsterXMLData.children()[5]));
			
			var enemyMon : TinyMon = enemyTrainer.squad[0] as TinyMon;
			var trainerMon : TinyMon = playerTrainer.squad[0] as TinyMon;
			
			var wildMonster : TinyMon = new TinyMon(monsterXMLData.children()[5]);

			// Create test battle
			if (doWildEncounter)
			{
				testBattle = new TinyBattleMon(playerTrainer, wildMonster);	
			}
			else 
			{
				testBattle = new TinyBattleMon(playerTrainer, null, enemyTrainer);
			}
			
			// Resize to fit the screen
			var scaleFactor : Number = stage.stageHeight / 144;
			TinyAppSettings.SCALE_FACTOR = scaleFactor;
			testBattle.scaleX *= scaleFactor;
			testBattle.scaleY *= scaleFactor;
			testBattle.startBattle();
			this.addChild(testBattle);
		}
		
		private function playFXAnimation(  )
		{
			TinyLogManager.log('playFXAnimation', this);
							
			this.currentStatusAnimation = statusAnim;
			this.currentStatusAnimation.addEventListener( Event.COMPLETE, this.onPlayStatusAnimComplete );
			this.currentStatusAnimation.play();
			this.currentStatusAnimation.x = 
			this.currentStatusAnimation.y = 0;
			
			this.addChild( this.currentStatusAnimation );
		}
	}
}
