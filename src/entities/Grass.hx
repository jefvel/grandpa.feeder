package entities;

import flixel.FlxSprite;

/**
 * ...
 * @author jefvel
 */
class Grass extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic(AssetPaths.grass__png, false, 8, 8);
		animation.randomFrame();
		this.x = Math.random() * Settings.WORLD_WIDTH;
		this.y = Math.random() * Settings.WORLD_HEIGHT;
	}
}