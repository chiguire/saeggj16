package orb;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class RecipeManager
{
	static public var energy_orb_definition_map = new Map<EnergyOrbTypeEnum, EnergyOrbDefinition>();
	
	public function new() 
	{
		
	}
	
	public static function load_recipe():Void
	{
		energy_orb_definition_map.set(EnergyOrbTypeEnum.Undefined,
			{ type:EnergyOrbTypeEnum.Undefined, color:FlxColor.GRAY, command:"" } );
		energy_orb_definition_map.set(EnergyOrbTypeEnum.Red,
			{ type:EnergyOrbTypeEnum.Red, color:FlxColor.RED, command:"LL" } );
		energy_orb_definition_map.set(EnergyOrbTypeEnum.Green,
			{ type:EnergyOrbTypeEnum.Green, color:FlxColor.GREEN, command:"LR" } );
		energy_orb_definition_map.set(EnergyOrbTypeEnum.Blue,
			{ type:EnergyOrbTypeEnum.Blue, color:FlxColor.BLUE, command:"RR" } );
	}
	
	public static function transform(s:String, o:EnergyOrb):Bool
	{
		var result:EnergyOrbDefinition = Lambda.find(energy_orb_definition_map, 
		function(obj:EnergyOrbDefinition) { return obj.command == s; } );
		if (result != null)
		{
			//trace(result.command);
			o.update_properties(result.type);
		}
		
		return false;
	}
	
	public static function get_definition(e:EnergyOrbTypeEnum):EnergyOrbDefinition
	{
		return energy_orb_definition_map.get(e);
	}
}