package com.tinyrpg.core 
{
	import com.tinyrpg.display.TinyDamageNumbers;

	/**
	 * @author jeremyabel
	 */
	public interface ITinySprite 
	{
		// Functions
		function die() : int;
		function attack() : int;
		function hit(attackType : String = null) : int;
		function miss() : int;

		// Setters
		function set selected(value : Boolean) : void;
		function set autoSelected(value : Boolean) : void;
		function set active(value : Boolean) : void;
		function set x(value : Number) : void;
		function set y(value : Number) : void;
		function set idNumber(value : int) : void
		function set damageTime(value : uint) : void

		// Getters
		function get idNumber() : int;
		function get x() : Number;
		function get y() : Number;
		function get damageNumbers() : TinyDamageNumbers;
		function get damageTime() : uint;
	}
}
