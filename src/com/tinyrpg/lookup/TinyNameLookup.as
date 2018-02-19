package com.tinyrpg.lookup
{
	import com.tinyrpg.utils.TinyLogManager;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyNameLookup 
	{
		public static function getRivalNameForPlayerName( playerName : String ) : String
		{
			TinyLogManager.log( 'getRivalNameForPlayerName: ' + playerName, TinyNameLookup );
	
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
		
		public static function getStarterNameForPlayerName( playerName : String ) : String
		{
			TinyLogManager.log( 'getStarterNameForPlayerName: ' + playerName, TinyNameLookup );
	
			switch ( playerName.toUpperCase() )
			{
				case 'ANDY': 	return 'Clegg';
				case 'BILL':	return 'Alex';
				case 'CHRIS':	return 'Dave';
				case 'DAVE':	return 'Chris';
				case 'EVAN':	return 'Maruska';
				case 'JASON':	return 'Kristi';
				case 'MEGAN':	return 'Maruska';
				case 'RACHEL':	return 'Gagnon';
				case 'RALPH':	return 'Stark';
				case 'RON':		return 'Yulia';
				case 'QUINN':	return 'Ziggy';
				default: 		return 'Chris';
			}
		}
	}
}
