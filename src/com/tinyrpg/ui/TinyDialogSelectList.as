package com.tinyrpg.ui 
{
	import com.tinyrpg.core.TinyEventSequence;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.text.TextField;

	/**
	 * @author jeremyabel
	 */
	public class TinyDialogSelectList extends TinyDialogBox 
	{
		public var selectList : TinyTwoChoiceList;
		public var choiceOneSeq : TinyEventSequence;
		public var choiceTwoSeq : TinyEventSequence;
		
		private var textField  : TextField;
		
		public function TinyDialogSelectList(selectItems : Array, introDialogText : String, horizontal : Boolean = false, horizontalSpacing : int = 0, speaker : String = '', width : int = 288, height : int = 56) : void
		{
			super(speaker, width, height);
			
			// Show dialog
			this.textField = TinyFontManager.returnTextField();
			this.textField.htmlText = TinyFontManager.returnHtmlText(introDialogText, 'dialogText');
			this.textField.x = 7;
			this.textField.y = -3;
			
			// Make select list
			this.selectList = new TinyTwoChoiceList('', selectItems, width, height, 11, 0, 0, horizontal, horizontalSpacing);
			this.selectList.containerBox.visible = false;
			
			// Deal with horizontalness
			if (horizontal) {
				this.selectList.x = 200;
				this.selectList.y = -3;
			} else {
				this.selectList.x = 2;
				if (introDialogText == '') {
					this.selectList.y = 0;
				} else {
					this.selectList.y = 6;
				}
			}
			
			// Add 'em up
			this.addChild(this.selectList);
			this.addChild(this.textField);			
			
			// Add event
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}

		private function onOptionOne(event : TinyInputEvent) : void 
		{
			TinyLogManager.log('onOptionOne', this);
			
			this.dispatchEvent(new TinyInputEvent(TinyInputEvent.OPTION_ONE));

			// Clean up
			this.selectList.removeEventListener(TinyInputEvent.OPTION_ONE, onOptionOne);
		}

		private function onOptionTwo(event : TinyInputEvent) : void 
		{
			TinyLogManager.log('onOptionTwo', this);
			
			this.dispatchEvent(new TinyInputEvent(TinyInputEvent.OPTION_TWO));
			
			// Clean up
			this.selectList.removeEventListener(TinyInputEvent.OPTION_ONE, onOptionOne);
			this.selectList.removeEventListener(TinyInputEvent.OPTION_TWO, onOptionTwo);
		}

		public static function newFromXML(xmlData : XML) : TinyDialogSelectList
		{
			// Get choice XML
			var choiceOneData : XMLList = xmlData.child('CHOICE_ONE');
			var choiceTwoData : XMLList = xmlData.child('CHOICE_TWO');
			
			// Convert from XMLList to XML
			var xmlString : String = xmlData.child('CHOICE_ONE').child('SEQUENCE').toXMLString();
			xmlString = '<EVENT>' + xmlString + '</EVENT>';
			var choiceOneXML : XML = new XML(xmlString);
			
			xmlString = xmlData.child('CHOICE_TWO').child('SEQUENCE').toXMLString();
			xmlString = '<EVENT>' + xmlString + '</EVENT>';
			var choiceTwoXML : XML = new XML(xmlString);
			
			// Make choice items
			var choiceOne : TinySelectableItem = new TinySelectableItem(choiceOneData.child('TEXT').toString(), 0);
			var choiceTwo : TinySelectableItem = new TinySelectableItem(choiceTwoData.child('TEXT').toString(), 1);
			
			// Make new dialog select thing
			var newDialogSelectList : TinyDialogSelectList = new TinyDialogSelectList([choiceOne, choiceTwo], xmlData.child('INTRO_TEXT').toString(), false, 0, xmlData.child('SPEAKER').toString());	
			
			// Make choice sequences
			newDialogSelectList.choiceOneSeq = TinyEventSequence.newFromXML(choiceOneXML);
			
			return newDialogSelectList;
		}
		
		private function onControlAdded(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlAdded', this);
			
			this.addEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.selectList.addEventListener(TinyInputEvent.OPTION_ONE, onOptionOne);
			this.selectList.addEventListener(TinyInputEvent.OPTION_TWO, onOptionTwo);
			this.removeEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
			
			TinyInputManager.getInstance().setTarget(this.selectList);
		}

		private function onControlRemoved(e : TinyInputEvent) : void
		{
			TinyLogManager.log('onControlRemoved', this);
			
			this.removeEventListener(TinyInputEvent.CONTROL_REMOVED, onControlRemoved);
			this.addEventListener(TinyInputEvent.CONTROL_ADDED, onControlAdded);
		}
	}
}