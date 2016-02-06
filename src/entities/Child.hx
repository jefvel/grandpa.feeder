package entities;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.util.FlxSignal;
import haxe.Timer;

/**
 * ...
 * @author jefvel
 */
class Child extends WorldEntity
{

	var speed = 6000;
	var foodLeft = 50;
	var holdingFood = false;
	var grabbingFood = false;
	
	public var onGrabbedFood:FlxSignal;
	public var onThrow:FlxSignal;
	var throwingTimer:Timer;
	var throwing = false;
	public var allowControl = true;
	
	var throwPhrases:Array<FlxSound>;
	
	public function new() 
	{
		super();
		
		throwPhrases = new Array<FlxSound>();
		
		throwPhrases.push(FlxG.sound.load(AssetPaths.here__ogg));
		throwPhrases.push(FlxG.sound.load(AssetPaths.havefood__ogg));
		throwPhrases.push(FlxG.sound.load(AssetPaths.throw1__ogg));
		
		allowControl = false;
		onGrabbedFood = new FlxSignal();
		onThrow = new FlxSignal();
		
		loadGraphic(AssetPaths.child_sheet__png, true, 32, 32);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		animation.add("throw", [1, 0], 16, false);
		animation.add("walk", [2, 3], 16, true);
		animation.add("stand", [0], 0, false);
		
		x = Settings.WORLD_WIDTH * 0.5 - 100;
		y = 0;
		
		drag.x = 600;
		acceleration.y = 100;
		
		FlxG.camera.follow(this);
		FlxG.camera.followLerp = 3;
	}
	
	public function grabFood() {
		if (!grabbingFood) {
			grabbingFood = true;	
			Timer.delay(function() {
				onGrabbedFood.dispatch();
				holdingFood = true;
			}, 100);
		}

	}
	
	public function throwFood() {
		if (holdingFood) {
			if (throwingTimer != null) {
				throwingTimer.stop();
				throwingTimer = null;
			}
			onThrow.dispatch();
			animation.play("throw");
			holdingFood = false;
			grabbingFood = false;
			throwing = true;
			throwingTimer = Timer.delay(function() {
				throwing = false;
			}, 300);
			
			var i = Std.int(Math.random() * throwPhrases.length);
			throwPhrases[i].play();
		}
	}

	override public function draw():Void 
	{
		super.draw();
	}
	
	override public function update():Void 
	{
		super.update();
		
		var right = FlxG.keys.pressed.D;
		var left = FlxG.keys.pressed.A;
		var _throw = FlxG.keys.justPressed.SPACE;
		
		var vx = 0;
		if(allowControl){
			if (right) {
				vx += speed;
			}
			if (left) {
				vx -= speed;
			}
			if (_throw) {
				throwFood();
			}
		}	
		
		grabFood();	
		
		acceleration.x = vx;
		maxVelocity.x = 200;
		
		if (velocity.x < -30) {
			facing = FlxObject.LEFT;
		}else if (velocity.x > 30) {
			facing = FlxObject.RIGHT;
		}
		
		if(!throwing){
			if (Math.abs(velocity.x) > 0.4) {
				animation.play("walk");
			}else {
				animation.play("stand");
			}
		}

	}
	
}