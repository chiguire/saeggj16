package orb;

import flash.display.Sprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author 
 */
class EnergySpawner extends FlxSpriteGroup
{	
	// tweakers
	static var max_objects = 64;
	public var spawn_time = 2.0;
	
	var parentState:PlayState;
	var spawnTimer:FlxTimer;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
	}
	
	public function create(playState:PlayState)
	{
		parentState = playState;
		
		for (i in 0...max_objects)
		{
			var orb = new orb.EnergyOrb(parentState);
			orb.create();
			add(orb);
			orb.kill();
		}
		
		spawnTimer = new FlxTimer(spawn_time, on_spawn_timeup);
	}
	
	override public function update():Void 
	{
		super.update();
		
		if(FlxG.mouse.justPressed)
		{
			var newOrb = new EnergyOrb(parentState, FlxG.mouse.x, FlxG.mouse.y);
			newOrb.create();
			add(newOrb);
		}
		
		FlxG.collide(this);
	}
	
	function on_spawn_timeup(t:FlxTimer):Void
	{
		spawn();
		spawnTimer.reset();
	}
	
	function spawn()
	{
		var newOrb:EnergyOrb = cast recycle(EnergyOrb);
		if (newOrb != null)
		{
			newOrb.resetStateData();
			newOrb.x = FlxRandom.intRanged(0, FlxG.width);
			newOrb.y = FlxRandom.intRanged(0, Std.int(FlxG.height/2));
			newOrb.velocity.x = FlxRandom.intRanged(-64, 64);
			newOrb.velocity.y = FlxRandom.intRanged(0, 0);
		}
	}
}