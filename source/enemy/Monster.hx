package enemy;

import flash.display.Sprite;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import orb.EnergyOrbTypeEnum;
import orb.RecipeManager;

/**
 * ...
 * @author 
 */
class Monster extends FlxSpriteGroup
{	
	public var tokens:List<EnergyOrbTypeEnum>;
	
	public var killed : FlxSignal;
	public var correct_orb_obtained : FlxSignal;
	public var incorrect_orb_obtained : FlxSignal;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		killed = new FlxSignal();
		correct_orb_obtained = new FlxSignal();
		incorrect_orb_obtained = new FlxSignal();
		
		tokens = Lambda.list([EnergyOrbTypeEnum.Red]);
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
			
			correct_orb_obtained.dispatch();
			
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
			
			if (tokens.length == 0)
			{
				kill();
				killed.dispatch();
			}
		}
		else
		{
			incorrect_orb_obtained.dispatch();
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