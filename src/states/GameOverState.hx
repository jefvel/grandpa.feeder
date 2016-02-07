package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

/**
 * ...
 * @author jefvel
 */
class GameOverState extends FlxState
{

	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		var score = new FlxText(0, 0, "Ate " + (Settings.BIRD_COUNT - Reg.birdsLeft) + " of " + Settings.BIRD_COUNT + " birds.\nGreat Job");
		add(score);
		score.x = FlxG.width * 0.5 - score.width * 0.5;
		score.y = FlxG.height * 0.5 - score.height * 0.5;
	}
	
}