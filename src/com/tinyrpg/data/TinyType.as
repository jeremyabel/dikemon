package com.tinyrpg.data 
{

	/**
	 * Class which represents a "type", an elemental property given to moves and mons.
	 * 
	 * Types are used to determine effectiveness of a move versus a mon.
	 * 
	 * @author jeremyabel
	 */
	public class TinyType 
	{  
		private static const NAME_NORMAL 	: String = "normal";
		private static const NAME_FIRE		: String = "fire";
		private static const NAME_WATER		: String = "water";
		private static const NAME_ELECTRIC 	: String = "electric";
		private static const NAME_GRASS		: String = "grass";
		private static const NAME_ICE		: String = "ice";
		private static const NAME_FIGHTING	: String = "fighting";
		private static const NAME_POISON	: String = "poison";
		private static const NAME_GROUND	: String = "ground";
		private static const NAME_FLYING	: String = "flying";
		private static const NAME_PSYCHIC	: String = "psychic";
		private static const NAME_BUG		: String = "bug";
		private static const NAME_ROCK		: String = "rock";
		private static const NAME_GHOST		: String = "ghost";
		private static const NAME_DRAGON	: String = "dragon";
		private static const NAME_DARK		: String = "dark";
		private static const NAME_STEEL		: String = "steel";
		
		public static const NORMAL 		: TinyType = new TinyType(1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 0.0, 1.0, 1.0, 0.5, NAME_NORMAL);
		public static const FIRE 		: TinyType = new TinyType(1.0, 0.5, 0.5, 1.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 0.5, 1.0, 0.5, 1.0, 2.0, NAME_FIRE);
		public static const WATER		: TinyType = new TinyType(1.0, 2.0, 0.5, 1.0, 0.5, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 2.0, 1.0, 0.5, 1.0, 1.0, NAME_WATER);
		public static const ELECTRIC	: TinyType = new TinyType(1.0, 1.0, 2.0, 0.5, 0.5, 1.0, 1.0, 1.0, 0.0, 2.0, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, NAME_ELECTRIC);
		public static const GRASS		: TinyType = new TinyType(1.0, 0.5, 2.0, 1.0, 0.5, 1.0, 1.0, 0.5, 2.0, 0.5, 1.0, 0.5, 2.0, 1.0, 0.5, 1.0, 0.5, NAME_GRASS);
		public static const ICE			: TinyType = new TinyType(1.0, 0.5, 0.5, 1.0, 2.0, 0.5, 1.0, 1.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 0.5, NAME_ICE);
		public static const FIGHTING	: TinyType = new TinyType(2.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 0.5, 1.0, 0.5, 0.5, 0.5, 2.0, 0.0, 1.0, 2.0, 2.0, NAME_FIGHTING);
		public static const POISON		: TinyType = new TinyType(1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 0.5, 0.5, 1.0, 1.0, 1.0, 0.5, 0.5, 1.0, 1.0, 0.0, NAME_POISON);
		public static const GROUND		: TinyType = new TinyType(1.0, 2.0, 1.0, 2.0, 0.5, 1.0, 1.0, 2.0, 1.0, 0.0, 1.0, 0.5, 2.0, 1.0, 1.0, 1.0, 2.0, NAME_GROUND);
		public static const FLYING		: TinyType = new TinyType(1.0, 1.0, 1.0, 0.5, 2.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 2.0, 0.5, 1.0, 1.0, 1.0, 0.5, NAME_FLYING);
		public static const PSYCHIC		: TinyType = new TinyType(1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 0.0, 0.5, NAME_PSYCHIC);
		public static const BUG			: TinyType = new TinyType(1.0, 0.5, 1.0, 1.0, 2.0, 1.0, 0.5, 0.5, 1.0, 0.5, 2.0, 1.0, 1.0, 0.5, 1.0, 2.0, 0.5, NAME_BUG);
		public static const ROCK		: TinyType = new TinyType(1.0, 2.0, 1.0, 1.0, 1.0, 2.0, 0.5, 1.0, 0.5, 2.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 0.5, NAME_ROCK);
		public static const GHOST		: TinyType = new TinyType(0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 2.0, 1.0, 0.5, 1.0, NAME_GHOST);
		public static const DRAGON		: TinyType = new TinyType(1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 0.5, NAME_DRAGON);
		public static const DARK		: TinyType = new TinyType(1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 2.0, 1.0, 0.5, 1.0, NAME_DARK);
		public static const STEEL		: TinyType = new TinyType(1.0, 0.5, 0.5, 0.5, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 0.5, NAME_STEEL);
				
		private var vsNormal 	: Number;
		private var vsFire 		: Number;
		private var vsWater		: Number;
		private var vsElectric 	: Number;
		private var vsGrass		: Number;
		private var vsIce		: Number;
		private var vsFighting 	: Number;
		private var vsPoison	: Number;
		private var vsGround	: Number;
		private var vsFlying	: Number;
		private var vsPsychic	: Number;
		private var vsBug		: Number;
		private var vsRock		: Number;
		private var vsGhost		: Number;
		private var vsDragon	: Number;
		private var vsDark		: Number;
		private var vsSteel		: Number;

		public var name : String;
		
		public function TinyType(
			vsNormal 	: Number,
 			vsFire 		: Number,
 			vsWater		: Number,
 			vsElectric 	: Number,
 			vsGrass		: Number,
 			vsIce		: Number,
 			vsFighting 	: Number,
 			vsPoison	: Number,
 			vsGround	: Number,
 			vsFlying	: Number,
 			vsPsychic	: Number,
 			vsBug		: Number,
 			vsRock		: Number,
 			vsGhost		: Number,
 			vsDragon	: Number,
 			vsDark		: Number,
 			vsSteel		: Number,
 			name		: String)
 		{
 			this.vsNormal 	= vsNormal;
			this.vsFire 	= vsFire;
			this.vsWater 	= vsWater;
			this.vsElectric = vsElectric;
			this.vsGrass 	= vsGrass;
			this.vsIce 		= vsIce;
			this.vsFighting = vsFighting;
			this.vsPoison 	= vsPoison;
			this.vsGround 	= vsGround;
			this.vsFlying 	= vsFlying;
			this.vsPsychic 	= vsPsychic;
			this.vsBug 		= vsBug;
			this.vsRock 	= vsRock;
			this.vsGhost 	= vsGhost;
			this.vsDragon 	= vsDragon;
			this.vsDark		= vsDark;
			this.vsSteel 	= vsSteel;
			
			this.name = name;
 		}
 		
 		/**
 		 * Returns a TinyType object which matches a given string name.
 		 * If the provided name is not a valid type, the Normal type is returned.
 		 */
 		public static function getTypeFromString(input : String) : TinyType
 		{
 			var typeString : String = input.toLowerCase();
 			
 			switch (typeString)
 			{
 				case NAME_NORMAL: 	return TinyType.NORMAL;
				case NAME_FIRE: 	return TinyType.FIRE;
				case NAME_WATER:	return TinyType.WATER;
				case NAME_ELECTRIC:	return TinyType.ELECTRIC;
				case NAME_GRASS:	return TinyType.GRASS;	
				case NAME_ICE:		return TinyType.ICE;
				case NAME_FIGHTING:	return TinyType.FIGHTING;
				case NAME_POISON:	return TinyType.POISON;
				case NAME_GROUND:	return TinyType.GROUND;
				case NAME_FLYING:	return TinyType.FLYING;
				case NAME_PSYCHIC:	return TinyType.PSYCHIC;
				case NAME_BUG:		return TinyType.BUG;
				case NAME_ROCK:		return TinyType.ROCK;
				case NAME_GHOST:	return TinyType.GHOST;
				case NAME_DRAGON:	return TinyType.DRAGON;
				case NAME_DARK:		return TinyType.DARK;
				case NAME_STEEL:	return TinyType.STEEL;
				default:			return TinyType.NORMAL;
			}
		}
		
		/**
		 * Returns the matchup value for this type versus a given target type.
		 */
		public function getMatchupValueVersus( targetType : TinyType ) : Number
		{
			switch (targetType.name)
			{
				case NAME_NORMAL: 	return this.vsNormal;
				case NAME_FIRE: 	return this.vsFire;
				case NAME_WATER:	return this.vsWater;
				case NAME_ELECTRIC:	return this.vsElectric;
				case NAME_GRASS:	return this.vsGrass;	
				case NAME_ICE:		return this.vsIce;
				case NAME_FIGHTING:	return this.vsFighting;
				case NAME_POISON:	return this.vsPoison;
				case NAME_GROUND:	return this.vsGround;
				case NAME_FLYING:	return this.vsFlying;
				case NAME_PSYCHIC:	return this.vsPsychic;
				case NAME_BUG:		return this.vsBug;
				case NAME_ROCK:		return this.vsRock;
				case NAME_GHOST:	return this.vsGhost;
				case NAME_DRAGON:	return this.vsDragon;
				case NAME_DARK:		return this.vsDark;
				case NAME_STEEL:	return this.vsSteel;
				default:			return 1.0;
			}
			
			return 1.0;
		}
		
		/**
		 * Returns true if the type is physial, otherwise false.
		 */
		public function get isPhysical() : Boolean
		{
			switch (this.name)
			{
				case NAME_NORMAL: 	return true;
				case NAME_FIRE: 	return false;
				case NAME_WATER:	return false;
				case NAME_ELECTRIC:	return false;
				case NAME_GRASS:	return false;	
				case NAME_ICE:		return false;
				case NAME_FIGHTING:	return true;
				case NAME_POISON:	return true;
				case NAME_GROUND:	return true;
				case NAME_FLYING:	return true;
				case NAME_PSYCHIC:	return false;
				case NAME_BUG:		return true;
				case NAME_ROCK:		return true;
				case NAME_GHOST:	return true;
				case NAME_DRAGON:	return false;
				case NAME_DARK:		return false;
				case NAME_STEEL:	return true;
				default:			return true;
			}
		}
	}
}
