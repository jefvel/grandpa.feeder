package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author jefvel
 */
class Ground extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		this.y = 50;
		this.setSize(Settings.WORLD_WIDTH, 50);
		immovable = true;
		makeGraphic(Settings.WORLD_WIDTH, 80, FlxColor.TRANSPARENT);
		
		this.updateHitbox();
	}
}