package com.tinyrpg.data 
{
	import com.tinyrpg.utils.TinyLogManager;

	import flash.utils.ByteArray;
	
	/**
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
		
		public function getMoveByName( targetName : String ) : TinyMoveData
		{
			TinyLogManager.log('getMoveByName: ' + targetName, this);
			
			// Find function
			var findFunction : Function = function(item : *, index : int, array : Array) : Boolean
			{ index; array; return ((item as TinyMoveData).name.toUpperCase() == targetName.toUpperCase()); };
				
			return this.moveList.filter(findFunction)[0];
		}
		
		// Singleton
		public static function getInstance() : TinyMoveDataList
		{
			return instance;
		}
	}
}