package cake.entity 
{
	import flash.display.*;
	import flash.geom.*;
	import org.axgl.*;
	import org.axgl.input.AxKey;
	
	public class Player extends AxSprite
	{
		static public const KNIGHT:uint = 0;
		static public const THEIF:uint = 1;
		static public const MAGE:uint = 2;
		static public const ARCHER:uint = 3;
		
		/**
		 * Create a new player object
		 * @param	x		The x location of the player
		 * @param	y		The y location of the player
		 * @param	type
		 */
		public function Player(x:int, y:int, type:uint) 
		{
			var buf:BitmapData = new BitmapData(32, 8, true, 0x00000000);
			buf.copyPixels(R.getBitmap(R.CHARS), new Rectangle(xVals[type], 232, 32, 8), new Point());
			
			this.type = type;
			
			super(x, y);
			load(buf, 8, 8);
			addAnimation("right", [0], 0);
			addAnimation("down", [1], 0);
			addAnimation("left", [2], 0);
			addAnimation("up", [3], 0);
			
			maxVelocity = new AxVector(100, 100);
			drag = new AxVector(maxVelocity.x * 8, maxVelocity.y * 8);
			
			buf.dispose();
			buf = null;
		}
		override public function update():void 
		{
			acceleration.x = acceleration.y = 0;
			
			if (Ax.keys.down(AxKey.LEFT)) 		acceleration.x = -drag.x;
			else if (Ax.keys.down(AxKey.RIGHT)) acceleration.x = drag.x;
			else if (Ax.keys.down(AxKey.UP)) 	acceleration.y = -drag.y;
			else if (Ax.keys.down(AxKey.DOWN)) 	acceleration.y = drag.y;
			
			super.update();
			
			if (velocity.x != 0) direction = (velocity.x > 0) ? "right" : "left";
			else if (velocity.y != 0) direction = (velocity.y < 0) ? "up" : "down";
			
			animate(direction);
		}
		private var type:uint;
		private var direction:String = "right";
		static private const xVals:Array = [32, 96, 64, 0];
	}
}