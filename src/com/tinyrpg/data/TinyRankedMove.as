package com.tinyrpg.data
{
	import com.tinyrpg.utils.TinyLogManager;
	
	/**
	 * Class which represents a move being ranked for consideration by the {@link TinyTrainerAI} class.
	 *  
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

		/**
		 * Reduces the rank if the move is status only. Used by Basic AI.
		 */
		public function adjustIfStatusOnly() : void 
		{
			if ( this.move.getStatusEffects().length > 0 && this.move.getDamageEffects().length == 0 ) 
			{
				TinyLogManager.log( 'adjustIfStatusOnly: ' + this.move.name + ' is status-only, rank - 5', this );
				this.rank -= 5;
			}
		}
		
		/**
		 * Increases the rank of the move is stat_mod. Used by Advanced AI.
		 */
		public function adjustIfStatMod() : void
		{
			if ( this.move.getStatModEffects().length > 0 ) 
			{
				TinyLogManager.log( 'adjustIfStatMod: ' + this.move.name + ' has stat_mod, rank + 1', this );
				this.rank += 1;
			}
		}
		
		/**
		 * Adjusts the rank of the move based on how effective it is. Used by Good AI.
		 */
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