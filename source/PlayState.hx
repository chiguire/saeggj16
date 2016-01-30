package;

import enemy.Monster;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import orb.EnergyOrb;
import orb.EnergyOrbTypeEnum;
import orb.EnergySpawner;
import orb.RecipeManager;
import player.EnergyCollector;
import player.EnerygyCollectorState.EnergyCollectorState;
import player.PlayerHand;
import player.PlayerHandMouse;

using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var playerLHand:PlayerHand;
	var playerRHand:PlayerHand;
	
	var playerEnergyCollector:EnergyCollector;
	var enemyBoss:Monster;
	
	public var playerHands:FlxSpriteGroup;
	public var eneryOrbs:EnergySpawner;
	public var playerEnergyCollectors:FlxSpriteGroup;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		RecipeManager.load_recipe();
		
		playerEnergyCollectors = new FlxSpriteGroup();
		add(playerEnergyCollectors);
		eneryOrbs = new EnergySpawner();
		eneryOrbs.create(this);
		add(eneryOrbs);
		playerHands = new FlxSpriteGroup();
		add(playerHands);
		
		playerLHand = new PlayerHand(this, 100, 100);
		playerLHand.create();
		playerLHand.color = FlxColor.GOLDEN;
		playerLHand.type = "L";
		playerLHand.controlMapping("W", "A", "S", "D", "F");
		playerRHand = new PlayerHand(this, 300, 100);
		playerRHand.create();
		playerRHand.controlMapping("I", "J", "K", "L", "H");
		playerRHand.type = "R";
		
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
		
		FlxG.overlap(playerEnergyCollectors, eneryOrbs, on_energy_orb_collection_completed);
	}
	
	function on_energy_orb_collection_completed(p:EnergyCollector, e:EnergyOrb):Void
	{
		if (p.state == EnergyCollectorState.ACTIVATED)
		{
			//trace("collection completed");
			e.kill();
			enemyBoss.remove_token(e.orbtype);
		}
	}
}