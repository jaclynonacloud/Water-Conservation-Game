package  {
	/**
	 * ...
	 * @author Jaclyn Staples
	 * This class works closely with the progress and task classes to feed information on how events are being handled
	 */
	
	import flash.display.*;
	import flash.events.*;
	
	
	public class ManageEvents extends Event{
		//declare event names
		public static const RESULT:String = "Result";
		public static const CHECK_FOR_UDPATES:String = "checkForUpdates";
		//---------------collections
		public static const GET_TASKLIST:String = "getTasklist";
		public static const GET_KITCHENKEY:String = "getKitchenKey";
		public static const GET_WRENCH:String = "getWrench";
		public static const GET_CLOTH:String = "getCloth";
		public static const GET_WATERBOTTLE:String = "getWaterBottle";
		public static const GET_FUSE:String = "getFuse";
		public static const GET_TOILETKIT:String = "getToiletKit";
		public static const GET_DISH:String = "getDish";
		public static const GET_FISHFOOD:String = "getFishFood";
		//---------------unlocks
		//declare counter totals
		private static const TOTAL_PLATES:int = 4;
		private static const TOTAL_LEAKS:int = 6;
		private static const TOTAL_BOTTLES:int = 10;
		
		//declare counters
		private static var _currPlates:int;
		private static var _currLeaks:int;
		private static var _currBottles:int;
		
		//declare toggles
		private static var _hasTasklist:Boolean;
		private static var _hasKitchenKey:Boolean;
		private static var _hasWrench:Boolean;
		private static var _hasAllCloth:Boolean;
		private static var _hasAllWaterBottles:Boolean;
		private static var _hasFuse:Boolean;
		private static var _hasToiletKit:Boolean;
		private static var _hasAllDishes:Boolean;
		private static var _hasFishFood:Boolean;
		
		public var switchToggle:Boolean;
		public var newCount:int;


		public function ManageEvents(type:String, switchToggle:Boolean = false, newCount:int = 0, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			this.switchToggle = switchToggle;
			this.newCount = newCount;
		}

		// always create a clone() method for events in case you want to redispatch them.
		public override function clone():Event {
			return new ManageEvents(type, switchToggle, newCount, bubbles, cancelable);
		}
		
		public static function resetEvents():void {
			_hasTasklist = false;
			_hasKitchenKey = false;
			_hasWrench = false;
		}
		
		
		//------------------------------------------------ getters and setters
		//collect first item get/set
		//public function get firstItem():Boolean {
		//	return _firstItem;
		//}
		
	}

}