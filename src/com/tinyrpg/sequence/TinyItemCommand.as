package com.tinyrpg.sequence 
{
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.managers.TinyGameManager;

	/**
	 * Class which represents several inventory-related commands: "GIVE_ITEM", "TAKE_ITEM",
	 * "GIVE_MONEY", and "TAKE_MONEY".
	 * 
	 * This command immediately gives or takes a given item or amount of money from the player.
	 * This command is not instanciated from XML directly, but is parsed from a single parameter
	 * which indicates the item to give / take or an amount of money to give / take.
	 * 
	 * If the tag contents are a string, it is assumed to be an item. If they are an integer, 
	 * it is assumed to be an amount of money. 
	 * 
	 * @author jeremyabel
	 */
	public class TinyItemCommand 
	{
		public var money 	: uint;
		public var item 	: TinyItem;
		public var take 	: Boolean;
		
		/**
		 * @param	take	True if the item / money should be taken, false if it should be given.
		 * @param	item	The {@link TinyItem} to be given / taken.
		 * @param	money	The amount of money to be given / taken. 
		 */
		public function TinyItemCommand( take : Boolean, item : TinyItem = null, money : uint = 0 ) : void
		{
			this.take = take;
			this.item = item;
			this.money = money;
		}
		
		public function execute() : void
		{
			if ( this.take )
			{
				if ( this.money > 0 )
				{
					// Remove money
					TinyGameManager.getInstance().playerTrainer.removeMoney( this.money );
					return;
				}
				else
				{
					// Remove item
					TinyGameManager.getInstance().playerTrainer.removeItem( this.item );
					return;
				}
			}
			else
			{
				if ( this.money > 0 ) 
				{
					// Add money
					TinyGameManager.getInstance().playerTrainer.addMoney( this.money );
					return;
				}
				else 
				{
					// Add item
					TinyGameManager.getInstance().playerTrainer.addItem( this.item);
					return;
				}
			}
		}
	}
}
