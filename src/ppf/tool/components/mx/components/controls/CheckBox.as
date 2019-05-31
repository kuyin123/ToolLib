package ppf.tool.components.mx.components.controls
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import mx.controls.CheckBox;
	import mx.core.ClassFactory;
	import mx.core.mx_internal;
	import mx.skins.spark.SparkSkinForHalo;
	
	import ppf.tool.components.mx.skins.MxCheckBoxSkin;
	
	import spark.core.SpriteVisualElement;
	
	use namespace mx_internal;
	public class CheckBox extends mx.controls.CheckBox
	{
		/**
		 * 是否是三态 CheckBox
		 */		
		public var isThreeState:Boolean = false;
		/**
		 * 部分选中的填充色 
		 */		
		public var checkBoxBgColor:uint = 0x5fcab0;////0x009900;
		
		/**
		 * 部分选中的充色的透明度 
		 */		
		public var checkBoxBgAlpha:Number=1;
		
		/**
		 * 部分选中的填充色的边距 
		 */		
		public var checkBoxBgPadding:Number=3;
		
		/**
		 * 部分选中的填充色的四角弧度 
		 */		
		public var checkBoxBgElips:Number=2;
		
		public function CheckBox()
		{
			super();
			setStyle("icon",ppf.tool.components.mx.skins.MxCheckBoxSkin);
		}
		
		/**
		 * 部分选中 
		 */
		public function get selectedPartially():Boolean
		{
			return _selectedPartially;
		}

		/**
		 * @private
		 */
		public function set selectedPartially(value:Boolean):void
		{
			if (_selectedPartially != value)
			{
				_selectedPartially = value;
				invalidateDisplayList();
			}
			
			if (_selectedPartially && selected)
				selected = false;
		}

		override protected function clickHandler(event:MouseEvent):void
		{
			//非三态
			if (!isThreeState)
				super.clickHandler(event);
			//三态
			else
			{
				//没有部分选中，全选或全不选
				if (!_selectedPartially)
					super.clickHandler(event);
				//部分选中
				else
				{
					selectedPartially = false;
					//必须发送事件，渲染器的CheckBox需要处理
					dispatchEvent(new Event(Event.CHANGE));
				}
			}
			
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (isThreeState)
			{
				if ("" == label)
				{
					var n:int = numChildren;
					var obj:DisplayObject;
					for (var i:int = 0; i < n; i++)
					{
						obj = getChildAt(i);
						if (!(obj is TextField))
						{
							obj.x = (unscaledWidth - obj.width) * 0.5;
						}
					}
				}
				
				var g:Graphics;
				var myRect:Rectangle;
//				FLEX_TARGET_VERSION::flex4
//				{
					if ((mx_internal::currentIcon as SparkSkinForHalo).numElements == 1)
					{
						s = new SpriteVisualElement;
						(mx_internal::currentIcon as SparkSkinForHalo).addElement(s);
					}
					
					g = s.graphics;
//				}
//				FLEX_TARGET_VERSION::flex3
//				{
//					g = graphics;
//				}
				
				g.clear();
				
				if (_selectedPartially)
				{
//					FLEX_TARGET_VERSION::flex4
//					{
						myRect = getCheckRect(checkBoxBgPadding);
//					}
//					FLEX_TARGET_VERSION::flex3
//					{
//						myRect = getCheckRect(checkBoxBgPadding);
//					}
					g.lineStyle(1,0x25b793);
					g.beginFill(checkBoxBgColor,checkBoxBgAlpha);
					g.drawRect(myRect.x, myRect.y, myRect.width - 1, myRect.height - 1);
//					g.drawRoundRect(myRect.x, myRect.y, myRect.width - 1, myRect.height - 1, checkBoxBgElips, checkBoxBgElips);
					g.endFill();
				}
			}
		}
		
		/**
		 * 获取填充色的边距
		 * @param checkTreeBgPadding 边距
		 * @return  填充的区域
		 * 
		 */
		protected function getCheckRect(checkTreeBgPadding:Number):Rectangle
		{
//			FLEX_TARGET_VERSION::flex4
//			{
				var myRect:Rectangle =  mx_internal::currentIcon.getBounds(s);
				myRect.top+=checkTreeBgPadding;
				myRect.left+=checkTreeBgPadding;
				myRect.bottom-=checkTreeBgPadding;
				myRect.right-=checkTreeBgPadding;
//			}
//			FLEX_TARGET_VERSION::flex3
//			{
//				var myRect:Rectangle=getBounds();
//				myRect.top+=checkTreeBgPadding;
//				myRect.left+=checkTreeBgPadding;
//				myRect.bottom-=checkTreeBgPadding;
//				myRect.right-=checkTreeBgPadding;
//			}
			return myRect;
		}
		
		private var _selectedPartially:Boolean = false;
		
		private var s:SpriteVisualElement;
	}
}