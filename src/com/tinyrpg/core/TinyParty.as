package com.tinyrpg.core 
{
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyParty 
	{
		public var party : Array = [];
		
		public function TinyParty() : void
		{
		}
		
		public function getCharByID(targetID : int) : TinyStatsEntity
		{
			// Find function
			var findFunction : Function = function(item : *, index : int, array : Array) : Boolean
				{ index; array; return (TinyStatsEntity(item).idNumber == targetID); };
			
			// Search for character
			return this.party.filter(findFunction)[0];
		}
		
		public function getCharByName(targetName : String) : TinyStatsEntity
		{
			TinyLogManager.log('getCharByName: ' + targetName, this);
			
			// Find function
			var findFunction : Function = function(item : *, index : int, array : Array) : Boolean
			{ 	
				index; array;
				return (TinyStatsEntity(item).name.toUpperCase() == targetName.toUpperCase()); 
			};
			
			// Search for character
			var returnChar : TinyStatsEntity = this.party.filter(findFunction)[0];
			
			// Fix for weird save character name thing
			if (!returnChar && targetName.toUpperCase() == 'FISHABEL') {
				targetName = 'JEREMY';
				returnChar = this.party.filter(findFunction)[0];
			}
			
			return returnChar;
		}
			
		public function addMember(character : TinyStatsEntity) : void
		{
			character.idNumber = this.party.length;
			TinyLogManager.log('addMember: ' + character.name + ', id: ' + character.idNumber, this);
			this.party.push(character);
		}
		
		public function get length() : uint
		{
			return party.length;
		}
		
		public function get lengthAlive() : uint
		{
			var length : uint = 0;
			for each (var character : TinyStatsEntity in this.party)
				if (!character.dead) length++;
			
			TinyLogManager.log('get lengthAlive: ' + length, this);	
			return length;
		}
		
		public function get lengthRecruited() : uint
		{
			var recruitedLength : uint = 0;
			for each (var character : TinyStatsEntity in this.party)
				if (character.recruited) recruitedLength++;
						TinyLogManager.log('get lengthRecruited: ' + recruitedLength, this);	
			return recruitedLength;
		}
		
		public function get aliveParty() : Array
		{
			var aliveParty : Array = [];
			
			for each (var character : TinyStatsEntity in this.party)
				if (!character.dead)
					aliveParty.push(character);
					
			return aliveParty;
		}
	}
}
