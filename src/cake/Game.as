package cake 
{
	import cake.entity.Player;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	/**
	 * The game is organized into 'states'. For instance you might have a state for the menu and the game
	 */
	public class Game extends World
	{
		//Called when the game switches to this state
		override public function begin():void 
		{
			var map:XML = FP.getXML(R.D_1);
			
			add(build(map));
			add(new Player(map.objects.Player[0].@x, map.objects.Player[0].@y, Player.KNIGHT));
		}
		public function build(map:XML):Entity
		{
			var tiles:Tilemap = new Tilemap(R.TILES, map.@width, map.@height, 8, 8);
			for each(var t:XML in map.tiles.tile) 
				tiles.setTile(t.@x, t.@y, t.@id);
			
			var grid:Grid = new Grid(map.@width, map.@height, 8, 8);
			grid.usePositions = true;
			for each(var r:XML in map.collides.rect) 
				grid.setRect(r.@x, r.@y, r.@w, r.@h);
			
			var e:Entity = new Entity(0, 0, tiles, grid);
			e.type = "solid";
			return e;
		}
	}
}