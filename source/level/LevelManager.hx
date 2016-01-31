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
		NumTokens:0 } );
		
		levels.push( { TitleText:"Right,Right we called BLUE Dance", 
		SubTitleText:"", 
		Tokens:[EnergyOrbTypeEnum.Blue],
		NumTokens:0 } );
		
		levels.push( { TitleText:"Left,Right is the GREEN", 
		SubTitleText:"", 
		Tokens:[EnergyOrbTypeEnum.Green],
		NumTokens:0 } );
		
		levels.push( { TitleText:"Let see if you remember?", 
		SubTitleText:"", 
		Tokens:[EnergyOrbTypeEnum.Green, EnergyOrbTypeEnum.Blue, EnergyOrbTypeEnum.Red],
		NumTokens:0 } );
	}
	
	static public function get_definition(i:Int):LevelDefinition
	{
		if (i >= 0 && i < levels.length) return levels[i];
		else
		{
			var numTokens = FlxRandom.intRanged(4, 8);
			return { TitleText:"Randomly Generated", 
			SubTitleText:"", 
			Tokens:[],
			NumTokens:numTokens };
		}
	}
	
	static public function generate_random_tokens(i:Int):Array<EnergyOrbTypeEnum>
	{
		return null;
	}
}