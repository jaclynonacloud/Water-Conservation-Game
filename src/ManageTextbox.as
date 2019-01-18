package  {
	
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * ...
	 * @author Jaclyn Staples
	 */
	public class ManageTextbox extends MovieClip {
		
		//declare classes
		private var cMain:Main;
		
		//declare textboxes
		private var textbox:Textbox;
		private var textPop:TextPop;
		
		//declare variables
		private var curPage:int; //writes the current page the user is on
		private var pages:int; //holds number of games for text popup
		private var txtArray:Array; //holds broken up popup page text
		
		public function ManageTextbox(classMain:Main) {
			cMain = classMain;
			//load textboxes
			textbox = new Textbox();
			textPop = new TextPop();
			curPage = 0;
			//empty out textboxes
			textbox.txtBox.text = "";
			textPop.txtPop.text = "";
			txtArray = new Array();
		}
		
		//---------------------------------------------------methods
		public function addText(isPopup:Boolean, textToAdd:String):void {
			if (isPopup) {
				//add criteria for popup text
				addChild(textPop);
				//split up the string
				txtArray = textToAdd.split("~");
				pages = txtArray.length;
				//print first page text
				textPop.txtPop.text = txtArray[curPage];
				
				//add listeners
				textPop.addEventListener(MouseEvent.CLICK, onClick);
			}else {
				//add criteria for textbox
				addChild(textbox);
				textbox.txtBox.text = textToAdd;
			}
		}
		
		public function removeText(isPopup:Boolean):void {
			if (isPopup) {
				//clean out text array
				curPage = 0;
				pages = 0;
				for each(var item:String in txtArray) {
					txtArray.pop();
				}
				//remove from displaylist
				removeChild(textPop);
			}
			else removeChild(textbox);
		}
		
		//---------------------------------------------------event  handlers
		private function onClick(e:MouseEvent):void {
			//trace("Current Page Count: " + curPage);
			//trace("Total Page Count: " + pages);
			//trace("Array Count: " + txtArray.length);
			//trace(txtArray[curPage]);
			if (e.target.name == "btnPop") {
				curPage++;
				if (curPage >= pages) {
					removeText(true);
				}else textPop.txtPop.text = txtArray[curPage];
				
				//add room listeners if not added
				if(cMain.mRooms.isListeners == false) cMain.mRooms.addListeners();
			}
		}
		
	}

}