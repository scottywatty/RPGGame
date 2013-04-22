package cake 
{
	import cake.entity.Player;
	import org.axgl.*;
	import org.axgl.render.AxColor;
	
	/**
	 * The game is organized into 'states'. For instance you might have a state for the menu and the game
	 */
	public class Game extends AxState
	{
		//Called when the game switches to this state
		override public function create():void 
		{
			//Set the background color to a greyish color
			Ax.background = AxColor.fromHex(0xFF303030);
			
			//Add a new player object
			add(new Player(0, 0, Player.KNIGHT));
		}
	}
}