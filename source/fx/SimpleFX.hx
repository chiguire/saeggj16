package fx;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class SimpleFX extends FlxEmitter
{	
	public var explosionspeedxmin = -40;
	public var explosionspeedxmax = 40;
	public var explosionspeedymin = -40;
	public var explosionspeedymax = 40;
	public var emitter_lifetime = 2.0;
	public var particle_lifetime =0.75;
	
	var whitePixel:FlxParticle;
	
	public function new(X:Float=0, Y:Float=0, Size:Int=50) 
	{
		super(X, Y, 50);
		
		setXSpeed(explosionspeedxmin,explosionspeedxmax);
		setYSpeed(explosionspeedymin,explosionspeedymax);
		
		bounce = 0.8;
	}
	
	public function initfx():Void
	{
		// Now it's almost ready to use, but first we need to give it some pixels to spit out!
		// Lets fill the emitter with some white pixels
		for (i in 0...(Std.int(maxSize / 2))) 
		{
			whitePixel = new FlxParticle();
			whitePixel.makeGraphic(2, 2, FlxColor.WHITE);
			// Make sure the particle doesn't show up at (0, 0)
			whitePixel.visible = false; 
			add(whitePixel);
			whitePixel = new FlxParticle();
			whitePixel.makeGraphic(1, 1, FlxColor.WHITE);
			whitePixel.visible = false;
			add(whitePixel);
		}
	}
	
	public function startfx():Void
	{
		start(true, particle_lifetime, 0.01);
	}	
}