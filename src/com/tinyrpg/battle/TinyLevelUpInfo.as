package com.tinyrpg.battle 
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.data.TinyStatSet;
	import com.tinyrpg.utils.TinyMath;

	/**
	 * @author jeremyabel
	 */
	public class TinyLevelUpInfo 
	{
		public var mon : TinyMon;
		public var nextLevel : int;
		public var initialLevel : int;
		public var numLevelsGained : int;
		public var initialStatSet : TinyStatSet;
		public var updatedStatSets : Array = [];
		public var newMoves : Array = [];
		
		public function TinyLevelUpInfo( mon : TinyMon, nextLevel : int )
		{
			this.mon = mon;
			this.nextLevel = nextLevel;
			this.initialLevel = TinyMath.deepCopyInt( this.mon.level ); 
			this.numLevelsGained = this.nextLevel - this.initialLevel;
			
			// Create a copy of the initial unlevelup'd stat set. This is used to compare against the new stat set
			// when generating the updated stats dialog box
			this.initialStatSet = new TinyStatSet( 
				this.mon.getMaxHP( this.initialLevel ), 
				this.mon.getAttack( this.initialLevel ),
				this.mon.getDefense( this.initialLevel ),
				this.mon.getSpAttack( this.initialLevel ),
				this.mon.getSpDefense( this.initialLevel ),
				this.mon.getSpeed( this.initialLevel )
			);
			
			// Generate updated stat sets
			for ( var i : int = 1; i <= this.numLevelsGained; i++ )
			{
				this.updatedStatSets.push( new TinyStatSet(
					this.mon.getMaxHP( this.initialLevel + i ), 
					this.mon.getAttack( this.initialLevel + i ),
					this.mon.getDefense( this.initialLevel + i ),
					this.mon.getSpAttack( this.initialLevel + i ),
					this.mon.getSpDefense( this.initialLevel + i ),
					this.mon.getSpeed( this.initialLevel + i )
				) );
			}
			
			// Get any new moves learned during this level up
			for ( var j : int = this.initialLevel + 1; j <= this.nextLevel; j++ )
			{
				var newMovesForLevel : Array = this.mon.moveSet.getLearnedMovesAtLevel( j );
				this.newMoves.push( newMovesForLevel );
			}			
		}
	}
}
