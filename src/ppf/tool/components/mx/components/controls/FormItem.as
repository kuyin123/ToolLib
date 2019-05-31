package ppf.tool.components.mx.components.controls
{
	import mx.containers.FormItem;
	import mx.controls.Text;
	import mx.core.FlexGlobals;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;

	/**
	 * FormItem换行显示label，（字符串加入换行符\n或&#x000A;比使用maxLabelWidth限制好）</br>
	 * multiline 是否换行标志</br>
	 * maxLabelWidth 最大label显示长度</br>
	 * selectable label是否可选</br>
	 * @author wangke
	 * 
	 */	
	public class FormItem extends mx.containers.FormItem
	{
		/**
		 * 最大的Label显示宽度
		 */		
		public var maxLabelWidth:Number = 200;
		public var text:Text;
		public var selectable:Boolean = false;
		public var multiline:Boolean = false;
		
		public function FormItem() 
		{
			super();
		}
		override protected function createChildren():void
		{
			super.createChildren();
			itemLabel.maxWidth = maxLabelWidth;
			if (multiline) 
			{
				itemLabel.visible = false;
				text = new Text();
				
				text.setStyle("textAlign", "right");
				text.selectable = selectable;
				
				var labelStyleName:String = getStyle("labelStyleName");
				if (labelStyleName)
				{
					var styleManager:IStyleManager2 = FlexGlobals.topLevelApplication.styleManager;
					var styleDecl:CSSStyleDeclaration = styleManager.getStyleDeclaration("." + labelStyleName);
					if (styleDecl) text.styleDeclaration = styleDecl;
				}
				rawChildren.addChild(text);
			}
			else 
			{
				itemLabel.selectable = selectable;
			}
		}
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (multiline) 
			{
				text.text = itemLabel.text;
			}
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (multiline)
			{
				text.explicitWidth = itemLabel.width;
				text.validateNow();
				text.setActualSize(itemLabel.width, text.measuredHeight + 3);
				text.validateSize();
			}
		}
		override protected function measure():void 
		{
			super.measure();
			if (multiline) 
			{
				measuredMinHeight = Math.max(measuredMinHeight, text.measuredMinHeight);
				measuredHeight = Math.max(measuredHeight, text.measuredHeight);
			}
		}
	}
}