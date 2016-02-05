package entities;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author jefvel
 */
class Grandpa extends FlxSprite
{

	var flying = false;
	var lifespan = 0;
	var animspeed = 0.8;
	public function new() 
	{
		super();
		loadGraphic(AssetPaths.grandpa__png, true, 32, 32);
		x = 100;
		drag.x = 100;
	}
	
	override public function update():Void 
	{
		super.update();
		lifespan++;
		if (!flying) {
			this.offset.y = Math.cos(lifespan*animspeed / 2) * 3;
			this.angle = Math.sin(lifespan*animspeed) * 5;
		}
		
	}
	
}