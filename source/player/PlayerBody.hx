package player;

import flash.geom.ColorTransform;
import flixel.FlxSprite;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.util.FlxColorUtil;
import flixel.util.FlxColor;
import openfl.Assets;

/**
 * ...
 * @author Ciro Duran
 */
class PlayerBody extends FlxSprite
{
	public var a0 : Float;
	public var a1 : Float;
	
	public var sprsrc : Sprite;
	public var bd : BitmapData;
	public var g : Graphics;
	public var m : Matrix;
	
	public var body_x : Float;
	public var body_y : Float;
	
	public var monster_x : Float;
	public var monster_y : Float;
	
	public var left_hand : FlxSprite;
	public var right_hand : FlxSprite;
	
	public var left_distance : Float;
	public var right_distance : Float;
	
	public var left_hand_sprite : BitmapData;
	public var right_hand_sprite : BitmapData;
	public var left_hand_m : Matrix;
	public var right_hand_m : Matrix;
	
	public function new() 
	{
		super(0, 0);
		
		a0 = 0;
		a1 = 0;
		
		body_x = FlxG.width / 2;
		body_y = FlxG.height / 2;
		
		monster_x = FlxG.width / 2+ 150;
		monster_y = 5*FlxG.height / 5;
		
		sprsrc = new Sprite();
		g = sprsrc.graphics;
		bd = new BitmapData(FlxG.width, FlxG.height, true, 0);
		m = new Matrix(1, 0, 0, 1, 0, 0);
		
		right_hand_sprite = Assets.getBitmapData(AssetPaths.right_hand__png);
		right_hand_m = new Matrix();
		left_hand_sprite = Assets.getBitmapData(AssetPaths.left_hand__png);
		left_hand_m = new Matrix();
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
		
		draw_monster();
		
		g.moveTo(0, 0);
		bd.fillRect(new Rectangle(0, 0, FlxG.width, FlxG.height), 0);
		bd.draw(sprsrc, m);
		draw_hands();
		loadGraphic(bd);
		
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
		g.moveTo(0, 0);
		g.lineStyle();
		
	}
	
	public function draw_arms()
	{
		var skin_color = FlxColorUtil.makeFromHSBA(Reg.inputdata.v(SKIN_HUE), Reg.inputdata.v(SKIN_SATURATION), Reg.inputdata.v(SKIN_VALUE)*0.9, 1.0);
		var torso_height = Reg.inputdata.v(TORSO_HEIGHT);
		var chest_width = Reg.inputdata.v(CHEST_WIDTH);
		
		var arm0_start_left_x = body_x - chest_width / 2 + 16;
		var arm0_start_left_y = body_y - torso_height + 16;
		var arm0_start_right_x = body_x + chest_width / 2 - 16;
		var arm0_start_right_y = body_y - torso_height + 16;
		var arm_length = 80;
		
		ik_solve(arm0_start_left_x, arm0_start_left_y, left_hand.x, left_hand.y, true, arm_length, arm_length, true);
		ik_solve(arm0_start_right_x, arm0_start_right_y, right_hand.x, right_hand.y, false, arm_length, arm_length, false);
		
		var arm_left0_angle = Reg.inputdata.v(ARM_LEFT0_ANGLE);
		var arm_left1_angle = Reg.inputdata.v(ARM_LEFT1_ANGLE);
		var arm_right0_angle = Reg.inputdata.v(ARM_RIGHT0_ANGLE);
		var arm_right1_angle = Reg.inputdata.v(ARM_RIGHT1_ANGLE);
		
		var arm1_start_left_x = evaluate_left_arm_x(arm0_start_left_x, arm0_start_left_y, arm_length, arm_left0_angle, 1.0);
		var arm1_start_left_y = evaluate_left_arm_y(arm0_start_left_x, arm0_start_left_y, arm_length, arm_left0_angle, 1.0);
		var arm1_end_left_x = evaluate_left_arm_x(arm1_start_left_x, arm1_start_left_y, arm_length, arm_left0_angle+arm_left1_angle, 1.0);
		var arm1_end_left_y = evaluate_left_arm_y(arm1_start_left_x, arm1_start_left_y, arm_length, arm_left0_angle+arm_left1_angle, 1.0);
		
		var arm1_start_right_x = evaluate_right_arm_x(arm0_start_right_x, arm0_start_right_y, arm_length, arm_right0_angle, 1.0);
		var arm1_start_right_y = evaluate_right_arm_y(arm0_start_right_x, arm0_start_right_y, arm_length, arm_right0_angle, 1.0);	
		var arm1_end_right_x = evaluate_right_arm_x(arm1_start_right_x, arm1_start_right_y, arm_length, arm_right0_angle+arm_right1_angle, 1.0);
		var arm1_end_right_y = evaluate_right_arm_y(arm1_start_right_x, arm1_start_right_y, arm_length, arm_right0_angle+arm_right1_angle, 1.0);
		
		g.lineStyle(20, skin_color, 1.0);
		g.moveTo(body_x - chest_width / 2 + 16, body_y - torso_height + 16);
		g.lineTo(arm1_start_left_x, arm1_start_left_y);
		g.lineTo(arm1_end_left_x, arm1_end_left_y);
		
		g.moveTo(body_x + chest_width / 2 - 16, body_y - torso_height + 16);
		g.lineTo(arm1_start_right_x, arm1_start_right_y);
		g.lineTo(arm1_end_right_x, arm1_end_right_y);
		g.moveTo(arm1_end_right_x, arm1_end_right_y);
		g.lineStyle();
	}
	
