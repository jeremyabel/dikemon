package com.tinyrpg.data 
{

	/**
	 * @author jeremyabel
	 */
	public class TinyExpGrowthRate 
	{
		public static const ERATIC : String = "E"; 
		public static const FAST : String = "F";
		public static const MEDIUM_FAST : String = "MF";
		public static const MEDIUM_SLOW : String = "MS";
		public static const SLOW : String = "S";
		
		public var levelTable : Array = [];
		public var growthRate : String;
		
		public function TinyExpGrowthRate( growthRateString : String )
		{
			this.growthRate = growthRateString;
			
			// Make level table
			for ( var i : int = 0; i < 100; i++ ) 
			{
				levelTable.push( TinyExpGrowthRate.getExpForLevelAtGrowth( i, this.growthRate ) );
			}
		}
		
		public function getLevelForExpValue( exp : int ) : int 
		{
			var i : int = 0;
			while ( i < 100 )
			{
				if ( this.levelTable[ i ] > exp ) return i;
				i++;
			}
			
			return 100;
		}
		
		public static function getExpForLevelAtGrowth( level : int, growthRate : String ) : int
		{
			var L : int = level;
			var exp : int = 1;
			
			switch (growthRate)
			{
				case TinyExpGrowthRate.ERATIC:
					var N : int = L % 3 == 0 ? 1501 : 1500;
					if (L <= 50) { exp = L * L * L * (100 - L) / 50;  break; }
					if (L <= 68) { exp = L * L * L * (150 - L) / 100; break; }
					if (L <= 97) { exp = L * L * L * (N + (10 * (L - 68) / 3) - (L * 10)) / 1000; break; }
					exp = L * L * L * (160 - L) / 100; 
					break;
					
				case TinyExpGrowthRate.FAST:
					exp = L * L * L * 4 / 5;
					break;
				
			 	case TinyExpGrowthRate.MEDIUM_FAST:
			 		exp = L * L * L;
			 		break;	
				
				case TinyExpGrowthRate.MEDIUM_SLOW:
					exp = (L * L * L * 6 / 5) - 15 * L * L + 100 * L - 140;
					break;	
				
				case TinyExpGrowthRate.SLOW:
					exp = L * L * L * 5 / 4;
					break;
				
				default:
					exp = L * L * L;
					break;
			}
			
			return Math.max(1, Math.floor(exp));
		}
	}
}
