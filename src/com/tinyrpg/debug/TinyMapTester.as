package com.tinyrpg.debug 
{
	import com.tinyrpg.data.TinyAppSettings;
	import com.tinyrpg.data.TinyPlayerSpriteState;
	import com.tinyrpg.data.TinyFieldMapObjectWarp;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.misc.TinyCSS;
	import com.tinyrpg.core.TinyFieldMap;
	import com.tinyrpg.display.TinyWalkSprite;
	import com.tinyrpg.misc.TinySpriteConfig;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.utils.ByteArray;

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
			testWarpObject.targetMapName = 'IslandCaveEntrance';
			testWarpObject.targetWarpName = 'warpCenter';
			testWarpObject.destinationFacing = 'DOWN';
			testWarpObject.stepForwardAfterWarp = true;
			
			TinyMapManager.getInstance().warp( testWarpObject );
			
			var scaleFactor : Number = stage.stageHeight / 144;
			TinyAppSettings.SCALE_FACTOR = scaleFactor;
			TinyMapManager.getInstance().scaleX *= scaleFactor;
			TinyMapManager.getInstance().scaleY *= scaleFactor;
			this.addChild( TinyMapManager.getInstance() );
		}
	}
}