	public function evaluate_left_arm_x(x_start:Float, y_start:Float, arm_length:Float, arm_angle:Float, t:Float) : Float
	{
		return x_start + arm_length * t * Math.cos(arm_angle * Math.PI / 180);
	}
	
	public function evaluate_left_arm_y(x_start:Float, y_start:Float, arm_length:Float, arm_angle:Float, t:Float) : Float
	{
		return y_start + arm_length * t * Math.sin(arm_angle * Math.PI / 180);
	}
	
	public function evaluate_right_arm_x(x_start:Float, y_start:Float, arm_length:Float, arm_angle:Float, t:Float) : Float
	{
		return x_start + arm_length * t * Math.cos(arm_angle * Math.PI / 180);
	}
	
	public function evaluate_right_arm_y(x_start:Float, y_start:Float, arm_length:Float, arm_angle:Float, t:Float) : Float
	{
		return y_start + arm_length * t * Math.sin(arm_angle * Math.PI / 180);
	}
	
	public function ik_solve(arm0_start_x:Float, arm0_start_y:Float, target_x:Float, target_y:Float, solve_positive_angle1 : Bool, arm0_length:Float, arm1_length:Float, modify_left_arm:Bool) : Bool
	{
		var epsilon = 0.0001;
		var found_valid_solution = true;
		
		var x = (target_x - arm0_start_x);
		var y = (target_y - arm0_start_y);
		
		var target_dist_sqr = (x * x + y * y);
		
		var sin_angle1;
		var cos_angle1;
		
		var angle0 : Float;
		var angle1 : Float;
		
		var cos_angle1_denom = 2 * arm0_length * arm1_length;
		if (cos_angle1_denom > epsilon)
		{
			cos_angle1 = (target_dist_sqr - arm0_length * arm0_length - arm1_length * arm1_length) / (cos_angle1_denom);
			
			if (cos_angle1 < -1.0 || cos_angle1 > 1.0)
			{
				found_valid_solution = false;
			}
			
			cos_angle1 = Math.max( -1, Math.min( 1, cos_angle1));
			angle1 = Math.acos(cos_angle1);
			
			if (!solve_positive_angle1)
			{
				angle1 = -angle1;
			}
			
			sin_angle1 = Math.sin(angle1);
		}
		else
		{
			var total_len_sqr = (arm0_length + arm1_length) * (arm0_length + arm1_length);
			
			if (target_dist_sqr < (total_len_sqr - epsilon) ||
			    target_dist_sqr > (total_len_sqr + epsilon))
			{
				found_valid_solution = false;
			}
			
			angle1 = 0;
			cos_angle1 = 1;
			sin_angle1 = 0;
		}
		
		var tri_adjacent = arm0_length + arm1_length * cos_angle1;
		var tri_opposite = arm1_length * sin_angle1;
		
		var tan_y = y * tri_adjacent - x * tri_opposite;
		var tan_x = x * tri_adjacent + y * tri_opposite;
		
		angle0 = Math.atan2(tan_y, tan_x);
		
		if (found_valid_solution)
		{
			if (modify_left_arm)
			{
				Reg.inputdata.value(ARM_LEFT0_ANGLE).value = angle0 * 180 / Math.PI;
				Reg.inputdata.value(ARM_LEFT1_ANGLE).value = angle1 * 180 / Math.PI;
			}
			else
			{
				Reg.inputdata.value(ARM_RIGHT0_ANGLE).value = angle0 * 180 / Math.PI;
				Reg.inputdata.value(ARM_RIGHT1_ANGLE).value = angle1 * 180 / Math.PI;
			}
		}
		
		return found_valid_solution;
	}
	
