package com.tinyrpg.sequence
{
	import com.tinyrpg.core.TinyEventSequence;
	
	/**
	 * @author jeremyabel
	 */
	public class TinySubSequenceCommand 
	{
		public var subSequence : TinyEventSequence;
		
		public function TinySubSequenceCommand() : void { }
		
		public static function newFromXML( xmlData : XML ) : TinySubSequenceCommand
		{
			var newCommand : TinySubSequenceCommand = new TinySubSequenceCommand();
			
			// Create sub sequence
			newCommand.subSequence = TinyEventSequence.newFromXML( xmlData.toString() );
			
			return newCommand;
		}
	}	
}
