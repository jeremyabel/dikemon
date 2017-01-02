package com.tinyrpg.utils
{
	public class TinyLogManager
	{
		static public var status : int = LogType.INFO;
		static public var showTimestamp : Boolean = true;

		/**
		 * Sends a message to the logging device
		 * 
		 * @param	str	Message to be displayed
		 * @param	sender	Reference to the Object sending the message
		 * @param	type	Message type
		 */
		static public function log(str : String, sender : Object, type : int = 0) : void
		{
			// Do nothing if status is restrictive
			if(type < status) return;
	    	
			var log_str : String = '';
			
			// Log message, Part 1: Timestamp?
			if(showTimestamp) {
				log_str += DateFormatter.format("[m/d-h:i:s] ");
			}
			
			// Log message, Part 2: Sender
			log_str += Object(sender).toString();
			
			// Log message, Part 3: Message
			log_str += " -> " + str;
			
			// Display message in Output window
			trace(log_str);
		}
	}
}