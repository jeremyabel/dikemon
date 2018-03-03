package com.tinyrpg.ui 
{
	import com.greensock.plugins.TweenPlugin;
	import com.tinyrpg.display.TinyModalScrollArrow;
	import com.tinyrpg.display.TinySelectableItem;
	import com.tinyrpg.events.TinyInputEvent;
	import com.tinyrpg.managers.TinyAudioManager;
	import com.tinyrpg.managers.TinyInputManager;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;
	
	import flash.display.Sprite;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyScrollableSelectList extends TinySelectList
	{ 
		private var selectedItemIndex : uint;
		private var maxItemsBeforeScroll : uint;
		private var itemHolderOrigY : int;
		private var scrollUpLimit : uint;
		private var scrollDownLimit : uint;
		private var scrollOffset : int;
		private var scrollMask : Sprite;
		
		protected var scrollArrowUp : TinyModalScrollArrow;
		protected var scrollArrowDown : TinyModalScrollArrow;
		
		public function TinyScrollableSelectList( title : String, newItemArray : Array = null, width : uint = 0, height : uint = 0, spacing : uint = 15, startingY : int = 6, startingX : int = 0, maxItemsBeforeScroll : uint = 4 )
		{	
			this.maxItemsBeforeScroll = maxItemsBeforeScroll;
			
			this.scrollUpLimit = 0;
			this.scrollDownLimit = maxItemsBeforeScroll;
			this.scrollOffset = 0;
			
			super( title, newItemArray, width, height, spacing, startingY, startingX, false );
			
			this.itemHolderOrigY = this.itemHolder.y;
					
			// Create scroll up arrow
			this.scrollArrowUp = new TinyModalScrollArrow;
			this.scrollArrowUp.x = this.boxWidth - 4;
			this.scrollArrowUp.y = 1;
			this.scrollArrowUp.visible = false;
			
			// Create scroll down arrow
			this.scrollArrowDown = new TinyModalScrollArrow;
			this.scrollArrowDown.x = this.boxWidth - 4;
			this.scrollArrowDown.y = this.boxHeight - 1;
			this.scrollArrowDown.scaleY = -1;
			this.scrollArrowDown.visible = false;
						
			// Show down scroll arrow if the item list cannot fit without scrolling
			if ( this.itemArray.length > this.maxItemsBeforeScroll ) {
				this.scrollArrowDown.visible = true;
			}
			
			// Create scroll mask
			this.scrollMask = new Sprite();
			this.scrollMask.graphics.beginFill( 0xFF00FF );
			this.scrollMask.graphics.drawRect( 0, 0, this.boxWidth, this.boxHeight );
			this.scrollMask.graphics.endFill();
			
			// Set mask
			this.itemHolder.mask = this.scrollMask;
			
			// Add 'em up
			this.addChild( this.scrollArrowUp );
			this.addChild( this.scrollArrowDown );
			this.addChild( this.scrollMask );
		}
		
		override public function removeListItem(targetItem : TinySelectableItem) : void
		{
			super.removeListItem( targetItem );
			
			// Hide scroll arrows if the item list can fit without scrolling 
			if ( this.itemArray.length <= this.maxItemsBeforeScroll ) {
				this.scrollArrowUp.visible = false;
				this.scrollArrowDown.visible = false;
			}
		}
		
		override public function setSelectedItemIndex( index : int ) : void
		{
			super.setSelectedItemIndex( index );
			
			this.selectedItemIndex = index;
			
			// Force scroll to top
			if ( index == 0 ) {
				this.scrollToTop();
				return;
			}
			
			// Force scroll to bottom
			if ( index == this.itemArray.length - 1 ) {
				this.scrollToBottom();
				return;
			}
		}

		override public function clearSelectedItem() : void
		{
			super.clearSelectedItem();
			
			// Reset scrolling
			this.scrollToTop();
		}
		
		override protected function onArrowUp(event : TinyInputEvent) : void
		{
			super.onArrowUp( event );
			
			// Check for scroll up			
			if ( this.selectedItemIndex < this.scrollUpLimit ) {
				this.scrollOffset--;
				this.scrollUpLimit--;
				this.scrollDownLimit = this.scrollUpLimit + this.maxItemsBeforeScroll;
				this.updateScroll();
			}
		}
		
		override protected function onArrowDown(event : TinyInputEvent) : void
		{
			super.onArrowDown( event ); 
			
			// Check for scroll down
			if ( this.selectedItemIndex >= this.scrollDownLimit ) {
				this.scrollOffset++;
				this.scrollUpLimit++;
				this.scrollDownLimit++;
				this.updateScroll();
			}
		}
		
		protected function scrollToTop() : void
		{
			this.scrollOffset = 0;
			this.scrollUpLimit = 0;
			this.scrollDownLimit = this.maxItemsBeforeScroll;
			this.updateScroll();
		}
		
		protected function scrollToBottom() : void
		{
			this.scrollOffset = this.itemArray.length - this.maxItemsBeforeScroll;
			this.scrollUpLimit = this.itemArray.length - this.maxItemsBeforeScroll;
			this.scrollDownLimit = this.itemArray.length;
			this.updateScroll();
		}
		
		protected function updateScroll() : void
		{
			if ( this.length <= this.maxItemsBeforeScroll ) return;
			
			this.itemHolder.y = this.itemHolderOrigY;
			this.itemHolder.y -= this.scrollOffset * this.spacing;
				
			// Show the up arrow if we're below the top of the list
			if ( this.scrollOffset > 0 ) {
				this.scrollArrowUp.visible = true;
			} else {
				this.scrollArrowUp.visible = false; 
			}
			
			if ( this.scrollOffset < this.itemArray.length - this.maxItemsBeforeScroll ) {
				this.scrollArrowDown.visible = true; 
			} else {
				this.scrollArrowDown.visible = false;
			}
		}
	}
}
