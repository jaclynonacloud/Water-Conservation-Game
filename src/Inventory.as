package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author Jaclyn Staples
	 * This class controls items used in the inventory system.  Once the item is actively being used, see Main class.
	 */
	public class Inventory extends MovieClip {
		//constant events
		public static const NEW_ITEM:String = "newItem";
		//key events
		public static const COLLECT_GARAGEKEY:String = "collectGarageKey";
		public static const COLLECT_WRENCH:String = "collectWrench";
		public static const COLLECT_FUSE:String = "collectFuse";
		public static const COLLECT_SHOWERHEAD:String = "collectShowerHead";
		public static const COLLECT_LOWFLOW:String = "collectLowFlow";
		//
		public static const TRY_ITEM:String = "tryItem";
		
		//skins
		private var inv:Util_Inventory;
		//classes
		private var mText:ManageTextbox;
		private var mRooms:ManageRooms;
		private var mProg:ManageProgress;
		//inventory sprites
		public var invWrench:InvWrench;
		public var invKey:InvKey;
		public var invCloth:InvCloth;
		public var invBottle:InvBottle;
		public var invPlate:InvPlate;
		public var invShower:InvShowerHead;
		public var invLowFlow:InvLowFlow;
		
		//variables
		private var _curItem:Sprite; //current item being selected
		private var invCount:int; //counts how many items are in the inventory
		private var itemArray:Vector.<Sprite>; //holds items in array
		private var boxArray:Array; //holds the box info
		
		public function Inventory(manageText:ManageTextbox, manageRooms:ManageRooms, manageProgress:ManageProgress) {
			mRooms = manageRooms;
			mText = manageText;
			mProg = manageProgress;
			inv = new Util_Inventory();
			addChild(inv);
			invWrench = new InvWrench();
			invKey = new InvKey();
			invCloth = new InvCloth();
			invBottle = new InvBottle();
			invPlate = new InvPlate();
			invShower = new InvShowerHead();
			invLowFlow = new InvLowFlow();
			
			inv.txtInfo.text = "To see what each item is, select the item.  To use an item, click the use button once an item is selected.";
			
			boxArray = [inv.box1, inv.box2, inv.box3, inv.box4, inv.box5, inv.box6, inv.box7, inv.box8, inv.box9, inv.box10, inv.box11, inv.box12, inv.box13];
			reset();
			
		}
		
		//----------------------------------------------methods
		public function makeInventoryItems(arrayOfItems:Array):void {
			//adds item to game inventory
			for each(var item:Sprite in arrayOfItems) {
				//-----------------------------------------handle multiple items
				item.addEventListener(MouseEvent.MOUSE_DOWN, getItem);
				item.addEventListener(MouseEvent.MOUSE_OVER, seeItem);
				item.addEventListener(MouseEvent.MOUSE_OUT, onOut);
				item.buttonMode = true;
			}
		}
		
		public function returnItem(itemToReturn:Sprite):void {
			//returns item to inventory if unsuccessfully used
			var item:Sprite = itemToReturn;
			setItem();
			Main.tryingItem = false;
		}
		
		public function removeItem(itemToRemove:Sprite):void {
			//removes item from game- makes sure item was used successfully
			itemArray.splice(itemArray.indexOf(itemToRemove), 1);
			itemToRemove.visible = false;
			Main.tryingItem = false;
		}
		
		public function setItem():void {
			if (invCount <= 12) {
				//cap the inventory items at 13- num of boxes
				
				//layout items
				for (var i:int = 0; i < itemArray.length; i++) {
					addChild(itemArray[i]);
					if (itemArray[i] != invBottle) {
						itemArray[i].width = (boxArray[i].width);
						itemArray[i].scaleY = itemArray[i].scaleX;
						itemArray[i].x = (boxArray[i].x);
						itemArray[i].y = ((boxArray[i].y) + ((boxArray[i].height / 2) - (itemArray[i].height / 2)));
					}
					else {
						//size bottle differently, cause he's a jerk
						itemArray[i].height = (boxArray[i].height);
						itemArray[i].scaleX = itemArray[i].scaleY;
						itemArray[i].x = (boxArray[i].x) + ((boxArray[i].width / 2) - (itemArray[i].width / 2));
						itemArray[i].y = ((boxArray[i].y) + ((boxArray[i].height / 2) - (itemArray[i].height / 2)));
					}
				}
				
			}else {
				//inventory full
				trace("Inventory is full");
				mText.addText(true, "Inventory is Full; Although I'm not sure how you pulled if off.");
			}
			//check inventory array
			trace("List of items in array: " + itemArray.toString() + ".");
		}
	
		public function reset():void {
			invCount = 0;
			_curItem = null;
			
			itemArray = new Vector.<Sprite>();
			
			//reset arrays if not empty
			if (itemArray != null) for each(var item:Sprite in itemArray) itemArray.shift();
			
		}
		
		//----------------------------------------------event handlers
		private function getItem(e:MouseEvent):void {
			if(!Main.tryingItem){
				//invoked by manageitems class
				invCount = itemArray.length; //changes inventory count to match itemArray length
				//controls the number of items in the inventory
				if(e.target.name != "wrench"){
					if (!mProg.firstItem) {
						mText.addText(true, "\n\nThis item is now in my inventory. \nI can see what's there by clicking the icon in the bottom right.");
						mProg.firstItem = true;
					}
				}
				
				//control items that are defined by the task list
				if (e.target.name == "silverKey") {
					dispatchEvent(new Event(Inventory.COLLECT_GARAGEKEY));
					mRooms.bath2.iKey.visible = false;
					mRooms.bath2.silverKey.visible = false;
					addChild(invKey);
					//toggle alphas to draw out current item
					e.currentTarget.alpha = .5;
					itemArray.push(invKey);
				}
				if (e.target.name == "fuse") {
					dispatchEvent(new Event(Inventory.COLLECT_FUSE));
					//toggle alphas to draw out current item
					e.currentTarget.alpha = .5;
					itemArray.push(e.currentTarget);
				}
				if (e.target.name == "showerHead") {
					//collect shower head
					dispatchEvent(new Event(Inventory.COLLECT_SHOWERHEAD));
					mRooms.garage.iShowerHead.visible = false;
					mRooms.garage.showerHead.visible = false;
					addChild(invShower);
					//toggle alphas to draw out current item
					e.currentTarget.alpha = .5;
					itemArray.push(invShower);
				}
				if (e.target.name == "lowFlow") {
					//collect low flow kit
					dispatchEvent(new Event(Inventory.COLLECT_LOWFLOW));
					mRooms.base.iLowFlow.visible = false;
					addChild(invLowFlow);
					//toggle alphas to draw out current item
					e.currentTarget.alpha = .5;
					itemArray.push(invLowFlow);
				}
				
				
				//------------------------------------------handle if item can be picked up
				if (e.target.name == "wrench") {
					if(mProg.unlockGarage){
						dispatchEvent(new Event(Inventory.COLLECT_WRENCH));
						mRooms.garage.iWrench.visible = false;
						mRooms.garage.wrench.visible = false;
						//toggle alphas to draw out current item
						addChild(invWrench);
						invWrench.alpha = .5;
						itemArray.push(invWrench);
					}
				}
				
				//-----------------------------------------handle multiple items
				//-----clothing
				if (e.target is HIT_Cloth) {
					if (!this.contains(invCloth)) {
						//if inventory image is not shown, will add to inventory
						addChild(invCloth);
						invCloth.alpha = .5;
						itemArray.push(invCloth);
					}
					
					//add count and remove hitbox
					mProg.numOfClothes += 1;
					trace("Get Cloth!");
					e.currentTarget.visible = false;
					
					//check to see if all clothes have been found
					if (mProg.numOfClothes >= ManageProgress.TOTAL_CLOTHES) {
						//found all the clothes
						//mText.addText(true, "Yay! All the clothes!");
						mProg.gotClothes = true;
					}
					
					//remove clothing images
					if (e.target == mRooms.bath2.cloth1) mRooms.bath2.iCloth1.visible = false;
					if (e.target == mRooms.bed1.cloth1) mRooms.bed1.iCloth1.visible = false;
					if (e.target == mRooms.bed1.cloth2) mRooms.bed1.iCloth2.visible = false;
					if (e.target == mRooms.bed1.cloth3) mRooms.bed1.iCloth3.visible = false;
					if (e.target == mRooms.bed2.cloth1) mRooms.bed2.iCloth1.visible = false;
					if (e.target == mRooms.bed2.cloth2) mRooms.bed2.iCloth2.visible = false;
					if (e.target == mRooms.bed2.cloth3) mRooms.bed2.iCloth3.visible = false;
					if (e.target == mRooms.bed2.cloth4) mRooms.bed2.iCloth4.visible = false;
					if (e.target == mRooms.bed2.cloth5) mRooms.bed2.iCloth5.visible = false;
					
					
				}
				//-----plates
				if (e.target is HIT_Plate) {
					if (!this.contains(invPlate)) {
						//if inventory image is not shown, will add to inventory
						addChild(invPlate);
						invPlate.alpha = .5;
						itemArray.push(invPlate);
					}
					
					//add count and remove hitbox
					if (e.target == mRooms.dining.plate1 || e.target == mRooms.dining.plate2) mProg.numOfPlates += 2; //double the plates
					else mProg.numOfPlates += 1;
					trace("Get Plate!");
					e.currentTarget.visible = false;
					
					//check to see if all bottles have been found
					if (mProg.numOfPlates >= ManageProgress.TOTAL_PLATES) {
						//found all the clothes
						//mText.addText(true, "Yay! All the plates!");
						mProg.gotPlates = true;
					}
					
					//remove plate images
					if (e.target == mRooms.dining.plate1) mRooms.dining.iPlate1.visible = false;
					if (e.target == mRooms.dining.plate2) mRooms.dining.iPlate2.visible = false;
					if (e.target == mRooms.kitchen.plate1) mRooms.kitchen.iPlate1.visible = false;
				}
				
				//-----bottles
				if (e.target is HIT_Bottle) {
					//collect some bottles
					if (!this.contains(invBottle) || !invBottle.visible) {
						//if inventory image is not shown, will add to inventory
						addChild(invBottle);
						invBottle.visible = true;
						invBottle.alpha = .5;
						itemArray.push(invBottle);
					}
					
					//add count and remove hitbox
					mProg.numOfBottles += 1;
					trace("Get Bottle!");
					e.currentTarget.visible = false;
					
					//check to see if all bottles have been found
					if ((mProg.numOfBottles + mProg.numRecycled) >= ManageProgress.TOTAL_BOTTLES) {
						//found all the clothes
						//mText.addText(true, "Yay! All the bottles!");
						mProg.gotBottles = true;
					}
					
					//remove bottle images
					if (e.target == mRooms.bath1.wBottle1) mRooms.bath1.iBottle1.visible = false;
					if (e.target == mRooms.bed1.wBottle1) mRooms.bed1.iBottle1.visible = false;
					if (e.target == mRooms.bed1.wBottle2) mRooms.bed1.iBottle2.visible = false;
					if (e.target == mRooms.bed1.wBottle3) mRooms.bed1.iBottle3.visible = false;
					if (e.target == mRooms.bed2.wBottle1) mRooms.bed2.iBottle1.visible = false;
					if (e.target == mRooms.bed2.wBottle2) mRooms.bed2.iBottle2.visible = false;
					if (e.target == mRooms.dining.wBottle1) mRooms.dining.iBottle1.visible = false;
					if (e.target == mRooms.dining.wBottle2) mRooms.dining.iBottle2.visible = false;
					if (e.target == mRooms.kitchen.wBottle1) mRooms.kitchen.iBottle1.visible = false;
					if (e.target == mRooms.kitchen.wBottle2) {
						mRooms.kitchen.iBottle2.visible = false;
						mRooms.gotFridgeBottle = true;
					}
				}
				//-----------------------------------------end of multiple items
				
				//give items options
				for each(var item:Sprite in itemArray) {
					item.addEventListener(MouseEvent.MOUSE_DOWN, onCheck);
					item.addEventListener(MouseEvent.MOUSE_OUT, onOut);
					item.addEventListener(MouseEvent.MOUSE_OVER, seeItem);
					item.removeEventListener(MouseEvent.MOUSE_DOWN, getItem);
					item.buttonMode = true;
				}
				inv.btnUse.addEventListener(MouseEvent.MOUSE_DOWN, onCheck);
				
				setItem();
				dispatchEvent(new Event(Inventory.NEW_ITEM));
			}
		}
		
		//inventory checks
		private function onCheck(e:MouseEvent):void {
			trace("Do something");
			//changes alpha so that active object stands out
			for each(var item:Sprite in itemArray) {
				item.alpha = .5;
			}
			if(e.target.name != "btnUse"){
				_curItem = Sprite(e.currentTarget);
				_curItem.alpha = 1;
				inv.btnUse.visible = true;
			}
			else if (e.target.name == "btnUse") onTry();
			
			
			//words to put as description
			if (e.target == invKey) inv.txtInfo.text = "Garage Key-\n  This can be used on the Garage Door.";
			if (e.target == invWrench) inv.txtInfo.text = "Wrench-\n I can use this wrench to fix leaky faucets!";
			if (e.target.name == "fuse") inv.txtInfo.text = "Fuse-\n This belongs in the basement.";
			if (e.target == invShower) inv.txtInfo.text = "Low-Flow Showerhead-\n I can replace our old showerhead in the bathroom with this.";
			if (e.target == invLowFlow) inv.txtInfo.text = "Low-Flow Toilet Kit-\n I can install this onto the toilet upstairs to make the toilet use less water.";
			if (e.target == invCloth) {
				if (mProg.gotClothes) inv.txtInfo.text = "Clothes (x" + mProg.numOfClothes + ") -\n I've collected all the clothing. I can put on a full load of laundry.";
				else  inv.txtInfo.text = "Clothes (x" + mProg.numOfClothes + ") -\n I should collect all the clothes I can find, so I can put on a full load of laundry.";
			}
			if (e.target == invPlate) {
				if (mProg.gotPlates) inv.txtInfo.text = "Dishes (x" + mProg.numOfPlates + ") -\n I have all the dishes! I should put the plates in the dishwasher.";
				else inv.txtInfo.text = "Dishes (x" + mProg.numOfPlates + ") -\n I should collect all the dishes before putting them in the dishwasher.";
			}
			if (e.target == invBottle) inv.txtInfo.text = "Water Bottles (x" + mProg.numOfBottles + ") -\n I can collect these bottles and put them in the recycling bin in the kitchen.";
		}
		
		private function onTry():void {
			dispatchEvent(new Event(Inventory.TRY_ITEM));
		}
		
		private function onOut(e:MouseEvent):void {
			mText.addText(false, "");
		}
		
		//see item in textbox
		private function seeItem(e:MouseEvent):void {
			//list what items will say when run over
			if(!Main.tryingItem){
				if (e.target.name == "showerHead") mText.addText(false, "Pick up Low-Flow Showerhead");
				if (e.target.name == "silverKey") mText.addText(false, "Pick Up Garage Key");
				if (e.target.name == "wrench")  mText.addText(false, "Pick Up Wrench");
				if (e.target.name == "fuse") mText.addText(false, "Pick Up Fuse");
				if (e.target.name == "lowFlow") mText.addText(false, "Pick Up Low-Flow Toilet Kit");
				if (e.target is HIT_Cloth) mText.addText(false, "Pick Up Clothing");
				if (e.target is HIT_Plate) mText.addText(false, "Pick Up Dish");
				if (e.target is HIT_Bottle) mText.addText(false, "Pick up Water Bottle");
				//repurposed objects
				if (e.target == invKey) mText.addText(false, "Key");
				if (e.target == invWrench)  mText.addText(false, "Wrench");
				if (e.target == invShower) mText.addText(false, "Low-Flow Showerhead");
				if (e.target == invLowFlow) mText.addText(false, "Low-Flow Toilet Kit");
				if (e.target == invCloth)  mText.addText(false, "Clothing");
				if (e.target == invBottle) mText.addText(false, "Water Bottle");
				if (e.target == invPlate) mText.addText(false, "Dish");
			}
		}
		
		//----------------------------------------------display methods
		public function showMe(root:Sprite):void {
			root.addChild(this);
			inv.txtInfo.text = "To see what each item is, select the item.  To use an item, click the use button once an item is selected.";
			inv.btnUse.visible = false;
		}
		
		public function hideMe():void {
			parent.removeChild(this);
			inv.txtInfo.text = "";
		}
		
		//------------------------------------------------ getters and setters
		//change current item get
		public function get curItem():Sprite {
			return _curItem;
		}
		
	}

}