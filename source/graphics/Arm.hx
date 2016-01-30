package graphics;

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.util.FlxSpriteUtil.FillStyle;
import flixel.util.FlxSpriteUtil.LineStyle;
import flixel.util.FlxColor;

/**
 * ...
 * @author Ciro Duran
 */
class Arm extends FlxSpriteGroup
{
	public var base_position : FlxPoint;
	public var arm_angle : Float;
	public var arm_length : Float;
	public var points : Int;
	
	static var ls : LineStyle = { thickness: 3, color: 0xf0f0f0 };
	static var fs : FillStyle = { hasFill: true, color: FlxColor.WHITE, alpha: 1.0 };
	
	public function new(X:Float, Y:Float, starting_angle : Float, arm_length:Int, points:Int) 
	{
		super(X, Y, points);
		
		base_position = FlxPoint.get(X, Y);
		arm_angle = starting_angle;
		this.arm_length = arm_length;
		
		this.points = points;
		for (j in 0...points)
		{
			var a = recycle(FlxShapeCircle, [0, 0, 10, ls, fs], true);
			a.revive();
		}
	}
	
	public function end_position_x() : Float
	{
		return base_position.x + Math.cos(arm_angle * Math.PI / 180.0) * arm_length;
	}
	
	public function end_position_y() : Float
	{
		return base_position.y + Math.sin(arm_angle * Math.PI / 180.0) * arm_length;
	}
	
	public override function update()
	{
		for (j in 0...points)
		{
			var a = members[j];
			a.x = base_position.x + ((j / ((points-1)*1.0)) * arm_length)*Math.cos(arm_angle*Math.PI/180.0);
			a.y = base_position.y + ((j / ((points-1)*1.0)) * arm_length)*Math.sin(arm_angle*Math.PI/180.0);
		}
	}
}