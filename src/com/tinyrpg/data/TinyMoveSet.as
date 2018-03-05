package com.tinyrpg.data 
{
	import com.tinyrpg.battle.TinyBattlePalette;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * @author jeremyabel
	 */
	public class TinyMoveSet 
	{
		private var m_move1 : TinyMoveData;
		private var m_move2 : TinyMoveData;
		private var m_move3 : TinyMoveData;
		private var m_move4 : TinyMoveData;
		
		private var m_oldestMoveIndex : int = 0;
		
		public var levelMoveSet : Array = [];
		
		public function get move1()	: TinyMoveData { return m_move1; }
		public function get move2()	: TinyMoveData { return m_move2; }
		public function get move3()	: TinyMoveData { return m_move3; }
		public function get move4()	: TinyMoveData { return m_move4; }
		
		public function TinyMoveSet() : void
		{
			this.levelMoveSet = new Array(100);
		}
		
		public static function newFromXML( xmlData : XML ) : TinyMoveSet
		{
			var newMoveSet : TinyMoveSet = new TinyMoveSet();
			
			var levelMoveStrings : Array = String(xmlData.child('MOVES').text()).split(';');
			for each (var moveString : String in levelMoveStrings) 
			{
				// Remove whitespace
				var regex : RegExp = /^\s*|\s*$/gim;
				moveString = moveString.replace(regex, '');
				
				// Separate level number and move name
				var separatedString : Array = moveString.split(':');
				var level : int = int(separatedString[0]);
				var moveName : String = separatedString[1];
				
				// Remove whitespace from move name
				moveName = moveName.replace(regex, '');
				
				// Replace underscores with spaces
				moveName = moveName.replace('_', ' ');
				
				// Get move object
				var newMove : TinyMoveData = TinyMoveDataList.getInstance().getMoveByName( moveName );
				
				// Initialize level moveset with empty array
				if (!newMoveSet.levelMoveSet[level])
				{
					newMoveSet.levelMoveSet[level] = [];
				}
				
				// Add to level moveset
				(newMoveSet.levelMoveSet[level] as Array).push( newMove );
			}
			
			return newMoveSet;
		}
	
		
		public function toJSON() : Object
		{
			var jsonObject : Object = {};
		
			if ( this.move1 ) jsonObject.move1 = this.move1.toJSON();
			if ( this.move2 ) jsonObject.move2 = this.move2.toJSON();
			if ( this.move3 ) jsonObject.move3 = this.move3.toJSON();
			if ( this.move4 ) jsonObject.move4 = this.move4.toJSON();
			
			return jsonObject;
		}
		
		public function logMoves() : void
		{
			TinyLogManager.log('logMoves: move 1 = ' + (m_move1 ? m_move1.name : '--'), this);
			TinyLogManager.log('logMoves: move 2 = ' + (m_move2 ? m_move2.name : '--'), this);
			TinyLogManager.log('logMoves: move 3 = ' + (m_move3 ? m_move3.name : '--'), this);
			TinyLogManager.log('logMoves: move 4 = ' + (m_move4 ? m_move4.name : '--'), this);
		}
		
		
		public function setMoves( move1 : TinyMoveData, move2 : TinyMoveData, move3 : TinyMoveData, move4 : TinyMoveData ) : void
		{
			TinyLogManager.log('setMoves', this);
			
			m_move1 = move1 ? TinyMoveData.newFromCopy( move1 ) : null;
			m_move2 = move2 ? TinyMoveData.newFromCopy( move2 ) : null;
			m_move3 = move3 ? TinyMoveData.newFromCopy( move3 ) : null;
			m_move4 = move4 ? TinyMoveData.newFromCopy( move4 ) : null;
		}
		
		
		public function setMovesFromJSON( jsonObject : Object ) : void
		{
			TinyLogManager.log( 'setMovesFromJSON', this );
			
			if ( jsonObject.move1 ) 
			{
				this.m_move1 = TinyMoveDataList.getInstance().getMoveByName( jsonObject.move1.name );
				this.m_move1.currentPP = jsonObject.move1.pp;
			}
			
			if ( jsonObject.move2 ) 
			{
				this.m_move2 = TinyMoveDataList.getInstance().getMoveByName( jsonObject.move2.name );
				this.m_move2.currentPP = jsonObject.move2.pp;
			}
			
			if ( jsonObject.move3 ) 
			{
				this.m_move3 = TinyMoveDataList.getInstance().getMoveByName( jsonObject.move3.name );
				this.m_move3.currentPP = jsonObject.move3.pp;
			}
			
			if ( jsonObject.move4 ) 
			{
				this.m_move4 = TinyMoveDataList.getInstance().getMoveByName( jsonObject.move4.name );
				this.m_move4.currentPP = jsonObject.move4.pp;
			}
			
			this.logMoves();
		}
		
		
		public function setMoveInSlot( move : TinyMoveData, slot : int ) : void
		{
			TinyLogManager.log('setMoveInSlot: ' + move.name + ' in slot ' + slot, this);
			
			if ( slot == 0 ) this.m_move1 = TinyMoveData.newFromCopy( move );
			if ( slot == 1 ) this.m_move2 = TinyMoveData.newFromCopy( move );
			if ( slot == 2 ) this.m_move3 = TinyMoveData.newFromCopy( move );
			if ( slot == 3 ) this.m_move4 = TinyMoveData.newFromCopy( move );
		}
		
		public function getSlotWithMove( move : TinyMoveData ) : int
		{
			if ( this.m_move1 && this.m_move1.name == move.name ) return 0;
			if ( this.m_move2 && this.m_move2.name == move.name ) return 1;
			if ( this.m_move3 && this.m_move3.name == move.name ) return 2;
			if ( this.m_move4 && this.m_move4.name == move.name ) return 3;
			return -1;
		}
		
		public function setMovesToLevel( level : int ) : void
		{						
			TinyLogManager.log('setMovesToLevel: ' + level, this);
			
			for (var i : int = 1; i <= level; i++)
			{
				if ( this.levelMoveSet[i] ) 
				{					
					for (var j : int = 0; j < (this.levelMoveSet[i] as Array).length; j++) 
					{
						var moveData : TinyMoveData = (this.levelMoveSet[i] as Array)[j];
												
						switch (m_oldestMoveIndex) 
						{
							case 0: m_move1 = TinyMoveData.newFromCopy( moveData ); break;
							case 1: m_move2 = TinyMoveData.newFromCopy( moveData ); break;
							case 2: m_move3 = TinyMoveData.newFromCopy( moveData ); break;
							case 3: m_move4 = TinyMoveData.newFromCopy( moveData ); break;
						}
						
						m_oldestMoveIndex = (m_oldestMoveIndex + 1) % 4;						
					}
				}
			}
		}
		
		public function getLearnedMovesAtLevel( level: int ) : Array
		{
			var learnedMoves : Array = [];
			var moveSetAtLevel : Array = this.levelMoveSet[ level ] as Array;
			
			if ( moveSetAtLevel )
			{
				for ( var i : int = 0; i < moveSetAtLevel.length; i++)
				{
					learnedMoves.push( moveSetAtLevel[i] );		
				}
			}
			
			return learnedMoves;
		}
		
		public function getFirstOpenMoveSlot() : int
		{
			if ( !this.move1 ) return 0;
			if ( !this.move2 ) return 1;
			if ( !this.move3 ) return 2;
			if ( !this.move4 ) return 3;
			return -1;	
		}
	
		public function getPPSum() : int
		{
			var ppSum : int = 0;
			if ( this.move1 ) ppSum += this.move1.currentPP;
			if ( this.move2 ) ppSum += this.move2.currentPP;
			if ( this.move3 ) ppSum += this.move3.currentPP;
			if ( this.move4 ) ppSum += this.move4.currentPP;
			
			return ppSum; 
		}
		
		public function loadAllMoveFXSprites( palette : TinyBattlePalette, isEnemy : Boolean ) : void
		{
			TinyLogManager.log('loadAllMoveFXSprites', this);
			
			if ( this.move1 ) this.move1.loadMoveFXAnimation( palette, isEnemy );
			if ( this.move2 ) this.move2.loadMoveFXAnimation( palette, isEnemy );
			if ( this.move3 ) this.move3.loadMoveFXAnimation( palette, isEnemy );
			if ( this.move4 ) this.move4.loadMoveFXAnimation( palette, isEnemy );
		}
		
		public function unloadAllMoveFXSprites() : void
		{
			TinyLogManager.log('unloadAllMoveFXSprites', this);
		}
	}
}
