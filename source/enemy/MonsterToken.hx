package enemy;

import flixel.FlxSprite;
import orb.EnergyOrbDefinition;

/**
 * ...
 * @author 
 */
class MonsterToken extends FlxSprite
{
	public static var token_size = 24;
	
	public var orbdef:EnergyOrbDefinition;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
	}
	
	public function create(def:EnergyOrbDefinition):Void
	{
		makeGraphic(token_size, token_size);
		color = def.color;
		
		orbdef = def;
	}
}