package player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
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
	
	public var draw_sound : FlxSound;

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
	}
	
	public function create():Void
	{
		//makeGraphic(64, 64, FlxColor.PINK);
		loadGraphic("assets/images/energy_collector.png");
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		var lhandOverlapping = FlxG.overlap(this, playerLHand);
		var rhandOverlapping = FlxG.overlap(this, playerRHand);
		if (lhandOverlapping && rhandOverlapping)
		{
			//trace("drawing power");
			if (draw_sound == null || !draw_sound.playing)
			{
				#if flash
				draw_sound = FlxG.sound.play(AssetPaths.DrawOrbs__mp3, 0.5, true);
				#else
				draw_sound = FlxG.sound.play(AssetPaths.DrawOrbs__ogg, 0.5, true);
				#end
			}
			
			state = EnergyCollectorState.ACTIVATED;
		}
		else 
		{
			if (draw_sound != null)
			{
				draw_sound.stop();
			}
			state = EnergyCollectorState.IDLE;
		}
	}
}