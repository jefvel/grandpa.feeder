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
	var keys = ["A", "S", "D", "W"];
	var entered = false;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;
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
		
		FlxG.camera.fade(0xa2a2a2, 0.1);
		Timer.delay(function() {
			FlxG.switchState(new PlayState());
		}, 100);
	}

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
	}	
}