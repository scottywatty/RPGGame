package cake.entity.bosses 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Image;
	
	public class Spider extends Entity 
	{
		public function Spider(x:Number, y:Number) 
		{
			img = new Image(R.CHARS, new Rectangle(40, 16 * 8, 16, 16));
			super(x, y, img);
		}
		private var img:Image;
	}
}