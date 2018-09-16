package com.tinyrpg.sequence
{
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.data.TinyItemDataList;
	import com.tinyrpg.data.TinyCommonStrings;
	import com.tinyrpg.display.TinyContentBox
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyFontManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.ui.TinyPurchaseItemFlow;
	import com.tinyrpg.ui.TinyDialogBox;
	import com.tinyrpg.ui.TinySelectList;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyShopCommand extends Sprite
	{
		public var welcomeString 			: String;
		public var anythingElseString		: String;
		public var items					: Array = [];
		
		private var buyOrSellMenu			: TinySelectList;
		private var welcomeDialog			: TinyDialogBox;
		private var anythingElseDialog		: TinyDialogBox;
		private var currentPurchaseItemFlow	: TinyPurchaseItemFlow;
		private var isSelling				: Boolean = false;
		
		public function TinyShopCommand() : void
		{
			var buyOrSellMenuItems : Array = [];
			buyOrSellMenuItems[ 0 ] = new TinySelectableItem( TinyCommonStrings.BUY.toUpperCase(),  0 );
			buyOrSellMenuItems[ 1 ] = new TinySelectableItem( TinyCommonStrings.SELL.toUpperCase(), 1 );
			buyOrSellMenuItems[ 2 ] = new TinySelectableItem( TinyCommonStrings.QUIT.toUpperCase(), 2 );
			
			this.buyOrSellMenu = new TinySelectList( buyOrSellMenuItems, 36, 50 );
			this.buyOrSellMenu.x = 8;
			this.buyOrSellMenu.y = 8;
		}
		
		public static function newFromXML( xmlData : XML ) : TinyShopCommand
		{
			var newCommand : TinyShopCommand = new TinyShopCommand();
			
			// Get welcome string
			newCommand.welcomeString = xmlData.child( 'WELCOME' ).toString();
			
			// Get "anything else?" string
			newCommand.anythingElseString = xmlData.child( 'ANYTHING_ELSE' ).toString();
			
			// Get items for sale
			for each ( var itemXML : XML in xmlData.child( 'ITEMS' ).children() )
			{
				var itemName : String = itemXML.toString();
				var item : TinyItem = TinyItemDataList.getInstance().getItemByOriginalName( itemName );
				newCommand.items.push( item );
			}
			
			return newCommand;
		}
		
		public function execute() : void
		{
			TinyInputManager.getInstance().setTarget( this.buyOrSellMenu );
			
			this.buyOrSellMenu.addEventListener( TinyInputEvent.ACCEPT, this.onBuyOrSellMenuAccepted );
			this.buyOrSellMenu.addEventListener( TinyInputEvent.CANCEL, this.onBuyOrSellMenuCancelled );
			
			// Create the welcome dialog
			this.welcomeDialog = TinyDialogBox.newFromString( this.welcomeString );
			this.welcomeDialog.x = 8;
			this.welcomeDialog.y = 104;
			
			// Create the "anything else?" dialog
			this.anythingElseDialog = TinyDialogBox.newFromString( this.anythingElseString );
			this.anythingElseDialog.x = 8;
			this.anythingElseDialog.y = 104;
				
			// Add 'em up
			this.addChild( this.anythingElseDialog );
			this.addChild( this.welcomeDialog );
			this.addChild( this.buyOrSellMenu );
			
			// Show just the welcome dialog and the buy/sell menu
			this.buyOrSellMenu.show();
			this.welcomeDialog.show();
		}
		
		private function onBuyOrSellMenuAccepted( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onBuyOrSellMenuAccepted', this );
			
			// Hide both shop conversation dialogs and the buy/sell menu
			this.anythingElseDialog.hide();
			this.welcomeDialog.hide();
			this.buyOrSellMenu.hide();
			
			switch ( this.buyOrSellMenu.selectedItem.textString.toUpperCase() )
			{
				case TinyCommonStrings.BUY.toUpperCase():
					this.isSelling = false;
					break;
					
				case TinyCommonStrings.SELL.toUpperCase():
					this.isSelling = true;
					break;
					
				case TinyCommonStrings.QUIT.toUpperCase():
					this.onBuyOrSellMenuCancelled( null );
					return;
			}
			
			this.currentPurchaseItemFlow = new TinyPurchaseItemFlow( this.items, this.isSelling );
			this.currentPurchaseItemFlow.addEventListener( Event.COMPLETE, this.onPurchaseComplete );
			this.currentPurchaseItemFlow.execute();
			this.addChild( this.currentPurchaseItemFlow );
		}
		
		private function onPurchaseComplete( event : Event ) : void
		{
			TinyLogManager.log( 'onBuyComplete', this );
			
			// Cleanup
			this.currentPurchaseItemFlow.removeEventListener( Event.COMPLETE, this.onPurchaseComplete );
			this.removeChild( this.currentPurchaseItemFlow );
			this.currentPurchaseItemFlow = null;
			this.isSelling = false;
			
			this.anythingElseDialog.show();
			this.buyOrSellMenu.show();
			
			// Return control to the buy/sell menu
			TinyInputManager.getInstance().setTarget( this.buyOrSellMenu );
		}
		
		private function onBuyOrSellMenuCancelled( event : TinyInputEvent ) : void
		{
			TinyLogManager.log( 'onBuyOrSellMenuCancelled', this );
			
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}