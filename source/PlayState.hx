package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import orb.EnergyOrb;
import player.EnergyCollector;
import player.PlayerHand;
import player.PlayerHandMouse;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var playerLHand:PlayerHand;
	var playerRHand:PlayerHand;
	
	var playerEnergyCollector:EnergyCollector;
	
	public var playerHands:FlxSpriteGroup;
	public var eneryOrbs:FlxSpriteGroup;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		eneryOrbs = new FlxSpriteGroup();
		add(eneryOrbs);
		playerHands = new FlxSpriteGroup();
		add(playerHands);
		
		var orb = new orb.EnergyOrb(200, 50);
		orb.create();
		eneryOrbs.add(orb);
		
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
		
		if (FlxG.mouse.justPressed)
		{
			var newOrb = new EnergyOrb(FlxG.mouse.x, FlxG.mouse.y);
			newOrb.create();
			eneryOrbs.add(newOrb);
		}
	}	
}