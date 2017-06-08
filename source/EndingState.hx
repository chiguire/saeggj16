package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import level.LevelManager;
import player.PlayerBody;
import player.PlayerHand;

/**
 * ...
 * @author 
 */
class EndingState extends FlxState
{
	var player_body:PlayerBody;
	
	var playerLHand:PlayerHand;
	var playerRHand:PlayerHand;
	public var playerHands:FlxSpriteGroup;
	
	var activate_fade = false;
	
	var fading_sprite:FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		player_body = new PlayerBody();
		player_body.monster_y = 500;
		player_body.monster_x = FlxG.width/2;
		add(player_body);
		
		playerHands = new FlxSpriteGroup();
		add(playerHands);
		
		playerLHand = new PlayerHand(null, FlxG.width/2 - 150, 180);
		playerLHand.create();
		playerLHand.color = 0xffffd700; // FlxColor.GOLDEN;
		playerLHand.visible = false;
		playerLHand.type = "L";
		playerLHand.controlMapping("W", "A", "S", "D", "F");
		playerRHand = new PlayerHand(null, FlxG.width/2 + 150, 180);
		playerRHand.create();
		playerRHand.controlMapping("I", "J", "K", "L", "H");
		playerRHand.type = "R";
		playerRHand.visible = false;
		
		player_body.left_hand = playerLHand;
		player_body.right_hand = playerRHand;
		
		playerHands.add(playerLHand);
		playerHands.add(playerRHand);
		
		Reg.inputdata.value(MOUTH_HAPPINESS).value = 1.0;
		
		fading_sprite = new FlxSprite();
		fading_sprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		fading_sprite.visible = false;
		add(fading_sprite);
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
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxTween.tween(player_body, { monster_y:250 }, 2, { type:FlxTween.PINGPONG, ease:FlxEase.bounceInOut, onComplete:onCompleted , startDelay:1, loopDelay:2 } );
		if (activate_fade)
		{
			FlxG.camera.shake();
			FlxG.camera.fade(FlxColor.BLACK, 1, false, onFadingCompleted);
		}
	}
	
	private function onCompleted(tween:FlxTween):Void
	{
		activate_fade = true;
	}
	
	private function onFadingCompleted():Void
	{
		fading_sprite.visible = true;
		var text = new FlxText(0, FlxG.height/2, FlxG.width, "Thanks for playing!");
		text.setFormat(null, 48, FlxColor.BLACK, "center");
		text.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, 2);
		add(text);
	}
}