package cake.entity 
{
	import cake.Game;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Spritemap;
	
	public class Enemy extends Entity 
	{
		public var speed:uint = 10;
		public var health:int = 100;
		public var atttackTime:int = 1;
		public var display:Spritemap;
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
		}
		/**
		 * Override this to attack the player
		 */
		public function attack():void {}
		
		public function get distance():Number { return FP.distance(x, y, Game.player.x, Game.player.y); }
		override public function update():void 
		{
			if (distance < 64)
			{
				moveTowards(Game.player.x, Game.player.y, speed * FP.elapsed, ["solid", "player", "enemy"]);
				if (collide("player", x + (FP.sign(Game.player.x - x) * 4), y + (FP.sign(Game.player.y - y) * 4)) && canAttack)
				{
					attack();
					canAttack = false;
					FP.alarm(atttackTime, resetAttack);
				}
			}
			layer = -y;
		}
		private var canAttack:Boolean = true;
		private function resetAttack():void { canAttack = true; }
		private function resetColor():void { display.color = 0xFFFFFF; }
	}
}