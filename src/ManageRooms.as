package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Jaclyn Staples
	 * controls all rooms and how/when they are added to the display list
	 * when adding new information, specify the hitbox in onClick(), give a buttonMode in constructor, and give a title in onOver()
	 */
	public class ManageRooms extends MovieClip {
		//declare class constants
		public static const ROOM_CHANGE:String = "roomChange";
		public static const UNLOCK_TASKLIST:String = "unlockTasklist";
		public static const WARN_BED1:String = "warnBed1";
		public static const UNLOCK_ATTIC:String = "unlockAttic";
		public static const WARN_ATTIC:String = "warnAttic";

		//declare classes
		private var items:Inventory;
		private var mProgress:ManageProgress;
		private var mText:ManageTextbox;
		
		//declare rooms
		public var attic:R_Attic;
		public var back:R_Backyard;
		public var base:R_Basement;
		public var bath1:R_Bathroom1;
		public var bath2:R_Bathroom2;
		public var bed1:R_Bedroom1;
		public var bed2:R_Bedroom2;
		public var dining:R_Dining;
		public var garage:R_Garage;
		public var hall1:R_Hallway1;
		public var hall2:R_Hallway2;
		public var kitchen:R_Kitchen;
		
		//variables
		private var _curRoom:String;
		private var timer:Timer;
		private var alphaLvl:Number;
		private var alphaMov:MovieClip;
		private var fridgeOpen:Boolean;
		public var gotFridgeBottle:Boolean; //used to represent whether bottle in fridge has been collected
		private var _isListeners:Boolean;
		
		//buttons arays
		private var infoArray:Array;
		private var doorArray:Array;
		
		
		public function ManageRooms(mP:ManageProgress, mT:ManageTextbox) {
			mProgress = mP;
			mText = mT;		
			reset();
		}
		
		public function reset():void {
			//load rooms- only needs to be done once
			attic = new R_Attic();
			back = new R_Backyard();
			base = new R_Basement();
			bath1 = new R_Bathroom1();
			bath2 = new R_Bathroom2();
			bed1 = new R_Bedroom1();
			bed2 = new R_Bedroom2();
			dining = new R_Dining();
			garage = new R_Garage();
			hall1 = new R_Hallway1();
			hall2 = new R_Hallway2();
			kitchen = new R_Kitchen();
			
			garage.garDark.visible = false;
			attic.txtBonus.text = "";
			fridgeOpen = false;
			gotFridgeBottle = false;
			//tell game what is NOT clickable
			//basement
			setAttributes(base.iLowFlow, true, false); //image
			setAttributes(base.lowFlow, true, true); //hitbox
			//bath1
			setAttributes(bath1.iBottle1, true, false); //image
			setAttributes(bath1.wBottle1, true, true); //hitbox
			setAttributes(bath1.leak, true, false); //image only
			//bath2
			setAttributes(bath2.newShower, false, false);
			setAttributes(bath2.oldShower, true, false);
			setAttributes(bath2.leak, true, false);
			setAttributes(bath2.hitSink, true, true);
			setAttributes(bath2.iCloth1, true, false);
			setAttributes(bath2.iKey, true, false);
			setAttributes(bath2.silverKey, true, true);
			//bed1
			setAttributes(bed1.list, true, true);
			setAttributes(bed1.iCloth1, true, false); //image
			setAttributes(bed1.iCloth2, true, false);
			setAttributes(bed1.iCloth3, true, false);
			setAttributes(bed1.cloth1, true, true); //hitbox
			setAttributes(bed1.cloth2, true, true);
			setAttributes(bed1.cloth3, true, true);
			setAttributes(bed1.iBottle1, true, false); //image
			setAttributes(bed1.iBottle2, true, false);
			setAttributes(bed1.iBottle3, true, false);
			setAttributes(bed1.wBottle1, true, true); //hitbox
			setAttributes(bed1.wBottle2, true, true);
			setAttributes(bed1.wBottle3, true, true);
			//bed2
			setAttributes(bed2.iCloth1, true, false); //image
			setAttributes(bed2.iCloth2, true, false);
			setAttributes(bed2.iCloth3, true, false);
			setAttributes(bed2.iCloth4, true, false);
			setAttributes(bed2.iCloth5, true, false);
			setAttributes(bed2.cloth1, true, true); //hitbox
			setAttributes(bed2.cloth2, true, true);
			setAttributes(bed2.cloth3, true, true);
			setAttributes(bed2.cloth4, true, true);
			setAttributes(bed2.cloth5, true, true);
			setAttributes(bed2.iBottle1, true, false); //image
			setAttributes(bed2.iBottle2, true, false);
			setAttributes(bed2.wBottle1, true, true); //hitbox
			setAttributes(bed2.wBottle2, true, true);
			//dining
			setAttributes(dining.iBottle1, true, false); //image
			setAttributes(dining.iBottle2, true, false);
			setAttributes(dining.wBottle1, true, true); //hitbox
			setAttributes(dining.wBottle2, true, true);
			setAttributes(dining.iPlate1, true, false); //image
			setAttributes(dining.iPlate2, true, false);
			setAttributes(dining.plate1, true, true); //hitbox
			setAttributes(dining.plate2, true, true);
			setAttributes(dining.fuse, false, false);
			//garage
			setAttributes(garage.iWrench, true, false); //image
			setAttributes(garage.wrench, true, true); //hitbox
			setAttributes(garage.iShowerHead, true, false); //image
			setAttributes(garage.showerHead, true, true); //hitbox
			//hall1
			setAttributes(hall1.iWaterLeak, true, false); //image only
			//kitchen
			setAttributes(kitchen.iFridge, false, false); //close fridge at start
			setAttributes(kitchen.hitFridge, true, true); //hitbox
			setAttributes(kitchen.leak, true, false); //image
			setAttributes(kitchen.hitLeak, true, true); //hitbox
			setAttributes(kitchen.iBottle1, true, false); //image
			setAttributes(kitchen.iBottle2, false, false);
			setAttributes(kitchen.wBottle1, true, true); //hitbox
			setAttributes(kitchen.wBottle2, false, false); //hide fridge bottle
			
			_isListeners = true;

			
			//load variables- only ones to be loaded once
			timer = new Timer(60, 0);
			
			addListeners();
		}
		
		//----------------------------------------------------------------------methods
		public function changeRoom(roomType:String, ease:Boolean):void {
			//eases the room
			trace("Current Room: " + roomType);
			_curRoom = roomType;
			//setup
			alphaLvl = 0;
			alphaMov = null;
			timer.reset(); //reset tween timer
			if (roomType == "attic") {
				if (ease) easeIn(attic);
				else addChild(attic);
			}else if (roomType == "back") {
				if (ease) easeIn(back);
				else addChild(back);
			}else if (roomType == "base") {
				if (ease) easeIn(base);
				else addChild(base);
			}else if (roomType == "bath1") {
				if (ease) easeIn(bath1);
				else addChild(bath1);
			}else if (roomType == "bath2") {
				if (ease) easeIn(bath2);
				else addChild(bath2);
			}else if (roomType == "bed1") {
				if (ease) easeIn(bed1);
				else addChild(bed1);
			}else if (roomType == "bed2") {
				if (ease) easeIn(bed2);
				else addChild(bed2);
			}else if (roomType == "dining") {
				if (ease) easeIn(dining);
				else addChild(dining);
			}else if (roomType == "garage") {
				if (ease) easeIn(garage);
				else addChild(garage);
			}else if (roomType == "hall1") {
				if (ease) easeIn(hall1);
				else addChild(hall1);
			}else if (roomType == "hall2") {
				if (ease) easeIn(hall2);
				else addChild(hall2);
			}else if (roomType == "kitchen") {
				if (ease) easeIn(kitchen);
				else addChild(kitchen);
			}else {
				trace("No room loaded, check naming");
			}
			
			dispatchEvent(new Event(ManageRooms.ROOM_CHANGE));
		}
		
		private function easeIn(roomToEase:MovieClip):void {
			//used to ease the room change if desired
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, timerEvent);
			alphaMov = roomToEase;
			roomToEase.alpha = 0;
			//-----------------trace("Alpha level: " + roomToEase.alpha);
			addChild(roomToEase);
		}
		//-------------------------------------------------------------------room actions
		private function onClick(e:MouseEvent):void {
			//manages door clicks
			if (e.target.name == "doorAttic") {
				trace("Is attic open? " + mProgress.unlockAttic);
				if (mProgress.unlockAttic) {
					attic.txtBonus.visible = true;
					attic.txtBonus.text = "You also recycled " + String(mProgress.numRecycled) + " bottles!";
					changeRoom("attic", false);
				}
				else mText.addText(true, "\n\nI'm not going up there right now.");
			}
			if (e.target.name == "doorBYard") changeRoom("back", false);
			if (e.target.name == "doorBasement") changeRoom("base", false);
			if (e.target.name == "doorBath1") changeRoom("bath1", false);
			if (e.target.name == "doorBath2") changeRoom("bath2", false);
			if (e.target.name == "doorBed1") changeRoom("bed1", false);
			if (e.target.name == "doorBed2") changeRoom("bed2", false);
			if (e.target.name == "doorDRoom") changeRoom("dining", false);
			if (e.target.name == "doorGarage") {
				if (mProgress.unlockGarage) changeRoom("garage", false);
				else mText.addText(true, "The door to the garage is locked.  I'll need to find the key.~\n\nIf I find the key, it will be put in my inventory.");
			}
			if (e.target.name == "doorHall2" && e.target != attic.doorHall2) {
				//don't open door unless task list is picked up
				if (mProgress.isListed) changeRoom("hall2", false);
				else mText.addText(true, "I should grab my Task list on the wall, so I'll know what I need to do to fix up the house.");
			}
			if (e.target.name == "doorHall1") changeRoom("hall1", false);
			if (e.target.name == "doorKitch") changeRoom("kitchen", false);
			
			for each(var door:Sprite in doorArray) {
				if (e.target == door) {
					//make sound
					if( e.target == hall1.doorKitch || e.target == kitchen.doorHall1 || e.target == kitchen.doorDRoom || e.target == dining.doorKitch || e.target == hall1.doorHall2 || e.target == hall2.doorHall1 || e.target == hall2.doorAttic){}
					else ManageSounds.playSound(ManageSounds.SND_DOORCLOSE);
				}
			}
			
			
			//handle hitboxes
			//handle things in attic
			//handle things in backyard
			if (e.target == back.hitGrass) mText.addText(true, "DID YOU KNOW:\n\nLeaving lawn clippings on your grass helps cool the ground and holds in moisture.");
			if (e.target == back.hitHose && back.leak.visible) mText.addText(true, "\n\nThis hose if leaking!  I can fix it with a wrench.~\n\nIf I find a wrench, it will be put in my inventory.");
			if (e.target == back.hitHose && !back.leak.visible) mText.addText(true, "DID YOU KNOW:\n\nYou can set a kitchen timer when using the hose as a reminder to turn it off. A running hose can discharge up to 44 litres per minute.");
			//handle things in basement
			if (e.target == base.waterTank) mText.addText(true, "DID YOU KNOW:\n\nBy draining a few litres from your hot water tank once a year, you can minimize the sediment buildup that causes a water heater to work harder, wasting energy.");
			//handle things in bathroom 1
			if (e.target == bath1.hitWashers && mProgress.washClothes) mText.addText(true, "DID YOU KNOW: \n\nWashing dark clothes in cold water saves water and energy, and helps your clothes retain their color."); //clothes have been washed
			if (e.target == bath1.hitWashers && !mProgress.washClothes) mText.addText(true, "\n\nThere's laundry scattered around the house.  I should pick it up and do a load of laundry.~\n\nIf I find any laundry, it will be put in my inventory."); //clothes are not washed
			if (e.target == bath1.hitSink && bath1.leak.visible) mText.addText(true, "\n\nI could fix this leak with a wrench.~\n\nIf I find a wrench, it will be put in my inventory."); //leaking
			if (e.target == bath1.hitSink && !bath1.leak.visible) mText.addText(true, "\n\nRemember to not leave the tap running while brushing your teeth or shaving."); //not leaking
			if (e.target == bath1.hitToilet) mText.addText(true, "DID YOU KNOW:\n\nToilet leaks can be silent! Be sure to test your toilet for leaks at least once a year.");
			//handle things in bathroom 2
			if (e.target == bath2.hitSink && bath2.leak.visible) mText.addText(true, "\n\nThis sink is leaking.  I could repair it with a wrench.~\n\nIf I find a wrench, it will be put in my inventory."); //leaky sink
			if (e.target == bath2.hitSink && !bath2.leak.visible) mText.addText(true, "DID YOU KNOW:\n\nA leaky faucet that drips once a second can waste over 350 litres of water a day."); //not leaky sink
			if (e.target == bath2.hitToilet && mProgress.installLowFlow) mText.addText(true, "DID YOU KNOW:\nToilets account for 30% of residential water usage. Low-flow kits are a worth-while investment and can save thousands of litres a year."); //installed low-flow kit
			if (e.target == bath2.hitToilet && !mProgress.installLowFlow) mText.addText(true, "\n\nI know there's a low-flow kit for this toilet somewhere...~\n\nIf I find the kit, it will be put in my inventory."); //no install
			if (e.target == bath2.shower && mProgress.changeShower) mText.addText(true, "DID YOU KNOW: \n\n If you use a low­flow showerhead, you can save over 50 liters of \nwater during a 10 minute shower."); //new showerhead
			if (e.target == bath2.shower && !mProgress.changeShower) mText.addText(true, "\n\nThis old shower head is such a water waster.  There's a new showerhead laying around somewhere.~\n\nIf I find the showerhead, it will be put in my inventory."); //old showerhead
			//handle things in bedroom 1
			if (e.target == bed1.hitTelescope) mText.addText(true, "DID YOU KNOW:\n\nEarth is the only known planet to have stable liquid water on it’s surface.");
			if (e.target == bed1.hitLaptop) mText.addText(true, "DID YOU KNOW:\n\nThere is oodles of information online about water conservation and easy steps to get anyone started.");
			if (e.target == bed1.hitPoster) mText.addText(true, "DID YOU KNOW:\n\n If every house in Canada had a faucet that dripped every second, about 3.5 million litres of water would leak a day.");
			if (e.target == bed1.list) {
				dispatchEvent(new Event(ManageRooms.UNLOCK_TASKLIST));
				e.target.visible = false;
			}
			//handle things in bedroom 2
			if (e.target == bed2.hitPoster) mText.addText(true, "DID YOU KNOW:\n\nApproximately 1.6 million kilometers of pipelines and aqueducts carry water in the US and Canada. ~Thats enough pipe to circle the globe 40 times.");
			//handle things in dining room
			if (e.target == dining.hitInfo) mText.addText(true, "\n\nThis plant has a plant feeder so that our family doesn't over-water it, which can help cut back on water waste!");
			//handle things in garage
			if (e.target == garage.hitInfo) mText.addText(true, "\n\nDon’t wash things like engine oil down the drain! Use cat litter or a commercial absorbent to clean spills instead.");
			//handle things in kitchen
			if (e.target == kitchen.hitInfo) mText.addText(true, "DID YOU KNOW:\n\n The average faucet flows at 8 litres per minute.");
			if (e.target == kitchen.hitFridge) {
				trace(gotFridgeBottle + ": Got Bottle in Fridge");
				if (!fridgeOpen) fridgeOpen = true;
				else fridgeOpen = false;
				//show water bottle
				if (fridgeOpen) {
					if (!gotFridgeBottle) setAttributes(kitchen.iBottle2, true, false);
					if (!gotFridgeBottle) setAttributes(kitchen.wBottle2, true, true);
					setAttributes(kitchen.iFridge, true, false);
				}
				else {
					setAttributes(kitchen.iBottle2, false, false);
					setAttributes(kitchen.wBottle2, false, false);
					setAttributes(kitchen.iFridge, false, false);
				}
			}
			if (e.target == kitchen.hitDishwasher && !mProgress.washDishes) mText.addText(true, "I should find all the silverware lying around, so that I can do a load of dishes.~\n\nIf I find any dishes, they will be put in my inventory."); //not all dishes
			else if (e.target == kitchen.hitDishwasher && mProgress.washDishes) mText.addText(true, "DID YOU KNOW:\n\nHandwashing dishes may take around 103 litres of water, but dishwashers only use around 15 litres.~\n\n\Dishwashing results in cleaner dishes as well!"); //all dishes
			if (e.target == kitchen.hitLeak && kitchen.leak.visible) mText.addText(true, "The sink is leaking.  I could fix it with a wrench.~\n\nIf I find a wrench, it will be put in my inventory."); //fixed leak
			else if (e.target == kitchen.hitLeak && !kitchen.leak.visible) mText.addText(true, "I repaired the sink with the wrench.  Now, it won't leak water! ~DID YOU KNOW:\n\nThe average faucet flows at 8 litres per minute."); //no leak
			if (e.target == kitchen.recycling && !mProgress.recycledAll) mText.addText(true, "I've recycled " + String(mProgress.numRecycled) + " bottles so far.  If I collect any, they will go into my inventory. ~ DID YOU KNOW:\n\n35% of all water bottles in Toronto are not recycled and end up in landfills, or worse, as litter in forests, lakes and oceans. ~\n\nThat’s over 35 million a year.");
			if (e.target == kitchen.recycling && mProgress.recycledAll) mText.addText(true, "I've recycled all the bottles! ~ DID YOU KNOW:\n\n35% of all water bottles in Toronto are not recycled and end up in landfills, or worse, as litter in forests, lakes and oceans. ~\n\nThat’s over 35 million a year.");
			
		}
		
		private function onOver(e:MouseEvent):void {
			if (e.target.name == "doorAttic") mText.addText(false, "Go to Attic");
			if (e.target.name == "doorBYard")  mText.addText(false, "Go to Backyard");
			if (e.target.name == "doorBasement")  mText.addText(false, "Go to Basement");
			if (e.target.name == "doorBath1")  mText.addText(false, "Go to Bathroom");
			if (e.target.name == "doorBath2")  mText.addText(false, "Go to Bathroom");
			if (e.target.name == "doorBed1")  mText.addText(false, "Go to Jack's Bedroom");
			if (e.target.name == "doorBed2")  mText.addText(false, "Go to Bedroom");
			if (e.target.name == "doorDRoom")  mText.addText(false, "Go to Dining Room");
			if (e.target.name == "doorGarage")  mText.addText(false, "Go to Garage");
			if (e.target.name == "doorHall2" && e.target != hall1.doorHall2)  mText.addText(false, "Go to Hallway");
			if (e.target == hall1.doorHall2)  mText.addText(false, "Go Upstairs");
			if (e.target.name == "doorHall1" && e.target != hall2.doorHall1)  mText.addText(false, "Go to Hallway");
			if (e.target == hall2.doorHall1)  mText.addText(false, "Go Downstairs");
			if (e.target.name == "doorKitch")  mText.addText(false, "Go to Kitchen");
			
			//handle hitboxes
			//handle things in attic
			//handle things in backyard
			if (e.target == back.hitGrass) mText.addText(false, "Look at Lawn");
			if (e.target == back.hitHose) mText.addText(false, "Look at Hose");
			//handle things in basement
			if (e.target == base.waterTank) mText.addText(false, "Look at Water Tank");
			//handle things in bathroom 1
			if (e.target == bath1.hitWashers) mText.addText(false, "Look at Laundry Machines");
			if (e.target == bath1.hitSink) mText.addText(false, "Look at Sink");
			if (e.target == bath1.hitToilet) mText.addText(false, "Look at Toilet");
			//handle things in bathroom 2
			if (e.target == bath2.hitSink) mText.addText(false, "Look at Sink");
			if (e.target == bath2.hitToilet) mText.addText(false, "Look at Toilet");
			if (e.target == bath2.hitShower) mText.addText(false, "Look at Shower");
			if (e.target == bath2.shower) mText.addText(false, "Look at Showerhead");
			//handle things in bedroom 1
			if (e.target == bed1.hitTelescope) mText.addText(false, "Look at Telescope");
			if (e.target == bed1.hitLaptop) mText.addText(false, "Look at Laptop");
			if (e.target == bed1.hitPoster) mText.addText(false, "Look at Poster");
			if (e.target == bed1.list) mText.addText(false, "Pick Up Task List");
			
			//handle things in bedroom 2
			if (e.target == bed2.hitPoster) mText.addText(false, "Look at Poster");
			//handle things in dining room
			if (e.target == dining.hitInfo) mText.addText(false, "Look at Flower Vase");
			//handle things in garage
			if (e.target == garage.hitInfo) mText.addText(false, "Look at Oil Spill");
			//handle things in kitchen
			if (e.target == kitchen.hitFridge) mText.addText(false, "Look at Fridge");
			if (e.target == kitchen.hitDishwasher) mText.addText(false, "Look at Dishwasher");
			if (e.target == kitchen.hitLeak) mText.addText(false, "Look at Leak");
			if (e.target == kitchen.recycling) mText.addText(false, "Look at Recycling Bin");
		}
		
		private function onOut(e:MouseEvent):void {
			if (e.target == MovieClip) e.target.buttonMode = false; //turns off button mode
			 mText.addText(false, "");
		}
		
		
		private function setAttributes(item:Sprite = null, visibility:Boolean = false, mEnabled:Boolean = false):void {
			if (item != null) {
				item.visible = visibility;
				item.mouseEnabled = mEnabled;
			}
		}
		
		public function addListeners():void {
			
			//make arrays for button clicking
			_isListeners = true;
			infoArray = new Array();
			//add to array
			infoArray.push(back.hitGrass);
			infoArray.push(back.hitHose);
			infoArray.push(base.waterTank);
			infoArray.push(bath1.hitWashers);
			infoArray.push(bath1.hitSink);
			infoArray.push(bath1.hitToilet);
			infoArray.push(bath2.hitSink);
			infoArray.push(bath2.hitToilet);
			infoArray.push(bath2.oldShower);
			infoArray.push(bath2.newShower);
			infoArray.push(bath2.shower);
			infoArray.push(bed1.hitTelescope);
			infoArray.push(bed1.hitLaptop);
			infoArray.push(bed1.list);
			infoArray.push(bed1.hitPoster);
			infoArray.push(bed2.hitPoster);
			infoArray.push(dining.hitInfo);
			infoArray.push(garage.hitInfo);
			infoArray.push(kitchen.hitFridge);
			infoArray.push(kitchen.hitDishwasher);
			infoArray.push(kitchen.hitLeak);
			infoArray.push(kitchen.recycling);
			
			doorArray = new Array(/*attic.doorHall2,*/ back.doorBasement, back.doorDRoom, base.doorBYard, bath1.doorHall1, bath2.doorHall2, bath2.doorHall2, bed1.doorHall2, bed2.doorHall2, dining.doorBYard, dining.doorKitch, garage.doorHall1, hall1.doorBath1, hall1.doorGarage, hall1.doorHall2, hall1.doorKitch, /*hall1.doorMain,*/ hall2.doorAttic, hall2.doorBath2, hall2.doorBed1, hall2.doorBed2, hall2.doorHall1, kitchen.doorDRoom, kitchen.doorHall1);

			
			for each(var info:MovieClip in infoArray) {
				info.buttonMode = true; //turns on button mode
				info.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
				info.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				info.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			}
			//use door array to cast events
			for each(var door:MovieClip in doorArray) {
				door.buttonMode = true; //turns on button mode
				door.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
				door.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				door.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			}
			
			trace("I have listeners.");
		}
		
		public function removeListeners():void {
			_isListeners = false;
			for each(var info:MovieClip in infoArray) {
				info.buttonMode = false; //turns on button mode
				info.removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
				info.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				info.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			}
			//use door array to cast events
			for each(var door:MovieClip in doorArray) {
				door.buttonMode = false; //turns on button mode
				door.removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
				door.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				door.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			}
			
			trace("I have no listeners.");
		}
		
		//-------------------------------------------------------------------event handlers
		
		private function timerEvent(e:TimerEvent):void {
			//---------------trace("Time: " + timer.currentCount);
			//causes the alpha to change on the room added
			alphaLvl = alphaLvl + 0.1;
			alphaMov.alpha = alphaLvl;
			//---------------trace("What is alpha: " + alphaLvl);
			if (timer.currentCount == 10) {
				alphaMov.alpha = 1;
				timer.stop();
			}
		}
		
		//------------------------------------------------ getters and setters
		//curRoom get
		public function get currRoom():String {
			return _curRoom;
		}
		//collect first item get/set
		public function get isListeners():Boolean {
			return _isListeners;
		}
		public function set isListeners(value:Boolean):void {
			_isListeners = value;
		}
		
		
		
		
	}

}