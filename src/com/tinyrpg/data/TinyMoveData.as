package com.tinyrpg.data 
{
	import com.tinyrpg.core.TinyMon;
	import com.tinyrpg.battle.TinyBattlePalette;
	import com.tinyrpg.display.TinyMoveFXAnimation;
	import com.tinyrpg.utils.TinyMath;
	import com.tinyrpg.utils.TinyLogManager;

	/**
	 * Class which represents a single move that can be used in battle by a mon.
	 * 
	 * A move consists of a set of stats which govern how the move operates, and
	 * a {@link TinyMoveFXAnimation} reference which governs how the move animates
	 * on screen.
	 *  
	 * @author jeremyabel
	 */
	public class TinyMoveData 
	{
		private var m_name 				: String = '-';
		private var m_description 		: String;
		private var m_basePower 		: int;
		private var m_accuracy 			: int;
		private var m_effectAccuracy 	: int;
		private var m_pp 				: int;
		private var m_currentPP			: int;
		private var m_type 				: TinyType;
		private var m_priority 			: int;
		private var m_effects			: Array = [];
		private var m_numHits			: int = 1;
		private var m_target			: String;
		private var m_fxScreenInverts	: String;
		private var m_fxScreenShake		: String;
		private var m_fxAnimDistortion	: String;
		private var m_fxPaletteEffect	: String;
		private var m_uselessText		: String;
	
		public var moveFXSAnimation		: TinyMoveFXAnimation;
		
		public function get name() 			 	: String { return m_name; }
		public function get description() 	 	: String { return m_description; }
		public function get basePower() 	 	: int { return m_basePower; }
		public function get accuracy() 		 	: int { return m_accuracy; }
		public function get effectAccuracy() 	: int { return m_effectAccuracy; }
		public function get maxPP() 			: int { return m_pp; }
		public function get currentPP()			: int { return m_currentPP; }
		public function get type() 				: TinyType { return m_type; }
		public function get priority() 		 	: int { return m_priority; }
		public function get numHits() 		 	: int { return m_numHits; }
		public function get effects() 		 	: Array { return m_effects; }
		public function get targetsSelf()		: Boolean { return m_target == 'SELF'; }
		public function get fxScreenInverts()	: String { return m_fxScreenInverts; }
		public function get fxScreenShake()		: String { return m_fxScreenShake; }
		public function get fxAnimDistortion()	: String { return m_fxAnimDistortion; }
		public function get fxPaletteEffect()	: String { return m_fxPaletteEffect; }
		
		public function get uselessText() : String 
		{ 
			var commaReplacePattern : RegExp = /\|/;
			return m_uselessText.replace( commaReplacePattern, ',' ); 
		}
		
		// Special attack for use when a mon hurts itself in confusion
		public static var CONFUSION_ATTACK : TinyMoveData = new TinyMoveData( 'CONFUSION HIT', '', 40, 0, 0, 10, TinyType.NORMAL, 0, 'SELF', [ TinyMoveEffect.HIT ] );
		
		// Special attack for use when a mon is all out of moves
		public static var STRUGGLE_ATTACK : TinyMoveData = new TinyMoveData( 'STRUGGLE', '', 50, 0, 0, 10, TinyType.NORMAL, 0, 'ENEMY', [ TinyMoveEffect.HIT, TinyMoveEffect.RECOIL ] );

		/**
		 * @param	name				The move's name.
		 * @param	description			The move's description.
		 * @param	basePower			The move's base power.
		 * @param	accuracy			The move's accuracy.
		 * @param	effectAccuracy		The move's secondary effect accuray.
		 * @param	pp					The move's max PP value.
		 * @param	type				The move's type.
		 * @param	priority			The move's speed priority.
		 * @param	target				The move's target, either "SELF" or "ENEMY".
		 * @param	effects				An array of secondary effects specified in {@link TinyMoveEffect}.
		 * @param	fxScreenInverts		String specifying fx animation screen inverts. See {@link TinyMoveFXScreenInvert}.
		 * @param	fxScreenShake		String specifying fx animation screen shakes. See {@link TinyMoveFXScreenShake}.
		 * @param	fxAnimDistortion	String specifying fx animation distortion effects. See {@link TinyMoveFXDistortionEffect}.
		 * @param	fxPaletteEffect		String specifying fx animation palette effects. See {@link TinyMoveFXPaletteEffect}.
		 * @param	uselessText			String specifying any extra text to be shown when the move is used.
		 */
		public function TinyMoveData(
			name : String,
			description : String,
			basePower : int,
			accuracy : int,
			effectAccuracy : int,
			pp : int,
			type : TinyType,
			priority : int,
			target : String,
			effects : Array,
			fxScreenInverts : String = '',
			fxScreenShake : String = '',
			fxAnimDistortion : String = '',
			fxPaletteEffect : String = '',
			uselessText : String = '' )  
		{
			m_name = name.toUpperCase();
			m_description = description;
			m_basePower = basePower;
			m_accuracy = accuracy;
			m_effectAccuracy = effectAccuracy;
			m_pp = pp;
			m_currentPP = m_pp;
			m_type = type;
			m_priority = priority;
			m_target = target;
			m_effects = effects; 
			m_fxScreenInverts = fxScreenInverts;
			m_fxScreenShake = fxScreenShake;
			m_fxAnimDistortion = fxAnimDistortion;
			m_fxPaletteEffect = fxPaletteEffect;
			m_uselessText = uselessText;
		}

		/**
		 * Static function which returns a new TinyMoveData generated by the given XML data.
		 * See Moves.xml for the formatting schema.
		 */
		public static function newFromXML( xmlData : XML ) : TinyMoveData
		{
			// Parse move effects list
			var moveEffectsListString : String = xmlData.child( 'EFFECT' );
			var moveEffectsList : Array = moveEffectsListString.split( ' ' );
			var moveEffectsArray : Array = [];
			
			for each ( var moveEffectString : String in moveEffectsList )
			{
				var moveEffect : TinyMoveEffect = TinyMoveEffect.getEffectByName( moveEffectString );
					
				// Print missing move effects
				if ( moveEffect ) {
					moveEffectsArray.push( moveEffect );	
				} else { 
					trace( '======= MISSING ATTACK EFFECT: ' + moveEffectString + ' =======' );
				}
			}
			
			// Return new move data using the XML 
			return new TinyMoveData(
				xmlData.child( 'ORIG_MOVE_NAME' ),
				xmlData.child( 'DESCRIPTION' ),
				int( xmlData.child( 'POWER' ).text() ),
				int( xmlData.child( 'ACC' ).text() ),
				int( xmlData.child( 'EFFECT_ACC' ).text()),
				int( xmlData.child( 'PP' ).text()),
				TinyType.getTypeFromString( xmlData.child( 'TYPE' ) ),
				int( xmlData.child( 'PRIORITY' ).text() ),
				xmlData.child( 'TARGET' ),
				moveEffectsArray,
				xmlData.child( 'SCREEN_INVERT' ),
				xmlData.child( 'SCREEN_SHAKE' ),
				xmlData.child( 'ANIM_DISTORTION_EFFECT' ),
				xmlData.child( 'ANIM_PALETTE_EFFECT' ),
				xmlData.child( 'USELESS_TEXT' )
			);	
		}
		
		/**
		 * Static function which returns a deep copy of the given move.
		 */
		public static function newFromCopy( target : TinyMoveData ) : TinyMoveData
		{
			if ( !target ) return null;
			
			return new TinyMoveData(
				TinyMath.deepCopyString( target.name ),
				TinyMath.deepCopyString( target.description ),
				TinyMath.deepCopyInt( target.basePower ),
				TinyMath.deepCopyInt( target.accuracy ),
				TinyMath.deepCopyInt( target.effectAccuracy ),
				TinyMath.deepCopyInt( target.maxPP ),
				TinyType.getTypeFromString( TinyMath.deepCopyString( target.type.name ) ),
				TinyMath.deepCopyInt( target.priority ),
				TinyMath.deepCopyString( target.targetsSelf ? 'SELF' : 'ENEMY' ),
				target.effects,
				TinyMath.deepCopyString( target.fxScreenInverts ),
				TinyMath.deepCopyString( target.fxScreenShake ),
				TinyMath.deepCopyString( target.fxAnimDistortion ),
				TinyMath.deepCopyString( target.fxPaletteEffect ),
				TinyMath.deepCopyString( target.uselessText )
			);
		}
		
		/**
		 * Serializes this move to a JSON object.
		 * Used when creating game save data.
		 */
		public function toJSON() : Object
		{
			var jsonObject : Object = {};
			
			// The only things we need to save are the move's name and the current PP.
			jsonObject.name = this.name;
			jsonObject.pp = this.currentPP;
			
			return jsonObject;
		}
		
		public function loadMoveFXAnimation( palette : TinyBattlePalette, isEnemy : Boolean ) : void
		{
			TinyLogManager.log( 'loadMoveFXSprite: ' + this.name + ', isEnemy: ' + isEnemy, this );
			this.moveFXSAnimation = new TinyMoveFXAnimation( this, isEnemy, palette );
		}
		
		public function unloadMoveFXAnimation() : void
		{
			// TODO: implement unloadMoveFXAnimation() 
			TinyLogManager.log( 'unloadMoveFXAnimation', this );
		}

		/**
		 * Returns true if this move is super-effective versus an array of {@link TinyType}s. 
		 */		
		public function isSuperEffectiveVs( types : Array ) : Boolean
		{	
			// Moves with the USELESS_TEXT effect are never effective
			if ( this.hasEffect( TinyMoveEffect.USELESS_TEXT ) ) return false;
			
			var effectiveness : Number = 1;
			for each ( var targetType : TinyType in types )
			{	
				if ( targetType.name != (types[0] as TinyType).name ) 
				{
					effectiveness *= this.type.getMatchupValueVersus( targetType );
				}	
			}
			
			return effectiveness > 1;
		}
		
		/**
		 * Returns true if this move is not effective versus an array of {@link TinyType}s.
		 */
		public function isNotEffectiveVs( types : Array ) : Boolean
		{
			// Moves with the USELESS_TEXT effect are always not effective
			if ( this.hasEffect( TinyMoveEffect.USELESS_TEXT ) ) return true;
			
			var effectiveness : Number = 1;
			for each ( var targetType : TinyType in types )
			{
				if ( targetType.name != (types[0] as TinyType).name ) 
				{
					effectiveness *= this.type.getMatchupValueVersus( targetType );
				}	
			}
			
			return effectiveness < 1;	
		}
		
		/**
		 * Reduces the PP of this move by a given amount.
		 */
		public function deductPP( amount : int ) : void
		{
			TinyLogManager.log('deductPP: ' + amount, this);
			this.m_currentPP = Math.max(0, this.m_currentPP - amount);
		}
		
		/**
		 * Restores the PP of this move by a given amount.
		 */
		public function recoverPP( amount : int ) : void
		{
			TinyLogManager.log('recoverPP: ' + amount, this);
			this.m_currentPP = Math.min( this.m_currentPP + amount, this.maxPP );
		}
		
		/**
		 * Restores all PP to this move.
		 */
		public function recoverAllPP() : void
		{
			TinyLogManager.log('recoverAllPP', this);
			this.m_currentPP = this.maxPP;
		}
		
		/**
		 * Sets the current PP of this move to a given value.
		 */
		public function set currentPP( value : int ) : void 
		{
			var ppValue : int = value;
			
			if ( !value ) 
			{
				ppValue = this.maxPP;	
			}
			
			TinyLogManager.log( this.name + ' set current PP: ' + ppValue, this ); 
			this.m_currentPP = ppValue; 
		} 
		
		/**
		 * Returns true if this move is at max PP.
		 */
		public function get isMaxPP() : Boolean
		{
			return this.m_currentPP == this.maxPP;
		}
		
		/**
		 * Returns true if this move uses a given {@link TinyMoveEffect}.
		 */
		public function hasEffect( effect : TinyMoveEffect ) : Boolean
		{
			return this.m_effects.indexOf( effect ) > -1;
		}
		
		/**
		 * Returns an array of this move's damage-dealing {@link TinyMoveEffect}s. 
		 */
		public function getDamageEffects() : Array
		{
			return this.m_effects.filter( TinyMoveEffect.isDamageEffect );
		}
		
		/**
		 * Returns an array of this move's stat-modifying {@link TinyMoveEffect}s.
		 */
		public function getStatModEffects() : Array
		{
			return this.m_effects.filter( TinyMoveEffect.isStatModEffect );
		}
		
		/**
		 * Returns an array of this move's status-effect-causing {@link TinyMoveEffect}s.
		 */
		public function getStatusEffects() : Array
		{
			return this.m_effects.filter( TinyMoveEffect.isStatusEffect );	
		}
		
		/**
		 * Returns an array of this move's miscellanious {@link TinyMoveEffect}s.
		 */
		public function getMiscEffects() : Array
		{
			return this.m_effects.filter( TinyMoveEffect.isMiscEffect );
		}
	}
}
