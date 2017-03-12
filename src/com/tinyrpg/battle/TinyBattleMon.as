package com.tinyrpg.battle 
{

	import com.greensock.TweenLite;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	import com.greensock.plugins.EndArrayPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyFieldMap;
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.display.BattleWhirl;
	import com.tinyrpg.display.TinyMonContainer;
	import com.tinyrpg.display.TinyTitleBox;
	import com.tinyrpg.display.TinySpriteSheet;
	import com.tinyrpg.display.TinyBattleBallDisplay;
	import com.tinyrpg.display.TinyBattleMonStatDisplay;
	import com.tinyrpg.events.TinyBattleMonEvent;
	import com.tinyrpg.events.TinyInputEvent;
//	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.ui.TinyBattleItemList;
	import com.tinyrpg.ui.TinyBattleCommandMenu;
	import com.tinyrpg.ui.TinyMoveSelectMenu;
	import com.tinyrpg.ui.TinySwitchMonMenu;
	import com.tinyrpg.utils.TinyLogManager;
		
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleMon extends Sprite 
	{
		public static var staticCurrentItem : TinyItem;
				
		public var won 							: Boolean;
		public var dialogBoxContainer			: Sprite;
		public var enemyContainer				: Sprite;
		
		public var watersportCounter	 		: int = 0;
		public var mudsportCounter 				: int = 0;
		public var raindanceCounter				: int = 0;
		
		private var battleCommandRunner			: TinyBattleCommandSequencer;
			
		public var m_testPlayerTrainer			: TinyTrainer;
		public var m_enemyTrainer				: TinyTrainer;
		public var m_currentPlayerMon 			: TinyMon;
		public var m_currentEnemyMon			: TinyMon;
		public var m_playerTrainerContainer		: Sprite;
		public var m_enemyTrainerContainer		: Sprite;
		public var m_playerMonContainer			: TinyMonContainer;
		public var m_enemyMonContainer			: TinyMonContainer;
		public var m_playerStatDisplay			: TinyBattleMonStatDisplay;
		public var m_enemyStatDisplay			: TinyBattleMonStatDisplay;
		public var m_playerBallDisplay			: TinyBattleBallDisplay;
		public var m_enemyBallDisplay			: TinyBattleBallDisplay;
		private var m_battleCommandMenu			: TinyBattleCommandMenu;
		private var m_moveSelectMenu			: TinyMoveSelectMenu;
		private var m_switchMonMenu				: TinySwitchMonMenu;
		public var m_isWildEncounter			: Boolean;
		private var m_savedPlayerPos			: Point;
//		private var m_savedPlayerFacing			: String;
		private var m_battleEvent				: TinyBattleEventSequence;
		private var m_battleIntroWhirl			: TinySpriteSheet;
		private var m_battleEmptyDialogBox		: TinyTitleBox;
		private var itemSelectorList			: TinyBattleItemList;
		private var isForcedSwitch				: Boolean = false;
		public var wasLastSwitchEnemy			: Boolean = false;
		public var wasLastTurnEnemy				: Boolean = false;
		public var battlePalette				: TinyBattlePalette;
			
		public function TinyBattleMon( playerTestTrainer : TinyTrainer, enemyMon : TinyMon, enemyTrainer : TinyTrainer = null )
		{
			// Command runner
			this.battleCommandRunner = new TinyBattleCommandSequencer( this );
			
			// Greensock plugins
			TweenPlugin.activate([EndArrayPlugin, ColorMatrixFilterPlugin]);
			
			// Set parameters
			m_isWildEncounter = enemyTrainer == null;
			m_testPlayerTrainer = playerTestTrainer;
			m_enemyTrainer = enemyTrainer;
			m_currentPlayerMon = m_testPlayerTrainer.getFirstHealthyMon();
			m_currentEnemyMon = m_isWildEncounter ? enemyMon : m_enemyTrainer.getFirstHealthyMon();
			
			// Save player position for later
			m_savedPlayerPos = new Point();
//			m_savedPlayerPos.x = TinyMath.deepCopyInt(TinyPlayer.getInstance().party.getCharByID(0).graphics.x);
//			m_savedPlayerPos.y = TinyMath.deepCopyInt(TinyPlayer.getInstance().party.getCharByID(0).graphics.y);
			
			// Save player facing
//			m_savedPlayerFacing = TinyMath.deepCopyString(TinyFriendSprite(TinyPlayer.getInstance().party.getCharByID(0).graphics).facing);
		}
		
		public function startBattle() : void
		{
			// Empty dialog box that sits behind the battle menu
			m_battleEmptyDialogBox = new TinyTitleBox(null, '', 144, 33);
			m_battleEmptyDialogBox.x = int((160 / 2) - (m_battleEmptyDialogBox.width / 2)) + 5;
			m_battleEmptyDialogBox.y = 104;
			
			// Container for the rest of the dialog boxes
			this.dialogBoxContainer = new Sprite();
			this.dialogBoxContainer.x = m_battleEmptyDialogBox.x;
			this.dialogBoxContainer.y = m_battleEmptyDialogBox.y; 
			
			// Battle menu
			m_battleCommandMenu = new TinyBattleCommandMenu();
			m_battleCommandMenu.x = 80;
			m_battleCommandMenu.y = m_battleEmptyDialogBox.y;
			m_battleCommandMenu.visible = false;
			
			// Move select menu
			m_moveSelectMenu = new TinyMoveSelectMenu();
			m_moveSelectMenu.x = 68;
			m_moveSelectMenu.y = m_battleEmptyDialogBox.y;
			m_moveSelectMenu.visible = false;
			
			// Switch mon menu
			m_switchMonMenu = new TinySwitchMonMenu( m_testPlayerTrainer );
			m_switchMonMenu.x = m_battleEmptyDialogBox.x;
			m_switchMonMenu.y = 7;
			m_switchMonMenu.visible = false;
			
			// Item select menu
			this.itemSelectorList = new TinyBattleItemList( this.m_testPlayerTrainer );
			this.itemSelectorList.x = 28;
			this.itemSelectorList.y = 49;
			this.itemSelectorList.visible = false;
			
			// Player ball display
			m_playerBallDisplay = new TinyBattleBallDisplay(m_testPlayerTrainer);
			m_playerBallDisplay.x = 77;
			m_playerBallDisplay.y = 80;
			
			// Enemy ball display
			if (!m_isWildEncounter)
			{
				m_enemyBallDisplay = new TinyBattleBallDisplay(m_enemyTrainer);
				m_enemyBallDisplay.scaleX *= -1;
				m_enemyBallDisplay.x = 79 + 3;
				m_enemyBallDisplay.y = 22;
			}
			
			// Player stats display
			m_playerStatDisplay = new TinyBattleMonStatDisplay( false );
			m_playerStatDisplay.x = m_playerBallDisplay.x;
			m_playerStatDisplay.y = 55;
			m_playerStatDisplay.visible = false;
			
			// Enemy stats display
			m_enemyStatDisplay = new TinyBattleMonStatDisplay( true );
			m_enemyStatDisplay.x = 3;
			m_enemyStatDisplay.y = 2;
			m_enemyStatDisplay.visible = false;
			
			// Player trainer container
			m_playerTrainerContainer = new Sprite();
			
			// Player mon container
			m_playerMonContainer = new TinyMonContainer( m_currentPlayerMon.bitmap );
			
			// Enemy trainer container
			m_enemyTrainerContainer = new Sprite();
			
			// Enemy mon container
			m_enemyMonContainer = new TinyMonContainer( m_currentEnemyMon.bitmap );
			
			// Fill enemy container
			this.enemyContainer = new Sprite;
			this.enemyContainer.x = 0;
			this.enemyContainer.y = 0;
			
			// Make battle palette
			this.battlePalette = new TinyBattlePalette( 
				this.m_playerMonContainer.palette, 
				this.m_enemyMonContainer.palette, 
				this.m_playerStatDisplay.palette, 
				this.m_enemyStatDisplay.palette 
			);
			
			// Load move FX animations for both mons
			this.m_currentEnemyMon.moveSet.loadAllMoveFXSprites( this.battlePalette );
			this.m_currentPlayerMon.moveSet.loadAllMoveFXSprites( this.battlePalette );

			TinyLogManager.log('', this);
			TinyLogManager.log('==================== START BATTLE MODE ====================', this);
			TinyLogManager.log('', this);
			
			TinyFieldMap.inBattle = true;
			
			// Whirl mask
			m_battleIntroWhirl = new TinySpriteSheet(new BattleWhirl, 160, false, 1);
			m_battleIntroWhirl.x = 
			m_battleIntroWhirl.y = 80;
			m_battleIntroWhirl.play(1);
			this.addChild(m_battleIntroWhirl);
			
			TweenLite.delayedCall(m_battleIntroWhirl.length + 32, this.whirlInComplete, null, true);

			// Sound
//			TinyAudioManager.play(TinyAudioManager.BATTLE_START);
		}
		
		private function whirlInComplete() : void
		{
			TinyLogManager.log('whirlInComplete', this);
			
			// Remove intro whirl sprite sheet
			m_battleIntroWhirl.stopAndRemove();
			this.removeChild(m_battleIntroWhirl);
			
			// Position player trainer
			m_playerTrainerContainer.x = 144 + 48;
			m_playerTrainerContainer.y = 50;
			m_playerTrainerContainer.addChild( m_testPlayerTrainer.battleBitmap );
	
			// Position enemy trainer
			m_enemyTrainerContainer.x = -56;
			m_enemyTrainerContainer.y = 0;
			if (!m_isWildEncounter) m_enemyTrainerContainer.addChild( m_enemyTrainer.battleBitmap );
			
			// Position player mon
			m_playerMonContainer.x = 16;
			m_playerMonContainer.y = 50;
			
			// Position enemy mon
			m_enemyMonContainer.x = m_isWildEncounter ? -56 : 96;
			m_enemyMonContainer.y = 0;
			if (m_isWildEncounter) m_enemyMonContainer.show();

			// Add 'em up
			this.enemyContainer.addChild( this.m_enemyStatDisplay );
			this.enemyContainer.addChild( this.m_enemyMonContainer );
			this.addChild(m_playerBallDisplay);
			this.addChild(m_playerStatDisplay);
			this.addChild(m_playerMonContainer);
			this.addChild( this.enemyContainer );
			this.addChild(m_playerTrainerContainer);
			this.addChild(m_enemyTrainerContainer);
			this.addChild(m_battleEmptyDialogBox);
			this.addChild(this.dialogBoxContainer);
			this.addChild(m_battleCommandMenu);
			this.addChild(m_moveSelectMenu);
			this.addChild(m_switchMonMenu);
			this.addChild( this.itemSelectorList );
			
			// If this isn't a wild encounter, add the enemy trainer ball display
			if (!m_isWildEncounter) 
			{
				this.addChild(m_enemyBallDisplay);
			}
			
			// Create intro event sequence
			m_battleEvent = new TinyBattleEventSequence(this);
			
			// Slide both trainers in 
			m_battleEvent.addShowTrainer(m_playerTrainerContainer, false, false);
			m_battleEvent.addShowTrainer(m_isWildEncounter ? m_enemyMonContainer : m_enemyTrainerContainer, true, true);
			
			// The rest of the intro sequence is determined by whether or not this is a wild encounter or a trainer battle
			if (m_isWildEncounter) 
			{	
				// Show player ball display
				m_battleEvent.addShowElement( m_playerBallDisplay );
				
				// Show enemy stat display
				m_battleEvent.addSetStatDisplayMon( m_currentEnemyMon, m_enemyStatDisplay );
				m_battleEvent.addShowElement( m_enemyStatDisplay );
				
				// Show intro dialog box				
				m_battleEvent.addDialogBoxFromString( TinyBattleStrings.getRandomWildEncounterString( m_currentEnemyMon ) );
				
				// Hide player trainer and summon first mon
				m_battleEvent.addHideTrainer( m_playerTrainerContainer, false, true);
				m_battleEvent.addSetElementVisibility( m_playerBallDisplay, false );
				m_battleEvent.addDialogBoxFromString( TinyBattleStrings.getRandomSummonDialogString( false, m_testPlayerTrainer.getFirstHealthyMon(), m_testPlayerTrainer ) );		
				m_battleEvent.addSetStatDisplayMon( m_currentPlayerMon, m_playerStatDisplay );
				m_battleEvent.addShowElement( m_playerStatDisplay );
				m_battleEvent.addSummonMon( m_currentPlayerMon, m_playerMonContainer );
			}
			else
			{	
				// Show both ball displays
				m_battleEvent.addShowElement( m_playerBallDisplay );
				m_battleEvent.addShowElement( m_enemyBallDisplay );
				
				// Show intro dialog box
				m_battleEvent.addDialogBoxFromString( TinyBattleStrings.getRandomTrainerBattleString( this.m_enemyTrainer ) );
				
				// Hide enemy trainer and summon first mon
				m_battleEvent.addHideTrainer( m_enemyTrainerContainer, true, true);
				m_battleEvent.addSetElementVisibility( m_enemyBallDisplay, false );
				m_battleEvent.addDialogBoxFromString(TinyBattleStrings.getRandomSummonDialogString( true, this.m_enemyTrainer.getFirstHealthyMon(), this.m_enemyTrainer ) );
				m_battleEvent.addSetStatDisplayMon( m_currentEnemyMon, m_enemyStatDisplay );
				m_battleEvent.addShowElement( m_enemyStatDisplay );
				m_battleEvent.addSummonMon( m_currentEnemyMon, m_enemyMonContainer );
				
				// Hide player trainer and summon first mon
				m_battleEvent.addHideTrainer( m_playerTrainerContainer, false, true);
				m_battleEvent.addSetElementVisibility( m_playerBallDisplay, false );
				m_battleEvent.addDialogBoxFromString( TinyBattleStrings.getRandomSummonDialogString( false, m_testPlayerTrainer.getFirstHealthyMon(), m_testPlayerTrainer ) );
				m_battleEvent.addSetStatDisplayMon( m_currentPlayerMon, m_playerStatDisplay );
				m_battleEvent.addShowElement( m_playerStatDisplay );
				m_battleEvent.addSummonMon( m_currentPlayerMon, m_playerMonContainer );
			}
			
			// Play the intro sequence
			m_battleEvent.addEnd();
			m_battleEvent.addEventListener( Event.COMPLETE, onIntroSequenceComplete);
			m_battleEvent.startSequence();
			
			// Play battle music
//			TinyAudioManager.getInstance().setSong(TinyAudioManager.getMusicByEnemyName(TinyStatsEntity(TinyBattle.enemyParty.party[0]).name), false);
		}
		
		private function onIntroSequenceComplete( event : Event ) : void
		{
			TinyLogManager.log('onIntroSequenceComplete', this);
			
			// Cleanup
			m_battleEvent.removeEventListener( Event.COMPLETE, this.onIntroSequenceComplete );
			m_battleEvent = null;
	
			// Set mon battle state
			m_currentPlayerMon.isInBattle = true;
			m_currentEnemyMon.isInBattle = true;
						
			this.startTurn();
		}

		public function startTurn() : void
		{
			TinyLogManager.log('startTurn', this);
			
			// Clean up from previous turn
			this.m_currentPlayerMon.postTurnCleanup();
			this.m_currentEnemyMon.postTurnCleanup();
			
			// Show the battle command menu and reset the cursor position
			this.m_battleCommandMenu.show();
			this.m_battleCommandMenu.setSelectedItemIndex( 0 ); 
			
			// Give input command to the battle menu
			TinyInputManager.getInstance().setTarget( m_battleCommandMenu );
			m_battleCommandMenu.addEventListener(TinyBattleMonEvent.FIGHT_SELECTED,  onPlayerCommandSelected);
			m_battleCommandMenu.addEventListener(TinyBattleMonEvent.SWITCH_SELECTED, onPlayerCommandSelected);
			m_battleCommandMenu.addEventListener(TinyBattleMonEvent.ITEM_SELECTED,   onPlayerCommandSelected);
			m_battleCommandMenu.addEventListener(TinyBattleMonEvent.RUN_SELECTED,    onPlayerCommandSelected);	
		}
		
		public function forcePlayerSwitch() : void
		{
			TinyLogManager.log('forcePlayerSwitch', this);
			
			this.isForcedSwitch = true;
			
			m_switchMonMenu.showForced();
			m_switchMonMenu.addEventListener( TinyBattleMonEvent.MON_SELECTED, onSwitchSelected );
			TinyInputManager.getInstance().setTarget( m_switchMonMenu );
		}
		
		private function onPlayerCommandSelected( event : TinyBattleMonEvent ) : void 
		{
			TinyLogManager.log('onCommandSelect: ' + event.type, this);
			
			switch (event.type)
			{
				case TinyBattleMonEvent.FIGHT_SELECTED:
					
					// Pass control to the move selector
					m_moveSelectMenu.setCurrentMon( m_currentPlayerMon );
					m_moveSelectMenu.show();
					TinyInputManager.getInstance().setTarget( m_moveSelectMenu );
					
					m_moveSelectMenu.addEventListener( TinyBattleMonEvent.MOVE_SELECTED, this.onMoveSelected );
					m_moveSelectMenu.addEventListener( TinyInputEvent.CANCEL, this.onMoveSelectCancelled );
					break;
					
				case TinyBattleMonEvent.SWITCH_SELECTED:
					
					// Pass control to the squad selector
					m_switchMonMenu.show();
					TinyInputManager.getInstance().setTarget( m_switchMonMenu );
					
					m_switchMonMenu.addEventListener( TinyBattleMonEvent.MON_SELECTED, onSwitchSelected );
					m_switchMonMenu.addEventListener( TinyInputEvent.CANCEL, this.onSwitchCancelled );
					break;
					
				case TinyBattleMonEvent.ITEM_SELECTED:
					
					// Pass control to the item selector
					this.itemSelectorList.show();
					TinyInputManager.getInstance().setTarget( this.itemSelectorList );
					
					this.itemSelectorList.addEventListener( TinyBattleMonEvent.ITEM_USED, this.onItemUsed );
					this.itemSelectorList.addEventListener( TinyInputEvent.CANCEL, this.onItemCancelled );
					break;
					
				case TinyBattleMonEvent.RUN_SELECTED:
				
					// Hide the battle command menu
					m_battleCommandMenu.hide();
			
					 // Set player's battle command	
					this.battleCommandRunner.commandSelected( new TinyBattleCommandRun( this, TinyBattleCommand.USER_PLAYER ) );
					break;
			}
		}
		
		private function onMoveSelected( event : TinyBattleMonEvent ) : void
		{
			var selectedMove : TinyMoveData = event.move;
			
			TinyLogManager.log('onMoveSelected: ' + selectedMove.name, this);
			
			// Hide the move menu
			m_moveSelectMenu.hide();
			
			// Hide the battle command menu
			m_battleCommandMenu.hide();
			
			// Clean up
			m_moveSelectMenu.removeEventListener(TinyBattleMonEvent.MOVE_SELECTED, this.onMoveSelected);
			m_moveSelectMenu.removeEventListener(TinyInputEvent.CANCEL, this.onMoveSelectCancelled);
			
			// Set player's battle command
			this.battleCommandRunner.commandSelected( new TinyBattleCommandMove( this, TinyBattleCommand.USER_PLAYER, event.move ) );
		}
		
		private function onMoveSelectCancelled( event : TinyInputEvent ) : void
		{
			TinyLogManager.log('onMoveSelectCancel', this);
			
			// Hide the move menu
			m_moveSelectMenu.hide();
			
			// Return control to the command menu
			TinyInputManager.getInstance().setTarget(m_battleCommandMenu);
			
			// Clean up
			m_moveSelectMenu.removeEventListener(TinyBattleMonEvent.MOVE_SELECTED, this.onMoveSelected);
			m_moveSelectMenu.removeEventListener(TinyInputEvent.CANCEL, this.onMoveSelectCancelled);
		}
		
		private function onSwitchSelected( event : TinyBattleMonEvent ) : void
		{
			TinyLogManager.log('onSwitchSelected: ' + event.mon.name, this);
			
			// Hide the switch menu
			m_switchMonMenu.hide();
			
			// Hide the battle command menu
			m_battleCommandMenu.hide();
			
			// Clean up
			m_moveSelectMenu.removeEventListener(TinyBattleMonEvent.MOVE_SELECTED, this.onMoveSelected);
			m_moveSelectMenu.removeEventListener(TinyInputEvent.CANCEL, this.onMoveSelectCancelled);
			
			// Set player's battle command	
			this.battleCommandRunner.commandSelected( new TinyBattleCommandSwitch( this, TinyBattleCommand.USER_PLAYER, event.mon, this.isForcedSwitch ) );
			
			// Clear forced switch flag
			this.isForcedSwitch = false;
		}
		
		private function onSwitchCancelled( event : TinyInputEvent ) : void
		{
			TinyLogManager.log('onSwitchCancelled', this);
			
			// Hide the switch menu
			m_switchMonMenu.hide();
			
			// Return control to the command menu
			TinyInputManager.getInstance().setTarget(m_battleCommandMenu);
			
			// Clean up
			m_switchMonMenu.removeEventListener(TinyBattleMonEvent.MON_SELECTED, this.onSwitchSelected);
			m_switchMonMenu.removeEventListener(TinyInputEvent.CANCEL, this.onSwitchCancelled);
		}
		
		private function onItemUsed( event : TinyBattleMonEvent ) : void
		{
			TinyLogManager.log('onItemUsed', this);
			
			// Hide the battle command menu
			m_battleCommandMenu.hide();
			
			// Clean up
			m_moveSelectMenu.removeEventListener( TinyBattleMonEvent.ITEM_USED, this.onItemUsed );
			m_moveSelectMenu.removeEventListener( TinyInputEvent.CANCEL, this.onItemCancelled );
			
			// Set player's battle command	
//			this.battleCommandRunner.commandSelected( new TinyBattleCommandSwitch( this, TinyBattleCommand.USER_PLAYER, event.mon, this.isForcedSwitch ) );
			
			// Clear forced switch flag
			this.isForcedSwitch = false;
		}
		
		private function onItemCancelled( event : TinyInputEvent ) : void
		{
			TinyLogManager.log('onItemCancelled', this);
			
			// Hide the item menu
			this.itemSelectorList.hide();
			
			// Return control to the command menu
			TinyInputManager.getInstance().setTarget( m_battleCommandMenu );
			
			// Clean up
			m_switchMonMenu.removeEventListener( TinyBattleMonEvent.ITEM_USED, this.onSwitchSelected );
			m_switchMonMenu.removeEventListener( TinyInputEvent.CANCEL, this.onItemCancelled );  
		}
		
		public function getBattlePalette() : TinyBattlePalette
		{
			return new TinyBattlePalette( this.m_playerMonContainer.palette, this.m_enemyMonContainer.palette, this.m_playerStatDisplay.palette, this.m_enemyStatDisplay.palette );
		}
	}
}
