package com.tinyrpg.battle 
{
	import com.greensock.TweenLite;
	
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyMoveData;
	import com.tinyrpg.display.BattleWhirl;
	import com.tinyrpg.display.TinyMonContainer;
	import com.tinyrpg.display.TinyContentBox;
	import com.tinyrpg.display.TinySpriteSheet;
	import com.tinyrpg.display.TinyMoveFXAnimation;
	import com.tinyrpg.display.TinyStatusFXAnimation;
	import com.tinyrpg.display.TinyBattleBallDisplay;
	import com.tinyrpg.display.TinyBattleMonStatDisplay;
	import com.tinyrpg.events.TinyBattleEvent;
	import com.tinyrpg.events.TinyGameEvent;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.ui.TinyBattleItemMenu;
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
	public class TinyBattle extends Sprite 
	{
		public static var staticCurrentItem : TinyItem;
				
		public var won 							: Boolean;
		public var dialogBoxContainer			: Sprite;
		public var enemyContainer				: Sprite;
		
		public var watersportCounter	 		: int = 0;
		public var mudsportCounter 				: int = 0;
		public var raindanceCounter				: int = 0;
		
		private var battleCommandRunner			: TinyBattleCommandSequencer;
			
		public var playerTrainer				: TinyTrainer;
		public var enemyTrainer					: TinyTrainer;
		public var currentPlayerMon 			: TinyMon;
		public var currentEnemyMon				: TinyMon;
		public var playerTrainerContainer		: Sprite;
		public var enemyTrainerContainer		: Sprite;
		public var playerMonContainer			: TinyMonContainer;
		public var enemyMonContainer			: TinyMonContainer;
		public var playerStatDisplay			: TinyBattleMonStatDisplay;
		public var enemyStatDisplay				: TinyBattleMonStatDisplay;
		public var playerBallDisplay			: TinyBattleBallDisplay;
		public var enemyBallDisplay				: TinyBattleBallDisplay;
		
		private var m_battleCommandMenu			: TinyBattleCommandMenu;
		private var m_moveSelectMenu			: TinyMoveSelectMenu;
		private var m_switchMonMenu				: TinySwitchMonMenu;
		private var m_battleEvent				: TinyBattleEventSequence;
		private var m_battleIntroWhirl			: TinySpriteSheet;
		private var m_battleEmptyDialogBox		: TinyContentBox;
		private var m_itemSelectorList			: TinyBattleItemMenu;
		private var isForcedSwitch				: Boolean = false;
		private var background					: Sprite;
		
		public var isWildEncounter				: Boolean;
		public var wasLastSwitchEnemy			: Boolean = false;
		public var wasLastTurnEnemy				: Boolean = false;
		public var battlePalette				: TinyBattlePalette;
		public var moveFXArray					: Array;
		public var debugMoveFX					: Boolean = false;
		public var allowGameOver				: Boolean = true;
		public var result						: TinyBattleResult;
			
		public function TinyBattle( playerTrainer : TinyTrainer, enemyMon : TinyMon, enemyTrainer : TinyTrainer = null, allowGameOver : Boolean = true )
		{
			TinyLogManager.log( 'new battle with ' + playerTrainer.name, this );
			
			// Command runner
			this.battleCommandRunner = new TinyBattleCommandSequencer( this );
			
			// Set parameters
			this.allowGameOver = allowGameOver;
			this.playerTrainer = playerTrainer;
			this.enemyTrainer = enemyTrainer;
			this.isWildEncounter = this.enemyTrainer == null;
			this.currentPlayerMon = this.playerTrainer.getFirstHealthyMon();
			this.currentEnemyMon = this.isWildEncounter ? enemyMon : this.enemyTrainer.getFirstHealthyMon();
		}
		
		public function startBattle() : void
		{
			// Empty dialog box that sits behind the battle menu
			m_battleEmptyDialogBox = new TinyContentBox( null, 144, 33 );
			m_battleEmptyDialogBox.x = int( ( 160 / 2 ) - ( m_battleEmptyDialogBox.width / 2 ) ) + 5;
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
			m_switchMonMenu = new TinySwitchMonMenu( playerTrainer );
			m_switchMonMenu.x = m_battleEmptyDialogBox.x;
			m_switchMonMenu.y = 7;
			m_switchMonMenu.visible = false;
			
			// Item select menu
			m_itemSelectorList = new TinyBattleItemMenu( playerTrainer );
			m_itemSelectorList.x = 22;
			m_itemSelectorList.y = 48;
			m_itemSelectorList.visible = false;
			
			// Player ball display
			playerBallDisplay = new TinyBattleBallDisplay(playerTrainer);
			playerBallDisplay.x = 77;
			playerBallDisplay.y = 80;
			
			// Enemy ball display
			if (!isWildEncounter)
			{
				enemyBallDisplay = new TinyBattleBallDisplay(enemyTrainer);
				enemyBallDisplay.scaleX *= -1;
				enemyBallDisplay.x = 79 + 3;
				enemyBallDisplay.y = 22;
			}
			
			// Player stats display
			playerStatDisplay = new TinyBattleMonStatDisplay( false );
			playerStatDisplay.x = playerBallDisplay.x;
			playerStatDisplay.y = 55;
			playerStatDisplay.visible = false;
			
			// Enemy stats display
			enemyStatDisplay = new TinyBattleMonStatDisplay( true );
			enemyStatDisplay.x = 3;
			enemyStatDisplay.y = 2;
			enemyStatDisplay.visible = false;
			
			// Player trainer container
			playerTrainerContainer = new Sprite();
			
			// Player mon container
			playerMonContainer = new TinyMonContainer( currentPlayerMon.bitmap, true );
			
			// Enemy trainer container
			enemyTrainerContainer = new Sprite();
			
			// Enemy mon container
			enemyMonContainer = new TinyMonContainer( currentEnemyMon.bitmap, false );
			
			// Fill enemy container
			this.enemyContainer = new Sprite;
			this.enemyContainer.x = 0;
			this.enemyContainer.y = 0;
			
			// Make battle palette
			this.battlePalette = new TinyBattlePalette( 
				this.playerMonContainer.palette, 
				this.enemyMonContainer.palette, 
				this.playerStatDisplay.palette, 
				this.enemyStatDisplay.palette 
			);
			
			// Load move FX animations for both mons
			this.currentEnemyMon.moveSet.loadAllMoveFXSprites( this.battlePalette, true );
			this.currentPlayerMon.moveSet.loadAllMoveFXSprites( this.battlePalette, false );
			
			// Background sprite
			this.background = new Sprite();
			this.background.graphics.beginFill( 0xFFFFFF )
			this.background.graphics.drawRect( 0, 0, 160, 144 );
			this.background.graphics.endFill();

			TinyLogManager.log('', this);
			TinyLogManager.log('==================== START BATTLE MODE ====================', this);
			TinyLogManager.log( '', this );
			
			// Whirl mask
			m_battleIntroWhirl = new TinySpriteSheet(new BattleWhirl, 160, false, 1);
			m_battleIntroWhirl.x = 
			m_battleIntroWhirl.y = 80;
			m_battleIntroWhirl.play(1);
			
			// Add 'em up
			this.addChild(m_battleIntroWhirl);
			
			TweenLite.delayedCall( m_battleIntroWhirl.length + 32, this.whirlInComplete, null, true );
		}
		
		private function whirlInComplete() : void
		{
			TinyLogManager.log('whirlInComplete', this);
			
			// Remove intro whirl sprite sheet
			m_battleIntroWhirl.stopAndRemove();
			this.removeChild(m_battleIntroWhirl);
			
			// Position player trainer
			playerTrainerContainer.x = 144 + 48;
			playerTrainerContainer.y = 50;
			playerTrainerContainer.scaleX = -1;
			playerTrainerContainer.addChild( playerTrainer.battleBitmap );
	
			// Position enemy trainer
			enemyTrainerContainer.x = -56;
			enemyTrainerContainer.y = 0;
			if (!isWildEncounter) enemyTrainerContainer.addChild( enemyTrainer.battleBitmap );
			
			// Position player mon
			playerMonContainer.x = 16;
			playerMonContainer.y = 54;
			
			// Position enemy mon
			enemyMonContainer.x = isWildEncounter ? -56 : 96;
			enemyMonContainer.y = 0;
			if (isWildEncounter) enemyMonContainer.show();

			// Add 'em up
			this.enemyContainer.addChild( this.enemyStatDisplay );
			this.enemyContainer.addChild( this.enemyMonContainer );
			this.addChild( this.background );
			this.addChild(playerBallDisplay);
			this.addChild(playerStatDisplay);
			this.addChild(playerMonContainer);
			this.addChild( this.enemyContainer );
			this.addChild(enemyTrainerContainer);
			this.addChild(playerTrainerContainer);
			this.addChild(m_battleEmptyDialogBox);
			this.addChild(this.dialogBoxContainer);
			this.addChild(m_battleCommandMenu);
			this.addChild(m_moveSelectMenu);
			this.addChild(m_switchMonMenu);
			this.addChild(m_itemSelectorList );
			
			// If this isn't a wild encounter, add the enemy trainer ball display
			if (!isWildEncounter) 
			{
				this.addChild(enemyBallDisplay);
			}
			
			// Create intro event sequence
			m_battleEvent = new TinyBattleEventSequence(this);
			
			// Slide both trainers in 
			m_battleEvent.addShowTrainer(playerTrainerContainer, false, false);
			m_battleEvent.addShowTrainer(isWildEncounter ? enemyMonContainer : enemyTrainerContainer, true, true);
			
			// The rest of the intro sequence is determined by whether or not this is a wild encounter or a trainer battle
			if (isWildEncounter) 
			{	
				// Show player ball display
				m_battleEvent.addShowElement( playerBallDisplay );
				
				// Show enemy stat display
				m_battleEvent.addSetStatDisplayMon( currentEnemyMon, enemyStatDisplay );
				m_battleEvent.addShowElement( enemyStatDisplay );
				
				// Show intro dialog box				
				m_battleEvent.addDialogBoxFromString( TinyBattleStrings.getRandomWildEncounterString( currentEnemyMon ) );
				
				// Hide player trainer and summon first mon
				m_battleEvent.addHideTrainer( playerTrainerContainer, false, true);
				m_battleEvent.addSetElementVisibility( playerBallDisplay, false );
				m_battleEvent.addDialogBoxFromString( TinyBattleStrings.getRandomSummonDialogString( false, playerTrainer.getFirstHealthyMon(), playerTrainer ) );		
				m_battleEvent.addSetStatDisplayMon( currentPlayerMon, playerStatDisplay );
				m_battleEvent.addShowElement( playerStatDisplay );
				m_battleEvent.addSummonMon( currentPlayerMon, playerMonContainer );
			}
			else
			{	
				// Show both ball displays
				m_battleEvent.addShowElement( playerBallDisplay );
				m_battleEvent.addShowElement( enemyBallDisplay );
				
				// Show intro dialog box
				m_battleEvent.addDialogBoxFromString( TinyBattleStrings.getRandomTrainerBattleString( this.enemyTrainer ) );
				
				// Hide enemy trainer and summon first mon
				m_battleEvent.addHideTrainer( enemyTrainerContainer, true, true);
				m_battleEvent.addSetElementVisibility( enemyBallDisplay, false );
				m_battleEvent.addDialogBoxFromString(TinyBattleStrings.getRandomSummonDialogString( true, this.enemyTrainer.getFirstHealthyMon(), this.enemyTrainer ) );
				m_battleEvent.addSetStatDisplayMon( currentEnemyMon, enemyStatDisplay );
				m_battleEvent.addShowElement( enemyStatDisplay );
				m_battleEvent.addSummonMon( currentEnemyMon, enemyMonContainer );
				
				// Hide player trainer and summon first mon
				m_battleEvent.addHideTrainer( playerTrainerContainer, false, true);
				m_battleEvent.addSetElementVisibility( playerBallDisplay, false );
				m_battleEvent.addDialogBoxFromString( TinyBattleStrings.getRandomSummonDialogString( false, playerTrainer.getFirstHealthyMon(), playerTrainer ) );
				m_battleEvent.addSetStatDisplayMon( currentPlayerMon, playerStatDisplay );
				m_battleEvent.addShowElement( playerStatDisplay );
				m_battleEvent.addSummonMon( currentPlayerMon, playerMonContainer );
			}
			
			if ( this.debugMoveFX ) 
			{
				this.debugPlayMoveFX( this.moveFXArray );				
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
			currentPlayerMon.isInBattle = true;
			currentEnemyMon.isInBattle = true;
						
			this.startTurn();
		}

		public function startTurn() : void
		{
			TinyLogManager.log( 'startTurn', this );
			
			// Clean up from previous turn
			this.currentPlayerMon.postTurnCleanup();
			this.currentEnemyMon.postTurnCleanup();
			
			// Show the battle command menu and reset the cursor position
			this.m_battleCommandMenu.show();
			this.m_battleCommandMenu.setSelectedItemIndex( 0 ); 
			
			// Give input command to the battle menu
			TinyInputManager.getInstance().setTarget( m_battleCommandMenu );
			m_battleCommandMenu.addEventListener(TinyBattleEvent.FIGHT_SELECTED,  onPlayerCommandSelected);
			m_battleCommandMenu.addEventListener(TinyBattleEvent.SWITCH_SELECTED, onPlayerCommandSelected);
			m_battleCommandMenu.addEventListener(TinyBattleEvent.ITEM_SELECTED,   onPlayerCommandSelected);
			m_battleCommandMenu.addEventListener(TinyBattleEvent.RUN_SELECTED,    onPlayerCommandSelected);	
		}
		
		public function endBattle() : void
		{
			TinyLogManager.log( 'endBattle: ' + this.result.value, this );
			this.dispatchEvent( new TinyGameEvent( TinyGameEvent.BATTLE_COMPLETE, this.result ) );
		}
		
		public function forcePlayerSwitch() : void
		{
			TinyLogManager.log('forcePlayerSwitch', this);
			
			this.isForcedSwitch = true;
			
			m_switchMonMenu.showForced();
			m_switchMonMenu.addEventListener( TinyBattleEvent.MON_SELECTED, onSwitchSelected );
			TinyInputManager.getInstance().setTarget( m_switchMonMenu );
		}
		
		private function onPlayerCommandSelected( event : TinyBattleEvent ) : void 
		{
			TinyLogManager.log('onCommandSelect: ' + event.type, this);
			
			switch (event.type)
			{
				case TinyBattleEvent.FIGHT_SELECTED:
					
					// Pass control to the move selector
					m_moveSelectMenu.setCurrentMon( currentPlayerMon );
					m_moveSelectMenu.show();
					TinyInputManager.getInstance().setTarget( m_moveSelectMenu );
					
					m_moveSelectMenu.addEventListener( TinyBattleEvent.MOVE_SELECTED, this.onMoveSelected );
					m_moveSelectMenu.addEventListener( TinyInputEvent.CANCEL, this.onMoveSelectCancelled );
					break;
					
				case TinyBattleEvent.SWITCH_SELECTED:
					
					// Pass control to the squad selector
					m_switchMonMenu.show();
					TinyInputManager.getInstance().setTarget( m_switchMonMenu );
					
					m_switchMonMenu.addEventListener( TinyBattleEvent.MON_SELECTED, onSwitchSelected );
					m_switchMonMenu.addEventListener( TinyInputEvent.CANCEL, this.onSwitchCancelled );
					break;
					
				case TinyBattleEvent.ITEM_SELECTED:
					
					// Pass control to the item selector
					m_itemSelectorList.show();
					m_itemSelectorList.setCurrentMon( currentPlayerMon );
					TinyInputManager.getInstance().setTarget( m_itemSelectorList );
					
					m_itemSelectorList.addEventListener( TinyBattleEvent.ITEM_USED, this.onItemUsed );
					m_itemSelectorList.addEventListener( TinyInputEvent.CANCEL, this.onItemCancelled );
					break;
					
				case TinyBattleEvent.RUN_SELECTED:
				
					// Hide the battle command menu
					m_battleCommandMenu.hide();
			
					 // Set player's battle command	
					this.battleCommandRunner.commandSelected( new TinyBattleCommandRun( this, TinyBattleCommand.USER_PLAYER ) );
					break;
			}
		}
		
		private function onMoveSelected( event : TinyBattleEvent ) : void
		{
			var selectedMove : TinyMoveData = event.move;
			
			TinyLogManager.log('onMoveSelected: ' + selectedMove.name, this);
			
			// Hide the move menu
			m_moveSelectMenu.hide();
			
			// Hide the battle command menu
			m_battleCommandMenu.hide();
			
			// Clean up
			m_moveSelectMenu.removeEventListener(TinyBattleEvent.MOVE_SELECTED, this.onMoveSelected);
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
			m_moveSelectMenu.removeEventListener(TinyBattleEvent.MOVE_SELECTED, this.onMoveSelected);
			m_moveSelectMenu.removeEventListener(TinyInputEvent.CANCEL, this.onMoveSelectCancelled);
		}
		
		private function onSwitchSelected( event : TinyBattleEvent ) : void
		{
			TinyLogManager.log('onSwitchSelected: ' + event.mon.name, this);
			
			// Hide the switch menu
			m_switchMonMenu.hide();
			
			// Hide the battle command menu
			m_battleCommandMenu.hide();			
			
			// Clean up
			m_moveSelectMenu.removeEventListener(TinyBattleEvent.MOVE_SELECTED, this.onMoveSelected);
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
			m_switchMonMenu.removeEventListener(TinyBattleEvent.MON_SELECTED, this.onSwitchSelected);
			m_switchMonMenu.removeEventListener(TinyInputEvent.CANCEL, this.onSwitchCancelled);
		}
		
		private function onItemUsed( event : TinyBattleEvent ) : void
		{
			TinyLogManager.log('onItemUsed', this);
			
			// Hide the item list menu
			m_itemSelectorList.hide();
			
			// Hide the battle command menu
			m_battleCommandMenu.hide();
			
			// Clean up
			m_itemSelectorList.removeEventListener( TinyBattleEvent.ITEM_USED, this.onItemUsed );
			m_itemSelectorList.removeEventListener( TinyInputEvent.CANCEL, this.onItemCancelled );
			
			// Set player's battle command	
			this.battleCommandRunner.commandSelected( new TinyBattleCommandItem( this, event.item, event.move ) );
		}
		
		private function onItemCancelled( event : TinyInputEvent ) : void
		{
			TinyLogManager.log('onItemCancelled', this);
			
			// Hide the item menu
			m_itemSelectorList.hide();
			
			// Return control to the command menu
			TinyInputManager.getInstance().setTarget( m_battleCommandMenu );
			
			// Clean up
			m_itemSelectorList.removeEventListener( TinyBattleEvent.ITEM_USED, this.onSwitchSelected );
			m_itemSelectorList.removeEventListener( TinyInputEvent.CANCEL, this.onItemCancelled );  
		}
		
		public function getBattlePalette() : TinyBattlePalette
		{
			return new TinyBattlePalette( this.playerMonContainer.palette, this.enemyMonContainer.palette, this.playerStatDisplay.palette, this.enemyStatDisplay.palette );
		}
		
		public function debugPlayMoveFX( fxArray : Array ) : void 
		{
			TinyLogManager.log( 'debugPlayMoveFX', this );
			
			m_battleEvent.addDelay( 1.0 );
			
			for ( var i : int = 0; i < fxArray.length; i++ )
			{
				m_battleEvent.addPlayAttackAnim( fxArray[ i ] );
				m_battleEvent.addDelay( 1.5 );
			}
			
			m_battleEvent.addEnd();
			m_battleEvent.startSequence();
		}

		public function debugPlayStatusFX( fxArray : Array ) : void
		{
			TinyLogManager.log( 'debugPlayStatusFX', this );
			
			m_battleEvent.addDelay( 1.0 );
			
			for ( var i : int = 0; i < fxArray.length; i++ )
			{
				m_battleEvent.addPlayStatusAnim( fxArray[ i ] );
				m_battleEvent.addDelay( 1.5 );
			}
			
			m_battleEvent.addEnd();
			m_battleEvent.startSequence();
		}
	}
}
