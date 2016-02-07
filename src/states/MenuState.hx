package states;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxMath;
import haxe.Timer;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	var keys = ["A", "D", "SPACE"];
	var entered = false;
	
	var logobg:FlxSprite;
	var logo:FlxSprite;
	var logoBob = false;
	var grandpa:FlxSprite;
	var child:FlxSprite;
	

	var menuBgs:FlxGroup;
	var bgs:Array<FlxSprite>;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;
		
		logobg = new FlxSprite(0, 0, AssetPaths.logobg__png);

		logobg.x = FlxG.width * 0.5 - logobg.width * 0.5;
		logobg.y = 70- logobg.height * 0.5;
		logobg.alpha = 0;
		add(logobg);
		
		bgs = new Array<FlxSprite>();
		menuBgs = new FlxGroup();
		var bg = new FlxSprite();
		bg.loadGraphic(AssetPaths.menubg__png);
		bg.y = FlxG.height - bg.height;
		bgs.push(bg);
		menuBgs.add(bg);
		
		bg = new FlxSprite();
		bg.loadGraphic(AssetPaths.menubg__png);
		bg.y = FlxG.height - bg.height;
		bg.x = bg.width;
		menuBgs.add(bg);
		bgs.push(bg);
		
		add(menuBgs);
		
	
		
		
		grandpa = new FlxSprite();
		grandpa.loadGraphic(AssetPaths.grandpalarge__png);
		grandpa.y = FlxG.height;
		grandpa.x = -5;
		grandpa.origin.y = grandpa.height;
		Timer.delay(function() {
			FlxTween.tween(grandpa, { y: FlxG.height - grandpa.height + 5 }, 0.2	);
		}, 300);
		add(grandpa);
		
		
		child = new FlxSprite();
		child.loadGraphic(AssetPaths.childlarge__png);
		child.origin.x = child.width ;
		child.origin.y = child.height;
		child.y = FlxG.height + child.height;
		child.x = FlxG.width - child.width + 5;
		Timer.delay(function() {
			FlxTween.tween(child, { y: FlxG.height - child.height + 5}, 0.4	);
		}, 300);
		add(child);
		
		
		logo = new FlxSprite(0, 0, AssetPaths.mainlogo__png);
		logo.alpha = 0;
		Timer.delay(function(){
			FlxTween.tween(logo, { alpha:1.0 }, 0.4);
			FlxTween.tween(logobg, { alpha:1.0 }, 0.2);
			FlxG.sound.playMusic(AssetPaths.main_menu__ogg);
			logoBob = true;
		}, 400);
		
		add(logo);
		
		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
	
	
	
	function enterGame() {
		if (entered) {
			return;
		}
		
		entered = true;
		
		FlxG.camera.fade(0xa2a2a2, 0.1);
		Timer.delay(function() {
			FlxG.switchState(new PlayState());
		}, 100);
	}

	var bobs = -1;
	var bobTime = 950;
	var lastT = 0;
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		FlxG.mouse.visible = false;		
		
		if (FlxG.touches.justStarted().length > 0) {
			enterGame();
		} else if (FlxG.keys.anyJustPressed(keys)) {
			enterGame();
		}
		
		logobg.angularVelocity = -10;
		
		if (logoBob) {
			var t = Std.int(FlxG.sound.music.time);
			if (lastT > t) {
				bobs -= bobs;	
			}
			
			lastT = t;
			var currentBob = (t / bobTime);
			if (Std.int(currentBob) > bobs) {
				logo.y = 10;
				bobs ++;
			} else {
				logo.y -= logo.y * 0.1;	
			}
			
			//grandpa.x -= (grandpa.x - (1 - (currentBob % 1)) * 10) * 0.5;
			grandpa.angle = Math.cos(currentBob * 3) * 4;
			child.angle = Math.cos(currentBob * 2) * 4;
	
		
			for(bg in bgs){
				bg.x --;
				bg.y = FlxG.height - bg.height + (Math.cos(currentBob) + 1) * 5;
				if (bg.x < -bg.width) {
					bg.x += bg.width * 2.0;
				}
			}
		}
	}	
}