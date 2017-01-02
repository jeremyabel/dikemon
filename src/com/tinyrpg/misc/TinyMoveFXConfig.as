package com.tinyrpg.misc 
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import com.tinyrpg.display.attacks.player.*;
	
	import com.tinyrpg.utils.TinyLogManager;
	
	/**
	 * @author jeremyabel
	 */
	public class TinyMoveFXConfig 
	{
		private static const MOVE_ABSORB 				: String = 'ABSORB';
		private static const MOVE_AGILITY 				: String = 'AGILITY';
		private static const MOVE_ANCIENT_POWER 		: String = 'ANCIENT POWER';
		private static const MOVE_ASTONISH				: String = 'ASTONISH';
		private static const MOVE_BITE 					: String = 'BITE';
		private static const MOVE_BLAZE_KICK 			: String = 'BLAZE KICK';
		private static const MOVE_BUBBLE 				: String = 'BUBBLE';
		private static const MOVE_BULK_UP		 		: String = 'BULK UP';
		private static const MOVE_CLAMP 				: String = 'CLAMP';
		private static const MOVE_CONFUSE_RAY			: String = 'CONFUSE RAY';
		private static const MOVE_CONFUSION 			: String = 'CONFUSION';
		private static const MOVE_COSMIC_POWER 			: String = 'COSMIC POWER';
		private static const MOVE_DETECT 				: String = 'DETECT';
		private static const MOVE_DOUBLE_EDGE 			: String = 'DOUBLE EDGE';
		private static const MOVE_DOUBLE_KICK 			: String = 'DOUBLE KICK';
		private static const MOVE_DRAGON_BREATH 		: String = 'DRAGON BREATH';
		private static const MOVE_DRAGON_DANCE 			: String = 'DRAGON DANCE';
		private static const MOVE_DREAM_EATER 			: String = 'DREAM EATER';
		private static const MOVE_DYNAMIC_PUNCH 		: String = 'DYNAMIC PUNCH';
		private static const MOVE_EMBER 				: String = 'EMBER';
		private static const MOVE_EXPLOSION 			: String = 'EXPLOSION';
		private static const MOVE_FAKE_OUT 				: String = 'FAKE OUT';
		private static const MOVE_FAKE_TEARS			: String = 'FAKE TEARS';
		private static const MOVE_FALSE_SWIPE 			: String = 'FALSE SWIPE';
		private static const MOVE_FEINT_ATTACK 			: String = 'FEINT ATTACK';
		private static const MOVE_FIRE_PUNCH 			: String = 'FIRE PUNCH';
		private static const MOVE_FLAMETHROWER 			: String = 'FLAMETHROWER';
		private static const MOVE_FOCUS_ENERGY 			: String = 'FOCUS ENERGY';
		private static const MOVE_FURY_SWIPES 			: String = 'FURY SWIPES';
		private static const MOVE_GROWL 				: String = 'GROWL';
		private static const MOVE_HEAL_BELL 			: String = 'HEAL BELL';
		private static const MOVE_HOWL					: String = 'HOWL';
		private static const MOVE_HYDRO_PUMP 			: String = 'HYDRO PUMP';
		private static const MOVE_HYPER_BEAM 			: String = 'HYPER BEAM';
		private static const MOVE_HYPNOSIS				: String = 'HYPNOSIS';
		private static const MOVE_IRON_DEFENSE			: String = 'IRON DEFENSE'; // Use first half of METAL CLAW, 2x
		private static const MOVE_KARATE_CHOP 			: String = 'KARATE CHOP';
		private static const MOVE_LEAF_BLADE			: String = 'LEAF BLADE';
		private static const MOVE_LEER 					: String = 'LEER';
		private static const MOVE_LICK 					: String = 'LICK';
		private static const MOVE_LOW_KICK 				: String = 'LOW KICK';
		private static const MOVE_LUSTER_PURGE			: String = 'LUSTER PURGE';
		private static const MOVE_MEAN_LOOK 			: String = 'MEAN LOOK';
		private static const MOVE_MEGA_PUNCH 			: String = 'MEGA PUNCH';
		private static const MOVE_METAL_CLAW 			: String = 'METAL CLAW';
		private static const MOVE_METEOR_MASH			: String = 'METEOR MASH';
		private static const MOVE_METRONOME 			: String = 'METRONOME';
		private static const MOVE_MUD_SLAP 				: String = 'MUD SLAP';
		private static const MOVE_MUD_SPORT				: String = 'MUD SPORT'; // Hydro Pump, but brown
		private static const MOVE_MUDDY_WATER			: String = 'MUDDY WATER';
		private static const MOVE_NIGHT_SHADE			: String = 'NIGHT SHADE';
		private static const MOVE_POUND 				: String = 'POUND';
		private static const MOVE_PROTECT 				: String = 'PROTECT';
		private static const MOVE_PSYCHIC				: String = 'PSYCHIC';
		private static const MOVE_PSYWAVE				: String = 'PSYWAVE';
		private static const MOVE_QUICK_ATTACK 			: String = 'QUICK ATTACK';
		private static const MOVE_RAIN_DANCE 			: String = 'RAIN DANCE';
		private static const MOVE_RAPID_SPIN 			: String = 'RAPID SPIN';
		private static const MOVE_RECOVER 				: String = 'RECOVER';
		private static const MOVE_REFRESH				: String = 'REFRESH';
		private static const MOVE_REST					: String = 'REST';
		private static const MOVE_SAFEGUARD 			: String = 'SAFEGUARD';
		private static const MOVE_SAND_ATTACK 			: String = 'SAND ATTACK';
		private static const MOVE_SCARY_FACE 			: String = 'SCARY FACE';
		private static const MOVE_SCRATCH 				: String = 'SCRATCH';
		private static const MOVE_SCREECH 				: String = 'SCREECH';
		private static const MOVE_SELF_DESTRUCT 		: String = 'SELF-DESTRUCT';
		private static const MOVE_SLAM 					: String = 'SLAM';
		private static const MOVE_SLASH 				: String = 'SLASH';
		private static const MOVE_SMOG 					: String = 'SMOG';
		private static const MOVE_SMOKESCREEN 			: String = 'SMOKESCREEN';
		private static const MOVE_SNORE 				: String = 'SNORE';
		private static const MOVE_SPITE 				: String = 'SPITE';
		private static const MOVE_STRUGGLE 				: String = 'STRUGGLE';
		private static const MOVE_SUBMISSION			: String = 'SUBMISSION';
		private static const MOVE_SUPERSONIC 			: String = 'SUPERSONIC';
		private static const MOVE_SWIFT 				: String = 'SWIFT';
		private static const MOVE_TACKLE 				: String = 'TACKLE';
		private static const MOVE_TAIL_WHIP				: String = 'TAIL WHIP';
		private static const MOVE_TAKE_DOWN 			: String = 'TAKE-DOWN';
		private static const MOVE_THRASH 				: String = 'THRASH';
		private static const MOVE_THUNDER 				: String = 'THUNDER';
		private static const MOVE_THUNDER_SHOCK 		: String = 'THUNDER SHOCK';
		private static const MOVE_TWISTER 				: String = 'TWISTER';
		private static const MOVE_WATER_GUN 			: String = 'WATER GUN';
		private static const MOVE_WATER_PULSE			: String = 'WATER PULSE';
		private static const MOVE_WATER_SPORT			: String = 'WATER SPORT'; 
		private static const MOVE_WING_ATTACK 			: String = 'WING ATTACK';
		private static const MOVE_WISH					: String = 'WISH';

		[Embed(source='../../../../bin/xml/MoveFX/player_absorb.xml', mimeType='application/octet-stream')] 			public static const XML_Absorb_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_agility.xml', mimeType='application/octet-stream')] 			public static const XML_Agility_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_ancient_power.xml', mimeType='application/octet-stream')] 		public static const XML_Ancient_Power_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_bite.xml', mimeType='application/octet-stream')] 				public static const XML_Bite_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_blaze_kick.xml', mimeType='application/octet-stream')] 		public static const XML_Blaze_Kick_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_bubble.xml', mimeType='application/octet-stream')] 			public static const XML_Bubble_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_clamp.xml', mimeType='application/octet-stream')] 				public static const XML_Clamp_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_confuse_ray.xml', mimeType='application/octet-stream')] 		public static const XML_Confuse_Ray_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_confusion.xml', mimeType='application/octet-stream')] 			public static const XML_Confusion_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_detect.xml', mimeType='application/octet-stream')] 			public static const XML_Detect_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_double_edge.xml', mimeType='application/octet-stream')] 		public static const XML_Double_Edge_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_double_kick.xml', mimeType='application/octet-stream')] 		public static const XML_Double_Kick_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_dragon_breath.xml', mimeType='application/octet-stream')] 		public static const XML_Dragon_Breath_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_dream_eater.xml', mimeType='application/octet-stream')] 		public static const XML_Dream_Eater_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_dynamic_punch.xml', mimeType='application/octet-stream')] 		public static const XML_Dynamic_Punch_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_ember.xml', mimeType='application/octet-stream')] 				public static const XML_Ember_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_explosion.xml', mimeType='application/octet-stream')] 			public static const XML_Explosion_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_feint_attack.xml', mimeType='application/octet-stream')] 		public static const XML_False_Swipe_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_bubble.xml', mimeType='application/octet-stream')] 			public static const XML_Feint_Attack_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_fire_punch.xml', mimeType='application/octet-stream')] 		public static const XML_Fire_Punch_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_flamethrower.xml', mimeType='application/octet-stream')] 		public static const XML_Flamethrower_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_focus_energy.xml', mimeType='application/octet-stream')] 		public static const XML_Focus_Energy_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_fury_swipes.xml', mimeType='application/octet-stream')] 		public static const XML_Fury_Swipes_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_growl.xml', mimeType='application/octet-stream')] 				public static const XML_Growl_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_heal_bell.xml', mimeType='application/octet-stream')] 			public static const XML_Heal_Bell_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_hydro_pump.xml', mimeType='application/octet-stream')] 		public static const XML_Hydro_Pump_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_hyper_beam.xml', mimeType='application/octet-stream')] 		public static const XML_Hyper_Beam_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_hypnosis.xml', mimeType='application/octet-stream')] 			public static const XML_Hypnosis_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_karate_chop.xml', mimeType='application/octet-stream')] 		public static const XML_Karate_Chop_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_leaf_blade.xml', mimeType='application/octet-stream')] 		public static const XML_Leaf_Blade_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_leer.xml', mimeType='application/octet-stream')] 				public static const XML_Leer_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_lick.xml', mimeType='application/octet-stream')] 				public static const XML_Lick_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_low_kick.xml', mimeType='application/octet-stream')] 			public static const XML_Low_Kick_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_mean_look.xml', mimeType='application/octet-stream')] 			public static const XML_Mean_Look_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_mega_punch.xml', mimeType='application/octet-stream')] 		public static const XML_Mega_Punch_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_metal_claw.xml', mimeType='application/octet-stream')] 		public static const XML_Metal_Claw_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_metronome.xml', mimeType='application/octet-stream')] 			public static const XML_Metronome_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_mud_slap.xml', mimeType='application/octet-stream')] 			public static const XML_Mud_Slap_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_muddy_water.xml', mimeType='application/octet-stream')] 		public static const XML_Muddy_Water_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_night_shade.xml', mimeType='application/octet-stream')] 		public static const XML_Night_Shade_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_pound.xml', mimeType='application/octet-stream')] 				public static const XML_Pound_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_protect.xml', mimeType='application/octet-stream')] 			public static const XML_Protect_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_psychic.xml', mimeType='application/octet-stream')] 			public static const XML_Psychic_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_psywave.xml', mimeType='application/octet-stream')] 			public static const XML_Psywave_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_quick_attack.xml', mimeType='application/octet-stream')] 		public static const XML_Quick_Attack_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_rain_dance.xml', mimeType='application/octet-stream')] 		public static const XML_Rain_Dance_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_rapid_spin.xml', mimeType='application/octet-stream')] 		public static const XML_Rapid_Spin_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_recover.xml', mimeType='application/octet-stream')] 			public static const XML_Recover_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_rest.xml', mimeType='application/octet-stream')] 				public static const XML_Rest_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_safeguard.xml', mimeType='application/octet-stream')] 			public static const XML_Safeguard_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_sand_attack.xml', mimeType='application/octet-stream')] 		public static const XML_Sand_Attack_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_scary_face.xml', mimeType='application/octet-stream')] 		public static const XML_Scary_Face_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_scratch.xml', mimeType='application/octet-stream')] 			public static const XML_Scratch_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_screech.xml', mimeType='application/octet-stream')] 			public static const XML_Screech_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_self_destruct.xml', mimeType='application/octet-stream')] 		public static const XML_Self_Destruct_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_slam.xml', mimeType='application/octet-stream')] 				public static const XML_Slam_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_slash.xml', mimeType='application/octet-stream')] 				public static const XML_Slash_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_smog.xml', mimeType='application/octet-stream')] 				public static const XML_Smog_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_smokescreen.xml', mimeType='application/octet-stream')] 		public static const XML_Smokescreen_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_snore.xml', mimeType='application/octet-stream')] 				public static const XML_Snore_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_spite.xml', mimeType='application/octet-stream')] 				public static const XML_Spite_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_struggle.xml', mimeType='application/octet-stream')] 			public static const XML_Struggle_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_submission.xml', mimeType='application/octet-stream')] 		public static const XML_Submission_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_supersonic.xml', mimeType='application/octet-stream')] 		public static const XML_Supersonic_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_swift.xml', mimeType='application/octet-stream')] 				public static const XML_Swift_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_tackle.xml', mimeType='application/octet-stream')] 			public static const XML_Tackle_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_tail_whip.xml', mimeType='application/octet-stream')] 			public static const XML_Tail_Whip_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_take_down.xml', mimeType='application/octet-stream')] 			public static const XML_Take_Down_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_thrash.xml', mimeType='application/octet-stream')] 			public static const XML_Thrash_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_thunder.xml', mimeType='application/octet-stream')] 			public static const XML_Thunder_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_thundershock.xml', mimeType='application/octet-stream')] 		public static const XML_Thundershock_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_twister.xml', mimeType='application/octet-stream')] 			public static const XML_Twister_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_water_gun.xml', mimeType='application/octet-stream')] 			public static const XML_Water_Gun_Player : Class;
