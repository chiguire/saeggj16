package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import player.PlayerHand;
import player.PlayerHandMouse;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var playerLHand:PlayerHand;
	var playerRHand:PlayerHand;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		playerLHand = new PlayerHand(100, 100);
		playerLHand.create();
		playerLHand.color = FlxColor.GOLDEN;
		playerLHand.controlMapping("W", "A", "S", "D", "F");
		playerRHand = new PlayerHand(300, 100);
		playerRHand.create();
		playerRHand.controlMapping("I", "J", "K", "L", "H");
		
		add(playerLHand);
		add(playerRHand);
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
	}	
}