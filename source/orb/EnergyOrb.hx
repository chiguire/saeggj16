package orb;

import flixel.effects.FlxFlicker;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import player.EnergyCollector;
import player.EnerygyCollectorState.EnergyCollectorState;

import flixel.util.FlxVelocity;


using flixel.util.FlxSpriteUtil;

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
	public var draw_to_power_time = 500; //millisecond
	public var retreat_speed = 512; // pixel/s
	
	public var orbtype = EnergyOrbTypeEnum.Undefined;
	public var recorded_command = "";
	
	public var sound_normal : String = "";
	public var sound_action : String = "";
	public var sound_reset: String = "";
	public var sound_select : String = "";
	
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
		loadGraphic(AssetPaths.OrbNeutral04__png, false);
		elasticity = 1.0;
	}
	
	public function resetStateData():Void
	{
		velocity.x = 0; velocity.y = 0;
		color = FlxColor.GRAY;
		
		curr_state = EnergyOrbState.IDLE;
		next_state = EnergyOrbState.IDLE;
		orbtype = EnergyOrbTypeEnum.Undefined;
		recorded_command = "";
		curr_player_energy_collector = null;
		
		recording_state_timer.active = false;
		collectable_state_timer.active = false;
		retreat_state_timer.active = false;
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
		
		if (x > FlxG.width + width) x = -width / 2;
		if (x < -width) x = FlxG.width + width / 2;
		if (y > FlxG.height) kill();
				
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
				if (sound_normal != "")
				{
					var snd = FlxG.sound.play(sound_normal, 1);
					snd.pan = ((x / FlxG.width) - 0.5) * 2;
				}
				collectable_state_timer.reset();
			}
			else
			{
				if (!RecipeManager.can_transform_further(recorded_command) && orbtype==EnergyOrbTypeEnum.Undefined)
				{
					kill();
				}
			}
		}
	}
	
	function on_recording_state_idle_timeup(t:FlxTimer):Void
	{
		can_record_command = true;
		
		if (sound_reset != "")
		{
			var snd = FlxG.sound.play(sound_reset, 1);
			snd.pan = ((x / FlxG.width) - 0.5) * 2;
		}		
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
		var def = RecipeManager.energy_orb_definition_map[_orbType];
		
		orbtype = _orbType;
		sound_action = def.sound_action;
		sound_normal = def.sound_normal;
		sound_reset = def.sound_reset;
		sound_select = def.sound_select;
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
		
		if (sound_action != "")
		{
			var snd = FlxG.sound.play(sound_action, 1);
			snd.pan = ((x / FlxG.width) - 0.5) * 2;
		}
	}
}