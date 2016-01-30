package player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class PlayerHandMouse extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
	}
	
	public function create():Void
	{
		makeGraphic(32, 32, FlxColor.HOT_PINK);
	}
	
	override public function update():Void
	{
		super.update();
		
		setPosition(FlxG.mouse.x, FlxG.mouse.y);
	}
}