package data;
import haxe.macro.Context;

/**
 * This basically wraps an map of floats
 * and some mutation methods.
 * 
 * @author Ciro Duran
 */
class InputData
{
	private var _map : Map<ValueName, InputValue>;
	
	// Initialise n values to 0
	public function new() 
	{
		_map = new Map<ValueName, InputValue>();
	}
	
	public function insert_value(vn:ValueName, v:Float, min:Float = 0.0, max:Float = 0.0)
	{
		var inputvalue = new InputValue(vn, v);
		if (min != 0.0 || max != 0.0)
		{
			inputvalue.set_range(min, max);
		}
		_map[vn] = inputvalue;
	}
	
	public function v(vn:ValueName) : Float
	{
		return _map[vn].value;
	}
	
	public function value(vn:ValueName) : InputValue
	{
		return _map[vn];
	}
	
	public function fill_random()
	{
		for (iv in _map)
		{
			iv.fill_random();
		}
	}
	
	public function mutate()
	{
		for (iv in _map)
		{
			//iv.mutate();
		}
	}
	
	public function to_png()
	{
		//output data to png
	}
	
	public function to_array()
	{
		var r = new Array();
		
		for (i in _map)
		{
			r.push(i.value);
		}
		
		return r;
	}
}
