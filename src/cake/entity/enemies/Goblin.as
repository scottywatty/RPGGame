package cake.entity.enemies 
{
	import cake.entity.Enemy;
	import cake.Game;
	import flash.geom.Point;
	
	public class Goblin extends Enemy 
	{
		override public function reset(x:int, y:int):void 
		{
			health = 20;
			speed = 20;
			image = new Point(10, 8);
			super.reset(x, y);
		}
		override public function attack():void 
		{
			Game.player.hit(5);
		}
	}
}