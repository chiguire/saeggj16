package;

import enemy.Monster;
import flixel.addons.display.FlxStarField.FlxStarField3D;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import lime.ui.Mouse;
import orb.EnergyOrb;
import orb.EnergyOrbTypeEnum;
import orb.EnergySpawner;
import orb.RecipeManager;
import player.EnergyCollector;
import player.EnerygyCollectorState.EnergyCollectorState;
import player.PlayerBody;
import player.PlayerHand;
import player.PlayerHandControl;
import player.PlayerHandMouse;

using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var player_body : PlayerBody;
	
	var playerLHand:PlayerHand;
	var playerRHand:PlayerHand;
	
	var playerEnergyCollector:EnergyCollector;
	var enemyBoss:Monster;
	
	public var playerHands:FlxSpriteGroup;
	public var eneryOrbs:EnergySpawner;
	public var playerEnergyCollectors:FlxSpriteGroup;
	
	public var mouth_happiness : Float;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		RecipeManager.load_recipe();
		
		Mouse.lock = true;
		FlxG.mouse.visible = false;
		FlxG.autoPause = false;
		
		var background = new FlxStarField3D(0,0,0,0,100);
		add(background);
		
		player_body = new PlayerBody();
		add(player_body);
		
		playerEnergyCollectors = new FlxSpriteGroup();
		add(playerEnergyCollectors);
		eneryOrbs = new EnergySpawner();
		eneryOrbs.create(this);
		add(eneryOrbs);
		playerHands = new FlxSpriteGroup();
		add(playerHands);
		
		playerLHand = new PlayerHand(this, FlxG.width/2 - 150, 180);
		playerLHand.create();
		playerLHand.color = FlxColor.GOLDEN;
		playerLHand.type = "L";
		playerLHand.controlMapping("W", "A", "S", "D", "F");
		playerRHand = new PlayerHand(this, FlxG.width/2 + 150, 180);
		playerRHand.create();
		playerRHand.controlMapping("I", "J", "K", "L", "H");
		playerRHand.type = "R";
		
		player_body.left_hand = playerLHand;
		player_body.right_hand = playerRHand;
		
		playerHands.add(playerLHand);
		playerHands.add(playerRHand);
		
		playerEnergyCollector = new EnergyCollector();
		playerEnergyCollector.create();
		playerEnergyCollector.screenCenter(); playerEnergyCollector.y += 64; 
		playerEnergyCollector.playerLHand = playerLHand;
		playerEnergyCollector.playerRHand = playerRHand;
		playerEnergyCollectors.add(playerEnergyCollector);
		
		enemyBoss = new Monster();
		enemyBoss.create();
		enemyBoss.screenCenter(); enemyBoss.y += 128; 
		add(enemyBoss);
		
		mouth_happiness = 0;
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
		
		if (FlxG.keys.justPressed.T)
		{
			var arry = Type.allEnums(EnergyOrbTypeEnum);
			var def = FlxRandom.getObject(arry, 1, arry.length);
			{
				enemyBoss.add_token(def);
			}
		}
		
		Reg.inputdata.value(MOUTH_HAPPINESS).value = mouth_happiness;
		
		FlxG.overlap(playerEnergyCollectors, eneryOrbs, on_energy_orb_collection_completed);
		
		mouth_happiness *= 0.99;
	}
	
	function on_energy_orb_collection_completed(p:EnergyCollector, e:EnergyOrb):Void
	{
		mouth_happiness += 0.2;
		if (p.state == EnergyCollectorState.ACTIVATED)
		{
			//trace("collection completed");
			e.kill();
			enemyBoss.remove_token(e.orbtype);
			mouth_happiness = 1.0;
		}
	}
}