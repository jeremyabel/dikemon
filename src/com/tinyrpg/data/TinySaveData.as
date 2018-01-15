package com.tinyrpg.data 
{
	import com.tinyrpg.core.TinyFieldMap;
	import com.tinyrpg.core.TinyFriendSprite;
	import com.tinyrpg.core.TinyItem;
	import com.tinyrpg.core.TinyParty;
	import com.tinyrpg.core.TinyPlayer;
	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;

	/**
	 * @author jeremyabel
	 */
	public class TinySaveData extends EventDispatcher
	{
		[Embed(source='../../../../bin/xml/StartingSave.xml', mimeType='application/octet-stream')]
		private static const Starting_Data : Class;
	
		private var xmlData : XML;
		 
		public function TinySaveData() : void
		{
			TinyLogManager.log('new TinySaveData', this);
			
			// Get things we'll need
			var player 		: TinyPlayer = TinyPlayer.getInstance();
			var inventory 	: TinyInventory = player.inventory;
			var eventFlags	: TinyEventFlagData = TinyEventFlagData.getInstance();
			var party 		: TinyParty = player.fullParty;
			
			// Set up xml base
			this.xmlData = XML('<SAVE_DATA></SAVE_DATA>');
			
			// Get current time
			var currentTime : Date = new Date(); 
			var minutes : int = currentTime.getMinutes();
			var hours : int = currentTime.getHours() % 12 == 0 ? 12 : currentTime.getHours() % 12;
			var timeString : String = String(hours) + ':' + String(minutes);
			
			// Get info for save menu display
			var saveMenuXMLString : String = '<SAVE_MENU>\n';
			saveMenuXMLString += '<NAME>' + TinyStatsEntity(party.party[0]).name + '</NAME>';
			saveMenuXMLString += '<TIME>' + timeString + '</TIME>'; 
			saveMenuXMLString += '<FOUND>';

			// Convert party to XML
			var partyXMLString : String = '<PARTY>\n';
			for each (var partyMember : TinyStatsEntity in party.party) {
				partyXMLString += '<MEMBER>\n';
				partyXMLString += '<NAME>' + partyMember.name + '</NAME>\n';
				partyXMLString += '<ID>' + partyMember.idNumber + '</ID>\n';
				partyXMLString += partyMember.getXMLString();				partyXMLString += '</MEMBER>\n';
				saveMenuXMLString += '<NAME recruited="'+ (partyMember.recruited ? 'TRUE' : 'FALSE') + '">' + partyMember.name + '</NAME>\n';
			}
			partyXMLString += '</PARTY>\n';
			saveMenuXMLString += '</FOUND>\n';
			saveMenuXMLString += '</SAVE_MENU>\n';
			this.xmlData.appendChild(XML(saveMenuXMLString));
			this.xmlData.appendChild(XML(partyXMLString));
			
			// Convert inventory to XML
			var itemXMLString : String = '<INVENTORY>\n';
			for each (var item : TinyItem in inventory.inventory) { 
				if (item.name != '') {
					itemXMLString += '<ITEM>' + item.name + '</ITEM>';
				}
			}
			itemXMLString += '</INVENTORY>\n';
			this.xmlData.appendChild(XML(itemXMLString));
			
			// Add gold amount
			this.xmlData.appendChild(XML('<GOLD>' + inventory.gold + '</GOLD>'));
			
			// Convert event flags to XML
			var eventXMLString :  String = '<EVENT_FLAGS>\n';
			for each (var eventFlag : TinyEventFlag in eventFlags.flagList) {
				eventXMLString += '<EVENT><NAME>' + eventFlag.name + '</NAME><VALUE>' + (eventFlag.value == true ? 'TRUE' : 'FALSE') + '</VALUE></EVENT>\n';
			}
			eventXMLString += '</EVENT_FLAGS>\n';
			this.xmlData.appendChild(XML(eventXMLString));
			
			
			// Convert map location to XML
			//var mapXMLString : String = '<MAP>\n';
			//mapXMLString += '<NAME>' + TinyFieldMap.mapName + '</NAME>';			//mapXMLString += '<PLAYER_POS>';
			//mapXMLString += TinyFriendSprite(TinyStatsEntity(TinyPlayer.getInstance().party.party[0]).graphics).x + ',';
			//mapXMLString += TinyFriendSprite(TinyStatsEntity(TinyPlayer.getInstance().party.party[0]).graphics).y + '</PLAYER_POS>'; 			//mapXMLString += '</MAP>\n';
			//this.xmlData.appendChild(XML(mapXMLString));
		}
		
		public function saveAndCompressData(fileSlot : int) : void
		{
			TinyLogManager.log('saveAndCompressData: Slot ' + fileSlot, this);

			//TinyInputManager.getInstance().setTarget(null);
			
			// Make new save file, or overwrite the old one			
			var saveFile : File = File.applicationStorageDirectory;
			saveFile = saveFile.resolvePath('sv_' + fileSlot + '.sav');
			
			// Convert xml data to a byte array
			var srcBytes : ByteArray = new ByteArray;
			srcBytes.writeUTFBytes(this.xmlData);
			
			// Open the file stream
			var outStream : FileStream = new FileStream();
			outStream.addEventListener(Event.COMPLETE, onSaveComplete);			outStream.addEventListener(Event.CLOSE, onSaveComplete);
			outStream.addEventListener(ProgressEvent.PROGRESS, onProgress);
			outStream.open(saveFile, FileMode.WRITE);
			
			// Compress and write
			srcBytes.compress(CompressionAlgorithm.DEFLATE);
			outStream.writeBytes(srcBytes, 0, srcBytes.length);
			
			// Done!
			outStream.close();
		}

		private function onProgress(event : ProgressEvent) : void 
		{
			trace('sdhh');
			trace(event.bytesLoaded);
		}

		private function onSaveComplete(event : Event) : void
		{
			TinyLogManager.log('onSaveComplete', this);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		public static function loadCompressedData(fileSlot : int) : XML
		{
			TinyLogManager.log('loadCompressedData: Slot ' + fileSlot, TinySaveData);
			
			// Get file to load
			var openFile : File = File.applicationStorageDirectory;
			openFile = openFile.resolvePath('sv_' + fileSlot + '.sav');
			
			// Read file into a byte array
			var inStream : FileStream = new FileStream();
			inStream.open(openFile, FileMode.READ);
			var fileBytes : ByteArray = new ByteArray;
			inStream.readBytes(fileBytes);
			
			// Uncompress
			fileBytes.uncompress(CompressionAlgorithm.DEFLATE);
			
			// Convert into XML and return
			var string : String = fileBytes.readUTFBytes(fileBytes.length);
			//trace(XML(string).toXMLString());
			return new XML(string);
		}
		
		public static function getStartingSave(startingPlayerName : String) : XML
		{
			TinyLogManager.log('getStartingSave: ' + startingPlayerName, TinySaveData);
			
			// Get character position in XML - THIS RELIES ON THE XML CHARACTER LIST BEING IN ALPHABETICAL ORDER!!
			var charPosition : int = 0;
			switch (startingPlayerName.toLocaleUpperCase())
			{
				case 'ANDY':
					charPosition = 0; break;
				case 'ASA':
					charPosition = 1; break;
				case 'FISH':
					charPosition = 2; break;
				case 'JASON':
					charPosition = 3; break;
				case 'MEGAN':
					charPosition = 4; break;
				case 'RACHEL':
					charPosition = 5; break;
				case 'RALPH':
					charPosition = 6; break;
				case 'RON':
					charPosition = 7; break;
				case 'EVAN':
					charPosition = 8; break;
				case 'EVAN?':
					charPosition = 9; break;
				case 'HYBRID':
					charPosition = 10; break;
			}
			
			// Get starting XML data
			var byteArray : ByteArray = (new TinySaveData.Starting_Data()) as ByteArray;
			var string : String = byteArray.readUTFBytes(byteArray.length);
			var saveData : XML = new XML(string);
			
			// Make new xml data from a string
			var startingXMLString : String = '<?xml version="1.0" encoding="UTF-8"?><SAVE_DATA><PARTY>';
			
			// Put party info into an array
			var partyArray : Array = [];
			for each (var memberXML : XML in saveData.child('PARTY').children()) {
				partyArray.push(memberXML);
			}
			
			// Re-arrainge array to put starting character first
			var targetChar : XML = partyArray[charPosition];
			partyArray.splice(charPosition, 1);
			
			// Add back into string
			startingXMLString += targetChar.toString();
			for each (memberXML in partyArray) {
				startingXMLString += memberXML.toXMLString();
			}
			
			// Close tags and add map info
			startingXMLString += '	</PARTY><INVENTORY /><GOLD>0</GOLD><MAP><NAME>Map_Castle_Entrance</NAME><PLAYER_POS>120,200</PLAYER_POS></MAP></SAVE_DATA>';
			//trace(XML(startingXMLString).toXMLString());
			return XML(startingXMLString);
		}
		
		public static function doesSaveExist(fileSlot : int) : Boolean
		{
			// Get file to load
			var file : File = File.applicationStorageDirectory;
			file = file.resolvePath('sv_' + fileSlot + '.sav');
			return file.exists;
		}
	}
}