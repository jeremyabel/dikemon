package com.tinyrpg.battle 
{
	import com.tinyrpg.utils.TinyFourColorPalette;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattlePalette 
	{
		public var playerMon 	: TinyFourColorPalette;
		public var enemyMon 	: TinyFourColorPalette;
		public var playerStats	: TinyFourColorPalette;
		public var enemyStats 	: TinyFourColorPalette;
		
		public function TinyBattlePalette( 
			playerMon : TinyFourColorPalette,
			enemyMon : TinyFourColorPalette,
			playerStats : TinyFourColorPalette,
			enemyStats : TinyFourColorPalette ) 
		{
			this.playerMon 	 = playerMon;
			this.enemyMon 	 = enemyMon;
			this.playerStats = playerStats;
			this.enemyStats  = enemyStats;		
		}
		
		public function toString() : String
		{
			return '\nplayerMon: \n' + this.playerMon.toString() + ' \n \n' + 
			'enemyMon: \n' + this.enemyMon.toString() + ' \n \n' + 
			'playerStats: \n' + this.playerStats.toString() + ' \n \n' + 
			'enemyStats: \n' + this.enemyStats.toString() + ' \n \n'; 
		}
	}
}
