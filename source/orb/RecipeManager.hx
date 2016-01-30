package orb;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class RecipeManager
{
	public function new() 
	{
		
	}
	
	public static function transform(s:String, o:EnergyOrb):Bool
	{
		switch(s)
		{
			case "LL":  
				o.update_properties(EnergyOrbTypeEnum.Red); return true; 
			case "RR":
				o.update_properties(EnergyOrbTypeEnum.Blue); return true;
		}
		
		return false;
	}
}