package player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
enum EnergyCollectorState
{
	IDLE;
	ACTIVATED;
}
 
class EnergyCollector extends FlxSprite
{
	var state = EnergyCollectorState.IDLE;
	
	// player hands overlapping test
	public var playerHands:FlxSpriteGroup;

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
	}
	
	public function create():Void
	{
		makeGraphic(64, 64, FlxColor.WHITE);
	}
	
	override public function update():Void 
	{
		super.update();
		
		//FlxG.overlap(this, playerHands, onPlayerHandsOverlap);
	}
}