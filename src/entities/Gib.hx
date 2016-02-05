package entities;

import flixel.FlxSprite;

/**
 * ...
 * @author jefvel
 */
class Gib extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic(AssetPaths.gib__png, true, 16, 16);
		animation.randomFrame();
		velocity.x = Math.random() * 200 - 100;
		velocity.y = Math.random() * -50;
		this.angularVelocity = velocity.x * 100;
		drag.x = 20;
		
		angularDrag = 400;
	}
	
	override public function update():Void 
	{
		super.update();
		acceleration.y = 300;
		maxVelocity.x = 900;
		maxVelocity.y = 900;
		
	}
}