	public function left_in_distance(x_dir:Float, y_dir:Float) : Bool
	{
		var torso_height = Reg.inputdata.v(TORSO_HEIGHT);
		var chest_width = Reg.inputdata.v(CHEST_WIDTH);
		
		var arm0_start_left_x = body_x - chest_width / 2 + 16;
		var arm0_start_left_y = body_y - torso_height + 16;
		
		var max_distance = (80+80) * (80+80); //arm_length*arm_length
		
		var temp_left_distance = (left_hand.x + x_dir - arm0_start_left_x) * (left_hand.x + x_dir - arm0_start_left_x) + (left_hand.y + y_dir - arm0_start_left_y) * (left_hand.y + y_dir - arm0_start_left_y);
		
		if (temp_left_distance <= max_distance)
		{
			left_distance = temp_left_distance;
			return true;
		}
		
		return false;
	}
	
	public function right_in_distance(x_dir:Float, y_dir:Float) : Bool
	{
		var torso_height = Reg.inputdata.v(TORSO_HEIGHT);
		var chest_width = Reg.inputdata.v(CHEST_WIDTH);
		
		var arm0_start_right_x = body_x + chest_width / 2 - 16;
		var arm0_start_right_y = body_y - torso_height + 16;
		
		var max_distance = (80+80) * (80+80); //arm_length*arm_length
		
		var temp_right_distance = (right_hand.x - arm0_start_right_x) * (right_hand.x - arm0_start_right_x) + (right_hand.y - arm0_start_right_y) * (right_hand.y - arm0_start_right_y);
		
		if (temp_right_distance <= max_distance)
		{
			right_distance = temp_right_distance;
			return true;
		}
		
		return false;
	}
	
