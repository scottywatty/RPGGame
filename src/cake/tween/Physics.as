package cake.tween 
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.tweens.motion.Motion;
	
	/**
	 * Simple physics a la Flixel
	 * Recommended to be supplemented with 'moveBy(deltaX, deltaY)';
	 * and by overiding 'moveCollideX' and 'moveCollideY' to set the respective velocity to 0.
	 * @author DelishusCake
	 */
	public class Physics extends Motion
	{
		/**
		 * The basic speed of this object.
		 */
		public var velocity:Point;
		/**
		 * If you are using <code>acceleration</code>, you can use <code>maxVelocity</code> with it
		 * to cap the speed automatically (very useful!).
		 */
		public var maxVelocity:Point;
		/**
		 * How fast the speed of this object is changing.
		 * Useful for smooth movement and gravity.
		 */
		public var acceleration:Point;
		/**
		 * This isn't drag exactly, more like deceleration that is only applied
		 * when acceleration is not affecting the sprite.
		 */
		public var drag:Point;
		/**
		 * Set the angle of a sprite to rotate it.
		 * WARNING: rotating sprites decreases rendering
		 * performance for this sprite by a factor of 10x!
		 */
		public var angle:Number;
		/**
		 * This is how fast you want this sprite to spin.
		 */
		public var angularVelocity:Number;
		/**
		 * How fast the spin speed should change.
		 */
		public var angularAcceleration:Number;
		/**
		 * Like <code>drag</code> but for spinning.
		 */
		public var angularDrag:Number;
		/**
		 * Use in conjunction with <code>angularAcceleration</code> for fluid spin speed control.
		 */
		public var maxAngular:Number;
		/**
		 * Create a new Physics tween.
		 */
		public function Physics()
		{
			super(1, null, LOOPING);
			
			velocity = new Point();
			acceleration = new Point();
			drag = new Point();
			maxVelocity = new Point(10000, 10000);
		}
		override public function update():void 
		{
			super.update();
			
			_delta = (computeVelocity(angularVelocity,angularAcceleration,angularDrag,maxAngular) - angularVelocity)/2;
			angularVelocity += _delta; 
			angle += angularVelocity*FP.elapsed;
			angularVelocity += _delta;
			
			_delta = (computeVelocity(velocity.x,acceleration.x,drag.x,maxVelocity.x) - velocity.x)/2;
			velocity.x += _delta;
			x = velocity.x*FP.elapsed;
			velocity.x += _delta;
			
			_delta = (computeVelocity(velocity.y,acceleration.y,drag.y,maxVelocity.y) - velocity.y)/2;
			velocity.y += _delta;
			y = velocity.y*FP.elapsed;
			velocity.y += _delta;
		}
		/**
		 * Calculate final velocity based on acceleration and drag, then cap it.
		 * @param	v	Velocity
		 * @param	a	Acceleration
		 * @param	d	Drag
		 * @param	m	Max Velocity
		 * @return	Final Velocity
		 */
		static public function computeVelocity(v:Number, a:Number = 0, d:Number = 0, m:Number = 10000):Number
		{
			if (a != 0) v += a * FP.elapsed;
			else if (d != 0)
			{
				d *= FP.elapsed;
				if (v - d > 0) v -= d;
				else if (v + d < 0) v += d;
				else v = 0;
			}
			if (v != 0 && m != 10000)
			{
				if (v > m) v = m;
				else if (v < -m) v = -m;
			}
			return v;
		}
		private var _delta:Number = 0;
	}
}