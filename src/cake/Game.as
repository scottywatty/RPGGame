package cake 
{
	import cake.entity.Player;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	/**
	 * The game is organized into 'world'. For instance you might have a world for the menu and the game
	 */
	public class Game extends World
	{
		//Called when the game switches to this state
		override public function begin():void 
		{
			//Get the xml data from the level file
			var map:XML = FP.getXML(R.D_1);
			
			//Buid the map
			add(build(map));
			
			//The XML data for the player
			var playerXML:XML = map.objects.Player[0];
			//Add the player at his/her/it/whatever's position from the level data
			add(new Player(playerXML.@x, playerXML.@y, Player.KNIGHT));
		}
		/**
		 * Create a map from level XML data
		 * @param	map		The XML data
		 * @return	a new map entity
		 */
		public function build(map:XML):Entity
		{
			//The tile map graphic
			var tiles:Tilemap = new Tilemap(R.TILES, map.@width, map.@height, 8, 8);
			//Go through each tile object
			for each(var t:XML in map.tiles.tile) 
				tiles.setTile(t.@x, t.@y, t.@id);	//Add to the tilemap
			
			//The grid collider
			var grid:Grid = new Grid(map.@width, map.@height, 8, 8);
			//Ogmo exports rectangles wierd, this makes it less-so
			grid.usePositions = true;
			//Same thing, but for the grid
			for each(var r:XML in map.collides.rect) 
				grid.setRect(r.@x, r.@y, r.@w, r.@h);
			
			//Create the map entity
			var e:Entity = new Entity(0, 0, tiles, grid);
			//Allow the player to collide with it
			e.type = "solid";
			//return it
			return e;
		}
	}
}