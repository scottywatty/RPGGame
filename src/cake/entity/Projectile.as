package cake.entity 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Stamp;
	
	public class Projectile extends Entity 
	{
		public var delta:Point;
		public var speed:uint;
		public var damage:uint;
		public var collidables:Array = ["solid"];
		public function Projectile() 
		{
			super(0, 0);
			type = "bullet";
			setHitbox(8, 8);
			delta = new Point();
		}
		static public function fire(x:int, y:int, img:Point, to:Entity, damage:uint = 5, speed:uint = 500, collidables:Array = null):void
		{
			var b:Projectile = FP.world.create(Projectile, true) as Projectile;
			b.x = x;
			b.y = y;
			b.graphic = getImage(img.x, img.y);
			b.speed = speed;
			b.damage = damage;
			
			var angle:Number = FP.angle(x, y, to.x, to.y) * Math.PI / 180;
			
			b.delta.x = Math.cos(angle) * speed;
			b.delta.y = Math.sin(-angle) * speed;
			b.collidables = collidables ? collidables : ["solid"];
		}
		override public function update():void 
		{
			if (x < 0 || y < 0 || x > (FP.width * 3) || y > (FP.height * 3))
			{
				FP.world.recycle(this);
				return;
			}
			moveBy(delta.x * FP.elapsed, delta.y * FP.elapsed, collidables);
			layer = -y;
		}
		public function collided(e:Entity):Boolean
		{
			if (e.type === "enemy") Enemy(e).hit(damage);
			else if (e.type === "player") Player(e).hit(damage);
			
			FP.world.recycle(this);
			return true;
		}
		override public function moveCollideX(e:Entity):Boolean {return collided(e);}
		override public function moveCollideY(e:Entity):Boolean { return collided(e); }
		static private function getImage(x:uint, y:uint):Stamp
		{
			var bmp:BitmapData = new BitmapData(8, 8, true, 0x00000000);
			bmp.copyPixels(FP.getBitmap(R.OBJ), new Rectangle(x * 8, y * 8, 8, 8), FP.zero);
			return new Stamp(bmp);
		}
	}
}