﻿package com.tinyrpg.misc {	import com.tinyrpg.core.TinyFriendSprite;	import com.tinyrpg.core.TinyPlayer;	import com.tinyrpg.core.TinyStatsEntity;	import flash.geom.Point;	/**	 * @author jeremyabel	 */	public class TinyAddNPCCommand 	{		public var _location  : Point;		public var battleName : String =  '';		public var battle	  : Boolean;		public var facing	  : String = 'DOWN';		public var specLocation : Boolean = false;				public function TinyAddNPCCommand() : void		{					}				public static function newFromXML(xmlData : XML) : TinyAddNPCCommand		{			var newNPCCommand : TinyAddNPCCommand = new TinyAddNPCCommand;						// For battle?			newNPCCommand.battle = (xmlData.child('BATTLE').toString() == 'TRUE');			newNPCCommand.battleName = xmlData.child('NAME').toString();						// Set facing			newNPCCommand.facing = xmlData.child('FACING').toString();			if (newNPCCommand.facing == 'DYNAMIC') {				switch (TinyFriendSprite(TinyStatsEntity(TinyPlayer.getInstance().fullParty.party[0]).graphics).facing)				{					case 'UP':					case 'DOWN':						newNPCCommand.facing = 'LEFT';						break;					case 'LEFT':					case 'RIGHT':						newNPCCommand.facing = 'DOWN';						break;					}			} else {				newNPCCommand.facing = (newNPCCommand.facing == '' ? 'DOWN' : newNPCCommand.facing);			} 						// Get location			newNPCCommand._location = new Point;			if (xmlData.child('LOCATION').toString() == 'PLAYER') {				newNPCCommand._location.x = TinyStatsEntity(TinyPlayer.getInstance().fullParty.party[0]).graphics.x;				newNPCCommand._location.y = TinyStatsEntity(TinyPlayer.getInstance().fullParty.party[0]).graphics.y;				newNPCCommand.specLocation = false;			} else {				var posArray : Array = xmlData.child('LOCATION').toString().split(',');				newNPCCommand._location.x = int(posArray[0]);				newNPCCommand._location.y = int(posArray[1]);				newNPCCommand.specLocation = true;			}						return newNPCCommand;		}				public function get location() : Point		{			if (this.specLocation) {				return this._location;			} else {				var playerPos : Point = new Point();				playerPos.x = TinyStatsEntity(TinyPlayer.getInstance().fullParty.party[0]).graphics.x;				playerPos.y = TinyStatsEntity(TinyPlayer.getInstance().fullParty.party[0]).graphics.y;				trace('ATJDAKJADG:KG');				return playerPos;			}		}	}}