package com.tinyrpg.data
{
	import com.tinyrpg.utils.TinyLogManager;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyRankedMove 
	{
		public var move : TinyMoveData;
		public var rank : int;
		
		public function TinyRankedMove( move : TinyMoveData )
		{
			this.move = move;
			this.rank = 10;
		}
		
		public function adjustIfStatusOnly() : void 
		{
			if ( this.move.getStatusEffects().length > 0 && this.move.getDamageEffects().length == 0 ) 
			{
				TinyLogManager.log( 'adjustIfStatusOnly: ' + this.move.name + ' is status-only, rank - 5', this );
				this.rank -= 5;
			}
		}
		
		public function adjustIfStatMod() : void
		{
			if ( this.move.getStatModEffects().length > 0 ) 
			{
				TinyLogManager.log( 'adjustIfStatMod: ' + this.move.name + ' has stat_mod, rank + 1', this );
				this.rank += 1;
			}
		}
		
		public function adjustIfEffectiveVs( types : Array ) : void
		{
			if ( this.move.isSuperEffectiveVs( types ) ) 
			{
				TinyLogManager.log( 'adjustIfEffectiveVs: ' + this.move.name + ' is effective, rank + 1', this );
				this.rank += 1;
			} 
			else if ( this.move.isNotEffectiveVs( types ) ) 
			{
				TinyLogManager.log( 'adjustIfEffectiveVs: ' + this.move.name + ' is not effective, rank - 1', this );
				this.rank -= 1;
			}
		}
	}
}