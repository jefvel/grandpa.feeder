package states;

import entities.Bird;
import entities.BonerEmitter;
import entities.Child;
import entities.FlyingEnemy;
import entities.Food;
import entities.Grandpa;
import entities.Grass;
import entities.Ground;
import entities.GuyNotification;
import entities.Tree;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import haxe.Timer;

/**
 * ...
 * @author jefvel
 */
class PlayState extends FlxState
{
	public static var child:Child;
	var childNotification:GuyNotification;
	var grandpa:Grandpa;
	
	var startPopup:FlxSprite;
	
	
	var clouds:FlxGroup;
	
	var treeLine1:FlxSprite;
	var treeLine2:FlxSprite;
	var treeLine3:FlxSprite;
	
	var grassBg:FlxSprite;
	var grassContainer:FlxGroup;
	
	var foodContainer:FlxGroup;
	var foodInHand:Food;
	
	var monsters:FlxGroup;
	var boners:BonerEmitter;
	
	
	var ground:Ground;
	
	var punchSfx:FlxSound;
	
	
	public function new() 
	{
		super();
	}
	
	function loadSounds() {
		punchSfx = FlxG.sound.load(AssetPaths.punch__ogg);
	}
	
	function init() {
		loadSounds();
		
		startPopup = new FlxSprite();
		startPopup.loadGraphic(AssetPaths.start_thing__png);
		startPopup.scrollFactor.set(0, 0);
		startPopup.x = FlxG.width * 0.5 - startPopup.width * 0.5;
		startPopup.y = FlxG.height * 0.5 - startPopup.height * 0.5;
		
		FlxG.worldBounds.set(0, -Settings.WORLD_HEIGHT, Settings.WORLD_WIDTH, Settings.WORLD_HEIGHT + 100);
		
		clouds = new FlxGroup();
		var cloudScale = 0.4;
		for (i in 0...30) {
			var cloud = new FlxSprite();
			cloud.loadGraphic(AssetPaths.clouds__png, false, 128, 64);
			cloud.x = Math.floor(Math.random() * Settings.WORLD_WIDTH - cloud.width  * 0.5);
			cloud.y = Math.floor(-Math.random() * Settings.WORLD_HEIGHT * cloudScale);
			cloud.scrollFactor.y = cloudScale;
			cloud.animation.randomFrame();
			
			clouds.add(cloud);
		}
		add(clouds);
		
		ground = new Ground();
		add(ground);
		
		//Grass bg
		grassBg = new FlxSprite();
		grassBg.loadGraphic(AssetPaths.grassbg__png);
		add(grassBg);
		
		treeLine3 = new FlxSprite(-30, -120, AssetPaths.treeline3__png);
		treeLine3.scrollFactor.x = 0.4;
		treeLine3.scrollFactor.y = 0.8;
		add(treeLine3);
		
		treeLine2 = new FlxSprite(-50, -120, AssetPaths.treeline2__png);
		treeLine2.scrollFactor.x = 0.6;
		treeLine2.scrollFactor.y = 0.9;
		add(treeLine2);
		
		treeLine1 = new FlxSprite(-90, -110, AssetPaths.treeline1__png);
		add(treeLine1);

		//Grass
		grassContainer = new FlxGroup();
		for (i in 0...100) {
			grassContainer.add(new Grass());
		}
		add(grassContainer);
		
		//Child
		child = new Child();
		child.onGrabbedFood.add(newFood);
		child.onThrow.add(throwFood);
		add(child);
		
		monsters = new FlxGroup();
		add(monsters);
		
		boners = new BonerEmitter();
		add(boners);
		
		//Food
		foodContainer = new FlxGroup();
		add(foodContainer);
		
		//Grandpa
		grandpa = new Grandpa();
		add(grandpa);
		
		
		//Guy popup
		childNotification = new GuyNotification();
		add(childNotification);
		
		startConversation();
		spawnMonsters();
	}
	
	function spawnMonsters() {
		for (i in 0...40) {
			var bird = new Bird();
			bird.y = -200 - Math.random() * 1800;
			monsters.add(bird);
		}
	}
	
