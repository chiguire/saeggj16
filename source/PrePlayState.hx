package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import level.LevelManager;

/**
 * ...
 * @author 
 */
class PrePlayState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		var level_definition = Reg.level_definition = LevelManager.get_definition(Reg.level);
		
		var level_completed_timer = new FlxTimer(3.0, on_level_completed_timeup);
		
		{
			var titleText = new FlxText(0, FlxG.height/2 - 120, FlxG.width, "Level " + (Reg.level+1));
			titleText.setFormat(null, 48, FlxColor.BLACK, "center");
			titleText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.WHITE, 2);
			add(titleText);
		}
		var levelTitleText;
		{
			var titleText = new FlxText(0, FlxG.height/2 - 60, FlxG.width-30, level_definition.TitleText);
			titleText.setFormat(null, 32, FlxColor.BLACK, "center");
			titleText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.WHITE, 2);
			add(titleText);
			levelTitleText = titleText;
		}
		
		{
			var titleText = new FlxText(0, FlxG.height - 100, FlxG.width, level_definition.SubTitleText);
			titleText.setFormat(null, 16, FlxColor.BLACK, "center");
			titleText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.WHITE, 2);
			add(titleText);
		}

		Reg.inputdata.fill_random();
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
	}
	
	function on_level_completed_timeup(t:FlxTimer):Void
	{
		FlxG.switchState(new PlayState());
	}
}