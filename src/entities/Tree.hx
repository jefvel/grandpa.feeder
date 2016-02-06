package entities;

import flixel.FlxSprite;

/**
 * ...
 * @author jefvel
 */
class Tree extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic(AssetPaths.trees__png, true, 64, 128);
		animation.randomFrame();
		x = Math.floor(Math.random() * Settings.WORLD_WIDTH);
		offset.x = this.width * 0.5;
	}
}