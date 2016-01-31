package;

import enemy.Monster;
import flixel.addons.display.FlxStarField.FlxStarField3D;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import level.LevelDefinition;
import level.LevelManager;
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
	public var update_mouth : Bool;
	
	var level_title_text:FlxText;
	var ritual_completed_text:FlxText;
	
	var level_definition:LevelDefinition;
	var level_completed = false;
	var level_completed_timer:FlxTimer;
	
	var command_layer : FlxTypedSpriteGroup<FlxText>;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		level_definition = Reg.level_definition;
		
		//FlxG.mouse.visible = false;
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
		playerLHand.visible = false;
		playerLHand.type = "L";
		playerLHand.controlMapping("W", "A", "S", "D", "F");
		playerRHand = new PlayerHand(this, FlxG.width/2 + 150, 180);
		playerRHand.create();
		playerRHand.controlMapping("I", "J", "K", "L", "H");
		playerRHand.type = "R";
		playerRHand.visible = false;
		
		player_body.left_hand = playerLHand;
		player_body.right_hand = playerRHand;
		
		playerHands.add(playerLHand);
		playerHands.add(playerRHand);
		
		playerEnergyCollector = new EnergyCollector();
		playerEnergyCollector.create();
		playerEnergyCollector.screenCenter(); playerEnergyCollector.y += 32; 
		playerEnergyCollector.playerLHand = playerLHand;
		playerEnergyCollector.playerRHand = playerRHand;
		playerEnergyCollectors.add(playerEnergyCollector);
		
		enemyBoss = new Monster();
		enemyBoss.tokens = Lambda.list(level_definition.Tokens);
		enemyBoss.create();
		enemyBoss.screenCenter(); enemyBoss.y += 128;	
		add(enemyBoss);
		enemyBoss.killed.add(enemy_boss_killed_handler);
		enemyBoss.correct_orb_obtained.add(enemy_boss_correct_orb_obtained_handler);
		enemyBoss.incorrect_orb_obtained.add(enemy_boss_incorrect_orb_obtained_handler);
		
		mouth_happiness = 0;
		update_mouth = true;
		
		#if flash
		//FlxG.sound.playMusic(FlxRandom.getObject([AssetPaths.Amityville__mp3, AssetPaths.Apparition__mp3]));
		#else
		//FlxG.sound.playMusic(FlxRandom.getObject([AssetPaths.Amityville__ogg, AssetPaths.Apparition__ogg]));
		#end
		
		command_layer = new FlxTypedSpriteGroup<FlxText>();
		
		level_title_text = new FlxText(0, 0, FlxG.width, "Level " + Std.string(Reg.level) + ":" + level_definition.TitleText);
		add(level_title_text);
		
		level_completed_timer = new FlxTimer(3.0, on_level_completed_timeup);
		level_completed_timer.active = false;
		
		ritual_completed_text = new FlxText(0, FlxG.height/2, FlxG.width, "Ritual Completed");
		ritual_completed_text.setFormat(null, 48, FlxColor.BLACK, "center");
		ritual_completed_text.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.WHITE, 2);
		add(ritual_completed_text);
		ritual_completed_text.visible = false;
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
		
		// end level condition
		if (!level_completed && enemyBoss.tokens.isEmpty())
		{
			level_completed = true;
			ritual_completed_text.visible = true;
			update_mouth = false;
			level_completed_timer.reset();
		}
		
		//if (FlxG.keys.justPressed.T)
		//{
		//	var arry = Type.allEnums(EnergyOrbTypeEnum);
		//	var def = FlxRandom.getObject(arry, 1, arry.length);
		//	{
		//		enemyBoss.add_token(def);
		//	}
		//}
		
		Reg.inputdata.value(MOUTH_HAPPINESS).value = mouth_happiness;
		
		FlxG.overlap(playerEnergyCollectors, eneryOrbs, on_energy_orb_collection_completed);
		
		if (update_mouth)
		{
			mouth_happiness *= 0.99;
		}
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
	
	function enemy_boss_killed_handler()
	{
		mouth_happiness = 1.0;
	}
	
	function enemy_boss_correct_orb_obtained_handler()
	{
		mouth_happiness += 0.2;
	}
	
	function enemy_boss_incorrect_orb_obtained_handler()
	{
		mouth_happiness -= 0.2;
	}
	
	function on_level_completed_timeup(t:FlxTimer):Void
	{
		Reg.level += 1;
		FlxG.switchState(new PrePlayState());
	}
}