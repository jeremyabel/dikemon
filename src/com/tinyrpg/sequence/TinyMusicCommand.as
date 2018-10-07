package com.tinyrpg.sequence 
{
	import flash.events.EventDispatcher;

	/**
	 * @author jeremyabel
	 */
	public class TinyMusicCommand extends EventDispatcher 
	{
		public var songName : String;
		public var loop : Boolean = false;
		public var interrupt : Boolean = false;
		
		public function TinyMusicCommand() : void { }
		
		public static function newFromXML(xmlData : XML) : TinyMusicCommand
		{
			var newMusicCommand : TinyMusicCommand = new TinyMusicCommand;
			
			newMusicCommand.songName = xmlData.child('NAME').toString();
			newMusicCommand.loop = xmlData.child('LOOP').toString() == 'TRUE';
			newMusicCommand.interrupt = xmlData.child('INTERRUPT').toString() == 'TRUE';
			
			return newMusicCommand;
		}
	}
}