	public function draw_monster()
	{
		var skin_color = FlxColorUtil.makeFromHSBA(Reg.inputdata.v(MONSTER_SKIN_HUE), Reg.inputdata.v(MONSTER_SKIN_SATURATION), Reg.inputdata.v(MONSTER_SKIN_VALUE), 1.0);
		var torso_height = Reg.inputdata.v(MONSTER_TORSO_HEIGHT);
		var chest_width = Reg.inputdata.v(MONSTER_CHEST_WIDTH);
		var waist_width = Reg.inputdata.v(MONSTER_WAIST_WIDTH);
		var hip_width = Reg.inputdata.v(MONSTER_HIP_WIDTH);
		var legs_length = Reg.inputdata.v(MONSTER_LEGS_LENGTH);
		var legs_spreadness = Reg.inputdata.v(LEGS_SPREADNESS);
		var face_width = Reg.inputdata.v(FACE_WIDTH);
		var face_height = Reg.inputdata.v(FACE_HEIGHT);
		var neck_length = Reg.inputdata.v(NECK_LENGTH) * face_height;
		
		g.beginFill(skin_color, 1);
		g.moveTo(monster_x, monster_y - torso_height);
		g.curveTo(monster_x + chest_width / 2.0, monster_y - torso_height, monster_x + chest_width / 2, monster_y - torso_height * 2.0 / 3.0);	// Chest
		g.curveTo(monster_x + chest_width / 2.0, monster_y - torso_height / 3.0, monster_x + waist_width / 2, monster_y - torso_height / 3.0);	// Waist
		g.curveTo(monster_x + hip_width / 2, monster_y - torso_height / 3.0, monster_x + hip_width / 2, monster_y);								// Hip
		
		
		//Other side
		g.lineTo(monster_x, monster_y + 30);
		g.lineTo(monster_x - hip_width / 2, monster_y);																					// Hip
		g.curveTo(monster_x - hip_width / 2, monster_y - torso_height / 3.0, monster_x - waist_width / 2, monster_y - torso_height / 3.0);		// Waist
		g.curveTo(monster_x - chest_width / 2, monster_y - torso_height / 3.0, monster_x - chest_width / 2, monster_y - torso_height * 2.0 / 3.0); // Chest
		g.curveTo(monster_x - chest_width / 2, monster_y - torso_height, monster_x, monster_y - torso_height);
		g.endFill();
		
		// Left leg
		g.beginFill(skin_color, 1);
		g.moveTo(monster_x - hip_width / 2, monster_y);
		
		var sn = Math.sin(legs_spreadness * Math.PI / 8.0);
		var sn1 = Math.sin((legs_spreadness - 18/180) * Math.PI / 8.0);
		var cs = Math.cos(legs_spreadness * Math.PI / 8.0);
		var cs1 = Math.cos((legs_spreadness - 18/180) * Math.PI / 8.0);
		g.lineTo(monster_x - hip_width / 2 - sn * legs_length * 0.5, monster_y + cs * legs_length * 0.5);
		g.lineTo(monster_x - hip_width / 2 - sn * legs_length * 0.5 - sn1 * legs_length * 0.5,
				 monster_y + cs * legs_length * 0.5 + cs1 * legs_length * 0.5);
			// Parallel line
		g.lineTo(monster_x - hip_width / 2 - sn * legs_length * 0.5 - sn1 * legs_length * 0.5 + hip_width / 2.0 * 0.5,
				 monster_y + cs * legs_length * 0.5 + cs1 * legs_length * 0.5);
		g.lineTo(monster_x - hip_width / 2 - sn * legs_length * 0.5 + (hip_width / 2.0)* 0.4, monster_y + cs * legs_length * 0.5);
		g.lineTo(monster_x, monster_y + 30);
		g.endFill();
		
		// Right leg
		g.beginFill(skin_color, 1);
		g.moveTo(monster_x + hip_width / 2, monster_y);
		
		g.lineTo(monster_x + hip_width / 2 + sn * legs_length * 0.5, monster_y + cs * legs_length * 0.5);
		g.lineTo(monster_x + hip_width / 2 + sn * legs_length * 0.5 + sn1 * legs_length * 0.5,
				 monster_y + cs * legs_length * 0.5 + cs1 * legs_length * 0.5);
			// Parallel line
		g.lineTo(monster_x + hip_width / 2 + sn * legs_length * 0.5 + sn1 * legs_length * 0.5 - hip_width / 2.0 * 0.5,
				 monster_y + cs * legs_length * 0.5 + cs1 * legs_length * 0.5);
		g.lineTo(monster_x + hip_width / 2 + sn * legs_length * 0.5 - (hip_width / 2.0)* 0.4, monster_y + cs * legs_length * 0.5);
		g.lineTo(monster_x, monster_y + 30);
		g.endFill();
		
		var elh = monster_y - torso_height - neck_length;
		
		g.beginFill(skin_color, 1);
		g.drawRect(monster_x - face_width * 0.15, elh, face_width * 0.3, neck_length*1.1);
		g.endFill();
		
		g.beginFill(skin_color, 1);
		g.moveTo(monster_x - face_width / 2, elh);
		g.curveTo(monster_x - face_width / 2, elh - face_height / 3, monster_x, elh - face_height / 3);
		g.curveTo(monster_x + face_width / 2, elh - face_height / 3, monster_x + face_width / 2, elh);
		g.curveTo(monster_x + face_width / 2, elh + face_height * 2.0 / 3.0, monster_x, elh + face_height * 2.0 / 3.0);
		g.curveTo(monster_x - face_width / 2, elh + face_height * 2.0 / 3.0, monster_x - face_width / 2, elh);
		g.endFill();
		
		g.beginFill(skin_color, 1);
		g.moveTo(monster_x - face_width / 2, elh);
		g.curveTo(monster_x - face_width, elh, monster_x - face_width, elh - 40);
		g.curveTo(monster_x - face_width, elh+30, monster_x - face_width / 3, elh + 30);
		g.endFill();
		
		g.beginFill(skin_color, 1);
		g.moveTo(monster_x + face_width / 2, elh);
		g.curveTo(monster_x + face_width, elh, monster_x + face_width, elh - 40);
		g.curveTo(monster_x + face_width, elh+30, monster_x + face_width / 3, elh + 30);
		g.endFill();
	}
	
