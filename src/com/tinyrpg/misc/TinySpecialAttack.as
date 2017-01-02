package com.tinyrpg.misc 
{
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinySpecialAttack 
	{
		public var type : String;
		public var text : String;
		public var attackAnim : String;
		
		public function TinySpecialAttack() : void
		{
			
		}
		
		public static function newFromXML(xmlData : XMLList) : TinySpecialAttack
		{
			TinyLogManager.log('newFromXML', TinySpecialAttack);
			
			var newSpecialAttack : TinySpecialAttack = new TinySpecialAttack;
			newSpecialAttack.type = xmlData.child('TYPE').toString();
			newSpecialAttack.text = xmlData.child('TEXT').toString(); 
			newSpecialAttack.attackAnim = xmlData.child('ATTACK_TYPE').toString();
			
			return newSpecialAttack;
		}
	}
}
