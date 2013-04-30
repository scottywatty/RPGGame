package cake 
{
	import cake.entity.*;
	import cake.entity.hud.*;
	import cake.entity.enemies.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	/**
	 * The game is organized into 'world'. For instance you might have a world for the menu and the game
	 */
	public class Game extends World
	{
		//Paused flag
		public var paused:Boolean = false;
		//Dialog box. Use 'dialog.say()' to have it popup. All enemies and the player are paused while it is open.
		public var dialog:Dialog;
		//The player object
		static public var player:Player;
		//The map entity
		public var map:Entity;
		//Holder for all the enemies in the level
		static public var enemies:Vector.<Enemy>;
		//MiniMap!!!!
		public var minimap:MiniMap;
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
			//Initialize the enemy holder
			enemies = new Vector.<Enemy>();
			
			minimap = new MiniMap(map);
			
			//Add the map
			add(map);
			//Add the player 
			add(player);
			//Create some enemies
			for each(var s:XML in xml.objects.Skeleton) createEnemy(s.@x, s.@y, Skeleton);
			for each(var go:XML in xml.objects.Goblin) 	createEnemy(go.@x, go.@y, Goblin);
			for each(var gh:XML in xml.objects.Ghost) 	createEnemy(gh.@x, gh.@y, Ghost);
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
			e.layer = -e.y;
			//return it
			return e;
		}
		/**
		 * Create a new enemy or recycle one already created
		 * @param	x
		 * @param	y
		 * @param	add
		 * @return
		 */
		public function createEnemy(x:int, y:int, type:Class, add:Boolean = true):Enemy
		{
			var e:Enemy = create(type, add) as Enemy;
			e.reset(x, y);
			enemies.push(e);
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
				for (var i:int = 0; i < enemies.length; i++)
					enemies[i].active = !dialog.active;
				//Update everything
				super.update();
				minimap.update();
				//Set the camera to center the player
				camera.x = (player.x - FP.halfWidth);
				camera.y = (player.y - FP.halfHeight);
			}
		}
		override public function render():void 
		{
			//Render everything
			super.render();
			
			minimap.render();
			
			//Set the drawing target to the drawing buffer
			Draw.setTarget(FP.buffer);
			Draw.rect(2, 2, 52, 7);
			Draw.rect(3, 3, player.health >> 1, 5, 0xFF0000);
			
			//Draw a nice pause screen if the game is paused
			if (paused)
			{
				//Draw a rectangle over the whole screen
				Draw.rect(0, 0, FP.width, FP.height, 0x000000, 0.75);
				//Draw the paused Text
				Draw.text("PAUSED", FP.halfWidth - 31, FP.halfHeight - 10, {size: 16});
			}
		}
	}
}