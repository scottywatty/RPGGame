package cake.entity 
{
	import cake.tween.Physics;
	import flash.display.*;
	import flash.geom.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.Spritemap;
	
	public class Player extends Entity
	{
		static public const KNIGHT:uint = 0;
		static public const THIEF:uint = 1;
		static public const MAGE:uint = 2;
		static public const ARCHER:uint = 3;
		
		public var health:int = 100;
		
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
			type = "player";
			//Set the hitbox as {0,2,8,6}
			setHitbox(8, 6, 0, -2);
			
			//Physics tween
			phys = new Physics();
			//Set the max velocity
			phys.maxVelocity = new Point(50, 50);
			//The player should stop imediately after moving
			phys.drag = new Point(phys.maxVelocity.x * 8, phys.maxVelocity.y * 8);
		}
		public function hit(damage:int):void
		{
			health -= damage;
			if (health <= 0) die();
		}
		public function die():void
		{
			world.remove(this);
		}
		override public function update():void 
		{
			//Reset acceleration
			phys.acceleration.x = phys.acceleration.y = 0;
			
			//Set the acceleration and animation based on keypress
			if (Input.check(Key.UP))
			{
				phys.acceleration.y = -phys.drag.y;
				direction = "up";
			}
			else if (Input.check(Key.DOWN))
			{
				phys.acceleration.y = phys.drag.y;
				direction = "down";
			}
			else if (Input.check(Key.LEFT)) 
			{
				phys.acceleration.x = -phys.drag.x;
				direction = "left";
			}
			else if (Input.check(Key.RIGHT))
			{
				phys.acceleration.x = phys.drag.x;
				direction = "right";
			}
			
			//Attack
			if (Input.pressed(Key.Z))
			{
				if (aspect == KNIGHT)
				{
					enemy = collide("enemy", x + xRange, y + yRange) as Enemy;
					if (enemy) enemy.hit(5);
				}
			}else if (Input.pressed(Key.X)) //Defend
			{
				
			}
			
			//Play the animation that coresponds to the direction
			anim.play(direction);
			//update the physics calculations
			phys.update();
			//Move where physics tells us to, checking for collisions with solid objects each time we move
			moveBy(phys.x, phys.y, ["solid", "enemy"]);
			layer = -y;
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
		private function get xRange():int
		{
			if (direction == "left") return -4;
			else if (direction == "right") return 4;
			return 0;
		}
		private function get yRange():int
		{
			if (direction == "up") return -4;
			else if (direction == "down") return 4;
			return 0;
		}
		private var enemy:Enemy;
		
		private var aspect:uint;
		private var phys:Physics;
		private var anim:Spritemap;
		private var direction:String = "right";
		static private const xVals:Array = [32, 96, 64, 0];
	}
}