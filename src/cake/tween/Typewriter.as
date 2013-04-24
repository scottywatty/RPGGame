package cake.tween 
{
	import net.flashpunk.FP;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * Old-school "typewriter" style text.
	 * @author DelishusCake
	 */
	public class Typewriter extends Tween
	{
		/**
		 * The key the user must press to go to the next page (or skip to the end).
		 */
		public var next:* = Key.SPACE;
		/**
		 * If the user can skip through the current page of text.
		 */
		public var skippable:Boolean = true;
		/**
		 * The holder for the text.
		 */
		public var text:String = "";
		/**
		 * An array of strings representing the text to "type".
		 */
		public var pages:Array = [];
		/**
		 * The current page that the text is on
		 */
		public function get page():uint { return _page; }
		/**
		 * Create a new dialog tween.
		 * @param	speed			The speed to display each letter at (in seconds).
		 * @param	pageComplete	The function to call at the end of each page.
		 * @param	complete		The function to call when all the text has been displayed.
		 */
		public function Typewriter(speed:Number = 0.02, pageComplete:Function = null, complete:Function = null) 
		{
			super(1, PERSIST, complete);
			_pageDone = pageComplete;
			_speed = speed;
		}
		/**
		 * Type out the text.
		 * @param	pages		The "pages" of text to type (Strings)
		 * @param	skippable	If the user can skip through a page.
		 */
		public function type(pages:Array, skippable:Boolean = true):void
		{
			text = "";
			this.pages = pages;
			this.skippable = skippable;
			_char = _page = _elapsed = 0;
			_done = _waiting = false;
			start();
		}
		override public function update():void 
		{
			super.update();
			if (_done)
			{
				if (Input.pressed(next))
				{
					active = false;
					if(complete != null) complete();
				}
				return;
			}
			if (_waiting)
			{
				if (Input.pressed(next))
				{
					_char = -1;
					text = "";
					_waiting = false;
					if (_pageDone != null) _pageDone();
				}
				return;
			}
			if (Input.pressed(next) && skippable)
			{
				text = pages[_page];
				_char = pages[_page].length;
				return;
			}
			_elapsed += FP.elapsed;
			if (_elapsed >= _speed)
			{
				_elapsed = 0;
				_char ++;
				if (_char > pages[_page].length)
				{
					_page ++;
					_char = 0;
					if (_page > (pages.length - 1))
					{
						_done = true;
						return;
					}
					_waiting = true;
					return;
				}
				text = pages[_page].substr(0, _char);
			}
		}
		private var _speed:Number;
		private var _elapsed:Number = 0;
		private var _pageDone:Function = null;
		
		private var _char:int = 0;
		private var _page:uint = 0;
		
		private var _done:Boolean = false;
		private var _waiting:Boolean = false;
	}
}