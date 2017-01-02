package com.tinyrpg.battle 
{
	

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleCommandPlayerVictory extends TinyBattleCommand 
	{
		public function TinyBattleCommandPlayerVictory( battle : TinyBattleMon )
		{
			super( battle, TinyBattleCommand.COMMAND_PLAYER_VICTORY, TinyBattleCommand.USER_PLAYER );
		}
	}
}
