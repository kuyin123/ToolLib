package ppf.tool.components.controls
{
	import flash.events.Event;
	import flash.text.engine.FontWeight;
	
	import mx.controls.Label;
	import mx.core.UITextField;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;
	
	/**
	 * 文本过长时，自动左边截断
	 * */
 	public class LLabel extends Label
		
	{
		/**
			* 一种文本标签：当文本过长时，在左边截断，同时在左边添加省略号(...)
			* */
		public function LLabel()
		{
			super();
			
			super.truncateToFit=false
			this.addEventListener(ResizeEvent.RESIZE, reDraw, false, 0, true)
			this.addEventListener(FlexEvent.CREATION_COMPLETE,_writeText,false,0,true)

		}
		/**
		 * 从外部读取LLabel标签的显示内容时,读取到的是没有经过截取的完整的字符串
		 * */
		private var _text:String=""

			/**
			 * 暂存text属性。当本组件还没有初始化完成时就写入文本，先暂存起来，等初始化完成后再自动写入
			 * */
		private var _text0:String=""
		override public function set text(txt:String):void
		{
			if( !this.initialized)
			{
				_text0=txt
				return
			}
 			this.textField.text=txt
			this._text=txt
			reDraw(null)	
   		}
		private function _writeText(e:FlexEvent):void
		{
			if(_text0 != "")
			{
				text=_text0
				_text0=""
				this.removeEventListener(FlexEvent.CREATION_COMPLETE,_writeText)
			}
		}
   		override public function get text():String
		{
			return _text
		}
		override public function set height(value:Number):void
		{
			super.height=value
		}
		override public function get height():Number
		{
			return super.height
		}
	 
		/**
		 * 在label的最右端留一点空白，这个是设置空白的宽度，默认为5
		 * */
		public var Rblank:uint=5
		 
		public function reDraw(e:Event):void
		{
 			if (this.textField.text == "")
			{
				return
			}
 			super.truncateToFit=false
   			var str:String
			var i:int=1
			this.textField.text=_text
     			while (this.textField.textWidth >= (this.width - Rblank)&&this.width>0)
			{ 
				str=this.textField.text
				this.textField.text=". . . " + str.slice(i, str.length)
				i++
 			}
       	}
 	}
}