	public function draw_hands()
	{
		var skin_color = FlxColorUtil.makeFromHSBA(Reg.inputdata.v(SKIN_HUE), Reg.inputdata.v(SKIN_SATURATION), Reg.inputdata.v(SKIN_VALUE)*0.9, 1.0);
		var skin_color_argb = FlxColorUtil.getARGB(skin_color);
		var torso_height = Reg.inputdata.v(TORSO_HEIGHT);
		var chest_width = Reg.inputdata.v(CHEST_WIDTH);
		
		var arm0_start_left_x = body_x - chest_width / 2 + 16;
		var arm0_start_left_y = body_y - torso_height + 16;
		var arm0_start_right_x = body_x + chest_width / 2 - 16;
		var arm0_start_right_y = body_y - torso_height + 16;
		var arm_length = 80;
		
		var arm_left0_angle = Reg.inputdata.v(ARM_LEFT0_ANGLE);
		var arm_left1_angle = Reg.inputdata.v(ARM_LEFT1_ANGLE);
		var arm_right0_angle = Reg.inputdata.v(ARM_RIGHT0_ANGLE);
		var arm_right1_angle = Reg.inputdata.v(ARM_RIGHT1_ANGLE);
		
		var arm1_start_left_x = evaluate_left_arm_x(arm0_start_left_x, arm0_start_left_y, arm_length, arm_left0_angle, 1.0);
		var arm1_start_left_y = evaluate_left_arm_y(arm0_start_left_x, arm0_start_left_y, arm_length, arm_left0_angle, 1.0);
		var arm1_end_left_x = evaluate_left_arm_x(arm1_start_left_x, arm1_start_left_y, arm_length, arm_left0_angle+arm_left1_angle, 1.0);
		var arm1_end_left_y = evaluate_left_arm_y(arm1_start_left_x, arm1_start_left_y, arm_length, arm_left0_angle+arm_left1_angle, 1.0);
		
		var arm1_start_right_x = evaluate_right_arm_x(arm0_start_right_x, arm0_start_right_y, arm_length, arm_right0_angle, 1.0);
		var arm1_start_right_y = evaluate_right_arm_y(arm0_start_right_x, arm0_start_right_y, arm_length, arm_right0_angle, 1.0);	
		var arm1_end_right_x = evaluate_right_arm_x(arm1_start_right_x, arm1_start_right_y, arm_length, arm_right0_angle+arm_right1_angle, 1.0);
		var arm1_end_right_y = evaluate_right_arm_y(arm1_start_right_x, arm1_start_right_y, arm_length, arm_right0_angle+arm_right1_angle, 1.0);
		
		var ct :ColorTransform = new ColorTransform(skin_color_argb.red / 255.0, skin_color_argb.green / 255.0, skin_color_argb.blue / 255.0);
		
		left_hand_m.identity();
		left_hand_m.translate(-10, -left_hand_sprite.height / 2.0);
		left_hand_m.rotate((arm_left0_angle+arm_left1_angle) * Math.PI / 180);
		left_hand_m.translate(arm1_end_left_x, arm1_end_left_y);
		
		right_hand_m.identity();
		right_hand_m.translate(-10, -right_hand_sprite.height / 2.0);
		right_hand_m.rotate((arm_right0_angle+arm_right1_angle) * Math.PI / 180);
		right_hand_m.translate(arm1_end_right_x, arm1_end_right_y);
		
		bd.draw(left_hand_sprite, left_hand_m, ct);
		bd.draw(right_hand_sprite, right_hand_m, ct);
	}
}