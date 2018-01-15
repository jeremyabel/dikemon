﻿package com.tinyrpg.core {	import com.greensock.TweenLite;		import com.tinyrpg.battle.TinyBattleMon;	import com.tinyrpg.data.TinyEventFlag;	import com.tinyrpg.data.TinyEventFlagData;	import com.tinyrpg.events.TinySequenceEvent;	import com.tinyrpg.managers.TinyAudioManager;	import com.tinyrpg.managers.TinyInputManager;	import com.tinyrpg.misc.TinyAddNPCCommand;	import com.tinyrpg.misc.TinyAnimCommand;	import com.tinyrpg.misc.TinyEventItem;	import com.tinyrpg.misc.TinyItemCommand;	import com.tinyrpg.misc.TinyMusicCommand;	import com.tinyrpg.misc.TinySetPosCommand;	import com.tinyrpg.misc.TinyWalkCommand;	import com.tinyrpg.ui.TinyDialogBox;	import com.tinyrpg.utils.TinyLogManager;	import flash.display.Sprite;	import flash.events.Event;	import flash.media.Sound;	/**	 * @author jeremyabel	 */	public class TinyEventSequence extends Sprite	{		public static const TYPE_FLAG   : String = 'TYPE_FLAG';		public static const TYPE_ITEM   : String = 'TYPE_ITEM';		public static const TYPE_GOLD   : String = 'TYPE_GOLD';		public static const TYPE_PLAYER : String = 'TYPE_PLAYER';				private var eventSequence 		: Array = [];		private var currentBattle   	: TinyBattleMon;		private var currentDialog   	: TinyDialogBox;		private var currentWalkCommand	: TinyWalkCommand;		private var currentAnimCommand	: TinyAnimCommand;				public var eventXMLData  		: XML;		public var conditionGold 		: uint = 0;		public var conditionFlag 		: String = '';		public var conditionItem		: String = '';		public var conditionPlayer  	: String = '';		public var conditionType  		: String = '';				public var elseSequence  		: TinyEventSequence;		public var eventDepth	 		: int = 0;
		public var eventName	 		: String;
		public function TinyEventSequence() : void		{					}				public static function newFromEventName( sourceXML : XML, eventName : String ) : TinyEventSequence		{			var newEventSequence : TinyEventSequence = new TinyEventSequence();			TinyLogManager.log( 'newFromEventName: ' + eventName, newEventSequence );						newEventSequence.eventName = eventName;			newEventSequence.eventXMLData = sourceXML;						// Find in XML			var eventList : XMLList = sourceXML.child( 'EVENT_' + eventName ).child( 'SEQUENCE' );			for each ( var eventXML : XML in eventList.children() )			{				var eventType : String = eventXML.name();								switch ( eventType )				{					case TinyEventItem.BATTLE:			newEventSequence.addBattle( eventXML ); break;					case TinyEventItem.CONDITIONAL:		newEventSequence.addCondition( eventXML ); break;					case TinyEventItem.DIALOG:			newEventSequence.addDialog( eventXML ); break;					case TinyEventItem.ADD_NPC:			newEventSequence.addNPC( eventXML ); break;					case TinyEventItem.REMOVE_NPC:		newEventSequence.removeNPC( eventXML ); break;					case TinyEventItem.SUB_SEQUENCE:	newEventSequence.addSubSequence( eventXML ); break;					case TinyEventItem.TAKE_GOLD:		newEventSequence.addTakeGold( eventXML ); break;					case TinyEventItem.PLAY_ANIM:		newEventSequence.addAnimation( eventXML ); break;					case TinyEventItem.PLAY_SOUND:		newEventSequence.addSound( eventXML ); break;					case TinyEventItem.PLAY_MUSIC:		newEventSequence.addMusic( eventXML ); break;					case TinyEventItem.SET_FLAG:		newEventSequence.addFlagSet( eventXML ); break;					case TinyEventItem.DELAY:			newEventSequence.addPause( eventXML ); break;					case TinyEventItem.HEAL_ALL:		newEventSequence.addHealAll(); break;					case TinyEventItem.WALK:			newEventSequence.addWalk( eventXML ); break;					case TinyEventItem.SET_POSITION:	newEventSequence.addSetPosition( eventXML ); break;					default: case TinyEventItem.END:	newEventSequence.addEnd(); break;					case TinyEventItem.FINAL_END:		break;				}			}						return newEventSequence;		}				public static function newFromXML( xmlData : XML ) : TinyEventSequence		{			var newEventSequence : TinyEventSequence = new TinyEventSequence();						// Check if a conditional flag is required			if ( xmlData.child( 'FLAG' ) && xmlData.child( 'FLAG' ).toString() != '' ) 			{				newEventSequence.conditionFlag = xmlData.child( 'FLAG' ).toString();				newEventSequence.conditionType = TinyEventSequence.TYPE_FLAG;							TinyLogManager.log( 'newFromXML: condition = ' + newEventSequence.conditionFlag, newEventSequence );			} 						// Check if a conditional item is required			if ( xmlData.child( 'ITEM' ) && xmlData.child( 'ITEM' ).toString() != '' ) 			{				newEventSequence.conditionItem = xmlData.child( 'ITEM' ).toString();				newEventSequence.conditionType = TinyEventSequence.TYPE_ITEM;							TinyLogManager.log( 'newFromXML: condition = has 1 ' + newEventSequence.conditionItem, newEventSequence );			}						// Check if a conditional gold ammount is required			if ( xmlData.child( 'GOLD' ) && xmlData.child( 'GOLD' ).toString() != '' ) 			{				newEventSequence.conditionGold = uint( xmlData.child( 'GOLD' ).toString() );				newEventSequence.conditionType = TinyEventSequence.TYPE_GOLD;							TinyLogManager.log( 'newFromXML: condition = has ' + newEventSequence.conditionGold + ' bucks', newEventSequence );			}						// Check if a conditional player name required			if ( xmlData.child( 'PLAYER' ) && xmlData.child( 'PLAYER' ).toString() != '' ) 			{				newEventSequence.conditionPlayer = xmlData.child( 'PLAYER' ).toString();				newEventSequence.conditionType = TinyEventSequence.TYPE_PLAYER;							TinyLogManager.log( 'newFromXML: condition = name is ' + newEventSequence.conditionPlayer, newEventSequence );			}					if ( newEventSequence.conditionType == '' )			{				TinyLogManager.log( 'newFromXML: no condition', newEventSequence );			}						// Add events to the sequence			for each ( var eventXML : XML in xmlData.child( 'SEQUENCE' ).children() )			{				var eventType : String = eventXML.name();								switch ( eventType )				{					case TinyEventItem.BATTLE:			newEventSequence.addBattle( eventXML ); break;					case TinyEventItem.CONDITIONAL:		newEventSequence.addCondition( eventXML ); break;					case TinyEventItem.DIALOG:			newEventSequence.addDialog( eventXML ); break;					case TinyEventItem.ADD_NPC:			newEventSequence.addNPC( eventXML ); break;					case TinyEventItem.REMOVE_NPC:		newEventSequence.removeNPC( eventXML ); break;					case TinyEventItem.SUB_SEQUENCE:	newEventSequence.addSubSequence( eventXML ); break;					case TinyEventItem.TAKE_GOLD:		newEventSequence.addTakeGold( eventXML ); break;					case TinyEventItem.PLAY_ANIM:		newEventSequence.addAnimation( eventXML ); break;					case TinyEventItem.PLAY_SOUND:		newEventSequence.addSound( eventXML ); break;					case TinyEventItem.PLAY_MUSIC:		newEventSequence.addMusic( eventXML ); break;					case TinyEventItem.SET_FLAG:		newEventSequence.addFlagSet( eventXML ); break;					case TinyEventItem.DELAY:			newEventSequence.addPause( eventXML ); break;					case TinyEventItem.HEAL_ALL:		newEventSequence.addHealAll(); break;					case TinyEventItem.WALK:			newEventSequence.addWalk( eventXML ); break;					case TinyEventItem.SET_POSITION:	newEventSequence.addSetPosition( eventXML ); break;					default: case TinyEventItem.END:	newEventSequence.addEnd(); break;					case TinyEventItem.FINAL_END:		break;				}			}						// If there's an ELSE sequence, add it to the list 			if ( xmlData.child( 'ELSE' ).toString() != '' )			{				// Wrap the ELSE sequence's XML in an EVENT tag to create a new full event XML object				var xmlString : String = '<EVENT>' + xmlData.child( 'ELSE' ).child( 'SEQUENCE' ).toXMLString() + '</EVENT>';				var newXML : XML = new XML( xmlString );								// Create a new sequence using the ELSE sequence's XML				var newElseSequence : TinyEventSequence = TinyEventSequence.newFromXML( newXML );				newEventSequence.elseSequence = newElseSequence;			}						return newEventSequence;		}		public function startSequence() : void		{			TinyLogManager.log( 'startSequence with depth ' + this.eventDepth, this );			this.addEventListener( TinySequenceEvent.SEQUENCE_END, onSequenceEnd );			this.doNextCommand();		}				///////////////////////////////////////////////////////////////////////////////////////////////		// ADDING EVENTS TO THE SEQUENCE		///////////////////////////////////////////////////////////////////////////////////////////////				private function addBattle( xmlData : XML ) : void		{			// TODO: Implement for TinyBattleMon		}		private function addCondition( xmlData : XML ) : void		{			TinyLogManager.log( 'addCondition', this );						// Make new event sequence			var newSequence : TinyEventSequence = TinyEventSequence.newFromXML( xmlData );			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.CONDITIONAL, newSequence );						// Add to sequence			this.eventSequence.push( newEventItem );		}		private function addDialog( xmlData : XML ) : void		{			TinyLogManager.log( 'addDialog', this );								// Make new dialog			var newDialog : TinyDialogBox = TinyDialogBox.newFromXML( xmlData );			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.DIALOG, newDialog );						// Add to sequence			this.eventSequence.push( newEventItem );		}				private function addNPC( xmlData : XML ) : void		{			TinyLogManager.log( 'addNPC', this );						// Make new add NPC command						var newNPCCommand : TinyAddNPCCommand = TinyAddNPCCommand.newFromXML( xmlData );			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.ADD_NPC, newNPCCommand );						// Add to sequence			this.eventSequence.push( newEventItem );		}				private function removeNPC( xmlData : XML ) : void		{			TinyLogManager.log( 'removeNPC', this );						// Make new add NPC command						var newNPCCommand : TinyAddNPCCommand = TinyAddNPCCommand.newFromXML( xmlData );			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.REMOVE_NPC, newNPCCommand );						// Add to sequence			this.eventSequence.push( newEventItem );		}			private function addSubSequence( xmlData : XML ) : void		{			TinyLogManager.log( 'addSubSequence: ' + xmlData.toString(), this );						// Make new sequence			var newSequence : TinyEventSequence = TinyEventSequence.newFromEventName( this.eventXMLData, xmlData.toString() );			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.SUB_SEQUENCE, newSequence );						// Add to sequence			this.eventSequence.push( newEventItem );		}		private function addTakeGold( xmlData : XML ) : void		{			TinyLogManager.log( 'addTakeItem', this );						// Get params from XML			var gold : int = int( xmlData.toString() );						// Make new item command			var newItemCommand : TinyItemCommand = new TinyItemCommand( true, null, gold );			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.TAKE_GOLD, newItemCommand );						// Add to sequence			this.eventSequence.push( newEventItem );			}		private function addAnimation( xmlData : XML ) : void		{			TinyLogManager.log( 'addAnimation', this );							// Make new animation command			var newAnimCommand : TinyAnimCommand = TinyAnimCommand.newFromXML( xmlData );			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.PLAY_ANIM, newAnimCommand );						// Add to sequence			this.eventSequence.push( newEventItem );		}				private function addSound( xmlData : XML ) : void		{			TinyLogManager.log( 'addSound', this );						// Make new sound			var newSound : Sound = TinyAudioManager.getSoundByName( xmlData.toString() );			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.PLAY_SOUND, newSound );						// Add to sequence			this.eventSequence.push( newEventItem );		}				private function addMusic( xmlData : XML ) : void		{			TinyLogManager.log( 'addMusic', this );						// Make new event item			var newMusicCommand : TinyMusicCommand = TinyMusicCommand.newFromXML( xmlData );			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.PLAY_MUSIC, newMusicCommand );						// Add to sequence			this.eventSequence.push( newEventItem );		}			private function addFlagSet( xmlData : XML ) : void		{			// Get flag from xml			var newFlag : TinyEventFlag = TinyEventFlagData.getInstance().getFlagByName( xmlData );			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.SET_FLAG, newFlag );			TinyLogManager.log( 'addFlagSet: ' + newFlag.name, this );						// Add to sequence			this.eventSequence.push( newEventItem );		}				private function addPause( xmlData : XML ) : void		{			// Make new event item			var pauseTime : int = int( xmlData.toString() );			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.DELAY, pauseTime );						TinyLogManager.log( 'addPause: ' + pauseTime + ' frames', this ); 						// Add to sequence			this.eventSequence.push( newEventItem );		}				private function addHealAll() : void		{			TinyLogManager.log( 'addHealAll', this );						var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.HEAL_ALL, null );						// Add to sequence			this.eventSequence.push( newEventItem );		}				private function addWalk( xmlData : XML ) : void		{//			TinyLogManager.log('addWalk', this);//			//			// Make new walk command//			var newWalkCommand : TinyWalkCommand = TinyWalkCommand.newFromXML(xmlData);//			var isBattle : Boolean = (xmlData.child('BATTLE').toString() == 'TRUE');//			var newEventItem : TinyEventItem = new TinyEventItem(TinyEventItem.WALK, newWalkCommand, isBattle);//			//			// Add to sequence//			this.eventSequence.push(newEventItem);		}				private function addSetPosition( xmlData : XML ) : void		{//			TinyLogManager.log('addSetPosition', this);//			//			// Make new command//			var newCommand : TinySetPosCommand = TinySetPosCommand.newFromXML(xmlData);//			var newEventItem : TinyEventItem = new TinyEventItem(TinyEventItem.SET_POSITION, newCommand);//			//			// Add to sequence//			this.eventSequence.push(newEventItem);		}		private function addEnd() : void		{			TinyLogManager.log( 'addEnd', this );						// Make new event item			var newEventItem : TinyEventItem = new TinyEventItem( TinyEventItem.END, null );						// Add to sequence			this.eventSequence.push( newEventItem );		}				private function doNextCommand() : void		{			this.logWithDepth( 'doNextCommand' ); 						var nextEvent : TinyEventItem = this.eventSequence.shift();							switch ( nextEvent.type )			{//				case TinyEventItem.BATTLE:				this.doBattle( TinyBattle( nextEvent.thingToDo ) ); break;				case TinyEventItem.CONDITIONAL:			this.doCondition(TinyEventSequence( nextEvent.thingToDo ) ); break;				case TinyEventItem.DIALOG:				this.doDialog( TinyDialogBox( nextEvent.thingToDo ) ); break;				case TinyEventItem.ADD_NPC:				this.doAddNPC( nextEvent.thingToDo ); break;				case TinyEventItem.REMOVE_NPC:			this.doRemoveNPC( nextEvent.thingToDo ); break;				case TinyEventItem.SUB_SEQUENCE:		this.doSubSequence( nextEvent.thingToDo ); break;				case TinyEventItem.TAKE_GOLD:			this.doTakeGold( nextEvent.thingToDo ); break;				case TinyEventItem.PLAY_ANIM:			this.doAnimation( nextEvent.thingToDo ); break;				case TinyEventItem.PLAY_SOUND:			this.doSound( nextEvent.thingToDo ); break;				case TinyEventItem.PLAY_MUSIC:			this.doMusic( nextEvent.thingToDo ); break;				case TinyEventItem.SET_FLAG:			this.doSetFlag( TinyEventFlag( nextEvent.thingToDo ) ); break;				case TinyEventItem.WALK:				this.doWalk( nextEvent.thingToDo ); break;				case TinyEventItem.SET_POSITION:		this.doSetPosition( nextEvent.thingToDo ); break;				case TinyEventItem.DELAY:				this.doPause( nextEvent.thingToDo ); break;				case TinyEventItem.HEAL_ALL:			this.doHealAll(); break;				default: case TinyEventItem.END:		this.doEnd(); break;				case TinyEventItem.FINAL_END:			this.doFinalEnd(); break;			}		}		//		private function doBattle(battle : TinyBattle) : void//		{//			TinyLogManager.log('DEPTH: ' + this.eventDepth + ' doBattle', this);	//			//			// Start battle//			TinyInputManager.getInstance().setTarget(battle);//			this.currentBattle = battle;//			this.currentBattle.startBattle();//			this.currentBattle.addEventListener(Event.COMPLETE, onBattleComplete);//			//			this.addChild(currentBattle);//		}////		private function onBattleComplete(event : Event) : void //		{//			TinyLogManager.log('onBattleComplete', this);//			TinyInputManager.getInstance().setTarget(null);//			//			if (!this.currentBattle.finalBattle) { //				TweenLite.to(this.currentBattle, 15, { alpha:0, ease:SteppedEase.create(5), useFrames:true, onComplete:this.onBattleOutComplete });//				TinyFieldMap.checkWeirdThing();//			}//			//			// Next!//			this.doNextCommand();//		}//		//		private function onBattleOutComplete() : void//		{//			TinyLogManager.log('onBattleOutComplete', this);//			this.removeChild(currentBattle);//			this.currentBattle.removeEventListener(Event.COMPLETE, onBattleComplete);//			this.currentBattle = null;//		}		private function doCondition( sequence : TinyEventSequence ) : void		{			this.logWithDepth( 'doCondition: ' + sequence.conditionFlag + ', ' + sequence.conditionType );						// Check flag / item / gold / whatever			// TODO: Refactor			if ( false ) 			{//				 ( sequence.conditionType == TYPE_FLAG   && TinyEventFlagData.getInstance().getFlagStatusByName(sequence.conditionFlag)) || //				 ( sequence.conditionType == TYPE_ITEM   && TinyPlayer.getInstance().inventory.hasItemNamed(sequence.conditionItem)) || //				 ( sequence.conditionType == TYPE_GOLD   && TinyPlayer.getInstance().inventory.gold >= sequence.conditionGold) || //				 ( sequence.conditionType == TYPE_PLAYER && TinyPlayer.getInstance().playerName.toUpperCase() == sequence.conditionPlayer.toUpperCase()) ||//				(sequence.conditionFlag == '' && sequence.conditionItem == '' && sequence.conditionGold == 0 && sequence.conditionPlayer == '')) {//								this.logWithDepth( 'doCondition: CONDITION MET; STARTING SEQUENCE' );				this.doSubSequence( sequence );			}						// Otherwise, run the else sub-sequence if there is one 			else if ( sequence.elseSequence ) 			{				this.logWithDepth( 'doCondition: CONDITION NOT MET; STARTING ELSE SEQUENCE' );				this.doSubSequence( sequence.elseSequence );			}						// Otherwise just continue			else 			{				this.logWithDepth( 'doCondition: CONDITION NOT MET; STARTING NEXT COMMAND' );				this.doNextCommand();			}		}		private function onSequenceEnd( event : TinySequenceEvent ) : void 		{			this.logWithDepth( 'onSequenceEnd' );							// Clean up			this.removeEventListener( TinySequenceEvent.SEQUENCE_END, onSequenceEnd );			this.dispatchEvent ( new TinySequenceEvent( TinySequenceEvent.SEQUENCE_END ) );						// All done if we're at the top-most event level			if ( this.eventDepth == 0 ) 			{				this.logWithDepth( 'all sequences complete' );				this.dispatchEvent( new Event( Event.COMPLETE ) );			}		}				private function doSubSequence( sequence : TinyEventSequence ) : void		{			this.logWithDepth( 'doSubSequence' );						// Increase the event depth and start the sequence			sequence.eventDepth = this.eventDepth + 1;			sequence.startSequence();						this.addChild( sequence );						// Listen for various complete events			sequence.addEventListener( Event.COMPLETE, onSubSequenceComplete );			sequence.addEventListener( TinySequenceEvent.SEQUENCE_END, onSequenceEnd );			this.addEventListener( TinySequenceEvent.SEQUENCE_END, onSequenceEnd );		}				private function onSubSequenceComplete(event : Event) : void 		{			this.logWithDepth( 'onSubSequenceComplete' );						// Next!			this.doNextCommand();		}		private function doDialog( dialog : TinyDialogBox ) : void		{			this.logWithDepth( 'doDialog' );						// Add and start dialog			this.currentDialog = dialog;			this.currentDialog.x = 8;			this.currentDialog.y = 104;			this.currentDialog.show();			this.addChild( this.currentDialog );						// Pass control to the dialog			TinyInputManager.getInstance().setTarget( this.currentDialog );						// Wait for the dialog to be completed before continuing to the next item in the sequence						this.currentDialog.addEventListener( Event.COMPLETE, this.onDialogComplete );		}		private function onDialogComplete( event : Event ) : void 		{			this.logWithDepth( 'onDialogComplete' );						// Clean up			this.currentDialog.removeEventListener( Event.COMPLETE, onDialogComplete );			this.removeChild( this.currentDialog );			this.currentDialog = null;						// Remove control from the dialog			TinyInputManager.getInstance().setTarget( null );						// Next!			this.doNextCommand();		}			private function doAddNPC( npcCommand : TinyAddNPCCommand ) : void		{			this.logWithDepth( 'doAddNPC' );				// TODO: Implement						// Next!			this.doNextCommand();		}				private function doRemoveNPC( npcCommand : TinyAddNPCCommand ) : void		{			this.logWithDepth( 'doRemoveNPC' );						// TODO: Implement						// Next!			this.doNextCommand();		}				private function doTakeGold( itemCommand : TinyItemCommand ) : void		{			this.logWithDepth( 'doTakeGold: ' + itemCommand.gold );						// Take the gold//			TinyPlayer.getInstance().inventory.gold -= itemCommand.gold;						// Play sound//			TweenLite.delayedCall(9, TinyAudioManager.play, [TinyAudioManager.BUY], true);						// Next!//			TweenLite.delayedCall( 14, this.doNextCommand, null, true );			}		//		private function doGiveItem(item : TinyItem) : void//		{//			TinyLogManager.log('DEPTH: ' + this.eventDepth + ' doTakeGold: ' + item.name, this);//			//			var itemBox : TinyBattleItemGetBox = new TinyBattleItemGetBox(item, false);//			this.currentBox = itemBox;//			this.currentBox.x = 13; //			this.currentBox.y = 10;//			//			this.addChild(this.currentBox);//			this.currentBox.addEventListener(Event.COMPLETE, onGiveItemDone);//			TinyInputManager.getInstance().setTarget(this.currentBox);//			this.currentBox.show();//		}////		private function onGiveItemDone(event : Event) : void //		{//			TinyLogManager.log('onGiveItemDone', this);//					//			// Clean up//			this.currentBox.removeEventListener(Event.COMPLETE, onGiveItemDone);//			this.currentBox.hide();//			this.removeChild(this.currentBox);	//			//			// Next!//			this.doNextCommand();
//		}
		private function doAnimation( animCommand : TinyAnimCommand ) : void		{			this.logWithDepth( 'doAnimation' );						this.currentAnimCommand = animCommand;						this.currentAnimCommand.addEventListener( Event.COMPLETE, this.onAnimationComplete );			this.currentAnimCommand.execute();		}		private function onAnimationComplete( event : Event ) : void 		{			this.logWithDepth( 'onAnimComplete' );						// Clean up			this.currentAnimCommand.removeEventListener( Event.COMPLETE, this.onAnimationComplete );			this.currentAnimCommand = null;						// Next!			this.doNextCommand();		}		private function doSound( sound : Sound ) : void		{			this.logWithDepth( 'doSound' );						sound.play();						// Next!			this.doNextCommand();		}				private function doMusic( musicCommand : TinyMusicCommand ) : void		{			var songName : String = musicCommand.songName;						this.logWithDepth( 'doMusic: ' + songName );						// Handle various types of music playing			if ( songName == 'MAP' ) {				TinyAudioManager.getInstance().resumeMapMusic();			} else if ( musicCommand.interrupt ) {				TinyAudioManager.getInstance().playInterruptMusic( TinyAudioManager.getInstance().getMusicByName( songName ) );			} else {				TinyAudioManager.getInstance().setSong( TinyAudioManager.getInstance().getMusicByName( songName ), true );			}						// Next!						this.doNextCommand();		}
		private function doSetFlag( targetFlag : TinyEventFlag ) : void		{			this.logWithDepth( 'doSetFlag: ' + targetFlag.name );						// Set the flag			targetFlag.value = true;						// Next!			this.doNextCommand();		}				private function doPause( pauseTime : int ) : void		{			this.logWithDepth( 'doPause: ' + pauseTime + ' frames' );						// Do next command after a pause			TweenLite.delayedCall( pauseTime, this.doNextCommand, null, true );		}				private function doWalk( walkCommand : TinyWalkCommand ) : void		{			this.logWithDepth( 'doWalk' );						// Execute walk command			this.currentWalkCommand = walkCommand;			this.currentWalkCommand.addEventListener( Event.COMPLETE, onWalkComplete );			this.currentWalkCommand.execute();		}		private function onWalkComplete( event : Event ) : void 		{			this.logWithDepth( 'onWalkComplete' );						// Clean up			this.currentWalkCommand.removeEventListener( Event.COMPLETE, onWalkComplete );			this.currentWalkCommand = null;						// Next!			this.doNextCommand();		}				private function doSetPosition( command : TinySetPosCommand ) : void		{			this.logWithDepth( 'doSetPosition' );						// Execute command			command.execute();						// Next!			this.doNextCommand();		}				private function doHealAll() : void		{			this.logWithDepth( 'doHealAll' );						// TODO: Implement for dikemon party						// Next!			this.doNextCommand();		}		private function doEnd() : void		{			this.logWithDepth( 'doEnd' );						this.dispatchEvent( new Event( Event.COMPLETE ) );		}				private function doFinalEnd() : void		{			this.logWithDepth( 'doFinalEnd' );						this.dispatchEvent( new TinySequenceEvent( TinySequenceEvent.SEQUENCE_END ) );		}				private function logWithDepth( message : String ) : void		{			TinyLogManager.log( ' - depth ' + this.eventDepth + ' - ' + message, this );		}	}}