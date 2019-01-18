package  {
	/**
	 * ...
	 * @author Jaclyn Staples
	 * This class handles all the action processes throughout the game
	 */
	public class ManageProgress {
		
		//declare variables
		private var _firstItem:Boolean;
		private var _invIsOpen:Boolean;
		//--get items
		private var _isListed:Boolean;
		private var _getGarageKey:Boolean;
		private var _getWrench:Boolean;
		//--install/change items
		private var _changeShower:Boolean;
		private var _installLowFlow:Boolean;
		//--unlock areas
		private var _unlockGarage:Boolean;
		private var _unlockAttic:Boolean;
		//--count items
		private var _numOfBottles:int;
		private var _numOfPlates:int;
		private var _numOfClothes:int;
		private var _numOfLeaks:int;
		private var _numRecycled:int;
		public static const TOTAL_BOTTLES:int = 10;
		public static const TOTAL_PLATES:int = 5;
		public static const TOTAL_CLOTHES:int = 9;
		public static const TOTAL_LEAKS:int = 4;
		private var _gotBottles:Boolean;  //toggles whether all bottles have been found
		private var _gotPlates:Boolean;
		private var _gotClothes:Boolean;
		private var _gotLeaks:Boolean;
		private var _washClothes:Boolean;
		private var _washDishes:Boolean;
		private var _recycledAll:Boolean;
		//declare manage tasks to check for win
		private var cMain:Main;
		
		public function ManageProgress(classMain:Main) {
			cMain = classMain;
			reset();
		}
		
		public function reset():void {
			_firstItem = false;
			_invIsOpen = false;
			_isListed = false;
			_getGarageKey = false;
			_getWrench = false;
			_changeShower = false;
			_installLowFlow = false;
			_unlockGarage = false;
			_unlockAttic = false;
			_numOfBottles = 0;
			_numOfClothes = 0;
			_numOfPlates = 0;
			_numRecycled = 0;
			_gotBottles = false;
			_gotClothes = false;
			_gotPlates = false;
			_gotLeaks = false;
			_washClothes = false;
			_washDishes = false;
			_recycledAll = false;
		}
		
		//------------------------------------------------ getters and setters
		//collect first item get/set
		public function get firstItem():Boolean {
			return _firstItem;
		}
		public function set firstItem(value:Boolean):void {
			_firstItem = value;
		}
		//toggle inventory state get/set
		public function get invIsOpen():Boolean {
			return _invIsOpen;
		}
		public function set invIsOpen(value:Boolean):void {
			_invIsOpen = value;
		}
		//collect task list get/set
		public function get isListed():Boolean {
			return _isListed;
		}
		public function set isListed(value:Boolean):void {
			_isListed = value;
			ManageSounds.playSound(ManageSounds.SND_SUCCESS);
			//check to see if win
			cMain.mTasks.checkWin();
		}
		//collect garage key get/set
		public function get getGarageKey():Boolean {
			return _getGarageKey;
		}
		public function set getGarageKey(value:Boolean):void {
			_getGarageKey = value;
			ManageSounds.playSound(ManageSounds.SND_SUCCESS);
		}
		//collect wrench get/set
		public function get getWrench():Boolean {
			return _getWrench;
		}
		public function set getWrench(value:Boolean):void {
			_getWrench = value;
			ManageSounds.playSound(ManageSounds.SND_SUCCESS);
		}
		
		//change shower get/set
		public function get changeShower():Boolean {
			return _changeShower;
		}
		public function set changeShower(value:Boolean):void {
			_changeShower = value;
			ManageSounds.playSound(ManageSounds.SND_SUCCESS);
			//check to see if win
			cMain.mTasks.checkWin();
		}
		//install low-flow get/set
		public function get installLowFlow():Boolean {
			return _installLowFlow;
		}
		public function set installLowFlow(value:Boolean):void {
			_installLowFlow = value;
			ManageSounds.playSound(ManageSounds.SND_SUCCESS);
			//check to see if win
			cMain.mTasks.checkWin();
		}
		
		
		//unlock garage get/set
		public function get unlockGarage():Boolean {
			return _unlockGarage;
		}
		public function set unlockGarage(value:Boolean):void {
			_unlockGarage = value;
			ManageSounds.playSound(ManageSounds.SND_DOORUNLOCK);
			//check to see if win
			cMain.mTasks.checkWin();
		}
		//unlock attic get/set
		public function get unlockAttic():Boolean {
			return _unlockAttic;
		}
		public function set unlockAttic(value:Boolean):void {
			_unlockAttic = value;
		}
		
		
		//count bottles
		public function get numOfBottles():int {
			return _numOfBottles;
		}
		public function set numOfBottles(value:int):void {
			_numOfBottles = value;
		}
		//count clothes
		public function get numOfClothes():int {
			return _numOfClothes;
		}
		public function set numOfClothes(value:int):void {
			_numOfClothes = value;
		}
		//count plates
		public function get numOfPlates():int {
			return _numOfPlates;
		}
		public function set numOfPlates(value:int):void {
			_numOfPlates = value;
		}
		//count leaks
		public function get numOfLeaks():int {
			return _numOfLeaks;
		}
		public function set numOfLeaks(value:int):void {
			_numOfLeaks = value;
		}
		//count num recycled
		public function get numRecycled():int {
			return _numRecycled;
		}
		public function set numRecycled(value:int):void {
			_numRecycled = value;
		}
		//found all bottles
		public function get gotBottles():Boolean {
			return _gotBottles;
		}
		public function set gotBottles(value:Boolean):void {
			_gotBottles = value;
			ManageSounds.playSound(ManageSounds.SND_SUCCESS);
			//check to see if win
			cMain.mTasks.checkWin();
		}
		//found all clothes
		public function get gotClothes():Boolean {
			return _gotClothes;
		}
		public function set gotClothes(value:Boolean):void {
			_gotClothes = value;
			ManageSounds.playSound(ManageSounds.SND_SUCCESS);
			//check to see if win
			cMain.mTasks.checkWin();
		}
		//found all clothes
		public function get gotPlates():Boolean {
			return _gotPlates;
		}
		public function set gotPlates(value:Boolean):void {
			_gotPlates = value;
			ManageSounds.playSound(ManageSounds.SND_SUCCESS);
			//check to see if win
			cMain.mTasks.checkWin();
		}
		//fixed all leaks
		public function get gotLeaks():Boolean {
			return _gotLeaks;
		}
		public function set gotLeaks(value:Boolean):void {
			_gotLeaks = value;
			ManageSounds.playSound(ManageSounds.SND_SUCCESS);
			//check to see if win
			cMain.mTasks.checkWin();
		}
		//washed clothes
		public function get washClothes():Boolean {
			return _washClothes;
		}
		public function set washClothes(value:Boolean):void {
			_washClothes = value;
			ManageSounds.playSound(ManageSounds.SND_SUCCESS);
			//check to see if win
			cMain.mTasks.checkWin();
		}
		//washed dishes
		public function get washDishes():Boolean {
			return _washDishes;
		}
		public function set washDishes(value:Boolean):void {
			_washDishes = value;
			ManageSounds.playSound(ManageSounds.SND_SUCCESS);
			//check to see if win
			cMain.mTasks.checkWin();
		}
		//recycled all bottles
		public function get recycledAll():Boolean {
			return _recycledAll;
		}
		public function set recycledAll(value:Boolean):void {
			_recycledAll = value;
			ManageSounds.playSound(ManageSounds.SND_SUCCESS);
			//check to see if win
			cMain.mTasks.checkWin();
		}
		
	}

}