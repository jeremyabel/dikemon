package com.tinyrpg.data 
{
	import com.tinyrpg.lookup.TinyEventFlagLookup;
	import com.tinyrpg.managers.TinyGameManager;
	import com.tinyrpg.managers.TinyMapManager;
	import com.tinyrpg.utils.TinyJSONUtils;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;

	/**
	 * Class which handles data for saving and loading a game.
	 * 
	 * The save data is JSON data, compressed with the "deflate" method.
	 * The file itself is named "dikemon.sav" and is located in the 
	 * application storage directory.
	 * 
	 * The saved data is only what is needed to recreate the game state:
	 * 
	 * - Trainer stats (money, mon list, etc)
	 * - Event flag values
	 * - The name of the current map
	 * - Player's XY grid coordinates on the current map
	 * 
	 * @author jeremyabel
	 */
	public class TinySaveData extends EventDispatcher
	{
		private static const SAVE_FILE_NAME : String = 'dikemon.sav';
		
		private var jsonObject : Object;
		
		/**
		 * Generates a new save data object.
		 */
		public function TinySaveData() : void
		{
			TinyLogManager.log( 'new TinySaveData', this );
			
			this.jsonObject = {};
			
			this.jsonObject.trainer = TinyGameManager.getInstance().playerTrainer.toJSON();
			this.jsonObject.flags = TinyEventFlagLookup.getInstance().toJSON();
			this.jsonObject.currentMap = TinyMapManager.getInstance().currentMap.mapName;
			this.jsonObject.position = TinyJSONUtils.pointToJSON( TinyMapManager.getInstance().playerSprite.getPositionOnGrid() );
		}
		
		/**
		 * Writes the save file to disk.
		 */
		public function save() : void
		{
			// Make new save file, or overwrite the old one			
			var saveFile : File = File.applicationStorageDirectory;
			saveFile = saveFile.resolvePath( SAVE_FILE_NAME );
			
			TinyLogManager.log( 'save: ' + saveFile.nativePath, this );
			
			// Convert xml data to a byte array
			var srcBytes : ByteArray = new ByteArray;
			srcBytes.writeUTFBytes( JSON.stringify( this.jsonObject ) );
			
			// Open the file stream
			var outStream : FileStream = new FileStream();
			outStream.addEventListener( IOErrorEvent.IO_ERROR, this.onSaveError );
			outStream.open( saveFile, FileMode.WRITE );
			
			// Compress and write
			srcBytes.compress( CompressionAlgorithm.DEFLATE );
			outStream.writeBytes( srcBytes );
			outStream.close();
		}
		
		/**
		 * Event handler for file writing errors.
		 */
		private function onSaveError( event : IOErrorEvent ) : void
		{
			TinyLogManager.log( 'IOError: ' + event.text, this );
			// TODO: add something user-facing here
		}

		/**
		 * Loads the save data from disk and returns the parsed JSON object.
		 */
		public static function loadToJSON() : Object
		{
			TinyLogManager.log( 'loadToJSON', TinySaveData );
			
			// Get file to load
			var openFile : File = File.applicationStorageDirectory;
			openFile = openFile.resolvePath( SAVE_FILE_NAME );
			
			// Read file into a byte array
			var inStream : FileStream = new FileStream();
			inStream.addEventListener( IOErrorEvent.IO_ERROR, TinySaveData.onLoadError );
			inStream.open( openFile, FileMode.READ );
			var fileBytes : ByteArray = new ByteArray;
			inStream.readBytes( fileBytes );
			
			// Uncompress
			fileBytes.uncompress( CompressionAlgorithm.DEFLATE );
			
			// Return the parsed JSON
			return JSON.parse( fileBytes.readUTFBytes( fileBytes.length ) );
		}
		
		/**
		 * Event handler for file reading errors.
		 */
		private static function onLoadError( event : IOErrorEvent ) : void
		{
			TinyLogManager.log( 'IOError: ' + event.text, TinySaveData );
			// TODO: add something user-facing here
		}

		/**
		 * Returns true if a save file exists, otherwise false.
		 */
		public static function doesSaveExist() : Boolean
		{
			// Get file to load
			var file : File = File.applicationStorageDirectory;
			file = file.resolvePath( SAVE_FILE_NAME );
			return file.exists;
		}
	}
}