package orb;

import flixel.effects.FlxFlicker;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import player.EnergyCollector;
import player.EnerygyCollectorState.EnergyCollectorState;

import flixel.util.FlxVelocity;

/**
 * ...
 * @author ...
 */
enum EnergyOrbState
{
	IDLE;
	DRAW_TO_POWER;
	RETREAT;
}

class EnergyOrb extends FlxSprite
{
	// tweakables
	public var recording_state_idle_time = 0.2;
	public var collectable_state_time = 5.0;
	public var draw_to_power_time = 2000; //millisecond
	public var retreat_speed = 512; // pixel/s
	
	public var orbtype = EnergyOrbTypeEnum.Undefined;
	public var recorded_command = "";
	
	var can_record_command = true;
	
	var recording_state_timer:FlxTimer;
	var collectable_state_timer:FlxTimer;
	var retreat_state_timer:FlxTimer;
	
	var parent_state:PlayState;
	
	var curr_state = EnergyOrbState.IDLE;
	var next_state = EnergyOrbState.IDLE;
	
	var curr_fallback_point = new FlxPoint();
	var curr_player_energy_collector:EnergyCollector; 
	
	public function new(parentState:PlayState, X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		parent_state = parentState;
		
		recording_state_timer = new FlxTimer(recording_state_idle_time, on_recording_state_idle_timeup);
		recording_state_timer.active = false;
		collectable_state_timer = new FlxTimer(collectable_state_time, on_collectable_state_timeup);
		collectable_state_timer.active = false;
		retreat_state_timer = new FlxTimer(1.0, on_retreat_state_timeup);
		retreat_state_timer.active = false;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
	
	public function create():Void
	{
		makeGraphic(48, 48, FlxColor.GRAY);
	}
	
	override public function update():Void 
	{
		super.update();
		
		curr_player_energy_collector = null;
		for (obj in parent_state.playerEnergyCollectors.members)
		{
			var playerEnergyCollector:EnergyCollector = cast obj;
			if (playerEnergyCollector.state == EnergyCollectorState.ACTIVATED && 
			orbtype != EnergyOrbTypeEnum.Undefined)
			{
				//trace([x,y]);
				next_state = EnergyOrbState.DRAW_TO_POWER;
				curr_player_energy_collector = playerEnergyCollector;
			}
		}
				
		switch(curr_state)
		{
			case EnergyOrbState.IDLE:
				{
					if (next_state == EnergyOrbState.DRAW_TO_POWER)
					{
						curr_fallback_point.x = x;
						curr_fallback_point.y = y;
						curr_state = EnergyOrbState.DRAW_TO_POWER;
					}
				}
			case EnergyOrbState.DRAW_TO_POWER:
				if (curr_player_energy_collector != null)
				{
					FlxVelocity.moveTowardsObject(this, curr_player_energy_collector, 60, draw_to_power_time);
				}
				else
				{	
					curr_state = EnergyOrbState.RETREAT;
				}
			case EnergyOrbState.RETREAT:
				{
					FlxVelocity.moveTowardsPoint(this, curr_fallback_point, retreat_speed);
					if (FlxMath.distanceToPoint(this, curr_fallback_point) < retreat_speed/10)
					{
						next_state = EnergyOrbState.IDLE;
					}
					
					if (next_state == EnergyOrbState.DRAW_TO_POWER)
					{
						curr_state = EnergyOrbState.DRAW_TO_POWER;
					}
					else if (next_state == EnergyOrbState.IDLE)
					{
						curr_state = EnergyOrbState.IDLE;
						velocity.x = 0; velocity.y = 0;
						x = curr_fallback_point.x; y = curr_fallback_point.y;
					}
				}
		}
	}
	
	public function record_command(s:String):Void
	{
		if (can_record_command)
		{
			FlxFlicker.flicker(this, recording_state_idle_time);
			can_record_command = false;
			recording_state_timer.reset();
			recorded_command += s;
			//trace(recorded_command);
			
			var transform_completed = RecipeManager.transform(recorded_command, this);
			if (transform_completed)
			{
				collectable_state_timer.reset();
			}
		}
	}
	
	function on_recording_state_idle_timeup(t:FlxTimer):Void
	{
		can_record_command = true;
	}
	
	function on_collectable_state_timeup(t:FlxTimer):Void
	{
		recorded_command = "";
		update_properties(EnergyOrbTypeEnum.Undefined);
	}
	
	function on_retreat_state_timeup(t:FlxTimer):Void
	{
		//next_state = EnergyOrbState.IDLE;
	}
	
	public function update_properties(_orbType:EnergyOrbTypeEnum)
	{
		orbtype = _orbType;
		switch(orbtype)
		{
			case EnergyOrbTypeEnum.Undefined:
				color = FlxColor.GRAY;
			case EnergyOrbTypeEnum.Red:  
				color = FlxColor.RED;
			case EnergyOrbTypeEnum.Green:
				color = FlxColor.GREEN;
			case EnergyOrbTypeEnum.Blue:  
				color = FlxColor.BLUE;
		}
	}
}