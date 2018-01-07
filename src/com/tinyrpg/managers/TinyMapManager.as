package com.tinyrpg.managers 
{
	import com.tinyrpg.core.TinyFieldMap;
	import com.tinyrpg.data.TinyAppSettings;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.events.EventDispatcher;

	/**
	 * @author jeremyabel
	 */
	public class TinyMapManager extends EventDispatcher
	{
		private var m_currentMap : TinyFieldMap;
		
		private static var instance : TinyMapManager = new TinyMapManager();
		
		public function TinyMapManager() : void
		{
			
		}

		// Singleton
		public static function getInstance() : TinyMapManager
		{
			return instance;
		}
		
		public function set currentMap( value : TinyFieldMap ) : void
		{
			TinyLogManager.log( 'set currentMap', this );
			this.m_currentMap = value;
		}
		
		public function get currentMap() : TinyFieldMap
		{
			return this.m_currentMap;
		}
	}
}