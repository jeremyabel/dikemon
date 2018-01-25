package com.tinyrpg.debug 
{
	import com.tinyrpg.data.TinyAppSettings;
	import com.tinyrpg.data.TinyFieldMapObjectWarp;
	import com.tinyrpg.lookup.TinyMonLookup;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.misc.TinyCSS;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;

	/**
	 * @author jeremyabel
	 */
	public class TinyMapTester extends MovieClip
	{
		public function TinyMapTester() : void
		{
			var appSettings : TinyAppSettings = new TinyAppSettings( stage );
			var inputManager : TinyInputManager = TinyInputManager.getInstance();
			
			// Init font manager
			var tinyCSS : TinyCSS = new TinyCSS();
			TinyFontManager.initWithCSS( TinyCSS.cssString );
			
			var testWarpObject : TinyFieldMapObjectWarp = new TinyFieldMapObjectWarp();
			testWarpObject.targetMapName = 'Route29';
			testWarpObject.targetWarpName = 'warpTown1';
			testWarpObject.destinationFacing = 'LEFT';
			testWarpObject.stepForwardAfterWarp = true;
			
			TinyMonLookup.getInstance().initMonsterData();
			TinyGameManager.getInstance().initWithTestData();
			TinyGameManager.getInstance().gotoMap( testWarpObject );
			
			var scaleFactor : Number = stage.stageHeight / 144;
			TinyAppSettings.SCALE_FACTOR = scaleFactor;
			TinyGameManager.getInstance().scaleX *= scaleFactor;
			TinyGameManager.getInstance().scaleY *= scaleFactor;
			this.addChild( TinyGameManager.getInstance() );
			
		}
	}
}