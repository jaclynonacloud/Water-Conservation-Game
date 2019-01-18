package  {
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.events.*;
	
	/**
	 * ...
	 * @author Jaclyn Staples
	 */
	public class ManageSounds extends Sound{
		//declare sound constants
		public static const SND_DOORCLOSE:String = "sndDoorClose";
		public static const SND_DOORUNLOCK:String = "sndDoorUnlock";
		public static const SND_WATER:String = "sndWater";
		public static const SND_SUCCESS:String = "sndSuccess";
		public static const SND_WRENCH:String = "sndWrench";
		
		//declare sounds
		private static var doorClose:SND_DoorClose;
		private static var doorUnlock:SND_DoorUnlock;
		private static var water:SND_Water;
		private static var success:SND_Success;
		private static var wrench:SND_Wrench;
		//---make a sound channel
		private static var channel:SoundChannel;
		private static var dripChannel:SoundChannel;
		//current sound
		private static var currSound:Sound;
		private static var currString:String;
		//check to see if sound is already playing
		private static var isPlaying:Boolean;
		private static var isDripPlaying:Boolean;
		
		public function ManageSounds() {
			isPlaying = false;
			isDripPlaying = false;
		}
		
		private static function loadSounds():void {
			if (channel == null) channel = new SoundChannel();
			if (dripChannel == null) dripChannel = new SoundChannel();
			if (doorClose == null) doorClose = new SND_DoorClose();
			if (doorUnlock == null) doorUnlock = new SND_DoorUnlock();
			if (water == null) water = new SND_Water();
			if (success == null) success = new SND_Success();
			if (wrench == null) wrench = new SND_Wrench();
		}
		
		public static function playSound(soundName:String = "", repeatSound:Boolean = false):void {
			loadSounds();
			if (soundName != "") {
				//play sound indicated
				if (soundName == SND_DOORCLOSE) currSound = doorClose;
				else if (soundName == SND_DOORUNLOCK) currSound = doorUnlock;
				else if (soundName == SND_WATER) {
					if (!isDripPlaying) {
						isDripPlaying = true;
						dripChannel = water.play();
					}
				}
				else if (soundName == SND_SUCCESS) currSound = success;
				else if (soundName == SND_WRENCH) currSound = wrench;
				
				//write current sound
				currString = soundName;
				//play sound
				trace(isPlaying + " is playing");
				if (!isPlaying) {
					isPlaying = true;
					channel = currSound.play();
				}
				//check to see when sound ends
				channel.addEventListener(Event.SOUND_COMPLETE, onDone);
				//repeat sound, if desired
				if (repeatSound) dripChannel.addEventListener(Event.SOUND_COMPLETE, onReplay);
				else dripChannel.addEventListener(Event.SOUND_COMPLETE, onDoneDrip);
			}
		}
		
		public static function endSound():void {
			loadSounds();
			isDripPlaying = false;
			//end the sound
			dripChannel.stop();
			dripChannel.removeEventListener(Event.SOUND_COMPLETE, onReplay);
		}
		
		public static function onDone(e:Event):void {
			isPlaying = false;
		}
		
		public static function onDoneDrip(e:Event):void {
			isDripPlaying = false;
		}
		
		private static function onReplay(e:Event):void {
			//replay sound
			playSound(currString, true);
		}
		
	}

}