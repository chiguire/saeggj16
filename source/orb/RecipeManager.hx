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
			{ type:EnergyOrbTypeEnum.Undefined, color:FlxColor.GRAY, command:"",
#if flash
				sound_normal: AssetPaths.Orb01__mp3, sound_action: AssetPaths.Orb01Action__mp3, sound_reset:AssetPaths.Orb01Reset__mp3, sound_select:AssetPaths.Orb01Select__mp3,
#else
				sound_normal: AssetPaths.Orb01__ogg, sound_action: AssetPaths.Orb01Action__ogg, sound_reset:AssetPaths.Orb01Reset__ogg, sound_select:AssetPaths.Orb01Select__ogg,
#end
			} );
		energy_orb_definition_map.set(EnergyOrbTypeEnum.Red,
			{ type:EnergyOrbTypeEnum.Red, color:FlxColor.RED, command:"LL",
#if flash
				sound_normal: AssetPaths.Orb02__mp3, sound_action: AssetPaths.Orb02Action__mp3, sound_reset:AssetPaths.Orb02Reset__mp3, sound_select:AssetPaths.Orb02Select__mp3,
#else
				sound_normal: AssetPaths.Orb02__ogg, sound_action: AssetPaths.Orb02Action__ogg, sound_reset:AssetPaths.Orb02Reset__ogg, sound_select:AssetPaths.Orb02Select__ogg,
#end
			} );
		energy_orb_definition_map.set(EnergyOrbTypeEnum.Green,
			{ type:EnergyOrbTypeEnum.Green, color:FlxColor.GREEN, command:"LR",
#if flash
				sound_normal: AssetPaths.Orb03__mp3, sound_action: AssetPaths.Orb03Action__mp3, sound_reset:AssetPaths.Orb03Reset__mp3, sound_select:AssetPaths.Orb03Select__mp3,
#else
				sound_normal: AssetPaths.Orb03__ogg, sound_action: AssetPaths.Orb03Action__ogg, sound_reset:AssetPaths.Orb03Reset__ogg, sound_select:AssetPaths.Orb03Select__ogg,
#end
			} );
		energy_orb_definition_map.set(EnergyOrbTypeEnum.Blue,
			{ type:EnergyOrbTypeEnum.Blue, color:FlxColor.BLUE, command:"RR",
#if flash
				sound_normal: AssetPaths.Orb04__mp3, sound_action: AssetPaths.Orb04Action__mp3, sound_reset:AssetPaths.Orb04Reset__mp3, sound_select:AssetPaths.Orb04Select__mp3,
#else
				sound_normal: AssetPaths.Orb04__ogg, sound_action: AssetPaths.Orb04Action__ogg, sound_reset:AssetPaths.Orb04Reset__ogg, sound_select:AssetPaths.Orb04Select__ogg,
#end
			} );
	}
	
	public static function transform(s:String, o:EnergyOrb):Bool
	{
		var result:EnergyOrbDefinition = Lambda.find(energy_orb_definition_map, 
		function(obj:EnergyOrbDefinition) { return obj.command == s; } );
		if (result != null)
		{
			//trace(result.command);
			o.update_properties(result.type);
			return true;
		}
		
		return false;
	}
	
	public static function get_definition(e:EnergyOrbTypeEnum):EnergyOrbDefinition
	{
		return energy_orb_definition_map.get(e);
	}
	
	public static function can_transform_further(s:String):Bool
	{
		return (s.length < 2);
	}
}