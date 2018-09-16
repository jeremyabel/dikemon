package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * Base display class for a simple box with a 9-slice border.
	 * 
	 * @author jeremyabel
	 */
	public class TinyContentBox extends Sprite 
	{
		public var content : DisplayObject;
		public var containerBox : Sprite;
		
		protected var boxWidth : uint;
		protected var boxHeight : uint; 
		
		/**
		 * @param	content			An optional DisplayObject which is added to the box.
		 * @param	width			The width of the box, in pixels.
		 * @param	height  		The height of the box, in pixels.
		 * @param	centerContent	Whether or not the content object is centered in the box.
		 */
		public function TinyContentBox( content : DisplayObject, width : uint = 0, height : uint = 0, centerContent : Boolean = false )
		{
			this.content = content;
			this.containerBox = new Sprite;
			
			this.boxWidth = width;
			this.boxHeight = height;
			
			if ( centerContent ) 
			{
				this.content.x = ( this.boxWidth / 2 ) - ( this.content.width / 2 );
				this.content.y = ( this.boxHeight / 2 ) - ( this.content.height / 2 );
			}
			
			var cornerUpLeft 	: DisplayObject;
			var cornerUpRight	: DisplayObject;
			var cornerDnLeft	: DisplayObject;
			var cornerDnRight	: DisplayObject;
			var sideLeft		: DisplayObject;
			var sideRight		: DisplayObject;
			var sideTop			: DisplayObject;
			var sideBottom		: DisplayObject;
			
			// Corners
			cornerUpLeft  = new Bitmap(new ModalBoxCornerT);
			cornerUpRight = new Bitmap(new ModalBoxCornerT);
			cornerDnLeft  = new Bitmap(new ModalBoxCornerB);
			cornerDnRight = new Bitmap(new ModalBoxCornerB);
				
			// Sides
			sideLeft	 = new Bitmap(new ModalBoxSideLR);
			sideRight	 = new Bitmap(new ModalBoxSideLR);			sideTop		 = new Bitmap(new ModalBoxSideT);			sideBottom	 = new Bitmap(new ModalBoxSideB);
			
			// Center
			var centerFill : Sprite = new Sprite();
			centerFill.graphics.beginFill(0xFFFFFF);
			centerFill.graphics.drawRect(0, 0, width, height);
			centerFill.graphics.endFill();
			
			// Up Left
			cornerUpLeft.x -= cornerUpLeft.width;
			cornerUpLeft.y -= cornerUpLeft.height;
			
			// Up Right
			cornerUpRight.scaleX = -1;
			cornerUpRight.x = width + cornerUpRight.width;
			cornerUpRight.y -= cornerUpRight.height;
			
			// Down Left
			cornerDnLeft.x -= cornerDnLeft.width;
			cornerDnLeft.y = height;
			
			// Down Right
			cornerDnRight.scaleX = -1;
			cornerDnRight.x = cornerUpRight.x;
			cornerDnRight.y = cornerDnLeft.y;		
			
			// Side Top
			sideTop.width = width;
			sideTop.y -= sideTop.height;
			
			// Side Bottom
			sideBottom.width = width;
			sideBottom.y = height;
			
			// Side Left
			sideLeft.scaleY = height;
			sideLeft.x -= sideLeft.width;
			
			// Side Right
			sideRight.scaleX = -1;
			sideRight.scaleY = height;
			sideRight.x = width + sideRight.width;
			
			// Add 'em up
			this.containerBox.addChild(cornerUpLeft);
			this.containerBox.addChild(cornerUpRight);			this.containerBox.addChild(cornerDnLeft);			this.containerBox.addChild(cornerDnRight);			this.containerBox.addChild(sideTop);
			this.containerBox.addChild(sideBottom);			this.containerBox.addChild(sideLeft);			this.containerBox.addChild(sideRight);			this.containerBox.addChild(centerFill);
			this.addChild(this.containerBox);
			if (content) this.addChild(content);
		}
	}
}
