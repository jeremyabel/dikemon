package com.tinyrpg.managers 
{
	import com.tinyrpg.core.TinyFieldMap;
	import com.tinyrpg.data.TinyAppSettings;
	import com.tinyrpg.display.TinyMapCameraContainer;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	/**
	 * @author jeremyabel
	 */
	public class TinyMapManager extends EventDispatcher
	{
		private static var instance : TinyMapManager = new TinyMapManager();
		
		private var m_currentMap : TinyFieldMap;
		
		public var mapContainer : Sprite;
		
		public function TinyMapManager() : void
		{
			this.mapContainer = new Sprite();
		}

		// Singleton
		public static function getInstance() : TinyMapManager
		{
			return instance;
		}
		
		public function updateCamera( x : int, y : int ) : void
		{
			this.m_currentMap.x = -x + ( 160 / 2 ) - 8;
			this.m_currentMap.y = -y + ( 144 / 2 ) - 8;
		}
		
		public function set currentMap( value : TinyFieldMap ) : void
		{
			TinyLogManager.log( 'set currentMap', this );
			this.m_currentMap = value;
			this.mapContainer.addChild( this.m_currentMap );
		}
		
		public function get currentMap() : TinyFieldMap
		{
			return this.m_currentMap;
		}
		
	}
}