package entities;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxSprite;

/**
 * ...
 * @author jefvel
 */
class BonerEmitter extends FlxEmitter
{

	public function new() 
	{
		super(0,0, 100);
		setXSpeed( -200, 200);
		setYSpeed( -10, 0);
		gravity = 900;
		bounce = 0.2;
		var p:FlxParticle;
		for (i in 0...(Std.int(maxSize))) {
			p = new FlxParticle();
			p.loadGraphic(AssetPaths.bones__png, false, 16, 16);
			p.visible = true;
			add(p);
			p.animation.randomFrame();
		}
	}
	
	public function boner(e:FlxSprite) {
		x = e.x + e.width * 0.5;
		y = e.y + e.height * 0.5;
		this.start(true, 3, 0, 3);
	}
	
}