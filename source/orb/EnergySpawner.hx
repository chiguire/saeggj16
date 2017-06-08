package orb;

import flash.display.Sprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author 
 */
class EnergySpawner extends FlxSpriteGroup
{	
	// tweakers
	static var max_objects = 10;
	public var spawn_time = 1.5;
	
	var parentState:PlayState;
	var spawnTimer:FlxTimer;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y, max_objects);
	}
	
	public function create(playState:PlayState)
	{
		parentState = playState;
		
		for (i in 0...max_objects)
		{
			var orb = new orb.EnergyOrb(parentState);
			orb.create();
			orb.commanded.add(parentState.commanded_orb_handler);
			add(orb);
			orb.kill();
		}
		
		spawnTimer = new FlxTimer();
		spawnTimer.start(spawn_time, on_spawn_timeup);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		//if(FlxG.mouse.justPressed)
		//{
		//	var newOrb = new EnergyOrb(parentState, FlxG.mouse.x, FlxG.mouse.y);
		//	newOrb.create();
		//	add(newOrb);
		//}
		
		//FlxG.collide(this);
	}
	
	function on_spawn_timeup(t:FlxTimer):Void
	{
		spawn();
		spawnTimer.reset();
	}
	
	function spawn()
	{	
		var newOrb:EnergyOrb = cast getFirstDead();
		if (newOrb != null)
		{
			newOrb.revive();
			newOrb.resetStateData();
			newOrb.angularVelocity = FlxG.random.int( -2, 2);
			
			newOrb.x = FlxG.width/2 + FlxG.random.int(-128, 128);
			newOrb.y = FlxG.random.int(0, Std.int(FlxG.height / 2));
		}
	}
	
	public function pre_spawn(n:Float)
	{
		var numSpawn:Int = Std.int(max_objects * n); 
		for (i in 0...numSpawn)
		{
			spawn();
		}
	}
}