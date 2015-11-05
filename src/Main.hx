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
	var buttonShowRewardVideo:Sprite;
	var textLog:TextField;

	public function new()  {
		super();
		
		var tf = new TextFormat();
		tf.size = 20;
		
		textLog = new TextField();
		textLog.x = 5;
		textLog.autoSize = TextFieldAutoSize.LEFT;
		textLog.defaultTextFormat = tf;
		textLog.text = "Example of AdBuddiz for OpenFL.\nInitializing...";
		addChild(textLog);
		
		// Interstitial Ad
		
		buttonShowAd = new Sprite();
		buttonShowAd.addChild(new Bitmap(Assets.getBitmapData("img/button_show_ad_up.png")));
		buttonShowAd.addChild(new Bitmap(Assets.getBitmapData("img/button_show_ad_down.png")));
		buttonShowAd.getChildAt(0).visible = true;
		buttonShowAd.getChildAt(1).visible = false;
		buttonShowAd.x = stage.stageWidth - buttonShowAd.width - 5;
		buttonShowAd.y = stage.stageHeight - buttonShowAd.height - 5;
		
		buttonShowAd.addEventListener(MouseEvent.MOUSE_UP, function(e) {
			buttonShowAd.getChildAt(0).visible = true;
			buttonShowAd.getChildAt(1).visible = false;
		});
		
		buttonShowAd.addEventListener(MouseEvent.MOUSE_DOWN, function(e) {
			buttonShowAd.getChildAt(0).visible = false;
			buttonShowAd.getChildAt(1).visible = true;
		});
	
		buttonShowAd.addEventListener(MouseEvent.CLICK, function(e) {
			#if android
			//Show ad if ready
			if (isAdReady) AdBuddiz.showAd();
			#end
		});
		
		addChild(buttonShowAd);
		
		#if android
		//Set ad callbacks
		
		AdBuddiz.callback.didShowAd = function() textLog.text += "\nAd Callback: Showed.";
		AdBuddiz.callback.didHideAd = function() textLog.text += "\nAd Callback: Closed.";
		AdBuddiz.callback.didClick = function() textLog.text += "\nAd Callback: Clicked.";
		AdBuddiz.callback.didFailToShowAd = function(error:String) textLog.text += '\nCallback: Failed to show. ERROR: $error';
		#end
		
		addEventListener(Event.ENTER_FRAME, function(e) {
			#if android
			//Check if ad is ready
			if (AdBuddiz.isReadyToShowAd() && !isAdReady) {
				isAdReady = true;
				textLog.text += "\nInitialization completed. Ready to show ad.";
			}
			#end
			
			if (textLog.height > stage.stageHeight) textLog.y = stage.stageHeight - textLog.height;
		});
		
		// Reward Video
		
		buttonShowRewardVideo = new Sprite();
		buttonShowRewardVideo.addChild(new Bitmap(Assets.getBitmapData("img/button_show_reward_video_up.png")));
		buttonShowRewardVideo.addChild(new Bitmap(Assets.getBitmapData("img/button_show_reward_video_down.png")));
		buttonShowRewardVideo.getChildAt(0).visible = true;
		buttonShowRewardVideo.getChildAt(1).visible = false;
		buttonShowRewardVideo.x = stage.stageWidth - buttonShowAd.width - buttonShowRewardVideo.width - 15;
		buttonShowRewardVideo.y = buttonShowAd.y;
		
		buttonShowRewardVideo.addEventListener(MouseEvent.MOUSE_UP, function(e) {
			buttonShowRewardVideo.getChildAt(0).visible = true;
			buttonShowRewardVideo.getChildAt(1).visible = false;
		});
		
		buttonShowRewardVideo.addEventListener(MouseEvent.MOUSE_DOWN, function(e) {
			buttonShowRewardVideo.getChildAt(0).visible = false;
			buttonShowRewardVideo.getChildAt(1).visible = true;
		});
	
		buttonShowRewardVideo.addEventListener(MouseEvent.CLICK, function(e) {
			#if android
			//Fetch reward video
			AdBuddiz.rewardedVideo.fetch();
			textLog.text += "\nFetching reward video...";
			#end
		});
		
		addChild(buttonShowRewardVideo);
		
		#if android
		//Set reward video callbacks
		
		AdBuddiz.rewardedVideo.callback.didFetch = function() {
			textLog.text += "\nReward Video Callback: Fetched. Showing...";
			// Show the fetched video
			AdBuddiz.rewardedVideo.show();
		}
		AdBuddiz.rewardedVideo.callback.didComplete = function() textLog.text += "\nReward Video Callback: Completed. Give reward here.";
		AdBuddiz.rewardedVideo.callback.didFail = function(error:String) textLog.text += '\nReward Video Callback: Failed to fetch or show. ERROR $error';
		AdBuddiz.rewardedVideo.callback.didNotComplete = function() textLog.text += '\nReward Video Callback: Failed to complete. Error happened during playback.';
		#end

	}
}

