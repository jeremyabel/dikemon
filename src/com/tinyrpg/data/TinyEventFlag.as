package com.tinyrpg.data 
{
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * Class which represents a single event flag. 
	 * 
	 * Event flags are used to enable or disable various scripted events in the game.
	 * 
	 * @author jeremyabel
	 */
	public class TinyEventFlag 
	{
		public var name  	: String;
		private var m_value : Boolean = false;
		
		public function TinyEventFlag( name : String ) : void
		{
			TinyLogManager.log( 'new TinyEventFlag: ' + name, this );
			
			this.name = name;
			this.value = false;
		}
		
		/**
		 * Serializes the event flag state to a JSON object. 
		 * Used when creating game save data.
		 */
		public function toJSON() : Object
		{
			var jsonObject : Object = {};
			
			jsonObject.name = this.name;
			jsonObject.value = this.value;
			
			return jsonObject;
		}
		
		/**
		 * Function for setting the value of the flag. 
		 */
		public function setValue( value : Boolean ) : void
		{
			this.value = value;
		}
		
		/**
		 * Setter for the value of the flag.
		 */
		public function set value( value : Boolean ) : void
		{
			TinyLogManager.log( 'set ' + this.name + ' value: ' + value, this );
			this.m_value = value;
		}
		
		/**
		 * Returns the value of the flag.
		 */
		public function get value() : Boolean
		{
			return this.m_value;
		}
	}
}
 