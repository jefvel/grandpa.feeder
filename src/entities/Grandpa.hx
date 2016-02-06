package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;

/**
 * ...
 * @author jefvel
 */
class Grandpa extends WorldEntity
{

	public var flying = false;
	var lifespan = 0;
	var animspeed = 0.8;
	public var parkinsonsScale = 1.0;
	
	var eatSounds:Array < FlxSound>;
	
	public function new() 
	{
		super();
		
		eatSounds = [
			FlxG.sound.load(AssetPaths.reallygood__ogg),
			FlxG.sound.load(AssetPaths.tastybird__ogg),
			FlxG.sound.load(AssetPaths.tastybird2__ogg)
		];
		
		this.marginX = 32;
		loadGraphic(AssetPaths.grandpa_sheet__png, true, 32, 32);
		animation.add("standing", [0], 15, true);
		animation.add("flying", [1], 2, true);
		animation.add("eating", [2, 3, 2, 3, 2, 3, 2, 3, 2, 3,2,3,2], 16, false);
		x = Settings.WORLD_WIDTH * 0.5;
		drag.x = 50;
		acceleration.y = 800;
	}
	
	public function eatMonster(m:FlyingEnemy) {
		for (sound in eatSounds) {
			sound.stop();
		}
		eatSounds[Std.int(Math.random() * eatSounds.length)].play();
		animation.play("eating", true);
	}
	
	override public function update():Void 
	{
		super.update();
		lifespan++;
		flying = (Math.abs(velocity.y) > 50) || y < -10;
		var enableAnimChange = true;
		if (animation.curAnim != null && animation.curAnim.name == "eating") {
			enableAnimChange = false;
		}
		
		if (!flying) {
			this.offset.y = (3 + Math.cos(lifespan*animspeed / 2) * 3) * parkinsonsScale;
			this.angle = (Math.sin(lifespan * animspeed) * 5) * parkinsonsScale;
			angularVelocity *= 0.6;
			
			
			if(enableAnimChange){
				animation.play("standing");
			}
			
		}else {
			if(enableAnimChange){
				animation.play("flying");
			}
			//angularVelocity = velocity.y + acceleration.y;
		}
	}
}