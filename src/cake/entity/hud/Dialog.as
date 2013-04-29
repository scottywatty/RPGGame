package cake.entity.hud 
{
	import cake.tween.Typewriter;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Key;
	
	public class Dialog extends Entity 
	{
		public function Dialog() 
		{
			Text.size = 8;
			
			speaker = new Text("Person", 2, 2);
			body = new Text("Text", 2, 10, {size: 8});
			body.wordWrap = true;
			body.width = 120;
			body.height = FP.halfHeight;
			
			var list:Graphiclist = new Graphiclist();
			list.scrollX = list.scrollY = 0;
			list.add(Image.createRect(120, FP.halfHeight, 0x333333, 0.75));
			list.add(new Text("Z to CONTINUE...", 2, FP.halfHeight - 10)); 
			list.add(speaker);
			list.add(body);
			
			super(20, FP.halfHeight, list);
			visible = active = false;
			
			tween = new Typewriter(0.02, null, complete);
			tween.next = Key.Z;
		}
		public function say(person:String, pages:Array, skippable:Boolean = true, callback:Function = null):void
		{
			speaker.text = person;
			done = callback;
			tween.type(pages, skippable);
			visible = active = true;
		}
		override public function update():void 
		{
			tween.update();
			body.text = tween.text;
		}
		private function complete():void
		{
			if (done != null) done();
			visible = active = false;
		}
		private var body:Text;
		private var speaker:Text;
		
		private var done:Function;
		private var tween:Typewriter;
	}
}