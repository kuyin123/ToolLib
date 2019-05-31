package ppf.tool.components
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import ppf.base.resources.LocaleConst;

	public final class TextFieldUtil
	{
		static public function TextFieldCenter(selectable:Boolean = false,mouseEnabled:Boolean = false):TextField
		{
			var tf:TextField = new TextField;
			tf.selectable = selectable;
			tf.mouseEnabled = mouseEnabled;
			tf.autoSize = TextFieldAutoSize.CENTER;
			return tf;
		}
		static public function TextFieldLeft(selectable:Boolean = false,mouseEnabled:Boolean = false):TextField
		{
			var tf:TextField = new TextField;
			tf.selectable = selectable;
			tf.mouseEnabled = mouseEnabled;
			tf.autoSize = TextFieldAutoSize.LEFT;
			return tf;
		}
		static public function TextFieldRight(selectable:Boolean = false,mouseEnabled:Boolean = false):TextField
		{
			var tf:TextField = new TextField;
			tf.selectable = selectable;
			tf.mouseEnabled = mouseEnabled;
			tf.autoSize = TextFieldAutoSize.RIGHT;
			return tf;
		}
		
		static public function CreateFormatCenter(bold:Boolean=false):TextFormat
		{
			var fmt:TextFormat = new TextFormat();
			fmt.font = LocaleConst.FONT_FAMILY;
			fmt.size = 12;
			fmt.align = TextFormatAlign.CENTER;
			fmt.bold = bold;
			return fmt;
		}
		
		static public function CreateFormatLeft(bold:Boolean=false):TextFormat
		{
			var fmt:TextFormat = new TextFormat();
			fmt.font = LocaleConst.FONT_FAMILY;
			fmt.size = 12;
			fmt.align = TextFormatAlign.LEFT;
			fmt.bold = bold;
			return fmt;
		}
		
	
		static public function CreateFormatRight(bold:Boolean=false):TextFormat
		{
			var fmt:TextFormat = new TextFormat();
			fmt.font = LocaleConst.FONT_FAMILY;
			fmt.size = 12;
			fmt.align = TextFormatAlign.RIGHT;
			fmt.bold = bold;
			return fmt;
		}

		
		public function TextFieldUtil()
		{
			throw new Error("TextFieldUtil类只是一个静态方法类!");  
		}
	}
}