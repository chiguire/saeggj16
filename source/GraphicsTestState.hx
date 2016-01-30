package;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil.LineStyle;
import flixel.util.FlxSpriteUtil.FillStyle;
import flixel.util.FlxTimer;
import graphics.Arm;

/**
 * ...
 * @author Ciro Duran
 */
class GraphicsTestState extends FlxState
{
	public var a0 : Float;
	public var a1 : Float;
	
	public var sprsrc : Sprite;
	public var bd : BitmapData;
	public var spr : FlxSprite;
	public var g : Graphics;
	public var m : Matrix;
	
	public var body_x : Float;
	public var body_y : Float;
	
	public var cursor_left_x : Float;
	public var cursor_left_y : Float;
	public var cursor_right_x : Float;
	public var cursor_right_y : Float;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		Reg.init();
		
		var timer = new FlxTimer(2, function (t:FlxTimer)
		{
			Reg.inputdata.fill_random();
		}, 0);
		
		a0 = 0;
		a1 = 0;
		
		body_x = FlxG.width / 2;
		body_y = FlxG.height / 2;
		
		sprsrc = new Sprite();
		g = sprsrc.graphics;
		bd = new BitmapData(FlxG.width, FlxG.height, true, 0);
		m = new Matrix(1, 0, 0, 1, 0, 0);
		spr = new FlxSprite(0, 0);
		add(spr);
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
		
		a0 += 1;
		a1 -= 1;
		
		g.clear();
		g.lineStyle();
		draw_body();
		draw_face();
		draw_arms();
		
		bd.fillRect(new Rectangle(0, 0, FlxG.width, FlxG.height), 0);
		bd.draw(sprsrc, m);
		spr.loadGraphic(bd);
		
		if (FlxG.keys.justPressed.A)
		{
			Reg.inputdata.fill_random();
		}
		
		var face_height = Reg.inputdata.v(FACE_HEIGHT);
		var neck_length = Reg.inputdata.v(NECK_LENGTH) * face_height;
		var torso_height = Reg.inputdata.v(TORSO_HEIGHT);
		var elh = body_y - torso_height - neck_length;
		
