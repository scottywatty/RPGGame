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
		static public const THIEF:uint = 1;
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
			//Grab the part of the image that holds the player's aspect
			var buf:BitmapData = new BitmapData(32, 8, true, 0x00000000);
			buf.copyPixels(FP.getBitmap(R.CHARS), new Rectangle(xVals[aspect], 232, 32, 8), new Point());
			
			//Animation graphic
			anim = new Spritemap(buf, 8, 8);
			//Set all the positions
			anim.add("right", [0], 0);
			anim.add("down", [1], 0);
			anim.add("left", [2], 0);
			anim.add("up", [3], 0);
			//Deafault to right
			anim.play("right");
			
			//Copy the aspect for later use
			this.aspect = aspect;
			//Create the entity
			super(x, y, anim);
			//Set the hitbox as {0,2,8,6}
			setHitbox(8, 6, 0, -2);
			
			//Physics tween
			phys = new Physics();
			//Set the max velocity
			phys.maxVelocity = new Point(50, 50);
			//The player should stop imediately after moving
			phys.drag = new Point(phys.maxVelocity.x * 8, phys.maxVelocity.y * 8);
		}
		override public function update():void 
		{
			//Reset acceleration
			phys.acceleration.x = phys.acceleration.y = 0;
			
			//Set the acceleration based on keypress
			if (Input.check(Key.LEFT)) 			phys.acceleration.x = -phys.drag.x;
			else if (Input.check(Key.RIGHT)) 	phys.acceleration.x = phys.drag.x;
			else if (Input.check(Key.UP)) 		phys.acceleration.y = -phys.drag.y;
			else if (Input.check(Key.DOWN)) 	phys.acceleration.y = phys.drag.y;
			
			//update the physics calculations
			phys.update();
			//Move where physics tells us to, checking for collisions with solid objects each time we move
			moveBy(phys.x, phys.y, "solid");
			
			//Get the direction based on velocity
			if (phys.velocity.x != 0) direction = (phys.velocity.x > 0) ? "right" : "left";
			else if (phys.velocity.y != 0) direction = (phys.velocity.y < 0) ? "up" : "down";
			
			//Play the animation that coresponds to the direction
			anim.play(direction);
			
			//Set the camera (center us on the screen)
			world.camera.x = (x - FP.halfWidth); //FP.lerp(world.camera.x, (x - FP.halfWidth), 3 * FP.elapsed);
			world.camera.y = (y - FP.halfHeight); // FP.lerp(world.camera.y, (y - FP.halfHeight), 3 * FP.elapsed);
		}
		/**
		 * Called when the player collides with something on the x axis
		 * @param	e		The entity collided with
		 * @return If we should prevent further movement
		 */
		override public function moveCollideX(e:Entity):Boolean 
		{
			//Reset velocity
			phys.velocity.x = 0;
			//Prevent further movement (false ignores collisions)
			return true;
		}
		/**
		 * Called when the player collides with something on the y axis
		 * @param	e		The entity collided with
		 * @return If we should prevent further movement
		 */
		override public function moveCollideY(e:Entity):Boolean 
		{
			//Reset velocity
			phys.velocity.y = 0;
			//Prevent further movement (false ignores collisions)
			return true;
		}
		//private var type:uint;
		private var aspect:uint;
		private var phys:Physics;
		private var anim:Spritemap;
		private var direction:String = "right";
		static private const xVals:Array = [32, 96, 64, 0];
	}
}