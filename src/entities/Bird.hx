package entities;
import flixel.FlxObject;

/**
 * ...
 * @author jefvel
 */
class Bird extends FlyingEnemy
{

	var speed = 200;
	public function new() 
	{
		super();
		loadGraphic(AssetPaths.bird__png, true, 32, 25);
		animation.add("flying", [0, 1, 2], 15);
		animation.play("flying");
		setFacingFlip(FlxObject.RIGHT, true, false);
		setFacingFlip(FlxObject.LEFT, false, false);
		
		if (Math.random() > 0.5) {
			this.facing = FlxObject.LEFT;
		}else {
			this.facing = FlxObject.RIGHT;	
		}
		
		x = Math.random() * Settings.WORLD_WIDTH;
	}
	
	override public function update():Void 
	{
		super.update();
		if (facing == FlxObject.LEFT) {
			velocity.x = -speed;
		}else {
			velocity.x = speed;
		}
		if (this.x < 0 - width) {
			this.x = Settings.WORLD_WIDTH;
		}else if (this.x > Settings.WORLD_WIDTH) {
			this.x = -width;
		}
	}
}