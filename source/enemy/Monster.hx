package enemy;

import flash.display.Sprite;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import orb.EnergyOrbTypeEnum;
import orb.RecipeManager;

/**
 * ...
 * @author 
 */
class Monster extends FlxSpriteGroup
{	
	var tokens:List<EnergyOrbTypeEnum>;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		tokens = Lambda.list([EnergyOrbTypeEnum.Blue, EnergyOrbTypeEnum.Red, EnergyOrbTypeEnum.Blue, EnergyOrbTypeEnum.Green, EnergyOrbTypeEnum.Blue, EnergyOrbTypeEnum.Red]);
	}
	
	public function create()
	{
		//sprite_group = new FlxSpriteGroup();
		var counter = 0;
		for (obj in tokens)
		{
			var def = RecipeManager.get_definition(obj);
			if (def != null)
			{
				var newSprite = new MonsterToken(MonsterToken.token_size * counter, 0);
				newSprite.create(def);
				add(newSprite);
				counter++;
			}
		}
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	public function remove_token(e:EnergyOrbTypeEnum)
	{
		if (tokens.remove(e))
		{
			var def = RecipeManager.get_definition(e);
			var itr = Lambda.find(this.members, function(sp:FlxSprite) { var s:MonsterToken = cast sp; return ((s.orbdef.color == def.color) && s.alive); } );
			if (itr != null)
			{
				//trace("remove sprite");
				itr.kill();
			}
			
			// rearrange the position
			var counter = 0;
			for (obj in this.members)
			{
				if (obj.alive)
				{
					obj.x = x + MonsterToken.token_size * counter;
					counter++;
				}
			}
		}
	}
	
	public function add_token(e:EnergyOrbTypeEnum)
	{
		var def = RecipeManager.get_definition(e);
		
		tokens.add(def.type);
		var newSprite = new MonsterToken();
		newSprite.create(def);
		add(newSprite);
		// rearrange the position
		var counter = 0;
		for (obj in this.members)
		{
			if (obj.alive)
			{
				obj.x = x + MonsterToken.token_size * counter;
				counter++;
			}
		}
	}
}