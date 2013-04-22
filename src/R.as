package  
{
	import flash.display.BitmapData;
	//Resources container
	public class R 
	{
		//This is how you 'embed' an image
		[Embed(source = "../res/img/lofi_char.png")] static public const CHARS:Class;
		[Embed(source = "../res/img/lofi_environment.png")] static public const TILES:Class;
		[Embed(source = "../res/map/Dungeon1.oel", mimeType = "application/octet-stream")] static public const D_1:Class;
	}
}