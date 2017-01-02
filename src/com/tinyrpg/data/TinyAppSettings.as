package com.tinyrpg.data 
{
	import flash.display.Stage;

	/**
	 * @author jeremyabel
	 */
	public class TinyAppSettings 
	{
		public static var STAGE_REF 			: Stage;
		public static var STAGE_WIDTH 			: int 	 = 160;
		public static var STAGE_HEIGHT 			: int 	 = 144;
		public static var STAGE_RESIZE_FACTOR	: Number = 4; 
		public static var SCALE_FACTOR			: Number;
		
		public function TinyAppSettings(stageRef : Stage) : void
		{
			TinyAppSettings.STAGE_REF = stageRef;
		}
	}
}
