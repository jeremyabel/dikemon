package com.tinyrpg.data 
{
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyEventFlag 
	{
		public var name  	: String;
		private var _value 	: Boolean = false;
		
		public function TinyEventFlag( name : String ) : void
		{
			TinyLogManager.log( 'new TinyEventFlag: ' + name, this );
			
			this.name = name;
			this.value = false;
		}
		
		public function setValue( value : Boolean ) : void
		{
			this.value = value;
		}
		
		public function set value( value : Boolean ) : void
		{
			TinyLogManager.log( 'set ' + this.name + ' value: ' + value, this );
			this._value = value;
		}
		
		public function get value() : Boolean
		{
			return this._value;
		}
	}
}
 