package  {
	/**
	 * ...
	 * @author Jaclyn Staples
	 */
	
	import flash.display.*;
	import flash.events.*;
	
	
	public class ManageTasks extends Sprite {
		
		//declare win
		public static const TASKS_COMPLETE:String = "tasksComplete";
		
		//declare screens
		private var tList:TaskList;
		private var mProgress:ManageProgress;
		private var overlay:Util_Overlay;
		private var mRooms:ManageRooms;
		//declare variables
		private var numTasks:int; //number of tasks completed
		
		public function ManageTasks(mP:ManageProgress, over:Util_Overlay, rooms:ManageRooms) {
			//initialize screens
			overlay = over;
			mProgress = mP;
			mRooms = rooms;
			tList = new TaskList();
			addChild(tList);
			
			reset();
			tList.task1.text = "Get Task List";
			tList.task2.text = "Find Garage Key";
			tList.task3.text = "Find Wrench";
			tList.task4.text = "Install New Shower Head";
			tList.task5.text = "Install Low-Flow Kit";
			tList.task6.text = "Fix all Leaks";
			tList.task7.text = "Wash the Dishes";
			tList.task8.text = "Collect all Laundry";
			tList.task9.text = "Wash the Laundry";
			tList.task10.text = "Go into Attic";
			tList.task11.text = "";
			tList.task12.text = "";
			tList.task13.text = "";
			tList.task14.text = "";
		}
		
		public function reset():void {
			tList.check1.visible = false;
			tList.check2.visible = false;
			tList.check3.visible = false;
			tList.check4.visible = false;
			tList.check5.visible = false;
			tList.check6.visible = false;
			tList.check7.visible = false;
			tList.check8.visible = false;
			tList.check9.visible = false;
			tList.check10.visible = false;
			tList.check11.visible = false;
			tList.check12.visible = false;
			tList.check13.visible = false;
			tList.check14.visible = false;
			numTasks = 0;
		}
		
		//----------------------------------------------methods
		public function checkWin():void {
			numTasks = 0;
			if (mProgress.isListed) {
				tList.check1.visible = true; 
				numTasks += 1;
			}
			if (mProgress.getGarageKey) {
				tList.check2.visible = true; 
				numTasks += 1;
			}
			if (mProgress.getWrench) {
				tList.check3.visible = true; 
				numTasks += 1;
			}
			if (mProgress.changeShower) {
				tList.check4.visible = true; 
				numTasks += 1;
			}
			if (mProgress.installLowFlow) {
				tList.check5.visible = true;
				numTasks += 1;
			}
			if (mProgress.gotLeaks) {
				tList.check6.visible = true; 
				numTasks += 1;
			}
			if (mProgress.washDishes) {
				tList.check7.visible = true; 
				numTasks += 1;
			}
			if (mProgress.gotClothes) {
				tList.check8.visible = true;
				numTasks += 1;
			}
			if (mProgress.washClothes) {
				tList.check9.visible = true; 
				numTasks += 1;
			}
			//if (mProgress.unlockAttic) tList.check10.visible = true;
			
			if (tList.check1.visible && tList.check2.visible && tList.check3.visible && tList.check4.visible && tList.check5.visible && tList.check6.visible && tList.check7.visible && tList.check8.visible && tList.check9.visible) {
				//finished the game!
				trace("I've completed all the tasks!");
				mProgress.unlockAttic = true;
				if (mRooms.currRoom == "attic") {
					numTasks += 1;
					overlay.txtTaskComplete.text = "10/10";
					//make a sound!
					ManageSounds.playSound(ManageSounds.SND_DOORUNLOCK);
				}
			}
			
			overlay.txtTaskComplete.text = String(numTasks) + "/10";
		}
		
		//----------------------------------------------display methods
		public function showMe(root:Sprite):void {
			root.addChild(this);
			//add event listeners
			checkWin();
		}
		
		public function hideMe():void {
			parent.removeChild(this);
			//remove event listeners
		}	
	}

}