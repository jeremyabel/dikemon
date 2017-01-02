package com.tinyrpg.data 
{

	/**
	 * @author jeremyabel
	 */
	public class TinySpecialAttackData 
	{
		// -S- = Single Target	S-A = Single Ally	S-E = Single Enemy
		// -A- = All Targets	A-A = All Allies	A-E = All Enemies
		// -C- = Caster
		
		public static var SINGLE_TARGET : String = "S";
		public static var ALL_TARGET	: String = "A";
		public static var TARGET_ENEMY	: String = "E";
		public static var TARGET_ALLY	: String = "A";
		public static var TARGET_CASTER	: String = "C";
		
		public var effectivity 	: int;
		public var accuracy 	: int;
		public var target		: String;
		
		public function TinySpecialAttackData(effectivity : int, accuracy : int, target : String) : void
		{
			this.effectivity = effectivity;
			this.accuracy = accuracy;
			this.target = target;
		}
	}
}
