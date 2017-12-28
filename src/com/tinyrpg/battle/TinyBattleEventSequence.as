package com.tinyrpg.battle 
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.SteppedEase;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.media.Sound;

	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.display.IShowHideObject;
	import com.tinyrpg.display.TinyMonContainer;
	import com.tinyrpg.display.TinyBattleMonStatDisplay;
	import com.tinyrpg.display.TinyBallFXAnimation;
	import com.tinyrpg.display.TinyMoveFXAnimation;
	import com.tinyrpg.display.TinyStatusFXAnimation;
	import com.tinyrpg.misc.TinyEventItem;
	import com.tinyrpg.misc.TinyDealDamageCommand;
	import com.tinyrpg.misc.TinyTweenCommand;
	import com.tinyrpg.misc.TinySetVisibilityCommand;
	import com.tinyrpg.misc.TinySetMonStatDisplayCommand;
	import com.tinyrpg.misc.TinySummonMonCommand;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.ui.TinyDialogBox;
	import com.tinyrpg.ui.TinyDeleteMoveDialog;
	import com.tinyrpg.ui.TinyLevelUpStatsDisplay;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleEventSequence extends EventDispatcher 
	{
		private var m_eventSequence : Array = [];
		private var m_hostBattle : TinyBattleMon;
		private var currentMonContainer : TinyMonContainer;
		private var currentStatDisplay : TinyBattleMonStatDisplay;
		private var currentLevelUpDisplay : TinyLevelUpStatsDisplay;
		private var currentDeleteMoveDialog : TinyDeleteMoveDialog;
		private var currentBallAnimation : TinyBallFXAnimation;
		private var currentAttackAnimation : TinyMoveFXAnimation;
		private var currentStatusAnimation : TinyStatusFXAnimation;
		private var m_currentDialog : TinyDialogBox;
		
		public function get events() : Array { return this.m_eventSequence; }
		
		public function TinyBattleEventSequence(hostBattle : TinyBattleMon)
		{
			m_hostBattle = hostBattle;
			
			// Add listeners
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}
		
		public function concatEventSequence( sequence : TinyBattleEventSequence ) : void 
		{
			TinyLogManager.log('concatEventSequence: ' + sequence.events.length + ' events added', this);
			this.m_eventSequence = this.m_eventSequence.concat( sequence.events );
		}

		private function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlAdded', this);
			
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ACCEPT, onAccept);
			this.addEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.removeEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}

		private function onControlRemoved(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlRemoved', this);
			
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ACCEPT, onAccept);
			this.removeEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}

		private function onAccept(event : TinyInputEvent) : void 
		{
			TinyLogManager.log('onAccept', this);
		}

		public function startSequence() : void
		{
			TinyLogManager.log('startSequence', this);
			this.doNextCommand();
		}
		
		public function doNextCommand() : void
		{
			TinyLogManager.log('doNextCommand', this); 
			
			var nextEvent : TinyEventItem = m_eventSequence.shift();
		
			if ( !nextEvent ) 
			{
				this.doEnd();
				return;
			}
				
			switch (nextEvent.type)
			{
				case TinyEventItem.DIALOG:
					this.doDialog( TinyDialogBox( nextEvent.thingToDo ) );
					break;
				case TinyEventItem.SHOW_TRAINER:
					this.doShowTrainer( nextEvent.thingToDo );
					break;
				case TinyEventItem.HIDE_TRAINER:
					this.doHideTrainer( nextEvent.thingToDo );
					break;
				case TinyEventItem.SET_STAT_MON:
					this.doSetMonStatDisplay( (nextEvent.thingToDo as TinySetMonStatDisplayCommand).mon, (nextEvent.thingToDo as TinySetMonStatDisplayCommand).statDisplay );
					break;
				case TinyEventItem.UPDATE_HP:
					this.doUpdateHPDisplay( nextEvent.thingToDo as TinyBattleMonStatDisplay );
					break;
				case TinyEventItem.UPDATE_EXP:
					this.doUpdateEXPDisplay( nextEvent.thingToDo as TinyBattleMonStatDisplay );
					break;
				case TinyEventItem.FILL_EXP_BAR:
					this.doFillEXPDisplay( nextEvent.thingToDo as TinyBattleMonStatDisplay );
					break;
				case TinyEventItem.CLEAR_EXP_BAR:
					this.doClearEXPDisplay( nextEvent.thingToDo  as TinyBattleMonStatDisplay );
					break;
				case TinyEventItem.INCREMENT_LEVEL:
					this.doIncrementLevelDisplay( nextEvent.thingToDo as TinyBattleMonStatDisplay );
					break;
				case TinyEventItem.SHOW_LEVEL_UP_STATS:
					this.doShowLevelStatsDisplay( nextEvent.thingToDo as TinyLevelUpStatsDisplay );
					break;
				case TinyEventItem.SHOW_DELETE_MOVE:
					this.doShowDeleteMoveDialog( nextEvent.thingToDo as TinyDeleteMoveDialog );
					break;
				case TinyEventItem.SUMMON_MON:
					this.doSummonMon( nextEvent.thingToDo as TinySummonMonCommand );
					break;
				case TinyEventItem.RECALL_MON:
					this.doRecallMon( nextEvent.thingToDo as TinyMonContainer );
					break;
				case TinyEventItem.FAINT_MON:
					this.doFaintMon( nextEvent.thingToDo as TinyMonContainer );
					break;
				case TinyEventItem.DEAL_DAMAGE:
					this.doDealDamage( nextEvent.thingToDo as TinyDealDamageCommand );
					break;
				case TinyEventItem.PLAY_ATTACK_ANIM:
					this.doPlayAttackAnim( nextEvent.thingToDo as TinyMoveFXAnimation );
					break;
				case TinyEventItem.PLAY_STATUS_ANIM:
					this.doPlayStatusAnim( nextEvent.thingToDo as TinyStatusFXAnimation );
					break;
				case TinyEventItem.PLAY_BALL_ANIM:
					this.doPlayBallAnim( nextEvent.thingToDo as TinyBallFXAnimation );
					break;
				case TinyEventItem.GET_IN_BALL:
					this.doGetInBall( nextEvent.thingToDo as TinyMonContainer );
					break;
				case TinyEventItem.ESCAPE_FROM_BALL:
					this.doEscapeFromBall( nextEvent.thingToDo as TinyMonContainer );
					break;
				case TinyEventItem.PLAYER_HEAL:
					this.doPlayerHeal( nextEvent.thingToDo as TinyMonContainer );
					break;
				case TinyEventItem.PLAYER_ATTACK:
					this.doPlayerAttack( nextEvent.thingToDo as TinyMonContainer );
					break;
				case TinyEventItem.ENEMY_ATTACK:
					this.doEnemyAttack( nextEvent.thingToDo as TinyMonContainer );
					break;
				case TinyEventItem.PLAYER_HIT_DAMAGE:
					this.doPlayerHitDamage();
					break;
				case TinyEventItem.ENEMY_HIT_DAMAGE:
					this.doEnemyHitDamage( nextEvent.thingToDo as TinyMonContainer );
					break;
				case TinyEventItem.PLAYER_HIT_SECONDARY:
					this.doPlayerHitSecondary();
					break;
				case TinyEventItem.ENEMY_HIT_SECONDARY:
					this.doEnemyHitSecondary();
					break;
				case TinyEventItem.SHOW_OBJECT:
					this.doShowObject( nextEvent.thingToDo as IShowHideObject );
					break;
				case TinyEventItem.HIDE_OBJECT:
					this.doHideObject( nextEvent.thingToDo as IShowHideObject );
					break;
				case TinyEventItem.PLAY_SOUND:
					this.doPlaySound( nextEvent.thingToDo as Sound );
					break;
				case TinyEventItem.SET_VISIBLITY:
					this.doSetVisibility( nextEvent.thingToDo );
					break;
				case TinyEventItem.DELAY:
					this.doDelay( nextEvent.thingToDo );
					break;
				default:
				case TinyEventItem.END:
					this.doEnd();
					break;
			}
		}
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////
		// ADDING EVENTS TO THE SEQUENCE
		///////////////////////////////////////////////////////////////////////////////////////////////
		
		public function addDialogBoxFromString( string : String, speaker : String = null ) : void
		{
			TinyLogManager.log('addDialog', this);		
			
			// Make new dialog
			var newDialog : TinyDialogBox = TinyDialogBox.newFromString( string, speaker );
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.DIALOG, newDialog );

			// Add to sequence
			m_eventSequence.push( newEventItem );
		}
		
		public function addShowTrainer( trainerContainer : Sprite, isEnemy : Boolean, waitForCompletion : Boolean ) : void
		{
			TinyLogManager.log('addShowTrainer: ' + (isEnemy ? 'enemy' : 'player' ), this);	
		 	
		 	// Make new tween command	
			var xLocation : int = isEnemy ? 96 : 16;
			var tween : TweenLite = new TweenLite( trainerContainer, 1.0, { x: xLocation, ease: SteppedEase.create(30) } );
			var tweenCommand : TinyTweenCommand = new TinyTweenCommand( tween, waitForCompletion );
			
			// Make event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.SHOW_TRAINER, tweenCommand );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );
		}
		
		public function addHideTrainer( trainerContainer : Sprite, isEnemy : Boolean, waitForCompletion : Boolean ) : void
		{
			TinyLogManager.log('addHideTrainer:' + (isEnemy ? 'enemy' : 'player' ), this);	
			
			// Make new tween command
			var xLocation : int = isEnemy ? 144 + 56 : -48;
			var tween : TweenLite = new TweenLite( trainerContainer, 0.5, { x: xLocation, ease: SteppedEase.create(10) } );
			var tweenCommand : TinyTweenCommand = new TinyTweenCommand( tween, waitForCompletion );
			
			// Make event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.HIDE_TRAINER, tweenCommand );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );	
		}
		
		public function addSetStatDisplayMon( targetMon : TinyMon, statDisplay : TinyBattleMonStatDisplay ) : void
		{
			TinyLogManager.log('addSetStatDisplayMon: ' + targetMon.name, this);
			
			// Make new event item
			var newCommand : TinySetMonStatDisplayCommand = new TinySetMonStatDisplayCommand( statDisplay, targetMon );
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.SET_STAT_MON, newCommand );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );
		}

		public function addSummonMon( targetMon : TinyMon, targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('addSummonMon', this);
			
			// Make new event item
			var newCommand : TinySummonMonCommand = new TinySummonMonCommand( targetMon, targetMonContainer );
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.SUMMON_MON, newCommand );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );	
		}

		public function addRecallMon( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('addRecallMon', this);	
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.RECALL_MON, targetMonContainer );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );	
		}
		
		public function addFaintMon( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('addFaintMon', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.FAINT_MON, targetMonContainer );
			
			// Add to sequence
			this.m_eventSequence.push( newEventItem );
		}

		public function addDealDamage( targetMon : TinyMon, damage : int, isEnemy : Boolean ) : void
		{
			TinyLogManager.log('addDealDamage: ' + targetMon.name + ' - ' + damage, this);
			
			// Make new event item
			var newCommand : TinyDealDamageCommand = new TinyDealDamageCommand( targetMon, damage, isEnemy );
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.DEAL_DAMAGE, newCommand );
			
			// Add to sequence
			this.m_eventSequence.push( newEventItem );	
		}

		public function addPlayAttackAnim( attackAnimation : TinyMoveFXAnimation ) : void
		{
			TinyLogManager.log('addPlayAttackAnim', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.PLAY_ATTACK_ANIM, attackAnimation );
			
			// Add to sequence
			this.m_eventSequence.push( newEventItem );	
		}
		
		public function addPlayStatusAnim( statusAnimation : TinyStatusFXAnimation ) : void
		{
			TinyLogManager.log('addPlayStatusAnim', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.PLAY_STATUS_ANIM, statusAnimation );
			
			// Add to sequence
			this.m_eventSequence.push( newEventItem );	
		}
		
		public function addPlayBallAnim( ballAnimation : TinyBallFXAnimation ) : void
		{
			TinyLogManager.log('addPlayBallAnim', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.PLAY_BALL_ANIM, ballAnimation );
			
			// Add to sequence
			this.m_eventSequence.push( newEventItem );
		}
		
		public function addGetInBall( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('addGetInBall', this);	
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.GET_IN_BALL, targetMonContainer );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );
		}
		
		public function addEscapeFromBall( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('addEscapeFromBall', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.ESCAPE_FROM_BALL, targetMonContainer );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );
		}
		
		public function addPlayerHeal( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('addPlayerHeal', this);	
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.PLAYER_HEAL, targetMonContainer );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );
		}

		public function addPlayerAttack( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('addPlayerAttack', this);	
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.PLAYER_ATTACK, targetMonContainer );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );	
		}
		
		public function addEnemyAttack( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('addEnemyAttack', this);	
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.ENEMY_ATTACK, targetMonContainer );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );	
		}
		
		public function addPlayerHitDamage() : void
		{
			TinyLogManager.log('addPlayerHitDamage', this);	
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.PLAYER_HIT_DAMAGE, null );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );	
		}
		
		public function addEnemyHitDamage( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('addEnemyHitDamage', this);	
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.ENEMY_HIT_DAMAGE, targetMonContainer );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );	
		}
		
		public function addPlayerHitSecondary() : void
		{
			TinyLogManager.log('addPlayerHitSecondary', this);	
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.PLAYER_HIT_SECONDARY, null );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );	
		}
		
		public function addEnemyHitSecondary( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('addEnemyHitSecondary', this);	
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.ENEMY_HIT_SECONDARY, targetMonContainer );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );	
		}
		
		public function addUpdateHPDisplay( statDisplay : TinyBattleMonStatDisplay ) : void
		{
			TinyLogManager.log('addUpdateHPDisplay', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.UPDATE_HP, statDisplay );
			
			// Add to sequence
			this.m_eventSequence.push(newEventItem);
		}
		
		public function addUpdateEXPDisplay( statDisplay : TinyBattleMonStatDisplay ) : void
		{
			TinyLogManager.log('addUpdateEXPDisplay', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.UPDATE_EXP, statDisplay );
			
			// Add to sequence
			this.m_eventSequence.push(newEventItem);
		}
		
		public function addFillEXPDisplay( statDisplay : TinyBattleMonStatDisplay ) : void
		{
			TinyLogManager.log('addFillEXPDisplay', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.FILL_EXP_BAR, statDisplay );
			
			// Add to sequence
			this.m_eventSequence.push(newEventItem);	
		}
		
		public function addClearEXPDisplay( statDisplay : TinyBattleMonStatDisplay ) : void
		{
			TinyLogManager.log('addClearEXPDisplay', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.CLEAR_EXP_BAR, statDisplay );
			
			// Add to sequence
			this.m_eventSequence.push(newEventItem);	
		}
		
		public function addIncrementLevelDisplay( statDisplay : TinyBattleMonStatDisplay ) : void
		{
			TinyLogManager.log('addIncrementLevelDisplay', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.INCREMENT_LEVEL, statDisplay );
			
			// Add to sequence
			this.m_eventSequence.push(newEventItem);
		}
		
		public function addShowLevelStats( levelStatsDisplay : TinyLevelUpStatsDisplay ) : void
		{
			TinyLogManager.log('addShowLevelStats', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.SHOW_LEVEL_UP_STATS, levelStatsDisplay );
			
			// Add to sequence
			this.m_eventSequence.push( newEventItem );
		}
		
		public function addShowDeleteMoveDialog( deleteMoveDialog : TinyDeleteMoveDialog ) : void
		{
			TinyLogManager.log('addShowDeleteMoveDialog', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.SHOW_DELETE_MOVE, deleteMoveDialog );
			
			// Add to sequence
			this.m_eventSequence.push( newEventItem );
		}

		public function addSetElementVisibility( element : DisplayObject, visibility : Boolean ) : void
		{
			TinyLogManager.log('addSetElementVisibility', this);
			
			// Make new event item
			var visibilityCommand : TinySetVisibilityCommand = new TinySetVisibilityCommand( element, visibility );
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.SET_VISIBLITY, visibilityCommand );
			
			// Add to sequence
			m_eventSequence.push(newEventItem);	
		}
		
		public function addShowElement( element : IShowHideObject ) : void
		{
			TinyLogManager.log('addShowElement', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.SHOW_OBJECT, element );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );	
		}
		
		public function addHideElement( element : IShowHideObject ) : void
		{
			TinyLogManager.log('addHideElement', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.HIDE_OBJECT, element );
			
			// Add to sequence
			m_eventSequence.push( newEventItem );	
		}
		
		public function addPlaySound( sound : Sound ) : void
		{
			TinyLogManager.log('addPlaySound', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.PLAY_SOUND, sound );
			
			// Add to sequence
			m_eventSequence.push(newEventItem);
		}

		public function addDelay( delaySeconds : Number ) : void
		{
			TinyLogManager.log('addDelay: ' + delaySeconds + ' seconds', this);
			 
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.DELAY, delaySeconds );
			
			// Add to sequence
			m_eventSequence.push(newEventItem);
		}
		
		public function addEnd() : void
		{
			TinyLogManager.log('addEnd', this);
			
			// Make new event item
			var newEventItem : TinyEventItem = new TinyEventItem(TinyEventItem.END, null);
			
			// Add to sequence
			m_eventSequence.push(newEventItem);
		}
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////
		// PERFORMING EVENTS FROM THE SEQUENCE
		///////////////////////////////////////////////////////////////////////////////////////////////
		
		private function doDialog( dialog : TinyDialogBox ) : void
		{
			TinyLogManager.log('doDialog', this);
			
			// Add and show dialog
			m_currentDialog = dialog;
			TinyInputManager.getInstance().setTarget(m_currentDialog);
					
			m_currentDialog.show();
			m_hostBattle.dialogBoxContainer.addChild(m_currentDialog);
			
			m_currentDialog.addEventListener(Event.COMPLETE, onDialogComplete);
		}
		
		private function onDialogComplete( event : Event ) : void 
		{
			TinyLogManager.log('onDialogComplete', this);
			
			// Clean up
			m_currentDialog.removeEventListener( Event.COMPLETE, onDialogComplete );
			m_hostBattle.dialogBoxContainer.removeChild( m_currentDialog );
			
			// Next!
			this.doNextCommand();
		}
		
		private function doShowTrainer( tweenCommand : TinyTweenCommand ) : void
		{
			TinyLogManager.log('doShowTrainer', this);
			
			tweenCommand.addEventListener( Event.COMPLETE, this.onShowTrainerComplete );	
			tweenCommand.execute();
		}
		
		private function onShowTrainerComplete( event : Event ) : void
		{
			TinyLogManager.log('onShowTrainerComplete', this);
			
			// Next!
			this.doNextCommand();
		}
		
		private function doHideTrainer( tweenCommand : TinyTweenCommand ) : void
		{
			TinyLogManager.log('doHideTrainer', this);
			
			tweenCommand.addEventListener( Event.COMPLETE, this.onHideTrainerComplete );	
			tweenCommand.execute();
		}
		
		private function onHideTrainerComplete( event : Event ) : void
		{
			TinyLogManager.log('onHideTrainerComplete', this);
			
			// Next!
			this.doNextCommand();
		}
		
		private function doSetMonStatDisplay( targetMon : TinyMon, statDisplay : TinyBattleMonStatDisplay ) : void
		{
			TinyLogManager.log('doSetMonStatDisplay: ' + targetMon.name, this);
			
			// Set stat display mon
			statDisplay.setCurrentMon( targetMon );
			
			// Next!
			this.doNextCommand();	
		}
		
		private function doSummonMon( summonCommand : TinySummonMonCommand ) : void
		{
			TinyLogManager.log('doSummonMon: ' + summonCommand.mon.name, this);
			
			this.currentMonContainer = summonCommand.monContainer;
			this.currentMonContainer.setMonBitmap( summonCommand.mon.bitmap );
			this.currentMonContainer.addEventListener( Event.COMPLETE, this.onSummonMonComplete );
			this.currentMonContainer.playSummonPoof();
		}
		
		private function onSummonMonComplete( event : Event ) : void
		{
			TinyLogManager.log('onSummonMonComplete', this);
			
			// Clean up
			this.currentMonContainer.removeEventListener( Event.COMPLETE, this.onSummonMonComplete );
			this.currentMonContainer = null;
			
			// Next!
			this.doNextCommand();
		}
		
		private function doRecallMon( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('doRecallMon', this);
			
			this.currentMonContainer = targetMonContainer;
			this.currentMonContainer.addEventListener( Event.COMPLETE, this.onRecallMonComplete );
			this.currentMonContainer.scaleOutMon();
		}
		
		private function onRecallMonComplete( event : Event ) : void
		{
			TinyLogManager.log('onRecallMonComplete', this);
			
			// Clean up
			this.currentMonContainer.removeEventListener( Event.COMPLETE, this.onRecallMonComplete );
			this.currentMonContainer = null;
			
			// Next!
			this.doNextCommand();
		}
		
		private function doDealDamage( damageCommand : TinyDealDamageCommand ) : void
		{
			TinyLogManager.log('doDealDamage: ' + damageCommand.mon.name + ' - ' + damageCommand.damage, this);
			damageCommand.mon.dealDamage( damageCommand.damage );
			
			// Next!
			this.doNextCommand();
		}

		private function doPlayAttackAnim( attackAnim : TinyMoveFXAnimation ) : void
		{
			TinyLogManager.log('doPlayAttackAnim: ' + attackAnim.moveName, this);
							
			this.currentAttackAnimation = attackAnim;
			this.currentAttackAnimation.addEventListener( Event.COMPLETE, this.onPlayAttackAnimComplete );
			this.currentAttackAnimation.setBattlePalette( this.m_hostBattle.getBattlePalette() );
			this.currentAttackAnimation.captureBattleBitmap( this.m_hostBattle );
			this.currentAttackAnimation.play();
			this.currentAttackAnimation.x = 
			this.currentAttackAnimation.y = 0;
			
			this.m_hostBattle.addChild( this.currentAttackAnimation );
		}

		private function onPlayAttackAnimComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onPlayAttackAnimComplete', this);
			
			// Clean up
			this.m_hostBattle.removeChild( this.currentAttackAnimation );
			this.currentAttackAnimation.removeEventListener( Event.COMPLETE, this.onPlayAttackAnimComplete );
			this.currentAttackAnimation = null;
			
			// Next!
			this.doNextCommand();	
		}
		
		private function doPlayStatusAnim( statusAnim : TinyStatusFXAnimation ) : void
		{
			TinyLogManager.log('doPlayStatusAnim', this);
							
			this.currentStatusAnimation = statusAnim;
			this.currentStatusAnimation.addEventListener( Event.COMPLETE, this.onPlayStatusAnimComplete );
			this.currentStatusAnimation.play();
			this.currentStatusAnimation.x = 
			this.currentStatusAnimation.y = 0;
			
			this.m_hostBattle.addChild( this.currentStatusAnimation );
		}
		
		private function onPlayStatusAnimComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onPlayStatusAnimComplete', this);
			
			// Clean up
			this.m_hostBattle.removeChild( this.currentStatusAnimation );
			this.currentStatusAnimation.removeEventListener( Event.COMPLETE, this.onPlayStatusAnimComplete );
			this.currentStatusAnimation = null;
			
			// Next!
			this.doNextCommand();	
		}
		
		private function doPlayBallAnim( ballAnim : TinyBallFXAnimation ) : void
		{
			TinyLogManager.log('doPlayBallAnim', this);
							
			this.currentBallAnimation = ballAnim;
			this.currentBallAnimation.addEventListener( Event.COMPLETE, this.onPlayBallAnimComplete );
			this.currentBallAnimation.play();
			this.currentBallAnimation.x = 
			this.currentBallAnimation.y = 0;
			
			this.m_hostBattle.addChild( this.currentBallAnimation );
		}
		
		private function doGetInBall( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('doGetInBall', this);
			
			this.currentMonContainer = targetMonContainer;
			this.currentMonContainer.addEventListener( Event.COMPLETE, this.onGetInBallComplete );
			this.currentMonContainer.scaleOutMon();
			
			// Next!
			this.doNextCommand();
		}
		
		private function onGetInBallComplete( event : Event ) : void
		{
			TinyLogManager.log('onGetInBallComplete', this);
			
			// Clean up
			this.currentMonContainer.removeEventListener( Event.COMPLETE, this.onGetInBallComplete );
			this.currentMonContainer = null;
		}
		
		private function doEscapeFromBall( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('doEscapeFromBall', this);
			
			this.currentMonContainer = targetMonContainer;
			this.currentMonContainer.addEventListener( Event.COMPLETE, this.onEscapeFromBallComplete );
			this.currentMonContainer.playSummonPoof();
			
			// Next!
			this.doNextCommand();
		}
		
		private function onEscapeFromBallComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onSummonMonComplete', this);
			
			// Clean up
			this.currentMonContainer.removeEventListener( Event.COMPLETE, this.onEscapeFromBallComplete );
			this.currentMonContainer = null;
		}
		
		private function onPlayBallAnimComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onPlayBallAnimComplete', this);
			
			// Clean up
			this.m_hostBattle.removeChild( this.currentBallAnimation );
			this.currentBallAnimation.removeEventListener( Event.COMPLETE, this.onPlayBallAnimComplete );
			this.currentBallAnimation = null;
			
			// Next!
			this.doNextCommand();
		}
		
		private function doPlayerHeal( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('doPlayerHeal', this);
			
			this.currentMonContainer = targetMonContainer;
			this.currentMonContainer.addEventListener( Event.COMPLETE, this.onPlayerHealComplete );
			this.currentMonContainer.playPlayerHeal();
		}
		
		private function onPlayerHealComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onPlayerHealComplete', this);
			
			// Clean up
			this.currentMonContainer.removeEventListener( Event.COMPLETE, this.onPlayerHealComplete );
			this.currentMonContainer = null;
			
			// Next!
			this.doNextCommand();
		}
		
		private function doPlayerAttack( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('doPlayerAttack', this);
			
			this.currentMonContainer = targetMonContainer;
			this.currentMonContainer.addEventListener( Event.COMPLETE, this.onPlayerAttackComplete );
			this.currentMonContainer.playPlayerAttack();
		}
		
		private function onPlayerAttackComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onPlayerAttackComplete', this);
			
			// Clean up
			this.currentMonContainer.removeEventListener( Event.COMPLETE, this.onPlayerAttackComplete );
			this.currentMonContainer = null;
			
			// Next!
			this.doNextCommand();
		}
		
		private function doEnemyAttack( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('doEnemyAttack', this);
			
			this.currentMonContainer = targetMonContainer;
			this.currentMonContainer.addEventListener( Event.COMPLETE, this.onEnemyAttackComplete );
			this.currentMonContainer.playEnemyAttack();
		}
		
		private function onEnemyAttackComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onEnemyAttackComplete', this);
			
			// Clean up
			this.currentMonContainer.removeEventListener( Event.COMPLETE, this.onEnemyAttackComplete );
			this.currentMonContainer = null;
			
			// Next!
			this.doNextCommand();
		}
		
		private function doPlayerHitDamage() : void
		{
			TinyLogManager.log('doPlayerHitDamage', this);
			
			var shakeSpan : int = 6;
			this.m_hostBattle.y = -shakeSpan;
			TweenMax.to( this.m_hostBattle, 1, { y: shakeSpan, delay: 1, ease: SteppedEase.create(1), yoyo: true, useFrames: true, repeat: 12, onComplete: this.onPlayerHitDamageComplete } );
		}
		
		private function onPlayerHitDamageComplete( event : Event = null ) : void
		{
			TinyLogManager.log('onPlayerHitDamageComplete', this);
			
			this.m_hostBattle.y = 0;	
			
			// Next!
			this.doNextCommand();
		}

		private function doEnemyHitDamage( monContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('doEnemyHitDamage', this);
			
			this.currentMonContainer = monContainer;
			this.currentMonContainer.addEventListener( Event.COMPLETE, this.onEnemyHitDamageComplete );
			this.currentMonContainer.playEnemyHitFlash();
		}

		private function onEnemyHitDamageComplete( event : Event ) : void
		{
			TinyLogManager.log('onEnemyHitDamageComplete', this);
			
			// Clean up
			this.currentMonContainer.removeEventListener( Event.COMPLETE, this.onEnemyHitDamageComplete );
			this.currentMonContainer = null;
			
			// Next!
			this.doNextCommand();	
		}

		private function doPlayerHitSecondary() : void
		{
			TinyLogManager.log('doPlayerHitSecondary', this);	
			
			var shakeSpan : int = 6;
			this.m_hostBattle.x= -shakeSpan;
			TweenMax.to( this.m_hostBattle, 4, { x: shakeSpan, delay: 1, yoyo: true, useFrames: true, repeat: 7, onComplete: this.onPlayerHitSecondaryComplete } );
		}
		
		private function onPlayerHitSecondaryComplete() : void
		{
			TinyLogManager.log('onPlayerHitSecondaryComplete', this);
			
			this.m_hostBattle.x = 0;	
			
			// Next!
			this.doNextCommand();
		}
		
		private function doEnemyHitSecondary() : void
		{
			TinyLogManager.log('doEnemyHitSecondary', this);
			
			var shakeSpan : int = 2;
			var shakeTime : int = 2;
			this.m_hostBattle.enemyContainer.x = -shakeSpan / 2;
			TweenMax.to( this.m_hostBattle.enemyContainer, shakeTime, { x: shakeSpan + 1, ease: Linear.easeNone, useFrames: true, yoyo: true, repeat: 6, onComplete: this.onEnemyHitSecondaryComplete } ); 
		}

		private function onEnemyHitSecondaryComplete() : void
		{
			TinyLogManager.log('onEnemyHitSecondaryComplete', this);
			
			this.m_hostBattle.enemyContainer.x = 0;
			
			// Next!
			this.doNextCommand();	
		}
		
		private function doFaintMon( targetMonContainer : TinyMonContainer ) : void
		{
			TinyLogManager.log('doFaintMon', this);
			
			this.currentMonContainer = targetMonContainer;
			this.currentMonContainer.addEventListener( Event.COMPLETE, this.onFaintMonComplete );
			this.currentMonContainer.playFaint();
		}
		
		private function onFaintMonComplete( event : Event ) : void
		{
			TinyLogManager.log('onFaintMonComplete', this);
			
			// Clean up
			this.currentMonContainer.removeEventListener( Event.COMPLETE, this.onFaintMonComplete );
			this.currentMonContainer = null;
			
			// Next!
			this.doNextCommand();	
		}
		
		private function doUpdateHPDisplay( targetStatDisplay : TinyBattleMonStatDisplay ) : void
		{
			TinyLogManager.log('doUpdateHPDisplay', this);
			
			// Start the update tween in the stat display
			this.currentStatDisplay = targetStatDisplay;
			this.currentStatDisplay.addEventListener( Event.COMPLETE, this.onUpdateHPDisplayComplete );
			this.currentStatDisplay.updateHP();
		}

		private function onUpdateHPDisplayComplete( event : Event ) : void
		{
			TinyLogManager.log('onUpdateHPDisplayComplete', this);
			
			// Cleanup
			this.currentStatDisplay.removeEventListener( Event.COMPLETE, this.onUpdateHPDisplayComplete );
			this.currentStatDisplay = null;
			
			// Next!
			this.doNextCommand();
		}
		
		private function doUpdateEXPDisplay( targetStatDisplay : TinyBattleMonStatDisplay ) : void
		{
			TinyLogManager.log('doUpdateEXPDisplay', this);
			
			// Start the update tween in the stat display
			this.currentStatDisplay = targetStatDisplay;
			this.currentStatDisplay.addEventListener( Event.COMPLETE, this.onUpdateEXPDisplayComplete );
			this.currentStatDisplay.updateEXP( false );
		}
		
		private function doFillEXPDisplay( targetStatDisplay : TinyBattleMonStatDisplay ) : void
		{
			TinyLogManager.log('doFillEXPDisplay', this);
			
			// Start the update tween in the stat display
			this.currentStatDisplay = targetStatDisplay;
			this.currentStatDisplay.addEventListener( Event.COMPLETE, this.onUpdateEXPDisplayComplete );
			this.currentStatDisplay.updateEXP( true );	
		}
		
		private function onUpdateEXPDisplayComplete( event : Event ) : void
		{
			TinyLogManager.log('onUpdateEXPDisplayComplete', this);
			
			// Cleanup
			this.currentStatDisplay.removeEventListener( Event.COMPLETE, this.onUpdateEXPDisplayComplete );
			this.currentStatDisplay = null;
			
			// Next!
			this.doNextCommand();
		}
		
		private function doClearEXPDisplay( targetStatDisplay : TinyBattleMonStatDisplay ) : void
		{
			TinyLogManager.log('doClearEXPDisplay', this);
			
			// Clear EXP bar
			targetStatDisplay.clearEXPBar();
			
			// Next!
			this.doNextCommand();	
		}
		
		private function doIncrementLevelDisplay( targetStatDisplay : TinyBattleMonStatDisplay ) : void
		{
			TinyLogManager.log('doIncrementLevelDisplay', this);
			
			// Update the level display
			targetStatDisplay.incrementLevelDisplay();
			
			// Next!
			this.doNextCommand();	
		}
		
		private function doShowLevelStatsDisplay( targetLevelStatsDisplay : TinyLevelUpStatsDisplay ) : void
		{
			TinyLogManager.log('doShowLevelStatsDisplay', this);
			
			// Add and show the level up stats display
			this.currentLevelUpDisplay = targetLevelStatsDisplay;
			this.currentLevelUpDisplay.x = 8;
			this.currentLevelUpDisplay.y = 41;
			this.currentLevelUpDisplay.show();
			this.m_hostBattle.addChild( this.currentLevelUpDisplay );
			
			this.currentLevelUpDisplay.addEventListener( Event.COMPLETE, this.onShowLevelUpStatsDisplayComplete );
		}
		
		private function onShowLevelUpStatsDisplayComplete( event : Event ) : void
		{
			TinyLogManager.log('onShowLevelUpStatsDisplayComplete', this);
			
			// Clean up
			this.currentLevelUpDisplay.hide();
			this.currentLevelUpDisplay.removeEventListener( Event.COMPLETE, this.onShowLevelUpStatsDisplayComplete );
			this.m_hostBattle.removeChild( this.currentLevelUpDisplay );
			this.currentLevelUpDisplay = null;
			
			// Next!
			this.doNextCommand();
		}
		
		private function doShowDeleteMoveDialog( targetDeleteMoveDialog : TinyDeleteMoveDialog ) : void
		{
			TinyLogManager.log('doShowDeleteMoveDialog', this);
			
			// Add and show the delete move dialog	
			this.currentDeleteMoveDialog = targetDeleteMoveDialog;
			this.currentDeleteMoveDialog.x = 8;
			this.currentDeleteMoveDialog.y = 104;
			this.currentDeleteMoveDialog.show();
			this.m_hostBattle.addChild( this.currentDeleteMoveDialog );
			
			this.currentDeleteMoveDialog.addEventListener( Event.COMPLETE, this.onShowDeleteMoveDialogComplete );	
		}

		private function onShowDeleteMoveDialogComplete( event : Event ) : void
		{
			TinyLogManager.log('onShowDeleteMoveDialogComplete', this);
			
			// Clean up
			this.currentDeleteMoveDialog.hide();
			this.currentDeleteMoveDialog.removeEventListener( Event.COMPLETE, this.onShowDeleteMoveDialogComplete );
			this.m_hostBattle.removeChild( this.currentDeleteMoveDialog );
			this.currentDeleteMoveDialog = null;			
			
			// Next!
			this.doNextCommand();	
		}

		private function doSetVisibility( visibilityCommand : TinySetVisibilityCommand ) : void
		{
			TinyLogManager.log('doSetVisibility', this);
			
			// Set visibility of given element
			visibilityCommand.element.visible = visibilityCommand.visibility;
			
			// Next!
			this.doNextCommand();
		}
		
		private function doShowObject( element : IShowHideObject ) : void
		{
			TinyLogManager.log('doShowObject', this);
			
			// Show given element
			element.show();
			
			// Next!
			this.doNextCommand();
		}
		
		private function doHideObject( element : IShowHideObject ) : void
		{
			TinyLogManager.log('doHideObject', this);
			
			// Hide given element
			element.hide();
			
			// Next!
			this.doNextCommand();
		}
		
		private function doPlaySound( sound : Sound ) : void 
		{
			TinyLogManager.log('doPlaySound', this);
			
			// Play the sound
			sound.play();
			
			// Next!
			this.doNextCommand();
		}
		
		private function doDelay( delayTime : Number ) : void
		{
			TinyLogManager.log('doDelay: ' + delayTime, this);
		
			TweenLite.delayedCall(delayTime, this.onDelayComplete);
		}
	
		private function onDelayComplete() : void
		{
			TinyLogManager.log('onDelayComplete', this);
			
			// Next!
			this.doNextCommand();
		}
		
		private function doEnd() : void
		{
			TinyLogManager.log('doEnd', this);
			
			if (this.m_eventSequence.length < 1)
				this.dispatchEvent(new Event(Event.COMPLETE));
			else {
				TinyLogManager.log('doEnd: more events to do, continuing', this);
				this.doNextCommand();
			}
		}
	}
}
