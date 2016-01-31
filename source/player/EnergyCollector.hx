package player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import player.EnerygyCollectorState.EnergyCollectorState;

/**
 * ...
 * @author 
 */ 
class EnergyCollector extends FlxSprite
{
	public var state = EnergyCollectorState.IDLE;
	
	// player hands overlapping test
	public var playerLHand:PlayerHand;
	public var playerRHand:PlayerHand;

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
	}
	
	public function create():Void
	{
		//makeGraphic(64, 64, FlxColor.PINK);
		loadGraphic("assets/images/energy_collector.png");
	}
	
	override public function update():Void 
	{
		super.update();
		
		var lhandOverlapping = FlxG.overlap(this, playerLHand);
		var rhandOverlapping = FlxG.overlap(this, playerRHand);
		if (lhandOverlapping && rhandOverlapping)
		{
			//trace("drawing power");
			state = EnergyCollectorState.ACTIVATED;
		}
		else 
		{
			state = EnergyCollectorState.IDLE;
		}
	}
}