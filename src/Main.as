package {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Mouse;
	import flash.system.fscommand;
	import flash.net.*;
	
	/**
	 * ...
	 * @author Jaclyn Staples
	 */
	public class Main extends Sprite {
		
		//declare actions
		public static const NO_USE:String = "noUse";
		public static const RETURN_CURSOR:String = "returnCursor";
		public static const RETURN_ITEM:String = "returnItem";
		//---------------key actions
		public static const UNLOCK_TASKLIST:String = "unlockTasklist";
		public static const UNLOCK_GARAGE:String = "unlockGarage";
		public static const CHANGE_FUSE:String = "changeFuse";
		public static const INSTALL_SHOWER:String = "installShower";
		public static const INSTALL_LOWFLOW:String = "installLowFlow";
		public static const CHECK_CLOTHES:String = "checkClothes";
		public static const CHECK_PLATES:String = "checkPlates";
		public static const CHECK_BOTTLES:String = "checkBottles";
		public static const CHECK_LEAKS:String = "checkLeaks";
		
		
		//declare screens
		private var sSplash: S_Splash;
		private var sStart: S_Start;
		
		//declare classes
		public var mRooms:ManageRooms;
		private var mText:ManageTextbox;
		public var mTasks:ManageTasks;
		private var mProgress:ManageProgress;
		public var overlay:Util_Overlay;
		private var inv:Inventory;
		
		//declare variables
		private var mIcon:Sprite;
		private static var _tryingItem:Boolean; //holds whether item is attempting to be used right now
		//private var loader:Loader;
		
		
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			reset();
		}
		
		//-----------------------------------------------------------------------RESET
		private function reset():void {
			//load classes- only needs to be done once
			overlay = new Util_Overlay();
			mProgress = new ManageProgress(this);
			mText = new ManageTextbox(this);
			mRooms = new ManageRooms(mProgress, mText);
			mTasks = new ManageTasks(mProgress, overlay, mRooms);
			inv = new Inventory(mText,  mRooms, mProgress);
			
			sSplash = new S_Splash();
			sStart = new S_Start();
			//loader = new Loader();
			//loader.load(new URLRequest("../bin/WaterConservationGame.swf"));
			//loader.load(new URLRequest("WaterConservationGame.swf"));
			//loader.load(new URLRequest("C:/Users/jaclynonacloud/Desktop/_Game/Water_ConservationGame/bin/WaterConservationGame.swf"));
			
			//set up children in order of layering- lower on the list, higher on the display
			addChild(mRooms);
			addChild(overlay);
			addChild(mText);
			addChild(mTasks);
			
			overlay.txtBonus.text = "";
			overlay.txtTaskComplete.text = "";
			overlay.newItem.visible = false;
			overlay.newItem.mouseEnabled = false;
			_tryingItem = false;
			
			//event listeners
			addEventListener(MouseEvent.CLICK, onClick, true);
			addEventListener(Main.RETURN_ITEM, onReturnItem);
			addEventListener(Main.NO_USE, onNoUse);
			inv.addEventListener(Inventory.NEW_ITEM, onEvent);
			mRooms.addEventListener(ManageRooms.ROOM_CHANGE, onEvent);
			//--------------key events
			//unlocking areas/things
			mRooms.addEventListener(ManageRooms.UNLOCK_TASKLIST, onEvent);
			addEventListener(Main.UNLOCK_GARAGE, onEvent);
			addEventListener(Main.INSTALL_SHOWER, onEvent);
			addEventListener(Main.INSTALL_LOWFLOW, onEvent);
			//collection for task list
			inv.addEventListener(Inventory.COLLECT_GARAGEKEY, onEvent);
			inv.addEventListener(Inventory.COLLECT_WRENCH, onEvent);
			//check items
			addEventListener(Main.CHECK_BOTTLES, onEvent);
			addEventListener(Main.CHECK_CLOTHES, onEvent);
			addEventListener(Main.CHECK_PLATES, onEvent);
			addEventListener(Main.CHECK_LEAKS, onEvent);
			//------------cursor events
			inv.addEventListener(Inventory.TRY_ITEM, onTryItem);
			addEventListener(Main.RETURN_CURSOR, onReturnCursor);
			
			//showSplash();
			showStart();
			overlay.txtClose.text = "Inventory -->";
			//hide some stuff in beginning
			if(this.contains(mTasks))mTasks.hideMe();
			overlay.btnTaskList.visible = false;
			mIcon = null;
			mRooms.bed1.list.visible = true;
			//setup initial talky box
			mText.addText(true, "Hi, my name is Jack, and I've been learning about water conservation. \n\n  After taking part in several opportunities teaching me about water conservation, I'm ready to try and make a difference. ~ In an effort to make my house more efficient, Help me find ways to cut down on water consumption and waste.");

			//------add items that can be put in inventory
			var invItems:Array = new Array();
			//basement
			invItems.push(mRooms.base.lowFlow);
			//bath 1
			invItems.push(mRooms.bath1.wBottle1);
			//bath 2
			invItems.push(mRooms.bath2.silverKey);
			invItems.push(mRooms.bath2.cloth1);
			//bed 1
			invItems.push(mRooms.bed1.cloth1);
			invItems.push(mRooms.bed1.cloth2);
			invItems.push(mRooms.bed1.cloth3);
			invItems.push(mRooms.bed1.wBottle1);
			invItems.push(mRooms.bed1.wBottle2);
			invItems.push(mRooms.bed1.wBottle3);
			//bed 2
			invItems.push(mRooms.bed2.cloth1);
			invItems.push(mRooms.bed2.cloth2);
			invItems.push(mRooms.bed2.cloth3);
			invItems.push(mRooms.bed2.cloth4);
			invItems.push(mRooms.bed2.cloth5);
			invItems.push(mRooms.bed2.wBottle1);
			invItems.push(mRooms.bed2.wBottle2);
			//dining room
			invItems.push(mRooms.dining.fuse);
			invItems.push(mRooms.dining.plate1);
			invItems.push(mRooms.dining.plate2);
			invItems.push(mRooms.dining.wBottle1);
			invItems.push(mRooms.dining.wBottle2);
			//garage
			invItems.push(mRooms.garage.wrench);
			invItems.push(mRooms.garage.showerHead);
			//hall 1
			//kitchen
			invItems.push(mRooms.kitchen.plate1);
			invItems.push(mRooms.kitchen.wBottle1);
			invItems.push(mRooms.kitchen.wBottle2);
			
			inv.makeInventoryItems(invItems);

			
			//initialize room
			mRooms.changeRoom("bed1", false);
		}
		
		//----------------------------------------------------------SCREEN CHANGES
		/*
		public function showSplash():void {
			
			//event listeners
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoading);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			
			//add to display list
			addChild(sSplash);
		}
		*/
		
		public function showStart():void {
			
			//event listeners
			//loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoading);
			//loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
			//buttons
			sStart.addEventListener(MouseEvent.CLICK, onStartClick);
			//add to display list
			if (this.contains(sSplash)) removeChild(sSplash);
			addChild(sStart);
		}
		
		public function showGame():void {
			
			//add to display list
			removeChild(sStart);
		}
		
		//----------------------------------Screen actions
		private function onLoading(e:ProgressEvent):void {
			var bLoaded:int = Math.round(e.bytesLoaded / 1024);
			var bTotal:int = Math.round(e.bytesTotal / 1024);
			
			var percent:Number = bLoaded / bTotal;
			sSplash.txtLoad.text = "Loading... \n" + (percent * 100) + "%";
			trace("PERCENT: " + percent);
		}
		private function onLoaded(e:Event):void {
			trace("Im here");
			//show start menu once loaded
			showStart();
		}
		//start menu
		private function onStartClick(e:MouseEvent):void {
			if (e.target.name == "gStart") showGame();
			if (e.target.name == "gLoad") //load game
			if (e.target.name == "gOptions") //load options
			if (e.target.name == "gExit") fscommand("quit");
		}
		
		
		private function resetMe():void {
			//obscure method I don't understand, but it works.
			var url:String = stage.loaderInfo.url;
			var request:URLRequest = new URLRequest(url);
			navigateToURL(request,"_level0");
		}
		
		//----------------------------------------------------------GAME ACTIONS
		
		private function onClick(e:MouseEvent):void {
			//Inventory Show/Hide
			if (e.target.name == "btnInventory") {
				if (!this.contains(inv)) {
					inv.showMe(this);
					mProgress.invIsOpen = true;
					overlay.txtClose.text = "Click to close -->";
				}else if(this.contains(inv)){
					inv.hideMe();
					mProgress.invIsOpen = false;
					overlay.txtClose.text = "Inventory -->";
				}
				
			}
			if (e.target.name == "btnUse") {
					inv.hideMe();
					mProgress.invIsOpen = false;
				}
			
			
			//control task list
			if (mProgress.isListed) {
				if (e.target.name == "btnTaskList" && !this.contains(mTasks)) mTasks.showMe(this);
				else if(this.contains(mTasks)){
					mTasks.hideMe();
				}
			}
			
			if (e.target.name == "btnReturn") {
				resetMe();
			}
		}
		
		private function onEvent(e:Event):void {
			//unlock stuff
			if (e.type == ManageRooms.UNLOCK_TASKLIST) {
				mProgress.isListed = true;
				overlay.btnTaskList.visible = true;
				mText.addText(true, "I now have a Task List! There is a Task List button in the top right corner of the screen that I can access the list with. ~ This list will let me know what I'll need to do to make my house more water friendly.");
				trace("Tasklist unlocked");
			}
			else if (e.type == Main.UNLOCK_GARAGE) {
				mProgress.unlockGarage = true;
				mText.addText(true, "Yay!  I can now go in the garage!");
				mRooms.garage.garDark.visible = false;
				dispatchEvent(new Event(Main.RETURN_CURSOR));
			}
			//inventory stuff
			else if (e.type == Inventory.COLLECT_GARAGEKEY) mProgress.getGarageKey = true;
			else if (e.type == Inventory.COLLECT_WRENCH) mProgress.getWrench = true;
			else if (e.type == Main.INSTALL_SHOWER) {
				mRooms.bath2.oldShower.visible = false;
				mRooms.bath2.newShower.visible = true;
				mProgress.changeShower = true;
				mText.addText(true, "There, a new low-flow showerhead! ~ DID YOU KNOW: \n\n If you use a low­flow showerhead, you can save over 50 liters of \nwater during a 10 minute shower.");
				dispatchEvent(new Event(Main.RETURN_CURSOR));
			}
			else if (e.type == Main.INSTALL_LOWFLOW) {
				mProgress.installLowFlow = true;
				mText.addText(true, "Yes!  This toilet will help in my efforts to reduce water waste! ~ DID YOU KNOW: \n\n Toilets account for 30% of residential water usage. Low-flow kits are a worth-while investment and can save thousands of litres a year.");
				dispatchEvent(new Event(Main.RETURN_CURSOR));
			}
			//checks
			else if (e.type == Main.CHECK_CLOTHES) {
				if (mProgress.gotClothes) {
					mProgress.washClothes = true;
					mText.addText(true, "I've got all the clothes!  Now, let's do a load of laundry! ~ DID YOU KNOW: \n\nWashing dark clothes in cold water saves water and energy, and helps your clothes retain their color.");
					dispatchEvent(new Event(Main.RETURN_CURSOR));
				}
				else  {
					mText.addText(true, "I should find all the clothes before starting a load.");
					dispatchEvent(new Event(Main.RETURN_ITEM));
				}
			}
			else if (e.type == Main.CHECK_PLATES) {
				if (mProgress.gotPlates) {
					mProgress.washDishes = true;
					mText.addText(true, "Let's wash the dishes!~DID YOU KNOW:\n\nHandwashing dishes may take around 103 litres of water, but dishwashers only use around 15 litres.~\n\n\Dishwashing results in cleaner dishes as well!");
					dispatchEvent(new Event(Main.RETURN_CURSOR));
				}
				else {
					mText.addText(true, "I have more dishes to find.");
					dispatchEvent(new Event(Main.RETURN_ITEM));
				}
			}
			else if (e.type == Main.CHECK_BOTTLES) {
				if (mProgress.numOfBottles != 0) {
					mProgress.numRecycled += mProgress.numOfBottles;
					mText.addText(true, "I've recycled " + String(mProgress.numOfBottles) + " bottles!");
					overlay.txtBonus.text = " " + String(mProgress.numRecycled);
					mProgress.numOfBottles = 0;
				}
				if (mProgress.gotBottles) {
					mProgress.recycledAll = true;
					mText.addText(true, "I've recycled all the bottles!");
				}
				dispatchEvent(new Event(Main.RETURN_CURSOR));
			}
			else if (e.type == Main.CHECK_LEAKS) {
				if (mProgress.numOfLeaks >= ManageProgress.TOTAL_LEAKS) {
					mProgress.gotLeaks = true;
					mText.addText(true, "I've fixed all the leaks!");
				}
			}
			//item thing
			else if (e.type == Inventory.NEW_ITEM) overlay.newItem.visible = true;
			else if (e.type == ManageRooms.ROOM_CHANGE) {
				if (overlay.newItem.visible) overlay.newItem.visible = false;
				//check for leak sounds
				if (mRooms.currRoom == "bath2" && mRooms.bath2.leak.visible) ManageSounds.playSound(ManageSounds.SND_WATER, true);
				else if (mRooms.currRoom == "bath1" && mRooms.bath1.leak.visible) ManageSounds.playSound(ManageSounds.SND_WATER, true);
				else if (mRooms.currRoom == "kitchen" && mRooms.kitchen.leak.visible) ManageSounds.playSound(ManageSounds.SND_WATER, true);
				else if (mRooms.currRoom == "back" && mRooms.back.leak.visible) ManageSounds.playSound(ManageSounds.SND_WATER, true);
				else ManageSounds.endSound();
			}
		}
		
		//--------------------CURSOR CHANGES
		private function onTryItem(e:Event):void {
			//currently trying item
			_tryingItem = true;
			mIcon = inv.curItem;
			//adding icon as cursor
			addChild(mIcon);
			mIcon.alpha = 1;
			mIcon.scaleX = .1;
			mIcon.scaleY = mIcon.scaleX;
			Mouse.hide();
			//hiding inventory
			if (this.contains(inv)) removeChild(inv);
			//remove room listeners for a moment
			mRooms.removeListeners();
			//change position of mouse cursor
			addEventListener(Event.ENTER_FRAME, onMousePos);
			addEventListener(MouseEvent.MOUSE_DOWN, onUseItem, true);
			//--allow item to give clues
			addEventListener(MouseEvent.MOUSE_OVER, onOver, true);
			addEventListener(MouseEvent.MOUSE_OUT, onOut, true);
		}
		
		private function onMousePos(e:Event):void {
			mIcon.x = mouseX;
			mIcon.y = mouseY;
		}
		
		private function onReturnCursor(e:Event):void {
			//this function is to be used once the item calling it has been used successfully
			//add back mouse cursor
			inv.removeItem(mIcon);
			inv.setItem();
			Mouse.show();
			//remove listener
			removeEventListener(Event.ENTER_FRAME, onMousePos);
		}
		
		private function onReturnItem(e:Event):void {
			//this function will return the item to the inventory- when item is used unsuccessfully
			//add back mouse cursor
			inv.returnItem(mIcon);
			Mouse.show();
			//remove listener
			removeEventListener(Event.ENTER_FRAME, onMousePos);
		}
		
		//------------------ITEM CHANGES
		private function onUseItem(e:MouseEvent):void {
			var item:Sprite = new Sprite();
			item = mIcon;
			trace(mIcon);
			
			//silver key usage
			if (item == inv.invKey) {
				if (e.target.name == "doorGarage") {
					//unlock kitchen
					trace("Unlock door");
					dispatchEvent(new Event(Main.UNLOCK_GARAGE));
				}else {
					trace("I do nothing");
					dispatchEvent(new Event(Main.NO_USE));
				}
			}
			
			//wrench usage
			if (item == inv.invWrench) {
				if (e.target == mRooms.bath2.hitSink && mRooms.bath2.leak.visible) {
					//repair sink
					mRooms.bath2.leak.visible = false;
					mProgress.numOfLeaks += 1;
					mText.addText(true, "There, a nice, clean sink!~DID YOU KNOW:\n\nA leaky faucet that drips once a second can waste over 350 litres of water a day.");
					dispatchEvent(new Event(Main.CHECK_LEAKS));
					dispatchEvent(new Event(Main.RETURN_ITEM));
					//sounds
					ManageSounds.playSound(ManageSounds.SND_WRENCH);
					ManageSounds.endSound();
				}
				else if (e.target == mRooms.kitchen.hitLeak && mRooms.kitchen.leak.visible) {
					//repair kitchen sink
					mRooms.kitchen.leak.visible = false;
					mRooms.hall1.iWaterLeak.visible = false;
					mRooms.kitchen.hitLeak.visible = false;
					mProgress.numOfLeaks += 1;
					mText.addText(true, "Phew, the faucet has stopped leaking!");
					dispatchEvent(new Event(Main.CHECK_LEAKS));
					dispatchEvent(new Event(Main.RETURN_ITEM));
					//sounds
					ManageSounds.playSound(ManageSounds.SND_WRENCH);
					ManageSounds.endSound();
				}
				else if (e.target == mRooms.back.hitHose && mRooms.back.leak.visible) {
					//repair hose
					mRooms.back.leak.visible = false;
					mProgress.numOfLeaks += 1;
					mText.addText(true, "Now the hose isn't leaking!~DID YOU KNOW:\n\nYou can set a kitchen timer when using the hose as a reminder to turn it off. A running hose can discharge up to 44 litres per minute.");
					dispatchEvent(new Event(Main.CHECK_LEAKS));
					dispatchEvent(new Event(Main.RETURN_ITEM));
					//sounds
					ManageSounds.playSound(ManageSounds.SND_WRENCH);
					ManageSounds.endSound();
				}
				else if (e.target == mRooms.bath1.hitSink && mRooms.bath1.leak.visible) {
					//repair sink bathroom downstairs
					mRooms.bath1.leak.visible = false;
					mProgress.numOfLeaks += 1;
					mText.addText(true, "The sink is leaky no more!~\n\nRemember to not leave the tap running while brushing your teeth or shaving.");
					dispatchEvent(new Event(Main.CHECK_LEAKS));
					dispatchEvent(new Event(Main.RETURN_ITEM));
					//sounds
					ManageSounds.playSound(ManageSounds.SND_WRENCH);
					ManageSounds.endSound();
				}
				else dispatchEvent(new Event(Main.NO_USE));
				
			}
			
			//showerhead usage
			if (item == inv.invShower) {
				if (e.target == mRooms.bath2.shower) dispatchEvent(new Event(Main.INSTALL_SHOWER));
				else dispatchEvent(new Event(Main.NO_USE));
			}
			
			//low flow usage
			if (item == inv.invLowFlow) {
				if (e.target == mRooms.bath2.hitToilet) dispatchEvent(new Event(Main.INSTALL_LOWFLOW));
				else dispatchEvent(new Event(Main.NO_USE));
			}
			
			//fuse usage
			if (item.name == "fuse") {
				if (e.target.name == "hitFusebox") dispatchEvent(new Event(Main.CHANGE_FUSE));
				else dispatchEvent(new Event(Main.NO_USE));
			}
			
			//clothing usage
			if (item == inv.invCloth) {
				trace("Target: " + e.target);
				if (e.target == mRooms.bath1.hitWashers) dispatchEvent(new Event(Main.CHECK_CLOTHES));
				else dispatchEvent(new Event(Main.NO_USE));
			}
			
			//plate usage
			if (item == inv.invPlate) {
				trace("Target: " + e.target);
				if (e.target == mRooms.kitchen.hitDishwasher) dispatchEvent(new Event(Main.CHECK_PLATES));
				else dispatchEvent(new Event(Main.NO_USE));
			}
			
			//bottle usage
			if (item == inv.invBottle) {
				if (e.target == mRooms.kitchen.recycling) dispatchEvent(new Event(Main.CHECK_BOTTLES));
				else dispatchEvent(new Event(Main.NO_USE));
			}
			
			
			//stop listening to event listener
			removeEventListener(MouseEvent.MOUSE_DOWN, onUseItem, true);
			removeEventListener(MouseEvent.MOUSE_OVER, onOver, true);
		}
		
		private function onNoUse(e:Event):void {
			//returns no result
			mText.addText(true, "Nothing happened");
			dispatchEvent(new Event(Main.RETURN_ITEM));
		}
		
		
		private function onOver(e:MouseEvent):void {
			//handle doors
			if (e.target.name == "doorAttic") mText.addText(false, "Use on Attic");
			if (e.target.name == "doorBYard")  mText.addText(false, "Use on Backyard");
			if (e.target.name == "doorBasement")  mText.addText(false, "Use on Basement");
			if (e.target.name == "doorBath1")  mText.addText(false, "Use on  Bathroom");
			if (e.target.name == "doorBath2")  mText.addText(false, "Use on  Bathroom");
			if (e.target.name == "doorBed1")  mText.addText(false, "Use on Jack's Bedroom");
			if (e.target.name == "doorBed2")  mText.addText(false, "Use on Bedroom");
			if (e.target.name == "doorDRoom")  mText.addText(false, "Use on Dining Room");
			if (e.target.name == "doorGarage")  mText.addText(false, "Use on Garage");
			if (e.target.name == "doorHall2" && e.target != mRooms.hall1.doorHall2)  mText.addText(false, "Use on Hallway Door");
			if (e.target == mRooms.hall1.doorHall2)  mText.addText(false, "Use on Upstairs");
			if (e.target.name == "doorHall1" && e.target != mRooms.hall2.doorHall1)  mText.addText(false, "Use on Hallway Door");
			if (e.target == mRooms.hall2.doorHall1)  mText.addText(false, "Use on Downstairs");
			if (e.target.name == "doorKitch")  mText.addText(false, "Use on Kitchen");
			//handle hitboxes
			//handle things in attic
			//handle things in backyard
			if (e.target == mRooms.back.hitGrass) mText.addText(false, "Use on Lawn");
			if (e.target == mRooms.back.hitHose) mText.addText(false, "Use on Hose");
			//handle things in basement
			if (e.target == mRooms.base.lowFlow) mText.addText(false, "Use on Toilet Kit");
			if (e.target == mRooms.base.waterTank) mText.addText(false, "Use on Water Tank");
			//handle things in bathroom 1
			if (e.target == mRooms.bath1.hitWashers) mText.addText(false, "Use on Laundry Machines");
			if (e.target == mRooms.bath1.hitSink) mText.addText(false, "Use on Sink");
			if (e.target == mRooms.bath1.hitToilet) mText.addText(false, "Use on Toilet");
			//handle things in bathroom 2
			if (e.target == mRooms.bath2.hitSink) mText.addText(false, "Use on Sink");
			if (e.target == mRooms.bath2.hitToilet) mText.addText(false, "Use on Toilet");
			if (e.target == mRooms.bath2.hitShower) mText.addText(false, "Use on Shower");
			if (e.target == mRooms.bath2.shower) mText.addText(false, "Use on Showerhead");
			//handle things in bedroom 1
			if (e.target == mRooms.bed1.hitTelescope) mText.addText(false, "Use on Telescope");
			if (e.target == mRooms.bed1.hitLaptop) mText.addText(false, "Use on Laptop");
			if (e.target == mRooms.bed1.hitPoster) mText.addText(false, "Use on Poster");
			if (e.target == mRooms.bed1.list) mText.addText(false, "Use on Task List");
			
			//handle things in bedroom 2
			if (e.target == mRooms.bed2.hitPoster) mText.addText(false, "Use on Poster");
			//handle things in dining room
			if (e.target == mRooms.dining.hitInfo) mText.addText(false, "Use on lower Vase");
			//handle things in garage
			if (e.target == mRooms.garage.hitInfo) mText.addText(false, "Use on Oil Spill");
			//handle things in kitchen
			if (e.target == mRooms.kitchen.hitFridge) mText.addText(false, "Use on Fridge");
			if (e.target == mRooms.kitchen.hitDishwasher) mText.addText(false, "Use on Dishwasher");
			if (e.target == mRooms.kitchen.hitLeak) mText.addText(false, "Use on Leak");
			if (e.target == mRooms.kitchen.recycling) mText.addText(false, "Use on Recycling Bin");
		}
		
		private function onOut(e:MouseEvent):void {
			mText.addText(false, "");
		}
		
		//-----------------------------------------------getters and setters
		public static function get tryingItem():Boolean {
			return _tryingItem;
		}		
		public static function set tryingItem(value:Boolean):void {
			_tryingItem = value;
		}
		
	}
	
}