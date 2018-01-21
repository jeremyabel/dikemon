﻿package com.tinyrpg.core {		import com.coreyoneil.collision.CollisionGroup;		import com.tinyrpg.core.TinyMon;	import com.tinyrpg.data.TinyCollisionData;	import com.tinyrpg.data.TinyWildEncounterData;	import com.tinyrpg.display.TinyMapMovieClip;	import com.tinyrpg.events.TinyFieldMapEvent;	import com.tinyrpg.lookup.TinyMapLookup;	import com.tinyrpg.managers.TinyMapManager;	import com.tinyrpg.utils.TinyLogManager;	import com.tinyrpg.utils.TinyMath;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.DisplayObject;	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;	/**	 * @author jeremyabel	 */	public class TinyFieldMap extends Sprite 	{		public static const COLLISION_TYPE_WALLS	: String = 'WALLS';		public static const COLLISION_TYPE_OBJECTS	: String = 'OBJECTS';		public static const COLLISION_TYPE_GRASS 	: String = 'GRASS';		public static const COLLISION_TYPE_JUMPS	: String = 'JUMPS';		public static const COLLISION_TYPE_DISABLE	: String = 'DISABLE'; 				public var mapName						: String;		public var mapUserObjects				: Sprite;		public var startingEventName			: String;		public var encounterRate				: int;		public var encounterData				: TinyWildEncounterData;		public var usedRepel					: Boolean = false;						private var mapMovieClip				: TinyMapMovieClip;		private var currentEventSequence		: TinyEventSequence;		private var eventXML 					: XML;		private var mapObjects					: MovieClip;		private var mapBase						: MovieClip;		private var mapHit						: MovieClip;		private var mapMiscCollisionContainer 	: Sprite;		private var collisionWalls 				: CollisionGroup;		private var collisionGrass				: CollisionGroup;		private var collisionJumps				: CollisionGroup;				private var collisionObjects			: CollisionGroup;		private var collisionDisable			: CollisionGroup;		public function TinyFieldMap( mapName : String ) : void		{			this.mapName = mapName;			this.encounterRate = TinyMapLookup.getEncounterRateForName( this.mapName );			this.encounterData = TinyMapLookup.getEncounterDataForName( this.mapName );						this.mapMovieClip = TinyMapLookup.getMapFromName( this.mapName );			this.mapBase = this.mapMovieClip.map;			this.mapHit = this.mapMovieClip.hit;			this.mapHit.visible = false;						this.mapObjects = this.mapMovieClip.objects;			this.mapUserObjects = new Sprite();			this.mapMiscCollisionContainer = new Sprite();			this.mapMiscCollisionContainer.visible = false;						// Collision groups			this.collisionWalls = new CollisionGroup( this.mapHit );			this.collisionGrass = new CollisionGroup();			this.collisionJumps = new CollisionGroup();			this.collisionObjects = new CollisionGroup();			this.collisionDisable = new CollisionGroup();						// Add each map object to the objects collision group			for ( var i : uint = 0; i < this.mapObjects.numChildren; i++ )			{				var mapObject : DisplayObject = this.mapObjects.getChildAt( i );				this.addToCollisionGroup( mapObject, COLLISION_TYPE_OBJECTS );			}						// Add optional map layers to their cooresponding collision groups if they exist			if ( this.mapMovieClip.hasGrass ) { this.mapMiscCollisionContainer.addChild( this.mapMovieClip.grass ); this.addToCollisionGroup( this.mapMovieClip.grass, COLLISION_TYPE_GRASS ); }			if ( this.mapMovieClip.hasJumpU ) { this.mapMiscCollisionContainer.addChild( this.mapMovieClip.jumpU ); this.addToCollisionGroup( this.mapMovieClip.jumpU, COLLISION_TYPE_JUMPS ); }			if ( this.mapMovieClip.hasJumpD ) { this.mapMiscCollisionContainer.addChild( this.mapMovieClip.jumpD ); this.addToCollisionGroup( this.mapMovieClip.jumpD, COLLISION_TYPE_JUMPS ); }			if ( this.mapMovieClip.hasJumpL ) { this.mapMiscCollisionContainer.addChild( this.mapMovieClip.jumpL ); this.addToCollisionGroup( this.mapMovieClip.jumpL, COLLISION_TYPE_JUMPS ); }			if ( this.mapMovieClip.hasJumpR ) { this.mapMiscCollisionContainer.addChild( this.mapMovieClip.jumpR ); this.addToCollisionGroup( this.mapMovieClip.jumpR, COLLISION_TYPE_JUMPS ); }			if ( this.mapMovieClip.hasDisableU ) { this.mapMiscCollisionContainer.addChild( this.mapMovieClip.disableU ); this.addToCollisionGroup( this.mapMovieClip.disableU, COLLISION_TYPE_DISABLE ); }						// Get event sequence XML data			this.eventXML = TinyMapLookup.getMapEventXMLFromName( mapName );						// Add 'em up			this.addChild( this.mapBase );			this.addChild( this.mapHit );			this.addChild( this.mapObjects );			this.addChild( this.mapMiscCollisionContainer );			this.addChild( this.mapUserObjects );		}				public function addToCollisionGroup( object : DisplayObject, type : String = COLLISION_TYPE_WALLS ) : void		{			switch ( type ) 			{				default:				case COLLISION_TYPE_WALLS:		this.collisionWalls.addItem( object ); break;				case COLLISION_TYPE_GRASS:		this.collisionGrass.addItem( object ); break;				case COLLISION_TYPE_JUMPS:		this.collisionJumps.addItem( object ); break;				case COLLISION_TYPE_OBJECTS:	this.collisionObjects.addItem( object ); break;				case COLLISION_TYPE_DISABLE:	this.collisionDisable.addItem( object ); break;			}		}				public function checkWallCollision( object : DisplayObject ) : TinyCollisionData		{				return this.collisionWalls.checkCollision( object );		}				public function checkGrassCollision( object : DisplayObject ) : TinyCollisionData 		{			return this.collisionGrass.checkCollision( object );		}				public function checkJumpCollision( object : DisplayObject ) : TinyCollisionData 		{			return this.collisionJumps.checkCollision( object );		}				public function checkObjectCollision( object : DisplayObject ) : TinyCollisionData		{				return this.collisionObjects.checkCollision( object );		}				public function checkDisableCollision( object : DisplayObject ) : TinyCollisionData 		{			return this.collisionDisable.checkCollision( object );		}				public function getMapObjectByName( objectName : String ) : DisplayObject		{			return this.mapObjects.getChildByName( objectName );		}						public function tryWildEncounter() : TinyMon		{			if ( this.usedRepel ) return null;						if ( TinyMath.randomInt( 0, 255 ) < this.encounterRate )			{				return this.encounterData.getEncounterMon();						}						return null;		}		public function startEventByName( eventName : String ) : void		{			TinyLogManager.log( 'startEventByName: ' + eventName, this );						// Create and start the new event sequence			this.currentEventSequence = TinyEventSequence.newFromEventName( this.eventXML, eventName );			this.currentEventSequence.addEventListener( Event.COMPLETE, this.onEventSequenceComplete );			this.currentEventSequence.startSequence();						// Add the sequence to the map manager's event container sprite			TinyMapManager.getInstance().mapEventContainer.addChild( this.currentEventSequence );		}		private function onEventSequenceComplete( event : Event ) : void 		{			TinyLogManager.log( 'onEventSequenceComplete', this );						// Remove the sequence from the map manager's event container sprite			TinyMapManager.getInstance().mapEventContainer.removeChild( this.currentEventSequence );						// Clean up			this.currentEventSequence.removeEventListener( Event.COMPLETE, this.onEventSequenceComplete );			this.currentEventSequence = null;						// Alert the map manager that the event is complete			this.dispatchEvent( new TinyFieldMapEvent( TinyFieldMapEvent.EVENT_COMPLETE ) );		}//		public static function getNPCSpriteByName(targetName : String) : TinyFriendSprite//		{//			TinyLogManager.log('getNPCSpriteByName: ' + targetName, TinyFieldMap);//			//			// Find function//			var findFunction : Function = function(item : *, index : int, array : Array) : Boolean//				{ index; array; return (TinyFriendSprite(item).charName.toUpperCase() == targetName.toUpperCase()); };//			//			// Search for character//			return TinyFieldMap.npcArray.filter(findFunction)[0];//		}			}}