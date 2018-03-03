package com.tinyrpg.sequence
{
	import com.tinyrpg.battle.TinyBattle;
	import com.tinyrpg.managers.TinyGameManager;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyStartBattleCommand 
	{
		public function TinyStartBattleCommand() : void
		{
				
		}
		
		public static function newFromXML( xmlData : XML ) : TinyStartBattleCommand
		{
			var newCommand : TinyStartBattleCommand = new TinyStartBattleCommand();
			return newCommand;	
		}
	}	
}
