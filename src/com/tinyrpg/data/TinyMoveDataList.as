package com.tinyrpg.data 
{
	import com.tinyrpg.utils.TinyLogManager;

	import flash.utils.ByteArray;
	
	/**
	 * Singleton class which contains the list of moves in the game.
	 * 
	 * @author jeremyabel
	 */
	public class TinyMoveDataList 
	{
		private static var instance : TinyMoveDataList = new TinyMoveDataList();
		public var moveList : Array = [];
		
		[Embed(source='../../../../bin/xml/Moves.xml', mimeType='application/octet-stream')]
		public var Move_Data : Class;
		
		public function TinyMoveDataList() : void
		{
			// Get move XML
			var byteArray : ByteArray = (new this.Move_Data()) as ByteArray;
			var string : String= byteArray.readUTFBytes(byteArray.length);
			var moveXMLData : XML = new XML(string);
			
			// Add each item to the array
			for each (var moveData : XML in moveXMLData.children()) 
			{
				var newMove : TinyMoveData = TinyMoveData.newFromXML(moveData);
				this.moveList.push(newMove);
			}
		}
		
		/**
		 * Returns the move with a given name, or null if none is found.
		 */
		public function getMoveByName( targetName : String ) : TinyMoveData
		{
			TinyLogManager.log( 'getMoveByName: ' + targetName, this );
			
			// Find function
			var findFunction : Function = function( item : *, index : int, array : Array ) : Boolean
			{ index; array; return ( ( item as TinyMoveData ).name.toUpperCase() == targetName.toUpperCase() ); };
				
			return this.moveList.filter( findFunction )[ 0 ];
		}
		
		/**
		 * Returns the singleton instance.
		 */
		public static function getInstance() : TinyMoveDataList
		{
			return instance;
		}
	}
}