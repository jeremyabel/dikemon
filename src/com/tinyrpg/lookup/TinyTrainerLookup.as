package com.tinyrpg.lookup
{
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.utils.TinyLogManager;
	
	import flash.utils.ByteArray;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyTrainerLookup 
	{
		[Embed(source='../../../../bin/xml/Trainers.xml', mimeType='application/octet-stream')]
		private static const Trainers_XML : Class;
		
		private var trainerData : XML;
		
		private static var instance : TinyTrainerLookup = new TinyTrainerLookup;
		
		public function TinyTrainerLookup() : void
		{
			// Load the trainer XML data
			var byteArray : ByteArray = ( new Trainers_XML() ) as ByteArray;
			this.trainerData = new XML( byteArray.readUTFBytes( byteArray.length ) );
		}
		
		public static function getInstance() : TinyMonLookup
		{
			return instance;
		}
		
		public function getTrainerByName( name : String ) : TinyTrainer
		{
			TinyLogManager.log( 'getTrainerByName: ' + name, this );
			
			return null;
		}		
	}
}
