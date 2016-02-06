package entities;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author jefvel
 */
class Grandpa extends WorldEntity
{

	public var flying = false;
	var lifespan = 0;
	var animspeed = 0.8;
	public function new() 
	{
		super();
		this.marginX = 32;
		loadGraphic(AssetPaths.grandpa_sheet__png, true, 32, 32);
		animation.add("standing", [0], 15, true);
		animation.add("flying", [1], 2, true);
		x = Settings.WORLD_WIDTH * 0.5;
		drag.x = 200;
		acceleration.y = 900;
	}
	
	override public function update():Void 
	{
		super.update();
		lifespan++;
		flying = (Math.abs(velocity.y) > 50) || y < -10;
		
		if (!flying) {
			this.offset.y = 3 + Math.cos(lifespan*animspeed / 2) * 3;
			this.angle = Math.sin(lifespan * animspeed) * 5;
			animation.play("standing");
			angularVelocity *= 0.6;
		}else {
			animation.play("flying");
			angularVelocity = velocity.y + acceleration.y;
		}
	}
}