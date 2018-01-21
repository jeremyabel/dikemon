package com.tinyrpg.lookup 
{
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	import com.tinyrpg.media.sfx.statusfx.*;
	import com.tinyrpg.display.status.player.*;
	import com.tinyrpg.display.status.enemy.*;	
	
	import com.tinyrpg.data.TinyStatusEffect;
	import com.tinyrpg.utils.TinyLogManager;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyStatusFXLookup 
	{	
		private static const SFX_BURN 		: Sound = new SFXBurn;
		private static const SFX_CONFUSION	: Sound = new SFXConfusion;
		private static const SFX_PARALYSIS	: Sound = new SFXParalysis;
		private static const SFX_POISON		: Sound = new SFXPoison;
		private static const SFX_SLEEP		: Sound = new SFXSleep;
		
		public static const SFX_HIT_SELF	: Sound = new SFXSelfHit;
		
		[Embed(source='../../../../bin/xml/StatusFX/player_burn.xml', mimeType='application/octet-stream')] 			public static const XML_Burn_Player: Class;
		[Embed(source='../../../../bin/xml/StatusFX/player_confused.xml', mimeType='application/octet-stream')] 		public static const XML_Confuse_Player: Class;
		[Embed(source='../../../../bin/xml/StatusFX/player_paralyzed.xml', mimeType='application/octet-stream')] 		public static const XML_Paralyze_Player: Class;
		[Embed(source='../../../../bin/xml/StatusFX/player_poison.xml', mimeType='application/octet-stream')] 			public static const XML_Poison_Player: Class;
		[Embed(source='../../../../bin/xml/StatusFX/player_sleep.xml', mimeType='application/octet-stream')] 			public static const XML_Sleep_Player: Class;
		
		[Embed(source='../../../../bin/xml/StatusFX/enemy_burn.xml', mimeType='application/octet-stream')] 				public static const XML_Burn_Enemy: Class;
		[Embed(source='../../../../bin/xml/StatusFX/enemy_confused.xml', mimeType='application/octet-stream')] 			public static const XML_Confuse_Enemy: Class;
		[Embed(source='../../../../bin/xml/StatusFX/enemy_paralyzed.xml', mimeType='application/octet-stream')] 		public static const XML_Paralyze_Enemy: Class;
		[Embed(source='../../../../bin/xml/StatusFX/enemy_poison.xml', mimeType='application/octet-stream')] 			public static const XML_Poison_Enemy: Class;
		[Embed(source='../../../../bin/xml/StatusFX/enemy_sleep.xml', mimeType='application/octet-stream')] 			public static const XML_Sleep_Enemy: Class;
		
		public static function getStatusFXXML( name : String, isEnemy : Boolean ) : XML
		{
			TinyLogManager.log('getStatusFXXML: ' + name, null);
			
			var newXMLBytes : ByteArray;
			
			switch ( name.toUpperCase() )
			{
				default:
				case TinyStatusEffect.BURN 		: newXMLBytes = ( isEnemy ? new XML_Burn_Enemy : new XML_Burn_Player ) as ByteArray; break;
				case TinyStatusEffect.CONFUSION	: newXMLBytes = ( isEnemy ? new XML_Confuse_Enemy : new XML_Confuse_Player ) as ByteArray; break;
				case TinyStatusEffect.PARALYSIS : newXMLBytes = ( isEnemy ? new XML_Paralyze_Enemy : new XML_Paralyze_Player ) as ByteArray; break;
				case TinyStatusEffect.POISON	: newXMLBytes = ( isEnemy ? new XML_Poison_Enemy : new XML_Poison_Player ) as ByteArray; break;
				case TinyStatusEffect.SLEEP		: newXMLBytes = ( isEnemy ? new XML_Sleep_Enemy : new XML_Sleep_Player ) as ByteArray; break;
			}
			
			var string : String = newXMLBytes.readUTFBytes( newXMLBytes.length );			
			return new XML( string );			
		}
		
		
		public static function getStatusFXSprite( name : String, isEnemy : Boolean ) : BitmapData
		{
			TinyLogManager.log('getMoveFXSprite: ' + name, null);
			
			var newSprite : BitmapData;
			
			switch ( name.toUpperCase() ) 
			{
				default:
				case TinyStatusEffect.BURN 		: newSprite = isEnemy ? new BurnEnemy : new BurnPlayer; break;
				case TinyStatusEffect.CONFUSION	: newSprite = isEnemy ? new ConfuseEnemy : new ConfusePlayer; break;
				case TinyStatusEffect.PARALYSIS : newSprite = isEnemy ? new ParalyzeEnemy : new ParalyzePlayer; break;
				case TinyStatusEffect.POISON	: newSprite = isEnemy ? new PoisonEnemy : new PoisonPlayer; break;
				case TinyStatusEffect.SLEEP		: newSprite = isEnemy ? new SleepEnemy : new SleepPlayer; break;
			}
			
			return newSprite;
		}
		
		public static function getStatusSFX( name : String ) : Sound
		{			
			TinyLogManager.log('getMoveSFX: ' + name, null);
			
			switch ( name.toUpperCase() ) 
			{
				default:						
				case TinyStatusEffect.BURN 		: return SFX_BURN; 
				case TinyStatusEffect.CONFUSION	: return SFX_CONFUSION;
				case TinyStatusEffect.PARALYSIS : return SFX_PARALYSIS;
				case TinyStatusEffect.POISON	: return SFX_POISON;
				case TinyStatusEffect.SLEEP		: return SFX_SLEEP;
			}
		}
	}
}
