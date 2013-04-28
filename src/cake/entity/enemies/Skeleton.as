package cake.entity.enemies 
{
	import cake.entity.Enemy;
	import flash.geom.Point;
	
	public class Skeleton extends Enemy 
	{
		override public function reset(x:int, y:int):void 
		{
			health = 10;
			speed = 8;
			image = new Point(0, 6);
			super.reset(x, y);
		}
	}
}