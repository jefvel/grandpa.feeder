package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxMath;
import haxe.Timer;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	var keys = ["A", "D", "SPACE"];
	var entered = false;
	var logo:FlxSprite;
	var logoBob = false;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;
		
		logo = new FlxSprite(0, 0, AssetPaths.mainlogo__png);
		logo.alpha = 0;
		Timer.delay(function(){
			FlxTween.tween(logo, { alpha:1.0 }, 0.4);
			FlxG.sound.playMusic(AssetPaths.main_menu__ogg);
			logoBob = true;
		}, 400);
		add(logo);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
	
	
	
	function enterGame() {
		if (entered) {
			return;
		}
		
		entered = true;
		
		FlxG.camera.fade(0xa2a2a2, 0.1);
		Timer.delay(function() {
			FlxG.switchState(new PlayState());
		}, 100);
	}

	var bobs = -1;
	var bobTime = 950;
	var lastT = 0;
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		FlxG.mouse.visible = false;		
		
		if (FlxG.touches.justStarted().length > 0) {
			enterGame();
		} else if (FlxG.keys.anyJustPressed(keys)) {
			enterGame();
		}
		
		if (logoBob) {
			var t = Std.int(FlxG.sound.music.time);
			if (lastT > t) {
				bobs = 0;	
			}
			
			lastT = t;
			var currentBob = Std.int(t / bobTime);
			if (currentBob> bobs) {
				logo.y = 10;
				bobs ++;
			} else {
				logo.y -= logo.y * 0.1;	
			}
		}
	}	
}