//		[Embed(source='../../../../bin/xml/MoveFX/player_water_sport.xml', mimeType='application/octet-stream')] 		public static const XML_Water_Sport_Player : Class;
		[Embed(source='../../../../bin/xml/MoveFX/player_wing_attack.xml', mimeType='application/octet-stream')] 		public static const XML_Wing_Attack_Player : Class;
		
		public static function getMoveFXXML( name: String, isEnemy : Boolean ) : XML
		{
			TinyLogManager.log('getMoveFXXML: ' + name, null);
			
			var newXMLBytes : ByteArray;
			
			switch ( name.toUpperCase() )
			{
				default:
				case MOVE_ABSORB 			: newXMLBytes = ( isEnemy ? new XML_Absorb_Player : new XML_Absorb_Player ) as ByteArray; break;
				case MOVE_AGILITY 			: newXMLBytes = ( isEnemy ? new XML_Agility_Player : new XML_Agility_Player ) as ByteArray; break;
				case MOVE_ANCIENT_POWER 	: newXMLBytes = ( isEnemy ? new XML_Ancient_Power_Player : new XML_Ancient_Power_Player ) as ByteArray; break;
				case MOVE_BITE 				: newXMLBytes = ( isEnemy ? new XML_Bite_Player : new XML_Bite_Player ) as ByteArray; break;
				case MOVE_BLAZE_KICK 		: newXMLBytes = ( isEnemy ? new XML_Blaze_Kick_Player : new XML_Blaze_Kick_Player ) as ByteArray; break;
				case MOVE_BUBBLE 			: newXMLBytes = ( isEnemy ? new XML_Bubble_Player : new XML_Bubble_Player ) as ByteArray; break;
				case MOVE_CLAMP 			: newXMLBytes = ( isEnemy ? new XML_Clamp_Player : new XML_Clamp_Player ) as ByteArray; break;
				case MOVE_CONFUSE_RAY 		: newXMLBytes = ( isEnemy ? new XML_Confuse_Ray_Player : new XML_Confuse_Ray_Player ) as ByteArray; break;
				case MOVE_CONFUSION 		: newXMLBytes = ( isEnemy ? new XML_Confusion_Player : new XML_Confusion_Player ) as ByteArray; break;
				case MOVE_DETECT 			: newXMLBytes = ( isEnemy ? new XML_Detect_Player : new XML_Detect_Player ) as ByteArray; break;
				case MOVE_DOUBLE_EDGE 		: newXMLBytes = ( isEnemy ? new XML_Double_Edge_Player : new XML_Double_Edge_Player ) as ByteArray; break;
				case MOVE_DOUBLE_KICK 		: newXMLBytes = ( isEnemy ? new XML_Double_Kick_Player : new XML_Double_Kick_Player ) as ByteArray; break;
				case MOVE_DRAGON_BREATH 	: newXMLBytes = ( isEnemy ? new XML_Dragon_Breath_Player : new XML_Dragon_Breath_Player ) as ByteArray; break;
				case MOVE_DREAM_EATER 		: newXMLBytes = ( isEnemy ? new XML_Dream_Eater_Player : new XML_Dream_Eater_Player ) as ByteArray; break;
				case MOVE_DYNAMIC_PUNCH 	: newXMLBytes = ( isEnemy ? new XML_Dynamic_Punch_Player : new XML_Dynamic_Punch_Player ) as ByteArray; break;
				case MOVE_EMBER 			: newXMLBytes = ( isEnemy ? new XML_Ember_Player : new XML_Ember_Player ) as ByteArray; break;
				case MOVE_EXPLOSION 		: newXMLBytes = ( isEnemy ? new XML_Explosion_Player : new XML_Explosion_Player ) as ByteArray; break;
				case MOVE_FALSE_SWIPE 		: newXMLBytes = ( isEnemy ? new XML_False_Swipe_Player : new XML_False_Swipe_Player ) as ByteArray; break;
				case MOVE_FEINT_ATTACK 		: newXMLBytes = ( isEnemy ? new XML_Feint_Attack_Player : new XML_Feint_Attack_Player ) as ByteArray; break;
				case MOVE_FIRE_PUNCH 		: newXMLBytes = ( isEnemy ? new XML_Fire_Punch_Player : new XML_Fire_Punch_Player ) as ByteArray; break;
				case MOVE_FLAMETHROWER 		: newXMLBytes = ( isEnemy ? new XML_Flamethrower_Player : new XML_Flamethrower_Player ) as ByteArray; break;
				case MOVE_FOCUS_ENERGY		: newXMLBytes = ( isEnemy ? new XML_Focus_Energy_Player : new XML_Focus_Energy_Player ) as ByteArray; break;
				case MOVE_FURY_SWIPES		: newXMLBytes = ( isEnemy ? new XML_Fury_Swipes_Player : new XML_Fury_Swipes_Player ) as ByteArray; break;
				case MOVE_GROWL				: newXMLBytes = ( isEnemy ? new XML_Growl_Player : new XML_Growl_Player ) as ByteArray; break;
				case MOVE_HEAL_BELL			: newXMLBytes = ( isEnemy ? new XML_Heal_Bell_Player : new XML_Heal_Bell_Player ) as ByteArray; break;
				case MOVE_HOWL				: newXMLBytes = ( isEnemy ? new XML_Growl_Player : new XML_Growl_Player ) as ByteArray; break;
				case MOVE_HYDRO_PUMP 		: newXMLBytes = ( isEnemy ? new XML_Hydro_Pump_Player : new XML_Hydro_Pump_Player ) as ByteArray; break;
				case MOVE_HYPER_BEAM 		: newXMLBytes = ( isEnemy ? new XML_Hyper_Beam_Player : new XML_Hyper_Beam_Player ) as ByteArray; break;
				case MOVE_HYPNOSIS			: newXMLBytes = ( isEnemy ? new XML_Hypnosis_Player : new XML_Hypnosis_Player ) as ByteArray; break;
				case MOVE_KARATE_CHOP 		: newXMLBytes = ( isEnemy ? new XML_Karate_Chop_Player : new XML_Karate_Chop_Player ) as ByteArray; break;
				case MOVE_LEAF_BLADE 		: newXMLBytes = ( isEnemy ? new XML_Leaf_Blade_Player : new XML_Leaf_Blade_Player ) as ByteArray; break;
				case MOVE_LEER 				: newXMLBytes = ( isEnemy ? new XML_Leer_Player : new XML_Leer_Player ) as ByteArray; break;
				case MOVE_LICK 				: newXMLBytes = ( isEnemy ? new XML_Lick_Player : new XML_Lick_Player ) as ByteArray; break;
				case MOVE_LOW_KICK 			: newXMLBytes = ( isEnemy ? new XML_Low_Kick_Player : new XML_Low_Kick_Player ) as ByteArray; break;
				case MOVE_MEAN_LOOK 		: newXMLBytes = ( isEnemy ? new XML_Mean_Look_Player : new XML_Mean_Look_Player ) as ByteArray; break;
				case MOVE_MEGA_PUNCH 		: newXMLBytes = ( isEnemy ? new XML_Mega_Punch_Player : new XML_Mega_Punch_Player ) as ByteArray; break;
				case MOVE_METAL_CLAW 		: newXMLBytes = ( isEnemy ? new XML_Metal_Claw_Player : new XML_Metal_Claw_Player ) as ByteArray; break;
				case MOVE_METRONOME 		: newXMLBytes = ( isEnemy ? new XML_Metronome_Player : new XML_Metronome_Player ) as ByteArray; break;
				case MOVE_MUD_SLAP 			: newXMLBytes = ( isEnemy ? new XML_Mud_Slap_Player : new XML_Mud_Slap_Player ) as ByteArray; break;
				case MOVE_MUDDY_WATER 		: newXMLBytes = ( isEnemy ? new XML_Muddy_Water_Player : new XML_Muddy_Water_Player ) as ByteArray; break;
				case MOVE_NIGHT_SHADE 		: newXMLBytes = ( isEnemy ? new XML_Night_Shade_Player : new XML_Night_Shade_Player ) as ByteArray; break;
				case MOVE_POUND 			: newXMLBytes = ( isEnemy ? new XML_Pound_Player : new XML_Pound_Player ) as ByteArray; break;
				case MOVE_PROTECT 			: newXMLBytes = ( isEnemy ? new XML_Protect_Player : new XML_Protect_Player ) as ByteArray; break;
				case MOVE_PSYCHIC 			: newXMLBytes = ( isEnemy ? new XML_Psychic_Player : new XML_Psychic_Player ) as ByteArray; break;
				case MOVE_PSYWAVE 			: newXMLBytes = ( isEnemy ? new XML_Psywave_Player : new XML_Psywave_Player ) as ByteArray; break;
				case MOVE_QUICK_ATTACK 		: newXMLBytes = ( isEnemy ? new XML_Quick_Attack_Player : new XML_Quick_Attack_Player ) as ByteArray; break;
				case MOVE_RAIN_DANCE 		: newXMLBytes = ( isEnemy ? new XML_Rain_Dance_Player : new XML_Rain_Dance_Player ) as ByteArray; break;
				case MOVE_RAPID_SPIN 		: newXMLBytes = ( isEnemy ? new XML_Rapid_Spin_Player : new XML_Rapid_Spin_Player ) as ByteArray; break;
				case MOVE_RECOVER 			: newXMLBytes = ( isEnemy ? new XML_Recover_Player : new XML_Recover_Player ) as ByteArray; break;
				case MOVE_REST 				: newXMLBytes = ( isEnemy ? new XML_Rest_Player : new XML_Rest_Player ) as ByteArray; break;
				case MOVE_SAFEGUARD 		: newXMLBytes = ( isEnemy ? new XML_Safeguard_Player : new XML_Safeguard_Player ) as ByteArray; break;
				case MOVE_SAND_ATTACK 		: newXMLBytes = ( isEnemy ? new XML_Sand_Attack_Player : new XML_Sand_Attack_Player ) as ByteArray; break;
				case MOVE_SCARY_FACE 		: newXMLBytes = ( isEnemy ? new XML_Scary_Face_Player : new XML_Scary_Face_Player ) as ByteArray; break;
				case MOVE_SCRATCH 			: newXMLBytes = ( isEnemy ? new XML_Scratch_Player : new XML_Scratch_Player ) as ByteArray; break;
				case MOVE_SCREECH 			: newXMLBytes = ( isEnemy ? new XML_Screech_Player : new XML_Screech_Player ) as ByteArray; break;
				case MOVE_SELF_DESTRUCT 	: newXMLBytes = ( isEnemy ? new XML_Self_Destruct_Player : new XML_Self_Destruct_Player ) as ByteArray; break;
				case MOVE_SLAM 				: newXMLBytes = ( isEnemy ? new XML_Slam_Player : new XML_Slam_Player ) as ByteArray; break;
				case MOVE_SLASH 			: newXMLBytes = ( isEnemy ? new XML_Slash_Player : new XML_Slash_Player ) as ByteArray; break;
				case MOVE_SMOG 				: newXMLBytes = ( isEnemy ? new XML_Smog_Player : new XML_Smog_Player ) as ByteArray; break;
				case MOVE_SMOKESCREEN 		: newXMLBytes = ( isEnemy ? new XML_Smokescreen_Player : new XML_Smokescreen_Player ) as ByteArray; break;
				case MOVE_SNORE 			: newXMLBytes = ( isEnemy ? new XML_Snore_Player : new XML_Snore_Player ) as ByteArray; break;
				case MOVE_SPITE 			: newXMLBytes = ( isEnemy ? new XML_Spite_Player : new XML_Spite_Player ) as ByteArray; break;
				case MOVE_STRUGGLE 			: newXMLBytes = ( isEnemy ? new XML_Struggle_Player : new XML_Struggle_Player ) as ByteArray; break;
				case MOVE_SUBMISSION 		: newXMLBytes = ( isEnemy ? new XML_Submission_Player : new XML_Submission_Player ) as ByteArray; break;
				case MOVE_SUPERSONIC 		: newXMLBytes = ( isEnemy ? new XML_Supersonic_Player : new XML_Supersonic_Player ) as ByteArray; break;
				case MOVE_SWIFT 			: newXMLBytes = ( isEnemy ? new XML_Swift_Player : new XML_Swift_Player ) as ByteArray; break;
				case MOVE_TACKLE	 		: newXMLBytes = ( isEnemy ? new XML_Tackle_Player : new XML_Tackle_Player ) as ByteArray; break;
				case MOVE_TAIL_WHIP 		: newXMLBytes = ( isEnemy ? new XML_Tail_Whip_Player : new XML_Tail_Whip_Player ) as ByteArray; break;
				case MOVE_TAKE_DOWN		 	: newXMLBytes = ( isEnemy ? new XML_Take_Down_Player : new XML_Take_Down_Player ) as ByteArray; break;
				case MOVE_THRASH 			: newXMLBytes = ( isEnemy ? new XML_Thrash_Player : new XML_Thrash_Player ) as ByteArray; break;
				case MOVE_THUNDER 			: newXMLBytes = ( isEnemy ? new XML_Thunder_Player : new XML_Thunder_Player ) as ByteArray; break;
				case MOVE_THUNDER_SHOCK	 	: newXMLBytes = ( isEnemy ? new XML_Thundershock_Player : new XML_Thundershock_Player ) as ByteArray; break;
				case MOVE_TWISTER 			: newXMLBytes = ( isEnemy ? new XML_Twister_Player : new XML_Twister_Player ) as ByteArray; break;
				case MOVE_WATER_GUN 		: newXMLBytes = ( isEnemy ? new XML_Water_Gun_Player : new XML_Water_Gun_Player ) as ByteArray; break;
				case MOVE_WATER_SPORT 		: newXMLBytes = ( isEnemy ? new XML_Hydro_Pump_Player : new XML_Hydro_Pump_Player ) as ByteArray; break;
				case MOVE_WING_ATTACK 		: newXMLBytes = ( isEnemy ? new XML_Wing_Attack_Player : new XML_Wing_Attack_Player ) as ByteArray; break;
			}
			
			var string : String = newXMLBytes.readUTFBytes( newXMLBytes.length );			
			return new XML( string );			
		}
		
		
		public static function getMoveFXSprite( name : String, isEnemy : Boolean ) : BitmapData
		{
			TinyLogManager.log('getMoveFXSprite: ' + name, null);
			
			var newSprite : BitmapData;
			
			switch ( name.toUpperCase() ) 
			{
				default:
				case MOVE_ABSORB: 				newSprite = isEnemy ? new AbsorbPlayer : new AbsorbPlayer; break;
				case MOVE_AGILITY: 				newSprite = isEnemy ? new AgilityPlayer : new AgilityPlayer; break;
				case MOVE_ANCIENT_POWER: 		newSprite = isEnemy ? new AncientPowerPlayer : new AncientPowerPlayer; break;
				case MOVE_BITE: 				newSprite = isEnemy ? new BitePlayer : new BitePlayer; break;
				case MOVE_BLAZE_KICK:			newSprite = isEnemy ? new BlazeKickPlayer : new BlazeKickPlayer; break;
				case MOVE_BUBBLE:				newSprite = isEnemy ? new BubblePlayer : new BubblePlayer; break;
				case MOVE_CLAMP:				newSprite = isEnemy ? new ClampPlayer : new ClampPlayer; break;
				case MOVE_CONFUSION:			newSprite = isEnemy ? new ConfusionPlayer : new ConfusionPlayer; break;
				case MOVE_CONFUSE_RAY:			newSprite = isEnemy ? new ConfuseRayPlayer : new ConfuseRayPlayer; break;
				case MOVE_DETECT:				newSprite = isEnemy ? new DetectPlayer : new DetectPlayer; break;
				case MOVE_DOUBLE_EDGE:			newSprite = isEnemy ? new DoubleEdgePlayer : new DoubleEdgePlayer; break;
				case MOVE_DOUBLE_KICK:			newSprite = isEnemy ? new DoubleKickPlayer : new DoubleKickPlayer; break;
				case MOVE_DRAGON_BREATH:		newSprite = isEnemy ? new DragonBreathPlayer : new DragonBreathPlayer; break;
				case MOVE_DREAM_EATER:			newSprite = isEnemy ? new DreamEaterPlayer : new DreamEaterPlayer; break;
				case MOVE_DYNAMIC_PUNCH:		newSprite = isEnemy ? new DynamicPunchPlayer : new DynamicPunchPlayer; break;
				case MOVE_EMBER:				newSprite = isEnemy ? new EmberPlayer : new EmberPlayer; break;
				case MOVE_EXPLOSION:			newSprite = isEnemy ? new ExplosionPlayer : new ExplosionPlayer; break;
				case MOVE_FALSE_SWIPE:			newSprite = isEnemy ? new FalseSwipePlayer : new FalseSwipePlayer; break;
				case MOVE_FEINT_ATTACK:			newSprite = isEnemy ? new FeintAttackPlayer : new FeintAttackPlayer; break;
				case MOVE_FIRE_PUNCH:			newSprite = isEnemy ? new FirePunchPlayer : new FirePunchPlayer; break;
				case MOVE_FLAMETHROWER:			newSprite = isEnemy ? new FlamethrowerPlayer : new FlamethrowerPlayer; break;
				case MOVE_FOCUS_ENERGY:			newSprite = isEnemy ? new FocusEnergyPlayer : new FocusEnergyPlayer; break;
				case MOVE_FURY_SWIPES:			newSprite = isEnemy ? new FurySwipesPlayer : new FurySwipesPlayer; break;
				case MOVE_GROWL:				newSprite = isEnemy ? new GrowlPlayer : new GrowlPlayer; break;
				case MOVE_HEAL_BELL:			newSprite = isEnemy ? new HealBellPlayer : new HealBellPlayer; break;
				case MOVE_HOWL:					newSprite = isEnemy ? new GrowlPlayer : new GrowlPlayer; break;
				case MOVE_HYDRO_PUMP:			newSprite = isEnemy ? new HydroPumpPlayer : new HydroPumpPlayer; break;
				case MOVE_HYPER_BEAM:			newSprite = isEnemy ? new HyperBeamPlayer : new HyperBeamPlayer; break;
				case MOVE_HYPNOSIS:				newSprite = isEnemy ? new HypnosisPlayer : new HypnosisPlayer; break;
				case MOVE_KARATE_CHOP:			newSprite = isEnemy ? new KarateChopPlayer : new KarateChopPlayer; break;
				case MOVE_LEAF_BLADE:			newSprite = isEnemy ? new LeafBladePlayer : new LeafBladePlayer; break;
				case MOVE_LEER:					newSprite = isEnemy ? new LeerPlayer : new LeerPlayer; break;
				case MOVE_LICK:					newSprite = isEnemy ? new LickPlayer : new LickPlayer; break;
				case MOVE_LOW_KICK:				newSprite = isEnemy ? new LowKickPlayer : new LowKickPlayer; break;
				case MOVE_MEAN_LOOK:			newSprite = isEnemy ? new MeanLookPlayer : new MeanLookPlayer; break;
				case MOVE_MEGA_PUNCH:			newSprite = isEnemy ? new MegaPunchPlayer : new MegaPunchPlayer; break;
				case MOVE_METAL_CLAW:			newSprite = isEnemy ? new MetalClawPlayer : new MetalClawPlayer; break;
				case MOVE_METRONOME:			newSprite = isEnemy ? new MetronomePlayer : new MetronomePlayer; break;
				case MOVE_MUD_SLAP:				newSprite = isEnemy ? new MudSlapPlayer : new MudSlapPlayer; break;
				case MOVE_MUDDY_WATER:			newSprite = isEnemy ? new MuddyWaterPlayer : new MuddyWaterPlayer; break;
				case MOVE_NIGHT_SHADE:			newSprite = isEnemy ? new NightShadePlayer : new NightShadePlayer; break;
				case MOVE_PSYCHIC:				newSprite = isEnemy ? new PsychicPlayer : new PsychicPlayer; break;
				case MOVE_PSYWAVE:				newSprite = isEnemy ? new PsywavePlayer : new PsywavePlayer; break;
				case MOVE_POUND:				newSprite = isEnemy ? new PoundPlayer : new PoundPlayer; break;
				case MOVE_PROTECT:				newSprite = isEnemy ? new ProtectPlayer : new ProtectPlayer; break;
				case MOVE_QUICK_ATTACK:			newSprite = isEnemy ? new QuickAttackPlayer : new QuickAttackPlayer; break;
				case MOVE_RAIN_DANCE:			newSprite = isEnemy ? new RainDancePlayer : new RainDancePlayer; break;
				case MOVE_RAPID_SPIN:			newSprite = isEnemy ? new RapidSpinPlayer : new RapidSpinPlayer; break;
				case MOVE_RECOVER:				newSprite = isEnemy ? new RecoverPlayer : new RecoverPlayer; break;
				case MOVE_REST:					newSprite = isEnemy ? new RestPlayer : new RestPlayer; break;
				case MOVE_SAFEGUARD:			newSprite = isEnemy ? new SafeguardPlayer : new SafeguardPlayer; break;
				case MOVE_SAND_ATTACK:			newSprite = isEnemy ? new SandAttackPlayer : new SandAttackPlayer; break;
				case MOVE_SCARY_FACE:			newSprite = isEnemy ? new ScaryFacePlayer : new ScaryFacePlayer; break;
				case MOVE_SCRATCH:				newSprite = isEnemy ? new ScratchPlayer : new ScratchPlayer; break;
				case MOVE_SCREECH:				newSprite = isEnemy ? new ScreechPlayer : new ScreechPlayer; break;
				case MOVE_SELF_DESTRUCT:		newSprite = isEnemy ? new SelfDestructPlayer : new SelfDestructPlayer; break;
				case MOVE_SLAM:					newSprite = isEnemy ? new SlamPlayer : new SlamPlayer; break;
				case MOVE_SLASH:				newSprite = isEnemy ? new SlashPlayer: new SlashPlayer; break;
				case MOVE_SMOG:					newSprite = isEnemy ? new SmogPlayer : new SmogPlayer; break;
				case MOVE_SMOKESCREEN:			newSprite = isEnemy ? new SmokescreenPlayer : new SmokescreenPlayer; break;
				case MOVE_SNORE:				newSprite = isEnemy ? new SnorePlayer : new SnorePlayer; break;
				case MOVE_SPITE:				newSprite = isEnemy ? new SpitePlayer : new SpitePlayer; break;
				case MOVE_STRUGGLE: 			newSprite = isEnemy ? new StrugglePlayer : new StrugglePlayer; break;
				case MOVE_SUBMISSION: 			newSprite = isEnemy ? new SubmissionPlayer : new SubmissionPlayer; break;
				case MOVE_SUPERSONIC:			newSprite = isEnemy ? new SupersonicPlayer : new SupersonicPlayer; break;
				case MOVE_SWIFT:				newSprite = isEnemy ? new SwiftPlayer : new SwiftPlayer; break;
				case MOVE_TACKLE:				newSprite = isEnemy ? new TacklePlayer : new TacklePlayer; break;
				case MOVE_TAIL_WHIP:			newSprite = isEnemy ? new TailWhipPlayer : new TailWhipPlayer; break;
				case MOVE_TAKE_DOWN:			newSprite = isEnemy ? new TakeDownPlayer : new TakeDownPlayer; break;
				case MOVE_THRASH:				newSprite = isEnemy ? new ThrashPlayer : new ThrashPlayer; break;
				case MOVE_THUNDER:				newSprite = isEnemy ? new ThunderPlayer : new ThunderPlayer; break;
				case MOVE_THUNDER_SHOCK:		newSprite = isEnemy ? new ThundershockPlayer : new ThundershockPlayer; break;
				case MOVE_TWISTER:				newSprite = isEnemy ? new TwisterPlayer : new TwisterPlayer; break;
				case MOVE_WATER_GUN: 			newSprite = isEnemy ? new WaterGunPlayer : new WaterGunPlayer; break;
				case MOVE_WATER_SPORT: 			newSprite = isEnemy ? new HydroPumpPlayer: new HydroPumpPlayer; break;
				case MOVE_WING_ATTACK:			newSprite = isEnemy ? new WingAttackPlayer : new WingAttackPlayer; break;
			}
			
			return newSprite;
		}		
	}
}
