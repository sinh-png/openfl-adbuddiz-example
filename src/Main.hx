package;

#if android
import extension.adbuddiz.AdBuddiz;
#end

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * ...
 * @author Hazame (http://www.haza.me)
 */

class Main extends Sprite {

	var isAdReady:Bool;
	var buttonShowAd:Sprite;
	var textLog:TextField;

	public function new()  {
		super();
		
		/*******Set up the button and the text log*******/
		var tf = new TextFormat();
		tf.size = 20;
		
		textLog = new TextField();
		textLog.x = 5;
		textLog.autoSize = TextFieldAutoSize.LEFT;
		textLog.defaultTextFormat = tf;
		textLog.text = "Example of AdBuddiz for OpenFL.\nInitializing...";
		addChild(textLog);
		
		buttonShowAd = new Sprite();
		buttonShowAd.addChild(new Bitmap(Assets.getBitmapData("img/button_up.png")));
		buttonShowAd.addChild(new Bitmap(Assets.getBitmapData("img/button_down.png")));
		buttonShowAd.getChildAt(0).visible = true;
		buttonShowAd.getChildAt(1).visible = false;
		buttonShowAd.x = stage.stageWidth - buttonShowAd.width - 5;
		buttonShowAd.y = 5;
		
		buttonShowAd.addEventListener(MouseEvent.MOUSE_UP, function(e) {
			buttonShowAd.getChildAt(0).visible = true;
			buttonShowAd.getChildAt(1).visible = false;
		});
		
		buttonShowAd.addEventListener(MouseEvent.MOUSE_DOWN, function(e) {
			buttonShowAd.getChildAt(0).visible = false;
			buttonShowAd.getChildAt(1).visible = true;
		});
		//////////////////////////////////////////////////////
		
		buttonShowAd.addEventListener(MouseEvent.CLICK, function(e) {
			//Show ad if it is ready
			#if android
			if (isAdReady) AdBuddiz.showAd();
			#end
		});
		
		addChild(buttonShowAd);
		
		//Set ad callbacks
		#if android
		AdBuddiz.callback.didShowAd = function() textLog.text += "\nCallback: Show ad.";
		AdBuddiz.callback.didHideAd = function() textLog.text += "\nCallback: Close ad.";
		AdBuddiz.callback.didClick = function() textLog.text += "\nCallback: Click on ad.";
		AdBuddiz.callback.didFailToShowAd = function(error:String) textLog.text += '\nCallback: Failed to show ad. ERROR: $error';
		#end
		
		addEventListener(Event.ENTER_FRAME, function(e) {
			//Check if ad is ready
			#if android
			if (AdBuddiz.isReadyToShowAd() && !isAdReady) {
				isAdReady = true;
				textLog.text += "\nInitialization completed. Ready to show ad.";
			}
			#end
			
			if (textLog.height > stage.stageHeight) textLog.y = stage.stageHeight - textLog.height;
		});
	}
}

