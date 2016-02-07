package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * ...
 * @author jefvel
 */
class BirdUI extends FlxGroup
{
	var birds:Array<FlxSprite>;
	public function new() 
	{
		super();
		birds = new Array<FlxSprite>();
		for (i in 0...Settings.BIRD_COUNT) {
			var bird = new FlxSprite(0, 2 + i * 3, AssetPaths.birdface__png);
			bird.x = FlxG.width - bird.width - 2 - (i % 3) * 4;
			add(bird);
			bird.scrollFactor.set(0, 0);
			birds.push(bird);
		}
	}
	
	override public function update() {
		super.update();
		for (i in 0...birds.length) {
			var toRemove = !(Reg.birdsLeft > i);
			if (toRemove) {
				birds[i].x ++;
				birds[i].alpha -= 0.1;
			}
		}
	}
}