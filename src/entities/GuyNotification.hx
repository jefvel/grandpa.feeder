package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import haxe.Timer;

/**
 * ...
 * @author jefvel
 */
class GuyNotification extends FlxSprite
{

	public function new() 
	{
		super();
		loadGraphic(AssetPaths.guy_notification__png, true, 32, 32);
		y = FlxG.height - height;
		scrollFactor.y = 0;
		
		animation.add("focus", [0], 2, false);
		animation.add("questionable", [2], 1, true);
		animation.add("default", [1], 1, true);
		animation.play("default");
	}
	
	var timer:Timer;
	public function focus() {
		animation.play("focus");
	
		if (timer != null) {
			timer.stop();
		}
		
		timer = Timer.delay(function() {
			animation.play("default");
			timer = null;
		}, 300);
	}
	
	public function question() {
		FlxG.sound.load(AssetPaths.plseat__wav).play();
		animation.play("questionable");
	
		if (timer != null) {
			timer.stop();
		}
		
		timer = Timer.delay(function() {
			animation.play("default");
			timer = null;
		}, 1800);
	}
	
	override public function update():Void 
	{
		super.update();
	}
}