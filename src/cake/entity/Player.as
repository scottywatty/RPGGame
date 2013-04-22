package cake.entity 
{
	import cake.tween.Physics;
	import flash.display.*;
	import flash.geom.*;
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.Spritemap;
	
	public class Player extends Entity
	{
		static public const KNIGHT:uint = 0;
		static public const THEIF:uint = 1;
		static public const MAGE:uint = 2;
		static public const ARCHER:uint = 3;
		
		/**
		 * Create a new player object
		 * @param	x		The x location of the player
		 * @param	y		The y location of the player
		 * @param	aspect	The type of player to use.
		 */
		public function Player(x:int, y:int, aspect:uint) 
		{
			var buf:BitmapData = new BitmapData(32, 8, true, 0x00000000);
			buf.copyPixels(FP.getBitmap(R.CHARS), new Rectangle(xVals[aspect], 232, 32, 8), new Point());
			
			anim = new Spritemap(buf, 8, 8);
			anim.add("right", [0], 0);
			anim.add("down", [1], 0);
			anim.add("left", [2], 0);
			anim.add("up", [3], 0);
			anim.play("right");
			
			this.aspect = aspect;
			super(x, y, anim);
			setHitbox(8, 6, 0, -2);
			
			phys = new Physics();
			phys.maxVelocity = new Point(50, 50);
			phys.drag = new Point(phys.maxVelocity.x * 8, phys.maxVelocity.y * 8);
		}
		override public function update():void 
		{
			phys.acceleration.x = phys.acceleration.y = 0;
			
			if (Input.check(Key.LEFT)) 			phys.acceleration.x = -phys.drag.x;
			else if (Input.check(Key.RIGHT)) 	phys.acceleration.x = phys.drag.x;
			else if (Input.check(Key.UP)) 		phys.acceleration.y = -phys.drag.y;
			else if (Input.check(Key.DOWN)) 	phys.acceleration.y = phys.drag.y;
			
			phys.update();
			moveBy(phys.x, phys.y, "solid");
			
			if (phys.velocity.x != 0) direction = (phys.velocity.x > 0) ? "right" : "left";
			else if (phys.velocity.y != 0) direction = (phys.velocity.y < 0) ? "up" : "down";
			
			anim.play(direction);
			
			world.camera.x = (x - FP.halfWidth); //FP.lerp(world.camera.x, (x - FP.halfWidth), 3 * FP.elapsed);
			world.camera.y = (y - FP.halfHeight); // FP.lerp(world.camera.y, (y - FP.halfHeight), 3 * FP.elapsed);
		}
		//private var type:uint;
		private var aspect:uint;
		private var phys:Physics;
		private var anim:Spritemap;
		private var direction:String = "right";
		static private const xVals:Array = [32, 96, 64, 0];
	}
}