package cake.entity.enemies 
{
	import cake.*;
	import cake.entity.*;
	import flash.geom.*;
	
	public class Ghost extends Enemy 
	{
		override public function reset(x:int, y:int):void 
		{
			health = 8;
			speed = 25;
			image = new Point(8, 7);
			range = 128;
			attackRange = 64;
			collidables = ["player"];
			super.reset(x, y);
		}
		override public function attack():void 
		{
			Projectile.fire(x, y, new Point(12, 6), Game.player, 5, 50, ["player"]);
		}
	}
}