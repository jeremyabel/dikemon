package com.tinyrpg.utils
{
	/**
	 * @author Oscar Trelles
	 * @version 0.1
	 * @created 18-Mar-2008 3:27:42 PM
	 */
	public class DateFormatter
	{
		static private const days:Array 		= new Array("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun");
		static private const days_long:Array 	= new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
		static private const months:Array 		= new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
		static private const months_long:Array	= new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
		static private const months_days:Array 	= new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
		
		public function DateFormatter()
		{
		}
		
		/**
		 * Provides date formatting functionality comparable PHP's 'date' function.
		 * 
		 * Usage: Pass a formatting String and a Date object to obtain a formatted Date string.
		 * 
		 * Example: trace(DateFormatter.format("Y-m-d", new Date(2008, 3, 18))); // "2008-03-18"
		 * 
		 * From PHP's Manual:
		 * 
		 * Day
		 * d  	Day of the month, 2 digits with leading zeros  	01 to 31
		 * D 	A textual representation of a day, three letters 	Mon through Sun
		 * j 	Day of the month without leading zeros 	1 to 31
		 * l 	A full textual representation of the day of the week 	Sunday through Saturday
		 * N 	ISO-8601 numeric representation of the day of the week (added in PHP 5.1.0) 	1 (for Monday) through 7 (for Sunday)
		 * S 	English ordinal suffix for the day of the month, 2 characters 	st, nd, rd or th. Works well with j
		 * w 	Numeric representation of the day of the week 	0 (for Sunday) through 6 (for Saturday)
		 * z 	The day of the year (starting from 0) 	0 through 365
		 * 
		 * Week
		 * W 	ISO-8601 week number of year, weeks starting on Monday (added in PHP 4.1.0) 	Example: 42 (the 42nd week in the year)
		 * 
		 * Month 
		 * F 	A full textual representation of a month, such as January or March 	January through December
		 * m 	Numeric representation of a month, with leading zeros 	01 through 12
		 * M 	A short textual representation of a month, three letters 	Jan through Dec
		 * n 	Numeric representation of a month, without leading zeros 	1 through 12
		 * t 	Number of days in the given month 	28 through 31
		 * 
		 * Year
		 * L 	Whether it's a leap year 	1 if it is a leap year, 0 otherwise.
		 * o 	ISO-8601 year number. This has the same value as Y, except that if the ISO week number (W) belongs to the previous or next year, that year is used instead. (added in PHP 5.1.0) 	Examples: 1999 or 2003
		 * Y 	A full numeric representation of a year, 4 digits 	Examples: 1999 or 2003
		 * y 	A two digit representation of a year 	Examples: 99 or 03
		 * 
		 * Time 
		 * a 	Lowercase Ante meridiem and Post meridiem 	am or pm
		 * A 	Uppercase Ante meridiem and Post meridiem 	AM or PM
		 * B 	Swatch Internet time 	000 through 999
		 * g 	12-hour format of an hour without leading zeros 	1 through 12
		 * G 	24-hour format of an hour without leading zeros 	0 through 23
		 * h 	12-hour format of an hour with leading zeros 	01 through 12
		 * H 	24-hour format of an hour with leading zeros 	00 through 23
		 * i 	Minutes with leading zeros 	00 to 59
		 * s 	Seconds, with leading zeros 	00 through 59
		 * u 	Milliseconds (added in PHP 5.2.2) 	Example: 54321
		 * 
		 * ---
		 * Timezone (not implemented)
		 * e 	Timezone identifier (added in PHP 5.1.0) 	Examples: UTC, GMT, Atlantic/Azores
		 * I 	Whether or not the date is in daylight saving time 	1 if Daylight Saving Time, 0 otherwise.
		 * O 	Difference to Greenwich time (GMT) in hours 	Example: +0200
		 * P 	Difference to Greenwich time (GMT) with colon between hours and minutes (added in PHP 5.1.3) 	Example: +02:00
		 * T 	Timezone abbreviation 	Examples: EST, MDT ...
		 * Z 	Timezone offset in seconds. The offset for timezones west of UTC is always negative, and for those east of UTC is always positive. 	-43200 through 50400
		 * Full Date/Time (not implemented)
		 * c 	ISO 8601 date (added in PHP 5) 	2004-02-12T15:19:21+00:00
		 * r 	» RFC 2822 formatted date 	Example: Thu, 21 Dec 2000 16:01:07 +0200
		 * U 	Seconds since the Unix Epoch (January 1 1970 00:00:00 GMT)
		 * 
		 * @returns	String
		 * @param	str	Matching expression 
		 * @param	date	Date object (optional). Default value is now.
		 */
		static public function format(str:String=null, date:Date=null):String
		{
			// Default value for formatting string
			if(str==null)	str = "";
			
			// Default value for date
			if(date==null)	date = new Date();
			
			// String to return
			var formatted_str:String = "";
			
			for(var i:int=0; i<str.length; i++)
			{
				formatted_str += getElement(str.charAt(i), date);
			}
			
			return formatted_str;
			//return date.toDateString();
		}
		
		/**
		 * 
		 */
		static private function getElement(character:String, date:Date):String
		{
			switch(character)
			{
				// Day of the month, 2 digits with leading zeros
				case "d":
					return addZeros(int(date.getDate()));
					
				// A textual representation of a day, three letters
				case "D":
					return DateFormatter.days[date.getDay()];
					
				// Day of the month without leading zeros 	1 to 31
				case "j":
					return String(date.getDate());
					
				// A full textual representation of the day of the week
				case "l":
					trace(date.getDay());
					return days_long[date.getDay()];
					
				// ISO-8601 numeric representation of the day of the week (added in PHP 5.1.0)
				case "N":
					return String(date.getDay()+1);
				
				// English ordinal suffix for the day of the month, 2 characters
				case "S":
					var r:int = date.getDate()%10;
					switch(r)
					{
						case 1:
							return "st";
							
						case 2:
							return "nd";
							
						case 3:
							return "rd";
							
						default:
							return "th";
					}
				
				// Numeric representation of the day of the week
				case "w":
					return String(date.getDay());
					
				// The day of the year (starting from 0)
				case "z":
					return String(dayNumber(date));
				
				// ISO-8601 week number of year, weeks starting on Monday
				case "W":
					return String(Math.ceil(dayNumber(date)/7));
					
				// A full textual representation of a month, such as January or March
				case "F":
					return months_long[date.getMonth()];
					
				// Numeric representation of a month, with leading zeros
				case "m":
					return addZeros(date.getMonth()+1);
				
				// A short textual representation of a month, three letters
				case "M":
					return months[date.getMonth()];
					
				// Numeric representation of a month, without leading zeros
				case "n":
					return String(date.getMonth()+1);
					
				// Number of days in the given month
				case "t":
					var days:int = months_days[date.getMonth()];
					return String((days<30 && isLeapYear(date)) ? 29 : days);
					
				// Whether it's a leap year
				case "L":
					return (isLeapYear(date)) ? "1" : "0";
					
				// ISO-8601 year number. This has the same value as Y, except that if the ISO week number (W) belongs to the previous or next year, that year is used instead. (added in PHP 5.1.0) 	Examples: 1999 or 2003
				case "o":
					var w:Number = dayNumber(date)/7;
					if(w<1)
						return String(date.getFullYear()-1);
					if(w>52)
						return String(date.getFullYear()+1);
					return String(date.getFullYear());
				
				// A full numeric representation of a year, 4 digits
				case "Y":
					return String(date.getFullYear());
					
				// A two digit representation of a year
				case "y":
					return addZeros(date.getFullYear()%100);
				
				// Lowercase Ante meridiem and Post meridiem
				case "a":
					return (date.getHours()>11) ? "pm" : "am";
					
				// Uppercase Ante meridiem and Post meridiem
				case "A":
					return (date.getHours()>11) ? "PM" : "AM";
					
				// Swatch Internet time
				case "B":
					var s:int = (date.getHours()+1)*60*60;
					s += date.getMinutes()*60;
					s += date.getSeconds();
					return String(Math.floor(s/86.4));
					
				// 12-hour format of an hour without leading zeros
				case "g":
					return String((date.getHours()%12)+1);
					
				// 24-hour format of an hour without leading zeros
				case "G":
					return String(date.getHours());
					
				// 12-hour format of an hour with leading zeros
				case "h":
					return addZeros((date.getHours()%12)+1);
					
				// 24-hour format of an hour with leading zeros
				case "H":
					return addZeros(date.getHours());
					
				// Minutes with leading zeros
				case "i":
					return addZeros(date.getMinutes());
				
				// Seconds, with leading zeros
				case "s":
					return addZeros(date.getSeconds());
				
				// Milliseconds (added in PHP 5.2.2)
				case "u":
					return addZeros(date.getMilliseconds());
				
				// The orignal character
				default:
					return character;
			}
		}
		
		static public function addZeros(n : int) : String
		{
			if(n < 10)
				return "0" + String(n);
				
			return String(n);
		}
		
		/**
		 * Returns a Boolean, indicating whether the year in the Date 
		 * object is a leap year or not
		 * 
		 * @param	date	Date object
		 */
		static private function isLeapYear(date:Date):Boolean
		{
			if(date.getFullYear()%4==0)	return true;
			
			return false;
		}
		
		/**
		 * Returns the day number relative to the year. Takes account 
		 * of leap years.
		 * 
		 * @param	date	Date object
		 */
		static private function dayNumber(date:Date):int
		{
			var n:int = 0;
			var m:int = date.getMonth();
			
			for(var i:int=0; i<m; i++)
			{
				var days:int = months_days[i];
				n += (days<30 && isLeapYear(date)) ? 29 : days;
			}
			
			n += date.getDate();
			
			return n;
		}

	}
}