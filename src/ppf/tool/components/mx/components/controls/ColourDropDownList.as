package ppf.tool.components.mx.components.controls
{
	import flash.events.MouseEvent;
	
	import mx.controls.ComboBox;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	public class ColourDropDownList extends ComboBox
	{
		/**
		 * 颜色数组数据源
		 * @param arr
		 *
		 */		
		public function set colorArray(arr:Array):void
		{
			_colorArray = arr;
			this.dataProvider = formatDataProvider();
			this.setStyle("alternatingItemColors",_colorArray);
		}
		public function get colorArray():Array
		{
			return _colorArray;
		}
		
		/**
		 * 选中的颜色 
		 * @return 颜色 
		 * 
		 */		
		public function get color():Number
		{
			return selectedItem.color;
		}
		
		public function ColourDropDownList()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,initApp,false,0,true);
		}
		
		/**
		 * 设置当前选中的项 
		 * @param color 选中的颜色
		 * 
		 */		
		public function setColor(color:Number):void
		{
			for each (var item:Object in dataProvider)
			{
				if (color == item.color)
				{
					selectedItem = item;
					break
				}
			}
			onChange(null);
		}
		
		private function initApp(e:FlexEvent):void
		{
			this.labelField = "name";
			
			this.textInput.addEventListener(MouseEvent.MOUSE_DOWN,onTextInputDown,false,0,true);
			this.textInput.setStyle("borderStyle","solid");
			//默认editable = false无法使用backgroundColor改变颜色
			this.editable = true;
			this.textInput.enabled = false;
			
			this.addEventListener(ListEvent.CHANGE,onChange,false,0,true);
			this.addEventListener(DropdownEvent.OPEN,onOpen,false,0,true);
		}
		
		/**
		 * 格式化颜色数据源 
		 * @return  格式化后的颜色数据源
		 * 
		 */		
		private function formatDataProvider():Array
		{
			var arr:Array = [];
			var len:Number = _colorArray.length;
			for (var i:int=0;i<len;++i)
			{
				var o:Object = {};
				o.name="";
				o.color = _colorArray[i];
				arr.push(o);
			}
			return arr;
		}
		
		/**
		 * 该颜色选项时的处理 
		 * @param e
		 * 
		 */		
		private function onChange(e:ListEvent):void
		{
			this.textInput.setStyle("backgroundDisabledColor",selectedItem.color);
			this.textInput.setStyle("backgroundColor",selectedItem.color);
			this.setStyle("selectionColor",selectedItem.color);
		}
		
		/**
		 * 点击显示框的处理函数 
		 * @param e
		 * 
		 */		
		private function onTextInputDown(e:MouseEvent):void
		{
			this.open();
		}
		
		/**
		 * 出现下拉框时取消鼠标roll的颜色 
		 * @param e
		 * 
		 */		
		private function onOpen(e:DropdownEvent):void
		{
			//取消鼠标移动的颜色
			this.dropdown.setStyle("useRollOver", false); 
		}
		
		/**
		 * 颜色数组 
		 */		
		private var _colorArray:Array;
	}
}