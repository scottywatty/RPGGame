package cake 
{
	import cake.entity.Dialog;
	import cake.entity.Player;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * The game is organized into 'world'. For instance you might have a world for the menu and the game
	 */
	public class Game extends World
	{
		public var paused:Boolean = false;
		//Dialog box. Use 'dialog.say()' to have it popup. All enemies and the player are paused while it is open.
		public var dialog:Dialog;
		//The player object
		public var player:Player;
		//The map entity
		public var map:Entity;
		//Called when the game switches to this state
		override public function begin():void 
		{
			//Get the xml data from the level file
			var xml:XML = FP.getXML(R.D_1);
			//The XML data for the player
			var playerXML:XML = xml.objects.Player[0];
			//Build the map from the xml
			map = build(xml);
			//Create the dialog popup
			dialog = new Dialog();
			//Create the player at his/her/it/whatever's position from the level data
			player = new Player(playerXML.@x, playerXML.@y, Player.KNIGHT);
			
			//Add the map
			add(map);
			//Add the player 
			add(player);
			//Add the dialog popup
			add(dialog);
			
			//Say the basic instructions
			dialog.say("How To Play", ["Use the ARROW KEYS to MOVE", "ATTACK with Z, BLOCK with X"]);
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
		override public function update():void 
		{
			//Pause the game if the player hits the escape key
			if (Input.pressed(Key.ESCAPE)) paused = !paused;
			//Only update if the game isn't paused
			if (!paused)
			{
				//Make sure the player can't move if the dialog box is showing
				player.active = !dialog.active;
				//Update everything
				super.update();
				//Set the camera to center the player
				camera.x = (player.x - FP.halfWidth);
				camera.y = (player.y - FP.halfHeight);
			}
		}
		override public function render():void 
		{
			//Render everything
			super.render();
			//Draw a nice pause screen if the game is paused
			if (paused)
			{
				//Set the drawing target to the drawing buffer
				Draw.setTarget(FP.buffer);
				//Draw a rectangle over the whole screen
				Draw.rect(0, 0, FP.width, FP.height, 0x000000, 0.75);
				//Draw the paused Text
				Draw.text("PAUSED", FP.halfWidth - 31, FP.halfHeight - 10, {size: 16});
			}
		}
	}
}