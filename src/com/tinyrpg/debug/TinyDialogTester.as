package com.tinyrpg.debug 
{
	import com.tinyrpg.data.TinyAppSettings;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.misc.TinyCSS;
	import com.tinyrpg.ui.TinyDialogBox;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.utils.ByteArray;

	/**
	 * @author jeremyabel
	 */
	public class TinyDialogTester extends MovieClip
	{
	 	[Embed(source='../../../../bin/xml/Characters.xml', mimeType='application/octet-stream')]
		public static const Character_Test : Class;
		[Embed(source='../../../../bin/xml/Enemies.xml', mimeType='application/octet-stream')]
		public static const Enemy_Test : Class;
		[Embed(source='../../../../bin/xml/Items.xml', mimeType='application/octet-stream')]
		public static const Item_Test : Class;
		[Embed(source='../../../../bin/xml/Dialog.xml', mimeType='application/octet-stream')]
		public static const Dialog_Test : Class;
		
		public function TinyDialogTester() : void
		{
			var appSettings : TinyAppSettings = new TinyAppSettings(stage);
			var inputManager : TinyInputManager = TinyInputManager.getInstance();
			
			// Init font manager
			var tinyCSS : TinyCSS = new TinyCSS();
			TinyFontManager.initWithCSS(TinyCSS.cssString);
			
			// Get dialog XML data
			var byteArray : ByteArray = (new TinyDialogTester.Dialog_Test()) as ByteArray;
			var string : String = byteArray.readUTFBytes(byteArray.length);
			var dialogXMLData : XML = new XML(string);

			// Make new dialog box
			for each (var dialogData : XML in dialogXMLData.children()) 
			{
				var dialogTest : TinyDialogBox = TinyDialogBox.newFromXML(dialogData);
				
				inputManager.setTarget(dialogTest);
				
				// Rescale and position
				var scaleFactor : Number = stage.stageHeight / 144;
				dialogTest.scaleX *= scaleFactor;
				dialogTest.scaleY *= scaleFactor;
				dialogTest.x = int((stage.stageWidth / 2) - (dialogTest.width / 2)) + (5 * scaleFactor);
				dialogTest.y = 103 * scaleFactor;
				dialogTest.show();
				this.addChild(dialogTest);
			}			
		}
	}
}