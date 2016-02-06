package states;

import entities.Child;
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
import haxe.Timer;

/**
 * ...
 * @author jefvel
 */
class PlayState extends FlxState
{
	var child:Child;
	var childNotification:GuyNotification;
	var grandpa:Grandpa;
	
	var treeLine1:FlxSprite;
	var treeLine2:FlxSprite;
	var treeLine3:FlxSprite;
	
	var grassBg:FlxSprite;
	var grassContainer:FlxGroup;
	
	var foodContainer:FlxGroup;
	var foodInHand:Food;
	
	var ground:Ground;
	
	
	public function new() 
	{
		super();
	}
	
	function init() {
		FlxG.worldBounds.set(0, -Settings.WORLD_HEIGHT, Settings.WORLD_WIDTH, Settings.WORLD_HEIGHT + 100);
		
		ground = new Ground();
		add(ground);
		
		//Grass bg
		grassBg = new FlxSprite();
		grassBg.loadGraphic(AssetPaths.grassbg__png);
		add(grassBg);
		
		treeLine3 = new FlxSprite(0, -120, AssetPaths.treeline3__png);
		treeLine3.scrollFactor.x = 0.4;
		treeLine3.scrollFactor.y = 0.8;
		add(treeLine3);
		
		treeLine2 = new FlxSprite(0, -120, AssetPaths.treeline2__png);
		treeLine2.scrollFactor.x = 0.6;
		treeLine2.scrollFactor.y = 0.9;
		add(treeLine2);
		
		treeLine1 = new FlxSprite(0, -110, AssetPaths.treeline1__png);
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
	}
	
	function startConversation() {
		Timer.delay(childNotification.question, 1500);
		Timer.delay(function() {
			FlxG.sound.load(AssetPaths.no__wav).play();
		}, 3500);
		
		Timer.delay(function() {
			child.allowControl = true;
		}, 4500);
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
				grandpa.velocity.y = -300;
				food.allowCollisions = FlxObject.NONE;
				
				if(grandpa.flying){
					//var dx = (grandpa.x + grandpa.width * 0.5) - (food.startX + food.width * 0.5);
					var max = 100;
					var dx = Math.max( -max, Math.min(max, food.lvx));
					grandpa.velocity.x = dx;
					grandpa.angularVelocity += dx;
				}
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