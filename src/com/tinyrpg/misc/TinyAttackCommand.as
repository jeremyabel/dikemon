package com.tinyrpg.misc 
{

	/**
	 * @author jeremyabel
	 */
	public class TinyAttackCommand 
	{
		public var attacker : String;
		public var defender : String;
		public var damage	: int;
		
		public function TinyAttackCommand() : void
		{
			
		}
		
		public static function newFromXML(xmlData : XML) : TinyAttackCommand
		{
			var newAttackCommand : TinyAttackCommand = new TinyAttackCommand;
			
			newAttackCommand.attacker = xmlData.child('ATTACKER').toString();
			newAttackCommand.defender = xmlData.child('DEFENDER').toString();
			newAttackCommand.damage = int(xmlData.child('DAMAGE').toString());
			
			return newAttackCommand;		
		}
	}
}
