package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import haxe.Timer;
import states.GameOverState;

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
	
	public var enableDeath = false;
	public var dead = false;
	
	public var dying = false;
	
	public function new() 
	{
		super();
		
		eatSounds = [
			FlxG.sound.load(AssetPaths.reallygood__ogg),
			FlxG.sound.load(AssetPaths.tastybird__ogg),
			FlxG.sound.load(AssetPaths.tastybird2__ogg)
		];
		
		this.marginX = 16;
		loadGraphic(AssetPaths.grandpa_sheet__png, true, 32, 32);
		animation.add("standing", [0], 15, true);
		animation.add("flying", [1], 2, true);
		animation.add("dead", [4], 2, true);
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
	
	public function die() {
		if(!dead){
			angularVelocity = angularAcceleration = angle = 0;
			animation.play("dead");
			dead = true;
			FlxG.camera.shake(0.1, 0.1);
			//FlxG.camera.zoom = 10;
			FlxG.timeScale = 0.4;
			FlxG.sound.music.stop();
			var deadSound = FlxG.sound.load(AssetPaths.klong__wav);
			deadSound.play();
			
			var grandpaDied = FlxG.sound.load(AssetPaths.dead__ogg);
	
			Timer.delay(function() {
				FlxG.camera.setSize(FlxG.width >> 1, FlxG.height >> 1);
				FlxG.camera.setScale(4, 4);
				FlxG.camera.follow(this);
				FlxG.camera.update();
				deadSound.stop();
				deadSound.play();
				Timer.delay(function() {
					FlxG.camera.setSize(FlxG.width >> 2, FlxG.height >> 2);
					FlxG.camera.setScale(8, 8);
					FlxG.camera.follow(this);
					FlxG.camera.update();
					deadSound.stop();
					deadSound.play();
					Timer.delay(function() {
						FlxG.camera.setSize(FlxG.width >> 3, FlxG.height >> 3);
						FlxG.camera.setScale(16, 16);
						FlxG.camera.follow(this);
						FlxG.camera.update();
						deadSound.stop();
						deadSound.play();
						Timer.delay(function() {
							grandpaDied.play();
							Timer.delay(function() {
								FlxG.camera.fade(0xcccccc, 0.4, false, function() {
									FlxG.switchState(new GameOverState());	
								});
							}, 1800);
						}, 1500);
					}, 1000);
				}, 1000);
			}, 1000);
		}
	}
	
	override public function update():Void 
	{
		super.update();
		lifespan++;
		flying = (Math.abs(velocity.y) > 50) || y < -10;
		
		if (dead) {
			return;
		}
		if (y < -200) {
			enableDeath = true;
			trace("Death enabled");
		}
		
	
		
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