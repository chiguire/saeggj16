package;

import data.InputData;
import flixel.util.FlxSave;
import level.LevelDefinition;
import level.LevelManager;
import orb.RecipeManager;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	public static var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	public static var level:Int = 0;
	public static var level_definition:LevelDefinition;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
	
	public static var inputdata:InputData = null;
	
	public static var reg_inited : Bool = false;
	
	public static function init()
	{
		if (reg_inited)
		{
			return;
		}
		
		reg_inited = true;
		
		inputdata = new InputData();
		
		inputdata.insert_value(FACE_WIDTH, 25, 35, 80);
		inputdata.insert_value(FACE_HEIGHT, 55, 50, 100);
		inputdata.insert_value(NECK_LENGTH, 0.7, 0.5, 1.0);
		inputdata.insert_value(EYE_WIDTH, 0.22, 0.2, 0.249);
		inputdata.insert_value(EYE_HEIGHT, 0.5, 0.1, 0.5);
		inputdata.insert_value(EYE_CLOSENESS, 0, 0, 1);
		inputdata.insert_value(PUPIL_DIRECTION_X, 0, -0.8, 0.8);
		inputdata.insert_value(PUPIL_DIRECTION_Y, 0, -1, 0.8);
		inputdata.insert_value(MOUTH_HAPPINESS, 0, -1, 1);
		inputdata.insert_value(SKIN_HUE, 0, 0, 360);
		inputdata.insert_value(SKIN_SATURATION, 0.5, 0.5, 1.0);
		inputdata.insert_value(SKIN_VALUE, 0.5, 0.2, 0.8);
		//inputdata.insert_value(ARMS_WOBBLINESS, 0, 0, 0);
		inputdata.insert_value(TORSO_HEIGHT, 100, 80, 120);
		inputdata.insert_value(CHEST_WIDTH, 100, 80, 140);
		inputdata.insert_value(WAIST_WIDTH, 80, 60, 120);
		inputdata.insert_value(HIP_WIDTH, 100, 80, 140);
		inputdata.insert_value(LEGS_LENGTH, 150, 140, 200);
		inputdata.insert_value(LEGS_SPREADNESS, 0.5, 0, 1.0);
		inputdata.insert_value(ARM_LEFT0_ANGLE, 0, -360, 360);
		inputdata.insert_value(ARM_LEFT1_ANGLE, 0, -360, 360);
		inputdata.insert_value(ARM_RIGHT0_ANGLE, 0, -360, 360);
		inputdata.insert_value(ARM_RIGHT1_ANGLE, 0, -360, 360);
		inputdata.fill_random();
		
		RecipeManager.load_recipe();
		LevelManager.load_definition();
	};
}