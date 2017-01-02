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

	/**
	 * @author jeremyabel
	 */
	public class TinyBattleBallDisplay extends Sprite implements IShowHideObject
	{
		private var m_ballContainer : Sprite;
		private var m_trainer : TinyTrainer;
		private var m_isEnemy : Boolean;
		
		public function TinyBattleBallDisplay(trainer : TinyTrainer, isEnemy : Boolean = false)
		{
			m_trainer = trainer;
			m_isEnemy = isEnemy;
			
			// Make ball container sprite
			m_ballContainer = new Sprite();	
			m_ballContainer.x = 18;
			m_ballContainer.y = 1;
			
			var trainerBallContainer : Bitmap = new Bitmap(new TrainerBallsContainer());
			
			// Add 'em up
			this.addChild(trainerBallContainer);
			this.addChild(m_ballContainer);
			 						
			this.visible = false;
		}
		
		public function show() : void
		{
			var xOffset : int = 0;
			
			// Populate balls
			for each (var mon : TinyMon in m_trainer.squad)
			{
				var ballBitmapData : BitmapData;
				
				if (mon.currentHP > 0)
				{
					ballBitmapData = new BattleBallFull;
				}
				else
				{
					ballBitmapData = new BattleBallKO;	
				}
				
				var ballBitmap : Bitmap = new Bitmap(ballBitmapData);
				ballBitmap.x = xOffset;
				xOffset += ballBitmap.width + 1;
				
				m_ballContainer.addChild(ballBitmap);
			}
			
			this.visible = true;			
		}
		
		public function hide() : void
		{
			this.visible = false;
				
			// Remove all ball sprites
			for (var i : int = 0; i < m_ballContainer.numChildren; i++) 
			{
				m_ballContainer.removeChildAt(i);	
			}
		}
	}
}
