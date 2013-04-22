package 
{
	import cake.Game;
	import org.axgl.Ax;
	
	//Extend the engine
	public class Main extends Ax
	{
		//Constructor
		public function Main():void
		{
			//Start the game in the 'Game' state, with a window size of 640x480, draw buffer scaled up by 4
			super(Game, 640, 480, 4);
		}
	}
}