package com.tinyrpg.sequence 
{
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.managers.TinyGameManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyItemCommand 
	{
		public var money 	: uint;
		public var item 	: TinyItem;
		public var take 	: Boolean;
		
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
