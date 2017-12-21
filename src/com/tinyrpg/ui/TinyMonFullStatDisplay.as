package com.tinyrpg.ui
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.display.TinyContentBox;
	import com.tinyrpg.display.TinyMonContainer;
	import com.tinyrpg.display.TinyStatsDisplay;
	import com.tinyrpg.display.TinyMoveStatDisplay;
	import com.tinyrpg.display.TinyBattleMonStatDisplay;
	import com.tinyrpg.display.TinyModalPageArrow;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyInputManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyMonFullStatDisplay extends TinyContentBox
	{
		private var mon : TinyMon;
		
		private var statsPage1Container : Sprite;
		private var statsPage2Container : Sprite;
		private var isShowingPage2 : Boolean = false;
		
		// Static Top Elements
		private var monContainer : TinyMonContainer;
		private var battleStatsDisplay : TinyBattleMonStatDisplay; 
		private var nextLevelLabel : TextField;
		private var nextLevelValue : TextField;
		private var styleLabel : TextField;
		private var styleValue : TextField;
		
		// Page 1 Elements
		private var fullStatsDisplay : TinyStatsDisplay;
		private var type1Label : TextField;
		private var type1Value : TextField;
		private var type2Label : TextField;
		private var type2Value : TextField;
		private var weightLabel : TextField;
		private var weightValue : TextField;
		private var page1Arrow : TinyModalPageArrow;
		
		// Page 2 Elements
		private var movesLabel : TextField;
		private var ppLabel : TextField;
		private var moveStatDisplay : TinyMoveStatDisplay;
		private var page2Arrow : TinyModalPageArrow;
		
		public function TinyMonFullStatDisplay()
		{
			super( null, 144, 130, true );	
			
			// Create new mon container with an empty dummy bitmap
			this.monContainer = new TinyMonContainer( new Bitmap( new BitmapData( 1, 1 ) ), true );
			this.monContainer.y = 2;
			
			// Create basic stats display
			this.battleStatsDisplay = new TinyBattleMonStatDisplay( false );
			this.battleStatsDisplay.x = 62;
			this.battleStatsDisplay.y = -3;
			this.battleStatsDisplay.show();
			
			this.nextLevelLabel = TinyFontManager.returnTextField();
			this.nextLevelLabel.x = this.battleStatsDisplay.x - 2;
			this.nextLevelLabel.y = this.battleStatsDisplay.y + 38;
			this.nextLevelLabel.htmlText = TinyFontManager.returnHtmlText( 'NEXT LV:', 'battleBoxTitle');
			
			this.nextLevelValue = TinyFontManager.returnTextField();
			this.nextLevelValue.x = this.nextLevelLabel.x + 41;
			this.nextLevelValue.y = this.nextLevelLabel.y + 1;
			
			this.styleLabel = TinyFontManager.returnTextField();
			this.styleLabel.x = this.nextLevelLabel.x;
			this.styleLabel.y = this.nextLevelLabel.y + 7;
			this.styleLabel.htmlText = TinyFontManager.returnHtmlText( 'STYLE:', 'battleBoxTitle');
			
			this.styleValue = TinyFontManager.returnTextField('none');
			this.styleValue.width = 81;
			this.styleValue.x = this.styleLabel.x;
			this.styleValue.y = this.styleLabel.y + 6;
			
			// Create full stats display
			this.fullStatsDisplay = new TinyStatsDisplay();
			this.fullStatsDisplay.y = 141 - this.fullStatsDisplay.height;
			this.fullStatsDisplay.show();
			
			this.type1Label = TinyFontManager.returnTextField();
			this.type1Label.x = this.fullStatsDisplay.width - 3;
			this.type1Label.y = this.fullStatsDisplay.y - 10;
			this.type1Label.htmlText = TinyFontManager.returnHtmlText( 'TYPE 1:', 'battleBoxTitle');
			
			this.type1Value = TinyFontManager.returnTextField();
			this.type1Value.x = this.type1Label.x;
			this.type1Value.y = this.type1Label.y + 6;
			
			this.type2Label = TinyFontManager.returnTextField();
			this.type2Label.x = this.type1Label.x
			this.type2Label.y = this.type1Value.y + 16;
			this.type2Label.htmlText = TinyFontManager.returnHtmlText( 'TYPE 2:', 'battleBoxTitle');
			
			this.type2Value = TinyFontManager.returnTextField();
			this.type2Value.x = this.type2Label.x;
			this.type2Value.y = this.type2Label.y + 6;
			
			this.weightLabel = TinyFontManager.returnTextField();
			this.weightLabel.x = this.type2Label.x
			this.weightLabel.y = this.type2Value.y + 16;
			this.weightLabel.htmlText = TinyFontManager.returnHtmlText( 'WEIGHT:', 'battleBoxTitle');
			
			this.weightValue = TinyFontManager.returnTextField();
			this.weightValue.x = this.weightLabel.x;
			this.weightValue.y = this.weightLabel.y + 6;
			
			this.page1Arrow = new TinyModalPageArrow();
			this.page1Arrow.x = this.weightLabel.x + 53;
			this.page1Arrow.y = this.weightValue.y + 11;
			
			this.movesLabel = TinyFontManager.returnTextField();
			this.movesLabel.y = this.fullStatsDisplay.y - 10;
			this.movesLabel.htmlText = TinyFontManager.returnHtmlText( 'MOVES:', 'battleBoxTitle');
			
			this.ppLabel = TinyFontManager.returnTextField();
			this.ppLabel.x = 102;
			this.ppLabel.y = this.movesLabel.y;
			this.ppLabel.htmlText = TinyFontManager.returnHtmlText( 'PP:', 'battleBoxTitle' );
			
			this.moveStatDisplay = new TinyMoveStatDisplay();
			this.moveStatDisplay.x = 1;
			this.moveStatDisplay.y = this.movesLabel.y + 7;
			
			this.page2Arrow = new TinyModalPageArrow();
			this.page2Arrow.x = 2;
			this.page2Arrow.y = this.weightValue.y + 11;
			this.page2Arrow.scaleX = -1;
			
			// Create page containers
			this.statsPage1Container = new Sprite();
			this.statsPage2Container = new Sprite();
			
			// Add 'em up - page 1
			this.statsPage1Container.addChild( this.fullStatsDisplay );
			this.statsPage1Container.addChild( this.type1Label );
			this.statsPage1Container.addChild( this.type1Value );
			this.statsPage1Container.addChild( this.type2Label );
			this.statsPage1Container.addChild( this.type2Value );
			this.statsPage1Container.addChild( this.weightLabel );
			this.statsPage1Container.addChild( this.weightValue );
			this.statsPage1Container.addChild( this.page1Arrow );
			
			// Add 'em up - page 2
			this.statsPage2Container.addChild( this.moveStatDisplay );
			this.statsPage2Container.addChild( this.movesLabel );
			this.statsPage2Container.addChild( this.ppLabel );
			this.statsPage2Container.addChild( this.page2Arrow );
			
			// Add 'em up - static top
			this.addChild( this.monContainer );
			this.addChild( this.battleStatsDisplay );
			this.addChild( this.statsPage1Container );
			this.addChild( this.statsPage2Container );
			this.addChild( this.nextLevelLabel );
			this.addChild( this.nextLevelValue );
			this.addChild( this.styleLabel );
			this.addChild( this.styleValue );
			
			// Add events
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}
		
		public function set currentMon( mon : TinyMon ) : void
		{
			this.mon = mon;
			TinyLogManager.log('setCurrentMon: ' + this.mon.name, this);
			
			// Update mon bitmap container
			this.monContainer.setMonBitmap( this.mon.bitmap );
			this.monContainer.show();
			
			// Update basic stats display
			this.battleStatsDisplay.setCurrentMon( this.mon );
			
			// Update full stats display
			this.fullStatsDisplay.setCurrentMon( this.mon );
			
			// Calculate EXP until next level
			var expValue : int = this.mon.getEXPForNextLevel() - this.mon.currentEXP;
			
			// Update text values
			this.nextLevelValue.htmlText = TinyFontManager.returnHtmlText( expValue.toString(), 'battleItemText' );
			this.styleValue.htmlText = TinyFontManager.returnHtmlText( this.mon.style.toUpperCase(), 'dialogText', 'right' );
			this.type1Value.htmlText = TinyFontManager.returnHtmlText( this.mon.type1.name.toUpperCase(), 'dialogText' );
			this.type2Value.htmlText = TinyFontManager.returnHtmlText( this.mon.type2.name.toUpperCase(), 'dialogText' );
			this.weightValue.htmlText = TinyFontManager.returnHtmlText( this.mon.weight + 'kg', 'dialogText' );
			
			// Update moves list
			this.moveStatDisplay.setMoveSet( this.mon.moveSet );
		}

		public function show() : void
		{
			TinyLogManager.log("show", this);	
			this.visible = true;
			
			// Show first page
			this.isShowingPage2 = false;
			this.statsPage1Container.visible = true;
			this.statsPage2Container.visible = false;
		}
		
		public function hide() : void
		{
			TinyLogManager.log("hide", this);
			this.visible = false;	
		}
		
		protected function onControlAdded(event : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlAdded', this);

			// Add events
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ARROW_LEFT, togglePage);
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ARROW_RIGHT, togglePage);
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.ACCEPT, onClose);
			TinyInputManager.getInstance().addEventListener(TinyInputEvent.CANCEL, onClose);
			
			this.addEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.removeEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}

		protected function onControlRemoved(event : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlRemoved', this);
	
			// Remove events
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_LEFT, togglePage);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ARROW_RIGHT, togglePage);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.ACCEPT, onClose);
			TinyInputManager.getInstance().removeEventListener(TinyInputEvent.CANCEL, onClose);
			
			this.removeEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}
		
		protected function togglePage( event : TinyInputEvent ) : void 
		{
			this.isShowingPage2 = !this.isShowingPage2;
			TinyLogManager.log('togglePage: ' + this.isShowingPage2, this);
			
			this.statsPage1Container.visible = !this.isShowingPage2;
			this.statsPage2Container.visible = this.isShowingPage2;
		}
		
		protected function onClose(event : TinyInputEvent) : void 
		{
			TinyLogManager.log('onClose', this);
			this.dispatchEvent(new TinyInputEvent(TinyInputEvent.CANCEL));
			
			// Play sound
			TinyAudioManager.play(TinyAudioManager.CANCEL);
		}
	}
}
