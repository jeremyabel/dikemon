package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author jeremyabel
	 */
	public class TinyContentBox extends Sprite 
	{
		public var content : DisplayObject;
		public var containerBox : Sprite; 
		
		public function TinyContentBox(content : DisplayObject, width : uint = 0, height : uint = 0, opaque : Boolean = false)
		{
			this.content = content;
			this.containerBox = new Sprite;
			
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
			sideRight	 = new Bitmap(new ModalBoxSideLR);
			
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
			this.containerBox.addChild(cornerUpRight);
			this.containerBox.addChild(sideBottom);
			this.addChild(this.containerBox);
			if (content) this.addChild(content);
		}
	}
}