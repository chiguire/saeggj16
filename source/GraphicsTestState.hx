package;

import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil.LineStyle;
import flixel.util.FlxSpriteUtil.FillStyle;
import graphics.Arm;

/**
 * ...
 * @author Ciro Duran
 */
class GraphicsTestState extends FlxState
{
	public var arm0 : Arm;
	public var arm1 : Arm;
	
	public var a0 : Float;
	public var a1 : Float;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		arm0 = new Arm(FlxG.width / 2.0, FlxG.height / 2.0, 0, 100, 10);
		arm1 = new Arm(FlxG.width / 2.0, FlxG.height / 2.0, 0, 100, 10);
		
		add(arm0);
		add(arm1);
		
		a0 = 0;
		a1 = 0;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		arm0.arm_angle = a0;
		arm1.arm_angle = a1;
		arm1.base_position.set(arm0.end_position_x(), arm0.end_position_y());
		
		a0 += 1;
		a1 -= 1;
	}
}