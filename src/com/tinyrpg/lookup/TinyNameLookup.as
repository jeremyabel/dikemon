package com.tinyrpg.lookup
{
	/**
	 * @author jeremyabel
	 */
	public class TinyNameLookup 
	{
		public static function getRivalNameForPlayerName( playerName : String ) : String
		{
			switch ( playerName.toUpperCase() )
			{
				case 'ANDY': 	return 'Rachel';
				case 'BILL':	return 'Chris';
				case 'CHRIS':	return 'Bill';
				case 'DAVE':	return 'Jason';
				case 'EVAN':	return 'Chris';
				case 'JASON':	return 'Dave';
				case 'MEGAN':	return 'Quinn';
				case 'RACHEL':	return 'Andy';
				case 'RALPH':	return 'Jason';
				case 'RON':		return 'Brenton';
				case 'QUINN':	return 'Megan';
				default: 		return 'Chris';
			}
		}
		
		public static function getStarterMonForPlayerName( playerName : String ) : String
		{
			return '';
		}
	}
}
