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
	
	static public function load_definition():Void
	{
		levels.push( { TitleText:"Left,Left is the RED Dance", 
		SubTitleText:"", 
		Tokens:[EnergyOrbTypeEnum.Red],
		PreSpawnFactor:0 } );
		
		levels.push( { TitleText:"Right,Right we called BLUE Dance", 
		SubTitleText:"", 
		Tokens:[EnergyOrbTypeEnum.Blue],
		PreSpawnFactor:0 } );
		
		levels.push( { TitleText:"Left,Right is the GREEN", 
		SubTitleText:"", 
		Tokens:[EnergyOrbTypeEnum.Green],
		PreSpawnFactor:0 } );
		
		levels.push( { TitleText:"Let's see if you remember?", 
		SubTitleText:"", 
		Tokens:[EnergyOrbTypeEnum.Green, EnergyOrbTypeEnum.Blue, EnergyOrbTypeEnum.Red],
		PreSpawnFactor:0 } );
	}
	
	static public function get_definition(i:Int):LevelDefinition
	{
		if (i >= 0 && i < levels.length) return levels[i];
		else
		{
			var numTokens = FlxRandom.intRanged(4, 8);
			var f = FlxRandom.floatRanged(0.3, 0.6);
			var tokens = generate_random_tokens(numTokens);
			return { TitleText:"Randomly Generated", 
			SubTitleText:"", 
			Tokens:tokens,
			PreSpawnFactor:f };
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