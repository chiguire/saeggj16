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
	
	public static var level_titles : Array<String> =
		["You haven't seen your cousin for a month."
		,"When you entered the room you forgot why you came and that's why you'll die here."
		,"Look at what happened when you opened the door."
		,"It might be Wednesday so you'll probably be doing this again."
		,"Whilst inventing the dog bicycle Mr. Robinson came down with food poisoning."
		,"Come feed sharks with me."
		,"Ronald jumped at the chance to meet his neighbours."
		,"On Saturday, Henry argued with a fish for 20 minutes because he thought it was still alive."
		,"This kind of thing happens often."
		,"Robert didn't like being spotted in a crowd."
		,"Little did John know, he was being followed and graded on his ability to confuse grapes with olives."
		,"After shoving the little boy into the river, Billy ran away."
		,"Kitty loved to play the ice-chimes."
		,"Claire was relieved to discover that you're never too old to pass on a sexually transmitted disease."
		,"Kez made his way around town. Walking fast."
		,"Rikki found an orb..."
		,"Don't judge me."
		,"Feed me durian fruit and call me Quantumby."
		,"It's in the bottle."
		,"You've got it."];
	
	public static var music : String;
	
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
		
		inputdata.insert_value(MONSTER_SKIN_HUE, 0, 0, 360);
		inputdata.insert_value(MONSTER_SKIN_SATURATION, 0.5, 0.5, 1.0);
		inputdata.insert_value(MONSTER_SKIN_VALUE, 0.5, 0.2, 0.8);
		inputdata.insert_value(MONSTER_FACE_WIDTH, 25, 25, 70);
		inputdata.insert_value(MONSTER_FACE_HEIGHT, 55, 35, 80);
		inputdata.insert_value(MONSTER_NECK_LENGTH, 0.7, 0.5, 1.0);
		inputdata.insert_value(MONSTER_TORSO_HEIGHT, 50, 40, 80);
		inputdata.insert_value(MONSTER_CHEST_WIDTH, 40, 40, 80);
		inputdata.insert_value(MONSTER_WAIST_WIDTH, 80, 60, 100);
		inputdata.insert_value(MONSTER_HIP_WIDTH, 100, 80, 140);
		inputdata.insert_value(MONSTER_LEGS_LENGTH, 80, 80, 120);
		inputdata.fill_random();
		
		RecipeManager.load_recipe();
		LevelManager.load_definition();
	};
}