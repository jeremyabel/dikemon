package com.tinyrpg.utils 
{
	import flash.geom.Point;
	import flash.utils.ByteArray;

	/**
	 * @author jeremyabel
	 */
	public class TinyMath 
	{
		public static function random(minValue : Number = 0, maxValue : Number = 1) : Number
		{
			return minValue + (Math.random() * (maxValue - minValue));
		}
		
		public static function randomInt(minValue : Number = 0, maxValue : Number = 100) : int
		{
			return Math.floor(TinyMath.random(minValue, maxValue));	
		}
		
		public static function weightedRandomChoice( choiceWeights : Array ) : int
		{
			var table : Array = [];
			
			for (var i : int = 0; i < choiceWeights.length; i++ )
			{
				for (var j : int = 0; j < choiceWeights[ i ] * 100; j++)
				{
					table.push(i);		
				}
			}
			
			return table[ randomInt() ];
		}

		public static function normalize(value : Number, min : Number, max : Number) : Number
		{
			return (value - min) / (max - min);
		}

		public static function interpolate(normValue : Number, min : Number, max : Number) : Number 
		{
			return min + (max - min) * normValue;
		}

		public static function map(value : Number, min1 : Number, max1 : Number, min2 : Number, max2 : Number) : Number 
		{
			return interpolate(normalize(value, min1, max1), min2, max2);	
		}
		
		public static function mapClamped(value : Number, min1 : Number, max1 : Number, min2 : Number, max2 : Number) : Number
		{
			return clamp(map(value, min1, max1, min2, max2), min2, max2);
		}

		public static function clamp(value : Number, min : Number, max : Number) : Number
		{
			return Math.max(min, Math.min(max, value));
		}

		public static function deg2rad(degrees : Number) : Number
		{
			return degrees * (Math.PI / 180);
		}

		public static function rad2deg(radians : Number) : Number
		{
			return radians * (180 / Math.PI);
		}

		public static function dotProduct(v1 : Point, v2 : Point) : Number 
		{ 
			return v1.x * v2.x + v1.y * v2.y; 
		}
		
		public static function deepCopyInt(source : *) : int
		{
			var copier : ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return int(copier.readObject());
		}
		
		public static function deepCopyString(source : *) : String
		{
			var copier : ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return String(copier.readObject());
		}
		
		public static function arrayShuffle(arr : Array) : Array
		{
			var len:int = arr.length;
			var arr2:Array = new Array(len);
			for(var i:int = 0; i<len; i++)
			{
				arr2[i] = arr.splice(int(Math.random() * (len - i)), 1)[0];
			}
			return arr2;
		}
	}
}
