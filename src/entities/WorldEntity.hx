package entities;

import flixel.FlxSprite;

/**
 * ...
 * @author jefvel
 */
class WorldEntity extends FlxSprite
{

	public function new() 
	{
		super();
	}
	
	var marginX = 0.0;
	
	override public function update():Void 
	{
		super.update();
		if (this.x < 0 + marginX) {
			this.x = 0 + marginX;	
		}else if(this.x > Settings.WORLD_WIDTH - this.width - marginX) {
			this.x = Settings.WORLD_WIDTH - this.width - marginX;
		}
	}
	
}