package level;
import flixel.util.FlxRandom;
import orb.EnergyOrbTypeEnum;

/**
 * ...
 * @author 
 */
class LevelManager
{
	static var levels:Array<LevelDefinition> = new Array();
	static var ending:LevelDefinition;
	
	static public function load_definition():Void
	{
		levels.push( { TitleText:"Left, Left is the RED Dance", 
		SubTitleText:"Complete the ritual before the time runs out!", 
		Tokens:[EnergyOrbTypeEnum.Red],
		PreSpawnFactor:0,
		LevelTimer:669.0 } );
		
		levels.push( { TitleText:"Right, Right is called the BLUE Dance", 
		SubTitleText:"Complete the ritual before the time runs out!", 
		Tokens:[EnergyOrbTypeEnum.Blue],
		PreSpawnFactor:0,
		LevelTimer:669.0 } );
		
		levels.push( { TitleText:"Left, Right is GREEN", 
		SubTitleText:"Complete the ritual before the time runs out!", 
		Tokens:[EnergyOrbTypeEnum.Green],
		PreSpawnFactor:0,
		LevelTimer:669.0 } );
		
		levels.push( { TitleText:"Let's see if you remember", 
		SubTitleText:"Complete the ritual before the time runs out!", 
		Tokens:[EnergyOrbTypeEnum.Green, EnergyOrbTypeEnum.Blue, EnergyOrbTypeEnum.Red],
		PreSpawnFactor:0,
		LevelTimer:669.0 } );
		
		ending = { TitleText:"Last Chapter", 
		SubTitleText:"End of the Ritual", 
		Tokens:[],
		PreSpawnFactor:0,
		LevelTimer:669.0 }
	}
	
	static public function get_definition(i:Int):LevelDefinition
	{
		if (i == 66) return ending;
		
		if (i >= 0 && i < levels.length) return levels[i];
		else
		{
			var numTokens = FlxRandom.intRanged(4, 16);
			var f = FlxRandom.floatRanged(0.3, 0.6);
			var tokens = generate_random_tokens(numTokens);
			return { TitleText:Reg.level_titles[(i-levels.length)%Reg.level_titles.length], 
			SubTitleText:"Complete the ritual before the time runs out!", 
			Tokens:tokens,
			PreSpawnFactor:f,
			LevelTimer:(numTokens * 10.0),
			};
		}
	}
	
	static public function generate_random_tokens(numItems:Int):Array<EnergyOrbTypeEnum>
	{
		var arry = Type.allEnums(EnergyOrbTypeEnum);
		var tokens = new Array<EnergyOrbTypeEnum>();
		for (i in 0...numItems)
		{
			var def = FlxRandom.getObject(arry, 1, arry.length);
			tokens.push(def);
		}
		
		return tokens;
	}
}