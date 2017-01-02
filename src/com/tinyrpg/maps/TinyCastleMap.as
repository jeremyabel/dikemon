package com.tinyrpg.maps 
{
	import com.greensock.TweenLite;
	import com.tinyrpg.core.TinyFieldMap;
	import com.tinyrpg.data.TinyEventFlagData;
	import com.tinyrpg.display.TinyMapMovieClip;
	import com.tinyrpg.display.maps.Map_Castle_Entrance;
	import com.tinyrpg.utils.TinyLogManager;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author jeremyabel
	 */
	public class TinyCastleMap extends TinyMapMovieClip 
	{
		private var mapClip : TinyMapMovieClip;
		
		public var BG		: TinyCastleMapBG;
		public var event	: String = 'introduction';
		public var HIT_OPEN	: MovieClip;
		public var doors	: MovieClip;
		
		public function TinyCastleMap() : void
		{
			this.mapClip  = new Map_Castle_Entrance;
			this.OVERLAY  = this.mapClip.OVERLAY;
			this.HIT 	  = this.mapClip.HIT;
			this.OBJECTS  = this.mapClip.OBJECTS;
			this.PROPS 	  = new MovieClip;
			this.MAP	  = new MovieClip;
			this.HIT_OPEN = MovieClip(this.mapClip.getChildByName('HIT_OPEN'));
			this.doors    = MovieClip(this.OBJECTS.getChildByName('EVENT_DOORS'));
			
			// Add BG to MAP
			this.BG = new TinyCastleMapBG;
			this.BG.play();
			this.BG.x = 160;
			this.BG.y = 160;
			this.MAP.addChild(this.BG);
			this.MAP.addChild(this.mapClip.MAP);
			
			// Close or open the door
			if (TinyEventFlagData.getInstance().getFlagByName('door_opened').value) {
				TinyLogManager.log('OPENING DOORS', this);
				this.doors.gotoAndStop(MovieClip(this.OBJECTS.getChildByName('EVENT_DOORS')).totalFrames);
				try { TinyFieldMap.collisionList.removeItem(this.doors); } catch (error : Error) { }
				this.HIT = this.HIT_OPEN;
			} else {
				this.doors.gotoAndStop(1);
			}
		}
		
		public function openDoor() : void
		{
			TinyLogManager.log('openDoor', this);
			
			// Play door animation
			this.doors.gotoAndPlay(1);
			TweenLite.delayedCall(this.doors.totalFrames, this.dispatchEvent, [new Event(Event.COMPLETE)], true);
			
			// Remove from collision list
			TinyFieldMap.collisionList.removeItem(this.doors);
			
			// Set new hit area
			this.HIT = this.HIT_OPEN;
		}
	}
}
