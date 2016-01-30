package orb;

import flixel.effects.FlxFlicker;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class EnergyOrb extends FlxSprite
{
	// tweakables
	public var recording_state_idle_time = 0.2;
	public var collectable_state_time = 5.0;
	
	public var orbtype = EnergyOrbTypeEnum.Undefined;
	public var recorded_command = "";
	
	var can_record_command = true;
	
	var recording_state_timer:FlxTimer;
	var collectable_state_timer:FlxTimer;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		recording_state_timer = new FlxTimer(recording_state_idle_time, on_recording_state_idle_timeup);
		recording_state_timer.active = false;
		collectable_state_timer = new FlxTimer(collectable_state_time, on_collectable_state_timeup);
		collectable_state_timer.active = false;
	}
	
	public function create():Void
	{
		makeGraphic(48, 48, FlxColor.GRAY);
	}
	
	override public function update():Void 
	{
		super.update();
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