package entities;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSignal;

/**
 * ...
 * @author jefvel
 */
class Child extends FlxSpriteGroup
{

	var speed = 6000;
	var child:FlxSprite;
	var foodLeft = 50;
	public var onGrabbedFood:FlxSignal;
	public function new() 
	{
		super();
		onGrabbedFood = new FlxSignal();
		
		child = new FlxSprite();
		child.loadGraphic(AssetPaths.child__png, true, 32, 32);
		add(child);
		
		child.immovable = true;
		child.offset.x = 16;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		child.setFacingFlip(FlxObject.LEFT, true, false);
		child.setFacingFlip(FlxObject.RIGHT, false, false);
		
		x = 15;
		y = 10;
		
		drag.x = 600;
		
		FlxG.camera.follow(this);
		grabFood();
	}
	
	public function grabFood() {
		onGrabbedFood.dispatch();
	}

	override public function draw():Void 
	{
		if (facing == FlxObject.LEFT) {
			currentFood.x = x + -24;
		}else {
			currentFood.x = x + 8;
		}
		super.draw();
	}
	
	override public function update():Void 
	{
		super.update();
		
		var right = FlxG.keys.pressed.D;
		var left = FlxG.keys.pressed.A;
		
		var vx = 0;
		if (right) {
			vx += speed;
		}
		if (left) {
			vx -= speed;
		}
		
		acceleration.x = vx;
		maxVelocity.x = 200;
		
		if (velocity.x < -30) {
			facing = FlxObject.LEFT;
		}else if (velocity.x > 30) {
			facing = FlxObject.RIGHT;
		}
		
	}
	
}