	function startConversation() {
		FlxG.sound.playMusic(AssetPaths.play_music_intro__ogg,0.8, false);
		FlxG.sound.music.onComplete = function() {
			FlxG.sound.playMusic(AssetPaths.play_music__ogg);
			add(startPopup);
			FlxG.camera.shake(0.01, 0.2);
			FlxTween.tween(startPopup, { alpha:0.0 }, 1.0, { complete: function(t:FlxTween) {
				remove(startPopup);
			}});
		}
		
		grandpa.parkinsonsScale = 0.3;
		
		var start1 = 600;
		
		Timer.delay(function() {
			Timer.delay(childNotification.question, 1500);
			Timer.delay(function() {
				FlxG.sound.load(AssetPaths.no__wav).play();
				grandpa.parkinsonsScale = 2.0;
			}, 4500);
			
			Timer.delay(function() {
				childNotification.forceFood();
			}, 5500);
		
			Timer.delay(function() {
				grandpa.parkinsonsScale = 0.3;
				child.allowControl = true;
			}, 6000);
		}, start1);
	}
	
	public function newFood() {
		foodInHand = new Food(foodContainer, grandpa);
		if(child.facing == FlxObject.LEFT){
			foodInHand.setPosition(child.x - 8, child.y + 13 - 8);
		}else {
			foodInHand.setPosition(child.x + 32 - 8, child.y + 13 - 8);
		}
		foodContainer.add(foodInHand);
	}
	
	public function throwFood() {
		if (foodInHand == null) {
			return;
		}
		
		var food = foodInHand;
		food.launchOff();
		foodInHand = null;
		
		childNotification.focus();
	}
	
	override public function update():Void 
	{
		super.update();
		
		//FlxG.collide(grandpa, child, function(grandpa, child) {
		//});
		
		FlxG.collide(grandpa, monsters, function(grandpa:Grandpa, monster:FlyingEnemy) {
			grandpa.eatMonster(monster);
			boners.boner(monster);
			monsters.remove(monster);
		});
		
		FlxG.collide(foodContainer, ground, function(food:Food, ground) {
			food.velocity.y = food.lvy * -0.7;
			food.angularVelocity *= 0.6;
			food.velocity.x *= 0.9;
		});
		
		FlxG.collide(child, ground);
		FlxG.collide(grandpa, ground);
		
		FlxG.collide(foodContainer, grandpa, function(food:Food, ground:Grandpa) {
			if(foodInHand != food){
				food.velocity.y =-( 200 * Math.random() + 100);
				food.acceleration.y = 700;
				food.velocity.x = -food.lvx * 0.7;
				grandpa.velocity.y = -400;
				food.allowCollisions = FlxObject.NONE;

				
				if(grandpa.flying){
					//var dx = (grandpa.x + grandpa.width * 0.5) - (food.startX + food.width * 0.5);
					var max = 100;
					var dx = 0.0;
					if (food.isProjectile) {
						dx = 6 * (grandpa.x - food.x);
					}else{
						dx = food.lvx;
					}
					
					dx = Math.max( -max, Math.min(max, dx));
					grandpa.velocity.x = dx;
					grandpa.angularVelocity = dx * 10;
				}
				
				punchSfx.play();
				FlxG.camera.shake(0.01, 0.06);
			}
		});
		
		if (grandpa.flying) {
			FlxG.camera.follow(grandpa);
		}else {
			FlxG.camera.follow(child);
		}
		
		cFrame ++;
	}
	
	var cFrame = 0;
	override public function draw():Void 
	{
		if (foodInHand != null) {
			if(child.facing == FlxObject.LEFT){
				foodInHand.setPosition(child.x - 8, child.y + 13 - 8);
			}else {
				foodInHand.setPosition(child.x + 32 - 8, child.y + 13 - 8);
			}
		}
		
		childNotification.x = child.x + child.width * 0.5 - childNotification.width * 0.5;
		if (FlxG.camera.scroll.y + FlxG.height < child.y) {
			childNotification.y = FlxG.height - childNotification.height;
		}else {
			childNotification.y = child.y - FlxG.camera.scroll.y - childNotification.height;
		}
		childNotification.y -= (1 + Math.cos(cFrame * 0.1)) * 4;
		
		super.draw();
	}
	
	override public function create():Void 
	{
		super.create();
		FlxG.camera.fade(0xa2a2a2, 0.3, true);
		FlxG.camera.setBounds(0, -Settings.WORLD_HEIGHT, Settings.WORLD_WIDTH, Settings.WORLD_HEIGHT + 100);
		init();
	}
}