		Reg.inputdata.value(PUPIL_DIRECTION_X).value = FlxG.mouse.x/FlxG.width;
		Reg.inputdata.value(PUPIL_DIRECTION_Y).value = (FlxG.mouse.y - elh) / FlxG.height * 2;
		Reg.inputdata.value(EYE_CLOSENESS).value = (Math.sin(a0 * Math.PI / 45) * 5) - 4;
		Reg.inputdata.value(LEGS_SPREADNESS).value = (Math.sin(a1 * Math.PI / 180) + 1) / 2.0;
	}
	
	public function draw_body()
	{
		var skin_color = FlxColorUtil.makeFromHSBA(Reg.inputdata.v(SKIN_HUE), Reg.inputdata.v(SKIN_SATURATION), Reg.inputdata.v(SKIN_VALUE), 1.0);
		var torso_height = Reg.inputdata.v(TORSO_HEIGHT);
		var chest_width = Reg.inputdata.v(CHEST_WIDTH);
		var waist_width = Reg.inputdata.v(WAIST_WIDTH);
		var hip_width = Reg.inputdata.v(HIP_WIDTH);
		var legs_length = Reg.inputdata.v(LEGS_LENGTH);
		var legs_spreadness = Reg.inputdata.v(LEGS_SPREADNESS);
		
		g.beginFill(skin_color, 1);
		g.moveTo(body_x, body_y - torso_height);
		g.curveTo(body_x + chest_width / 2.0, body_y - torso_height, body_x + chest_width / 2, body_y - torso_height * 2.0 / 3.0);	// Chest
		g.curveTo(body_x + chest_width / 2.0, body_y - torso_height / 3.0, body_x + waist_width / 2, body_y - torso_height / 3.0);	// Waist
		g.curveTo(body_x + hip_width / 2, body_y - torso_height / 3.0, body_x + hip_width / 2, body_y);								// Hip
		
		
		//Other side
		g.lineTo(body_x, body_y + 30);
		g.lineTo(body_x - hip_width / 2, body_y);																					// Hip
		g.curveTo(body_x - hip_width / 2, body_y - torso_height / 3.0, body_x - waist_width / 2, body_y - torso_height / 3.0);		// Waist
		g.curveTo(body_x - chest_width / 2, body_y - torso_height / 3.0, body_x - chest_width / 2, body_y - torso_height * 2.0 / 3.0); // Chest
		g.curveTo(body_x - chest_width / 2, body_y - torso_height, body_x, body_y - torso_height);
		g.endFill();
		
		// Left leg
		g.beginFill(skin_color, 1);
		g.moveTo(body_x - hip_width / 2, body_y);
		
		var sn = Math.sin(legs_spreadness * Math.PI / 8.0);
		var sn1 = Math.sin((legs_spreadness - 18/180) * Math.PI / 8.0);
		var cs = Math.cos(legs_spreadness * Math.PI / 8.0);
		var cs1 = Math.cos((legs_spreadness - 18/180) * Math.PI / 8.0);
		g.lineTo(body_x - hip_width / 2 - sn * legs_length * 0.5, body_y + cs * legs_length * 0.5);
		g.lineTo(body_x - hip_width / 2 - sn * legs_length * 0.5 - sn1 * legs_length * 0.5,
				 body_y + cs * legs_length * 0.5 + cs1 * legs_length * 0.5);
			// Parallel line
		g.lineTo(body_x - hip_width / 2 - sn * legs_length * 0.5 - sn1 * legs_length * 0.5 + hip_width / 2.0 * 0.5,
				 body_y + cs * legs_length * 0.5 + cs1 * legs_length * 0.5);
		g.lineTo(body_x - hip_width / 2 - sn * legs_length * 0.5 + (hip_width / 2.0)* 0.4, body_y + cs * legs_length * 0.5);
		g.lineTo(body_x, body_y + 30);
		g.endFill();
		
		// Right leg
		g.beginFill(skin_color, 1);
		g.moveTo(body_x + hip_width / 2, body_y);
		
		g.lineTo(body_x + hip_width / 2 + sn * legs_length * 0.5, body_y + cs * legs_length * 0.5);
		g.lineTo(body_x + hip_width / 2 + sn * legs_length * 0.5 + sn1 * legs_length * 0.5,
				 body_y + cs * legs_length * 0.5 + cs1 * legs_length * 0.5);
			// Parallel line
		g.lineTo(body_x + hip_width / 2 + sn * legs_length * 0.5 + sn1 * legs_length * 0.5 - hip_width / 2.0 * 0.5,
				 body_y + cs * legs_length * 0.5 + cs1 * legs_length * 0.5);
		g.lineTo(body_x + hip_width / 2 + sn * legs_length * 0.5 - (hip_width / 2.0)* 0.4, body_y + cs * legs_length * 0.5);
		g.lineTo(body_x, body_y + 30);
		g.endFill();
	}
	
	public function draw_face()
	{
		var skin_color = FlxColorUtil.makeFromHSBA(Reg.inputdata.v(SKIN_HUE), Reg.inputdata.v(SKIN_SATURATION), Reg.inputdata.v(SKIN_VALUE), 1.0);
		var face_width = Reg.inputdata.v(FACE_WIDTH);
		var face_height = Reg.inputdata.v(FACE_HEIGHT);
		var torso_height = Reg.inputdata.v(TORSO_HEIGHT);
		var neck_length = Reg.inputdata.v(NECK_LENGTH) * face_height;
		var eye_width = Reg.inputdata.v(EYE_WIDTH) * face_width;
		var eye_height = Reg.inputdata.v(EYE_HEIGHT) * eye_width;
		var eye_closeness = Reg.inputdata.v(EYE_CLOSENESS);
		var pupil_direction_x = Reg.inputdata.v(PUPIL_DIRECTION_X);
		var pupil_direction_y = Reg.inputdata.v(PUPIL_DIRECTION_Y);
		var mouth_happiness = Reg.inputdata.v(MOUTH_HAPPINESS) * face_height / 5;
		
		var elh = body_y - torso_height - neck_length;
		
		g.beginFill(skin_color, 1);
		g.drawRect(body_x - face_width * 0.15, elh, face_width * 0.3, neck_length*1.1);
		g.endFill();
		
		g.beginFill(skin_color, 1);
		g.moveTo(body_x - face_width / 2, elh);
		g.curveTo(body_x - face_width / 2, elh - face_height / 3, body_x, elh - face_height / 3);
		g.curveTo(body_x + face_width / 2, elh - face_height / 3, body_x + face_width / 2, elh);
		g.curveTo(body_x + face_width / 2, elh + face_height * 2.0 / 3.0, body_x, elh + face_height * 2.0 / 3.0);
		g.curveTo(body_x - face_width / 2, elh + face_height * 2.0 / 3.0, body_x - face_width / 2, elh);
		g.endFill();
		
		g.beginFill(0xffffff, 1.0);
		g.drawEllipse(body_x - face_width / 4 - eye_width / 2, elh - eye_height/2, eye_width, eye_height);
		g.endFill();
		
		g.beginFill(FlxColor.BLACK, 1.0);
		g.drawCircle(body_x  - face_width / 4 + pupil_direction_x * eye_width/2, elh + pupil_direction_y * eye_height / 2, eye_height*0.5);
		g.endFill();
		
		g.beginFill(0xffffff, 1.0);
		g.drawEllipse(body_x + face_width / 4 - eye_width / 2, elh - eye_height/2, eye_width, eye_height);
		g.endFill();
		
		g.beginFill(FlxColor.BLACK, 1.0);
		g.drawCircle(body_x + face_width / 4 + pupil_direction_x * eye_width/2, elh + pupil_direction_y * eye_height / 2, eye_height*0.5);
		g.endFill();
		
		g.beginFill(skin_color, 1.0);
		g.drawRect(body_x - face_width / 4 - eye_width / 1.3, elh - eye_height / 1.3, eye_width * 1.5, eye_height * eye_closeness * 1.7);
		g.endFill();
		
		g.beginFill(skin_color, 1.0);
		g.drawRect(body_x + face_width / 4 - eye_width / 1.3, elh - eye_height / 1.3, eye_width * 1.5, eye_height * eye_closeness * 1.7);
		g.endFill();
		
		g.lineStyle(3, 0x000000, 1.0);
		g.moveTo(body_x - face_width / 4, elh + face_height / 3 - mouth_happiness);
		g.curveTo(body_x - face_width / 4, elh + face_height / 3, body_x, elh + face_height / 3);
		g.curveTo(body_x + face_width / 4, elh + face_height / 3, body_x + face_width / 4, elh + face_height / 3 - mouth_happiness);
	}
	
	public function draw_arms()
	{
		var skin_color = FlxColorUtil.makeFromHSBA(Reg.inputdata.v(SKIN_HUE), Reg.inputdata.v(SKIN_SATURATION), Reg.inputdata.v(SKIN_VALUE), 1.0);
		var torso_height = Reg.inputdata.v(TORSO_HEIGHT);
		var chest_width = Reg.inputdata.v(CHEST_WIDTH);
		var arm_left0_angle = Reg.inputdata.v(ARM_LEFT0_ANGLE);
		var arm_left1_angle = Reg.inputdata.v(ARM_LEFT1_ANGLE);
		var arm_right0_angle = Reg.inputdata.v(ARM_RIGHT0_ANGLE);
		var arm_right1_angle = Reg.inputdata.v(ARM_RIGHT1_ANGLE);
		
		g.lineStyle();
		
		var arm_length = 80;
		
		var arm1_start_left_x = evaluate_left_arm_x(body_x - chest_width / 2 + 16, body_y - torso_height + 16, arm_length, arm_left0_angle, 1.0);
		var arm1_start_left_y = evaluate_left_arm_y(body_x - chest_width / 2 + 16, body_y - torso_height + 16, arm_length, arm_left0_angle, 1.0);
		var arm1_end_left_x = evaluate_left_arm_x(arm1_start_left_x, arm1_start_left_y, arm_length, arm_left0_angle+arm_left1_angle, 1.0);
		var arm1_end_left_y = evaluate_left_arm_y(arm1_start_left_x, arm1_start_left_y, arm_length, arm_left0_angle+arm_left1_angle, 1.0);
		
		var arm1_start_right_x = evaluate_right_arm_x(body_x + chest_width / 2 - 16, body_y - torso_height + 16, arm_length, arm_right0_angle, 1.0);
		var arm1_start_right_y = evaluate_right_arm_y(body_x + chest_width / 2 - 16, body_y - torso_height + 16, arm_length, arm_right0_angle, 1.0);	
		var arm1_end_right_x = evaluate_right_arm_x(arm1_start_right_x, arm1_start_right_y, arm_length, arm_right0_angle+arm_right1_angle, 1.0);
		var arm1_end_right_y = evaluate_right_arm_y(arm1_start_right_x, arm1_start_right_y, arm_length, arm_right0_angle+arm_right1_angle, 1.0);
		
		g.lineStyle(32, skin_color, 1.0);
		g.moveTo(body_x - chest_width / 2 + 16, body_y - torso_height + 16);
		g.lineTo(arm1_start_left_x, arm1_start_left_y);
		g.lineTo(arm1_end_left_x, arm1_end_left_y);
		
		g.moveTo(body_x + chest_width / 2 - 16, body_y - torso_height + 16);
		g.lineTo(arm1_start_right_x, arm1_start_right_y);
		g.lineTo(arm1_end_right_x, arm1_end_right_y);
		g.lineStyle();
	}
	
	public function evaluate_left_arm_x(x_start:Float, y_start:Float, arm_length:Float, arm_angle:Float, t:Float) : Float
	{
		return x_start - arm_length * t * Math.cos(arm_angle * Math.PI / 180);
	}
	
	public function evaluate_left_arm_y(x_start:Float, y_start:Float, arm_length:Float, arm_angle:Float, t:Float) : Float
	{
		return y_start - arm_length * t * Math.sin(arm_angle * Math.PI / 180);
	}
	
	public function evaluate_right_arm_x(x_start:Float, y_start:Float, arm_length:Float, arm_angle:Float, t:Float) : Float
	{
		return x_start + arm_length * t * Math.cos(arm_angle * Math.PI / 180);
	}
	
	public function evaluate_right_arm_y(x_start:Float, y_start:Float, arm_length:Float, arm_angle:Float, t:Float) : Float
	{
		return y_start - arm_length * t * Math.sin(arm_angle * Math.PI / 180);
	}
	
	public function ik_solve(target:FlxSprite)
	{
		//l_arm_angle += solve_ik_solve(left_arm_2, target);
		//l_sidearm_angle += solve_ik_solve(left_arm_1, target);
		//r_brush_angle += solve_ik_solve(right_arm_3, target);
		//r_arm_angle += solve_ik_solve(right_arm_2, target);
		//r_sidearm_angle += solve_ik_solve(right_arm_1, target);
	}
	
	private function solve_ik_solve(arm:FlxSprite, target:FlxSprite)
	{
		//var v = FlxVector.get(0, arm.height - 20);
		//v.rotateByDegrees(arm.angle);
		//var v_p = FlxVector.get(v.x, v.y);
		//v_p.rotateByDegrees(90);
		//
		//var v_f = FlxVector.get((target.x + target.origin.x) - (arm.x + arm.origin.x + v.x),
		//						(target.y + target.origin.y) - (arm.y + arm.origin.y + v.y));
		//
		//var dot_product = v_f.dotProdWithNormalizing(v_p);
		//
		//return dot_product*0.005;
	}
}