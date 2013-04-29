package cake.entity.enemies 
{
	import cake.entity.Enemy;
	import cake.entity.Projectile;
	import cake.Game;
	import flash.geom.Point;
	import net.flashpunk.FP;
	
	public class Ghost extends Enemy 
	{
		override public function reset(x:int, y:int):void 
		{
			health = 8;
			speed = 25;
			image = new Point(8, 7);
			range = 128;
			attackRange = 16;
			collidables = ["player"];
			super.reset(x, y);
		}
		override public function attack():void 
		{
			Projectile.fire(x, y, new Point(12, 6), Game.player, 5, 50, ["player"]);
		}
	}
}