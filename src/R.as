package  
{
	import flash.display.BitmapData;
	//Resources container
	public class R 
	{
		//This is how you 'embed' an image
		[Embed(source = "../res/lofi_char.png")] static public const CHARS:Class;
		
		//Simple caching function. Use this to get the image in a usable format
		static public function getBitmap(bitmap:Class):BitmapData
		{
			if (!cache[bitmap]) cache[bitmap] = (new bitmap()).bitmapData;
			return cache[bitmap];
		}
		static private var cache:Object = new Object();
	}
}