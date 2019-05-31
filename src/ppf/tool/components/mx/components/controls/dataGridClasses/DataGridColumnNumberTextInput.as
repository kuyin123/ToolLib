package ppf.tool.components.mx.components.controls.dataGridClasses
{
	import mx.core.ClassFactory;
	import ppf.tool.components.mx.components.renderers.DataGridComboBoxHeadRenderer;
	import ppf.tool.components.mx.components.renderers.DataGridNumberTextInputItemRenderer;

	public class DataGridColumnNumberTextInput extends DataGridColumnLabel
	{
		public function DataGridColumnNumberTextInput(columnName:String=null)
		{
			super(columnName);
		}
		
		public function get regexString():String
		{
			return _regexString;
		}
		/**
		 * 传入正则表达式 限制输入
		 * 例如：
		 * 标准负整数   DataGridColumnNumberTextInput 专用
		 * 	static public const NEGATIVE_INT:String = "^\\-?\\d{0,10}$";
		 */
		public function set regexString(value:String):void
		{
			_regexString = value;
			setClassFactory();
		}

		public function set labelField(value:String):void
		{
			_labelField = value;
			setClassFactory();
		}
		
		public function set dataProviderHead(value:Object):void
		{
			_dataProviderHead = value;
			//			setHeadClassFactory();
		}
		public function set maxChars(value:int):void
		{
			_maxChars = value;
			setClassFactory();
		}
		
		public function set minChars(value:int):void
		{
			_minChars = value;
		}
		
		private function setHeadClassFactory():void
		{
			var myFactory:ClassFactory = new ClassFactory(DataGridComboBoxHeadRenderer);
			myFactory.properties = {"dataProvider":_dataProviderHead};
			this.headerRenderer = myFactory;
		}
		public function set prompt(value:String):void
		{
			_prompt = value;
			setClassFactory();
		}
		/**
		 * 设置点击输入框的时候  显示之前内容
		 * */
		public function set itemValueField(value:String):void
		{
			_itemValueField = value;
			setClassFactory();
		}
		public function get itemValueField():String
		{
			return _itemValueField;
		}
		
		public function set dataProvider(value:Object):void
		{
			_dataProvider = value;
			
			setClassFactory();
		}
		
		/**
		 *  
		 * @param value
		 * 
		 */		
		public function set undefinedStr(value:String):void
		{
			_undefinedStr = value;
		}
		
		private function setClassFactory():void
		{
			//			editorDataField = "selectedValue";
			var myFactory:ClassFactory = new ClassFactory(DataGridNumberTextInputItemRenderer);
			if ("" == _labelField)
				myFactory.properties = {"maxChars":_maxChars,"itemValueField":_itemValueField,"regexString":_regexString};
			else
				myFactory.properties = {"maxChars":_maxChars,"itemValueField":_itemValueField,"regexString":_regexString};
			this.itemEditor = myFactory;
		}
//		protected function labelFunc(item:Object,column:mx.controls.dataGridClasses.DataGridColumn):String
//		{
//			if (column is DataGridComboBoxColumn)
//			{
//				var value:String = item[column.dataField];
//				var data:Object = ((_dataProvider.hasOwnProperty("source"))?(_dataProvider.source):_dataProvider);
//				for each (var item:Object in data)
//				{
//					if ("" != _itemValueField)
//					{
//						if (item[_itemValueField].toString() == value)
//							return item[_labelField];
//					}
//				}
//			}
//			return _undefinedStr;
//		}
		
		
		
		private var _dataProvider:Object;
		
		private var _dataProviderHead:Object;
		
		private var _itemValueField:String="";
		
		private var _prompt:String;
		private var _maxChars:int;
		private var _minChars:int;
		private var _labelField:String = "label";
		
		private var _undefinedStr:String = "undefined";
		private var _regexString:String;
	}
}

