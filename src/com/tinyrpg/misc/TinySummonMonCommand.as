package com.tinyrpg.misc 
{
	import com.tinyrpg.display.TinyMonContainer;
	import com.tinyrpg.core.TinyMon;

	/**
	 * @author jeremyabel
	 */
	public class TinySummonMonCommand
	{		
		public var mon : TinyMon;
		public var monContainer : TinyMonContainer;
		
		public function TinySummonMonCommand( mon : TinyMon, monContainer : TinyMonContainer )
		{
			this.mon = mon;
			this.monContainer = monContainer;
		}
	}
}