package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxRect;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	public var title : FlxSprite;
	public var options : FlxSprite;
	public var cursor : FlxSprite;
	public var cursor_group : FlxSpriteGroup;
	
	public var rect1 : FlxRect;
	public var rect2 : FlxRect;
	
	public var cursor_x : Float;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		rect1 = FlxRect.get(0, 250, FlxG.width, 60);
		rect2 = FlxRect.get(0, 330, FlxG.width, 60);
		
		title = new FlxSprite(0, 0, AssetPaths.title__png);
		options = new FlxSprite(0, 0, AssetPaths.menu__png);
		cursor_group = new FlxSpriteGroup();
		cursor = new FlxSprite(0, 0, AssetPaths.cursor__png);
		
		add(title);
		add(options);
		add(cursor_group);
		cursor_group.add(cursor);
		
		cursor_x = FlxG.width / 2.0 + 100;
		cursor.y = rect1.y;
		FlxTween.tween(cursor.scale, { x: -1 }, 1, { type: FlxTween.PINGPONG, ease: FlxEase.quadInOut } );
		FlxTween.tween(this, { cursor_x: FlxG.width/2.0 - 100 }, 1, { type: FlxTween.PINGPONG, ease: FlxEase.quadInOut } );
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
		
		cursor.x = cursor_x;
		
		if (rect1.containsFlxPoint(FlxG.mouse.getScreenPosition()))
		{
			cursor.y = rect1.y;
			
			if (FlxG.mouse.justPressed)
			{
				FlxG.switchState(new PrePlayState());
			}
		}
		
		if (rect2.containsFlxPoint(FlxG.mouse.getScreenPosition()))
		{
			cursor.y = rect2.y;
			
			if (FlxG.mouse.justPressed)
			{
				FlxG.switchState(new CreditsState());
			}
		}
	}	
}