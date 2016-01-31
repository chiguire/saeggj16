package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ciro Duran
 */
class SplashState extends FlxState
{
	public var top : FlxSprite;
	public var spr : FlxSprite;
	public var txt : FlxText;
	
	public var timer : FlxTimer;
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		spr = new FlxSprite(0, 0, AssetPaths.splash_16by9__png);
		add(spr);
		
		txt = new FlxText(0, 0, FlxG.width, "Made in under 48 hours on the Global Game Jam 2016.\nSAE Institute, Haggerston, London, UK.\nhttp://globalgamejam.org");
		txt.alignment = "center";
		txt.x = 0;
		txt.y = FlxG.height * 7.0 / 8.0;
		
		add(txt);
		
		top = new FlxSprite(0, 0);
		top.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(top);
		
		FlxTween.tween(top, { alpha: 0 }, 0.3);
		timer = new FlxTimer(3, show_timer_handler, 1);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		if (FlxG.keys.justPressed.ANY || FlxG.mouse.justPressed)
		{
			FlxG.switchState(new MenuState());
		}
	}
	
	public function show_timer_handler(?timer:FlxTimer)
	{
		FlxTween.tween(top, { alpha: 1 }, 0.3, { complete: fade_out_handler });
	}
	
	public function fade_out_handler(?tween:FlxTween)
	{
		FlxG.switchState(new MenuState());
	}
}