package com.tinyrpg.ui 
{
	import com.tinyrpg.display.TinyOneLineBox;
	import com.tinyrpg.utils.TinyLogManager;
	import com.tinyrpg.utils.TinyMath;

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleMenu extends TinyModal
	{
		public var enemyList 	: TinyEnemyList;
		public var friendList	: TinyFriendList;
		public var itemList 	: TinyBattleItemList;
		public var commandMenu	: TinyBattleCommandMenu;
		
		public static var helperBox	: TinyOneLineBox;
		
		private var _width		: int;
		private var _height		: int; 

		public function TinyBattleMenu()
		{
			// Make stuff
			this.enemyList 	= new TinyEnemyList;
			this.commandMenu = new TinyBattleCommandMenu;
			this.friendList = new TinyFriendList;
//			this.itemList	= new TinyBattleItemList;
			
			TinyBattleMenu.helperBox = new TinyOneLineBox;
			TinyBattleMenu.helperBox.hide();
			
			this._width = this.enemyList.width + this.commandMenu.width + this.friendList.width;

			// Position 
			this.enemyList.x = 3;
			this.enemyList.y = 3;
			this.commandMenu.x = this.enemyList.x + this.enemyList.width - 1;
			this.commandMenu.y = this.enemyList.y;
			this.friendList.x = (this.commandMenu.x + this.commandMenu.width) - 1;
			this.friendList.y = this.enemyList.y;
			this.itemList.x = this.enemyList.y + int((this._width / 2) - (this.itemList.width / 2));
			this.itemList.y = this.enemyList.y + 4;
			TinyBattleMenu.helperBox.x = this.enemyList.x;
			TinyBattleMenu.helperBox.y = -TinyBattleMenu.helperBox.height + 4;
			
			// Add 'em up
			this.addChild(this.enemyList);
			this.addChild(this.friendList);
			this.addChild(this.commandMenu);
			this.addChild(this.itemList);
			this.addChild(TinyBattleMenu.helperBox);
		}

		override public function show() : void
		{
			super.show();
			
			// Update friends list
			var friendListIndex : int = TinyMath.deepCopyInt(this.getChildIndex(this.friendList));
			this.removeChild(this.friendList);
			this.friendList = new TinyFriendList;
			this.friendList.x = (this.commandMenu.x + this.commandMenu.width) - 1;
			this.friendList.y = this.enemyList.y;
			this.addChildAt(this.friendList, friendListIndex);
			
			// Update enemy list
			var enemyListIndex : int = TinyMath.deepCopyInt(this.getChildIndex(this.enemyList));
			this.removeChild(this.enemyList);
			this.enemyList = new TinyEnemyList;
			this.enemyList.x = 3;
			this.enemyList.y = 3;			
			this.addChildAt(this.enemyList, enemyListIndex);
			
			// Update command list
			var commandMenuIndex : int = TinyMath.deepCopyInt(this.getChildIndex(this.commandMenu));
			this.removeChild(this.commandMenu);
			this.commandMenu = new TinyBattleCommandMenu;
			this.commandMenu.x = this.enemyList.x + this.enemyList.width - 1;
			this.commandMenu.y = this.enemyList.y;
			this.addChildAt(this.commandMenu, commandMenuIndex);
		}

		override public function hide() : void
		{
			super.hide();
		}
		
		public function resetInventory() : void
		{
			TinyLogManager.log('resetInventory', this);
			
			var inventoryIndex : int = TinyMath.deepCopyInt(this.getChildIndex(this.itemList));
			this.removeChild(this.itemList);
			this.itemList = null;
//			this.itemList = new TinyBattleItemList;
			this.itemList.x = this.enemyList.y + int((this._width / 2) - (this.itemList.width / 2));
			this.itemList.y = this.enemyList.y + 4;
			this.addChildAt(this.itemList, inventoryIndex);
		}

		public function update() : void
		{
			TinyLogManager.log('update', this);
			
			this.friendList.update();
		}
		
		override public function get width() : Number
		{
			return this._width - 3;
		}
		
		override public function get height() : Number
		{
			return this._height + 3;
		}
	}
}
