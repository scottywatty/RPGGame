package cake.entity 
{
	import cake.Game;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Spritemap;
	
	public class Enemy extends Entity 
	{
		/**
		 * The speed the enemy moves at (pixels per second)
		 */
		public var speed:uint = 10;
		/**
		 * The health.
		 */
		public var health:int = 100;
		/**
		 * Time (in seconds) between attacks
		 */
		public var atttackTime:int = 1;
		/**
		 * How close the playe rmust be before the enemy "sees" the player
		 */
		public var range:uint = 64;
		/**
		 * How close the player must be (in pixels) before the enemy attacks
		 */
		public var attackRange:uint = 4;
		/**
		 * The types the enemy can collide with
		 */
		public var collidables:Array = ["solid", "player", "enemy"];
		
		public function Enemy() 
		{
			display = new Spritemap(R.CHARS, 8, 8);
			super(0, 0, display);
			setHitbox(8, 6, 0, -2);
			type = "enemy";
		}
		public function set image(i:Point):void { display.frame = (i.y * 16) + i.x; }
		/**
		 * Override this for setup/reset logic
		 * @param	x
		 * @param	y
		 */
		public function reset(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		/**
		 * Override this to take damage
		 * @param	damage
		 */
		public function hit(damage:int):void
		{
			health -= damage;
			display.color = 0xFF0000;
			FP.alarm(0.2, resetColor);
			if (health <= 0) die();
		}
		/**
		 * Override this to cahnge what happens when the enemy dies
		 */
		public function die():void
		{
			world.recycle(this);
			Game.enemies.splice(Game.enemies.indexOf(this), 1);
		}
		/**
		 * Override this to attack the player
		 */
		public function attack():void { }
		
		public function get distance():Number { return FP.distance(x, y, Game.player.x, Game.player.y); }
		override public function update():void 
		{
			if (distance < range)
			{
				moveTowards(Game.player.x, Game.player.y, speed * FP.elapsed, collidables);
				if ((distance * -1) <= attackRange && canAttack)
				{
					attack();
					canAttack = false;
					FP.alarm(atttackTime, resetAttack);
				}
				display.flipped = (FP.sign(Game.player.x - x) < 0);
			}
			layer = -y;
		}
		private var display:Spritemap;
		private var canAttack:Boolean = true;
		private function resetAttack():void { canAttack = true; }
		private function resetColor():void { display.color = 0xFFFFFF; }
	}
}