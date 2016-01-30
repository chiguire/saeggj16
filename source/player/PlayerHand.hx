package player;

import flixel.effects.FlxFlicker;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class PlayerHand extends FlxSprite
{
	public var speed = 256.0;
	public var touch_idle_duration = 0.1;
	
	// key mapping
	public var key_up = "";
	public var key_left = "";
	public var key_down = "";
	public var key_right= "";
	public var key_touch= "";
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
	}
	
	public function create():Void
	{
		makeGraphic(32, 32);
	}
	
	public function controlMapping(up:String, left:String, down:String, right:String, touch:String)
	{
		key_up = up;
		key_down = down;
		key_left = left;
		key_right = right;
		key_touch = touch;
	}
	
	override public function update():Void
	{
		super.update();
		
		velocity.x = velocity.y = 0;
		if ( FlxG.keys.anyPressed([key_up])) { velocity.y -= speed; }
		if ( FlxG.keys.anyPressed([key_left])) { velocity.x -= speed; } 
		if ( FlxG.keys.anyPressed([key_down])) { velocity.y += speed; } 
		if ( FlxG.keys.anyPressed([key_right])) { velocity.x += speed; }
		
		if (FlxG.keys.anyJustPressed([key_touch])) { FlxFlicker.flicker(this, touch_idle_duration); }
	}
}