package com.tinyrpg.data 
{
	import com.tinyrpg.core.TinyStatsEntity;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.utils.ByteArray;

	/**
	 * @author jeremyabel
	 */
	public class TinyEnemyDataList 
	{
		private static var instance : TinyEnemyDataList = new TinyEnemyDataList();

		[Embed(source='../../../../bin/xml/Enemies.xml', mimeType='application/octet-stream')]
		public var Enemy_Data : Class;
		
		public var enemyList : Array = [];
		public var levelList : Array = []; 
		
		
		public function TinyEnemyDataList() : void
		{
			// Get enemy XML data
			var byteArray : ByteArray = (new this.Enemy_Data()) as ByteArray;
			var string : String= byteArray.readUTFBytes(byteArray.length);
			var enemyXMLData : XML = new XML(string);
			
			// Add each enemy to the array
			for each (var enemyData : XML in enemyXMLData.child('ENEMY_DATA').children()) {
				var newEnemy : TinyStatsEntity = TinyStatsEntity.newEnemyFromXML(enemyData);
				this.enemyList.push(newEnemy);
			}
			
			// Populate enemy level sets
			for each (var levelData : XML in enemyXMLData.child('LEVEL_SETS').children()) {
				var newLevelSet : Array = [];
				for each (var enemy : XML in levelData.children()) {
					newLevelSet.push(enemy.toString());
				}
				this.levelList.push(newLevelSet);
			}
		}
		
		public function getEnemyByName(targetName : String) : TinyStatsEntity
		{
			TinyLogManager.log('getEnemyByName: ' + targetName, this);
			
			// Find function
			var findFunction : Function = function(item : *, index : int, array : Array) : Boolean
				{ index; array; return (TinyStatsEntity(item).name == targetName); };
				
			return this.enemyList.filter(findFunction)[0];
		}
		
		// Singleton
		public static function getInstance() : TinyEnemyDataList
		{
			return instance;
		}
	}
}
