package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxDestroyUtil;

/**
 * ...
 * @author jefvel
 */
class Food extends WorldEntity
{

	var holding = true;
	public var lvy:Float;
	public var lvx:Float;
	var lifeLeft = 400;
	private var parent:FlxGroup;
	private var target:FlxSprite;
	public var startX:Float;
	public function new(parent:FlxGroup, target:FlxSprite) 
	{
		super();
		this.target = target;
		this.parent = parent;
		loadGraphic(AssetPaths.food__png, true, 16, 16);
		animation.randomFrame();
		offset.x = 8;
		offset.y = 8;
		updateHitbox();
	}
	
	override public function update():Void 
	{
		super.update();
		lvy = this.velocity.y;
		lvx = this.velocity.x;
		
		if (acceleration.y > 0) {
			if (y > 40) {
				y = 40;
				velocity.y *= -0.7;
				angularVelocity *= 0.6;
				velocity.x *= 0.9;
			}
		}
		
		if (!holding) {
			lifeLeft--;
			if (lifeLeft < 0) {
				alpha -= 0.1;
				if (alpha <= 0) {
					parent.remove(this);
					FlxDestroyUtil.destroy(this);
				}
			}
		}
	}
	
	var throwForce = 400;
	
	public function launchOff() {
		startX = x;
		holding = false;
		//this.acceleration.y = 700;
		this.angularDrag = 0.2;
		velocity.x = (Math.random() - 0.5) * 90;
		velocity.y = -Math.random() * 300 - 100;
		
	
		if (FlxG.camera.scroll.y < -FlxG.height) {
			y = FlxG.camera.scroll.y + FlxG.height + height;
		}
		
		velocity.x = (target.x - this.x + target.width * 0.5 - width * 0.5);
		velocity.y = (target.y - this.y + target.height - height * 0.5);
		
		var l = Math.sqrt(velocity.x * velocity.x + velocity.y * velocity.y);
		velocity.x /= l;
		velocity.y /= l;
		
		velocity.x *= throwForce;
		velocity.y *= throwForce;
		
		angularVelocity = (Math.random() * 60 + 50) * 30;
	}
}