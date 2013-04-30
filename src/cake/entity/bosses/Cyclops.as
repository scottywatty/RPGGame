package cake.entity.bosses 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Image;
	
	public class Cyclops extends Entity 
	{
		public function Cyclops(x:Number, y:Number) 
		{
			img = new Image(R.CHARS, new Rectangle(4 * 8, 16 * 8, 16, 16));
			super(x, y, img);
		}
		private var img:Image;
	}
}