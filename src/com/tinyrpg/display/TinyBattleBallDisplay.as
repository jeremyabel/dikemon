package com.tinyrpg.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.core.TinyTrainer;
	import com.tinyrpg.display.TrainerBallsContainer;
	import com.tinyrpg.display.BattleBallParalyzed;
	import com.tinyrpg.display.BattleBallFull;
	import com.tinyrpg.display.BattleBallKO;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * Display class for the trainer balls display used during battle.
	 * 
	 * The ball display is shown only at the start of the battle, and when switching mons.
	 * 
	 * @author jeremyabel
	 */
	public class TinyBattleBallDisplay extends Sprite implements IShowHideObject
	{
		private var m_ballContainer : Sprite;
		private var m_trainer : TinyTrainer;
		
		/**
		 * @param 	trainer		The trainer this display belongs to.
		 */
		public function TinyBattleBallDisplay( trainer : TinyTrainer )
		{
			m_trainer = trainer;
			
			// Make ball container sprite
			m_ballContainer = new Sprite();	
			m_ballContainer.x = 18;
			m_ballContainer.y = 1;
			
			var trainerBallContainer : Bitmap = new Bitmap( new TrainerBallsContainer() );
			
			// Add 'em up
			this.addChild( trainerBallContainer );
			this.addChild( m_ballContainer );
			 						
			this.visible = false;
		}
		
		public function show() : void
		{
			TinyLogManager.log("show: " + (this.m_trainer.isEnemy ? 'Enemy' : 'Player'), this);
			
			var xOffset : int = 0;
			
			// Populate balls
			for each ( var mon : TinyMon in m_trainer.squad )
			{
				// Healthy mons get a regular ball, dead ones are shown with an X'd-out ball
				var ballBitmap : Bitmap = new Bitmap( mon.currentHP > 0 ? new BattleBallFull : new BattleBallKO );
				
				ballBitmap.x = xOffset;
				xOffset += ballBitmap.width + 1;
				
				m_ballContainer.addChild( ballBitmap );
			}
			
			this.visible = true;			
		}
		
		public function hide() : void
		{
			TinyLogManager.log("hide: " + (this.m_trainer.isEnemy ? 'Enemy' : 'Player'), this);
			
			this.visible = false;
				
			// Remove all ball sprites
			for ( var i : int = 0; i < m_ballContainer.numChildren; i++ ) 
			{
				m_ballContainer.removeChildAt( i );	
			}
		}
	}
}
