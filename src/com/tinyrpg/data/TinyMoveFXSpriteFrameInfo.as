package com.tinyrpg.data 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyMoveFXSpriteFrameInfo 
	{	
		public var sourceX : int;
		public var sourceY : int;
		public var sourceW : int;
		public var sourceH : int;
		public var origX : int;
		public var origY : int;
		public var origW : int;
		public var origH : int;
		
		public var copyRect : Rectangle;
		public var destPoint : Point;
		
		public static function newFromXML( xml : XML ) : TinyMoveFXSpriteFrameInfo
		{
			var newFrameInfo : TinyMoveFXSpriteFrameInfo = new TinyMoveFXSpriteFrameInfo();
			
			newFrameInfo.sourceX = int( xml.@x );
			newFrameInfo.sourceY = int( xml.@y );
			newFrameInfo.sourceW = int( xml.@w );
			newFrameInfo.sourceH = int( xml.@h );
			newFrameInfo.origX = int( xml.@oX );
			newFrameInfo.origY = int( xml.@oY );
			newFrameInfo.origW = int( xml.@oW );
			newFrameInfo.origH = int( xml.@oH );
			
			newFrameInfo.copyRect = new Rectangle( newFrameInfo.sourceX, newFrameInfo.sourceY, newFrameInfo.sourceW, newFrameInfo.sourceH );
			newFrameInfo.destPoint = new Point( newFrameInfo.origX, newFrameInfo.origY );
			
			return newFrameInfo;
		}
		
		public function toString() : String
		{
			var str : String = '';
			str += 'x: ' + this.sourceX + ' ';
			str += 'y: ' + this.sourceY + ' ';
			str += 'w: ' + this.sourceW + ' ';
			str += 'h: ' + this.sourceH;
			return str;
		}
	}
}
