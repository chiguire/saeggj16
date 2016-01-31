package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

/**
 * ...
 * @author Ciro Duran
 */
class CreditsState extends FlxState
{
	public var spr : FlxSprite;
	public var txt : FlxText;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		spr = new FlxSprite(0, 0, AssetPaths.Credits__png);
		add(spr);
		
		txt = new FlxText(FlxG.width / 2, 10, FlxG.width / 2 - 20, "Made in under 48 hours on the Global Game Jam 2016.\nSAE Institute, Haggerston, London, UK.\nhttp://globalgamejam.org\n\n");
		txt.alignment = "left";
		add(txt);
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
		
		if (FlxG.mouse.justPressed)
		{
			FlxG.switchState(new MenuState());
		}
	}
}