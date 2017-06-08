package data;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;

/**
 * ...
 * @author Ciro Duran
 */
class InputValue
{
	public var name (default, null): ValueName;
	public var value (default, set): Float;
	public var percent (get, set) : Float; // A 0.0-1.0 value that translates to the [min, max] range, if ranged == true. Does not affect value otherwise.
	public var ranged (default, null): Bool;
	public var min (default, null): Float;
	public var max (default, null): Float;
	
	public function new(name:ValueName, v:Float = 0.0)
	{
		this.name = name;
		value = v;
		ranged = false;
		min = 0;
		max = 0;
		
	}
	
	public function set_range(min:Float, max:Float)
	{
		if (min == 0 && max == 0)
		{
			ranged = false;
			return;
		}
		
		ranged = true;
		if (min > max)
		{
			this.min = max;
			this.max = min;
		}
		else
		{
			this.min = min;
			this.max = max;
		}
		
		this.value = clamp(this.value);
	}
	
	public function set_zero_plus_one_range()
	{
		set_range(0.0, 1.0);
	}
	
	public function set_minus_one_plus_one_range()
	{
		set_range( -1.0, 1.0);
	}
	
	public function remove_range()
	{
		set_range(0, 0);
	}
	
	public function set_value(v:Float)
	{
		return this.value = if (ranged) clamp(v) else v;
	}
	
	public function get_percent()
	{
		return if (ranged) ((value - min) / (max - min)) else Math.NaN;
	}
	
	public function set_percent(v:Float)
	{
		if (ranged)
		{
			return value = min + (max - min) * v;
		}
		else
		{
			trace("Setting percent to an inputvalue that is not ranged");
			return Math.NaN;
		}
	}
	
	public function fill_random()
	{
		value = if (ranged) min + (max - min) * FlxG.random.float() else FlxG.random.float();
	}
	
	private function clamp(v:Float)
	{
		return Math.max(min, Math.min(max, v));
	}
}