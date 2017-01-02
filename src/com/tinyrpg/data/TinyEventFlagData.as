package com.tinyrpg.data 
{
	import com.tinyrpg.utils.TinyLogManager;

	import flash.utils.ByteArray;

	/**
	 * @author jeremyabel
	 */
	public class TinyEventFlagData 
	{
		private static var instance : TinyEventFlagData = new TinyEventFlagData();

		[Embed(source='../../../../bin/xml/Events.xml', mimeType='application/octet-stream')]
		public var Event_Data : Class;
		
		public var flagList : Array = [];
		
		// Fetch quest counters
		public var meganBatteryCount : int = 0;
		public var bunnyCount : int = 0;
				
		public function TinyEventFlagData() : void
		{
	
		}
		
		public function init() : void
		{
			TinyLogManager.log('init', this);
			
			// Get flag XML data
			var byteArray : ByteArray = (new this.Event_Data()) as ByteArray;
			var string : String = byteArray.readUTFBytes(byteArray.length);
			var eventXMLData : XML = new XML(string);
			var flagXMLData : XMLList = eventXMLData.child('EVENT_FLAGS');
			
			// Add each flag to the array
			for each (var flag : XML in flagXMLData.children()) {
				var newFlag : TinyEventFlag = new TinyEventFlag(flag.text()); 
				this.flagList.push(newFlag);
				TinyLogManager.log('add event flag: ' + newFlag.name + ', ' + newFlag.value, this);
			}
		}
		
		public function getFlagStatusByName(targetName : String) : Boolean
		{
			TinyLogManager.log('getFlagStatusByName: ' + targetName, this);
			
			// Find function
			var findFunction : Function = function(item : *, index : int, array : Array) : Boolean
				{ index; array; return (TinyEventFlag(item).name == targetName); };
				
			var returnVal : Boolean = (this.flagList.filter(findFunction).length > 0) ? TinyEventFlag(this.flagList.filter(findFunction)[0]).value : false;
			return returnVal;
		}
		
		public function getFlagByName(targetName : String) : TinyEventFlag
		{
			TinyLogManager.log('getFlagByName: ' + targetName, this);
			
			// Find function
			var findFunction : Function = function(item : *, index : int, array : Array) : Boolean
				{ index; array; return (TinyEventFlag(item).name == targetName); };
				
			return this.flagList.filter(findFunction)[0];
		}
		
		// Singleton
		public static function getInstance() : TinyEventFlagData
		{
			return instance;
		}
		
		public static function initFromXML(xmlData : XML) : void
		{
			TinyLogManager.log('initFromXML', TinyEventFlagData);
			
			var instance : TinyEventFlagData = TinyEventFlagData.getInstance();
			
			var eventData : XMLList = xmlData.child('EVENT_FLAGS');
			for each (var flagData : XML in eventData.children()) {
				instance.getFlagByName(flagData.child('NAME').toString()).value = (flagData.child('VALUE').toString().toUpperCase() == 'TRUE');
			}
		}
		
		public static function getRecruitFlagByName(charName : String) : TinyEventFlag
		{
			TinyLogManager.log('getRecruitFlagByName: ' + charName, TinyEventFlagData);
		
			var instance : TinyEventFlagData = TinyEventFlagData.getInstance();
			var returnFlag : TinyEventFlag;
			switch (charName.toUpperCase())
			{
				case 'ANDY':
					returnFlag = instance.getFlagByName('recruit_andy'); 
					break;
				case 'ASA':
					returnFlag = instance.getFlagByName('recruit_asa');
					break;
				case 'JASON':
					returnFlag = instance.getFlagByName('recruit_jason');
					break;
				case 'FISH':
					returnFlag = instance.getFlagByName('recruit_fish');
					break;
				case 'MEGAN': 
					returnFlag = instance.getFlagByName('recruit_megan');
					break;
				case 'RACHEL':
					returnFlag = instance.getFlagByName('recruit_rachel');
					break;
				case 'RALPH':
					returnFlag = instance.getFlagByName('recruit_ralph');
					break;
				case 'RON': 
					returnFlag = instance.getFlagByName('recruit_ron');
					break;
			}
			return returnFlag;
		}
	}
}
