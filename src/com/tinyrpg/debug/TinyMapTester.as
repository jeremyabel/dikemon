package com.tinyrpg.debug 
{
	import com.tinyrpg.core.TinyPlayer;
	import com.tinyrpg.data.TinyAppSettings;
	import com.tinyrpg.data.TinyFieldMapObjectWarp;
	import com.tinyrpg.lookup.TinyEventFlagLookup;
	import com.tinyrpg.lookup.TinyMonLookup;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.misc.TinyCSS;
	import com.tinyrpg.sequence.TinyWarpCommand;

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
	
			TinyEventFlagLookup.getInstance().getFlagByName( 'finished_intro_cutscene' ).value = true;
			TinyPlayer.getInstance().usedRepel = true;
			
			var testWarpObject : TinyFieldMapObjectWarp = new TinyFieldMapObjectWarp();
			testWarpObject.targetMapName = 'Route29';
			testWarpObject.targetWarpName = 'warpTown1';
			testWarpObject.destinationFacing = 'LEFT';
			testWarpObject.stepForwardAfterWarp = true;
			
//			var testWarpCommand : TinyWarpCommand = new TinyWarpCommand();
//			testWarpCommand.preFadeSequenceName = 'intro_prefade_debug';
//			TinyMapManager.getInstance().warpCommandInProgress = testWarpCommand;
			
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