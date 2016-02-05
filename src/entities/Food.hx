package entities;

import flixel.FlxSprite;

/**
 * ...
 * @author jefvel
 */
class Food extends FlxSprite
{

	public function new() 
	{
		super();
		loadGraphic(AssetPaths.food__png, true, 16, 16);
		animation.randomFrame();
	}
	
}