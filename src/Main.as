package 
{
	import cake.Game;
	import net.flashpunk.*;
	
	//Extend the engine
	public class Main extends Engine
	{
		public function Main():void { super(160, 120); }
		override public function init():void 
		{
			FP.screen.scale = 4;
			//FP.console.enable();
			FP.world = new Game;
		}
	}
}