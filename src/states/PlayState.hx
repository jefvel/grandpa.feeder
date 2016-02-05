package states;

import entities.Child;
import entities.Grandpa;
import entities.Grass;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;

/**
 * ...
 * @author jefvel
 */
class PlayState extends FlxState
{
	var child:Child;
	var grandpa:Grandpa;
	var grassContainer:FlxGroup;
	public function new() 
	{
		super();
		
		FlxG.camera.fade(0xa2a2a2, 0.3, true);
		
	}
	
	function init() {
		FlxG.worldBounds.set(0, 0, Settings.WORLD_WIDTH, Settings.WORLD_HEIGHT);
		
		//Grass
		grassContainer = new FlxGroup();
		for (i in 0...100) {
			grassContainer.add(new Grass());
		}
		
		add(grassContainer);
		
		child = new Child();
		add(child);
		
		grandpa = new Grandpa();
		add(grandpa);
	}
	
	override public function update():Void 
	{
		super.update();
		FlxG.collide(grandpa, child, function(grandpa, child) {
			grandpa.vy = 20;
		});
	}
	
	override public function create():Void 
	{
		super.create();
		init();
		
	}
}