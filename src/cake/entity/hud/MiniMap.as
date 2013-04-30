package cake.entity.hud 
{
	import cake.*;
	import cake.entity.*;
	import flash.display.Bitmap;
	import flash.geom.*;
	import net.flashpunk.*;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.utils.*;
	
	public class MiniMap extends Entity 
	{
		public function MiniMap(map:Entity)
		{
			ratio = new Point(FP.width / map.width, FP.height / map.height);
			super();
			visible = false;
			layer = 0;
			
			tiles = new Bitmap((map.mask as Grid).data.clone());
			transform = new ColorTransform(1, 1, 1, 0.2);
			matrix = new Matrix();
			matrix.scale(map.width / FP.width * 2, map.height / FP.height * 2);
		}
		override public function update():void 
		{
			if (Input.pressed(Key.TAB)) visible = !visible;
		}
		override public function render():void 
		{
			if (!visible) return;
			
			Draw.setTarget(FP.buffer);
			
			//Draw.rect(FP.world.camera.x * ratio.x, FP.world.camera.y * ratio.y, FP.width * ratio.x, FP.height * ratio.y, 0xFFFFFF, 0.2);
			Draw.circlePlus(Game.player.x * ratio.x, Game.player.y * ratio.y, FP.halfWidth * ratio.x, 0xFFFFFF, 0.2); 
			Draw.rect(Game.player.x * ratio.x, Game.player.y * ratio.y, 8 * ratio.x, 8 * ratio.y, 0x0000FF, 0.5);
			
			//Draw the boss (if there is one)
			if (Game.boss) Draw.rect(Game.boss.x * ratio.x, Game.boss.y * ratio.y, 16 * ratio.x, 16 * ratio.y, 0xFF0000, 0.5);
			
			var e:Enemy;
			for (var i:int = 0; i < Game.enemies.length; i++)
			{
				e = Game.enemies[i];
				if(e.onCamera) Draw.rect(e.x * ratio.x, e.y * ratio.y, 8 * ratio.x, 8 * ratio.y, 0x660000, 0.5);
			}
			e = null;
			
			FP.buffer.draw(tiles, matrix, transform);
		}
		private var transform:ColorTransform;
		private var tiles:Bitmap;
		private var matrix:Matrix;
		private var ratio:Point;
	}
}