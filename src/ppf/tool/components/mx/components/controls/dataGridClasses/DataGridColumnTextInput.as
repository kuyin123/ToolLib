package ppf.tool.components.mx.components.controls.dataGridClasses
{
	import ppf.tool.components.mx.components.renderers.DataGridComboBoxHeadRenderer;
	import ppf.tool.components.mx.components.renderers.DataGridTextInputItemRenderer;
	import ppf.tool.components.spark.components.controls.TextInput;
	
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;

	public class DataGridColumnTextInput extends DataGridColumnLabel
	{
		public function DataGridColumnTextInput(columnName:String=null)
		{
			super(columnName);
//			labelFunction = labelFunc;
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
			var myFactory:ClassFactory = new ClassFactory(DataGridTextInputItemRenderer);
			if ("" == _labelField)
				myFactory.properties = {"restrict":_restrict,"maxChars":_maxChars};
			else
				myFactory.properties = {"restrict":_restrict,"maxChars":_maxChars};
			this.itemEditor = myFactory;
		}
		
		protected function labelFunc(item:Object,column:mx.controls.dataGridClasses.DataGridColumn):String
		{
			if (column is DataGridComboBoxColumn)
			{
				var value:String = item[column.dataField];
				var data:Object = ((_dataProvider.hasOwnProperty("source"))?(_dataProvider.source):_dataProvider);
				for each (var item:Object in data)
				{
					if ("" != _itemValueField)
					{
						if (item[_itemValueField].toString() == value)
							return item[_labelField];
					}
				}
			}
			return _undefinedStr;
		}
		
		public function set  restrict(value:String):void
		{
			_restrict = value;
			setClassFactory();
		}
		
		private var _restrict:String;//限制字符
		
		private var _dataProvider:Object;
		
		private var _dataProviderHead:Object;
		
		private var _itemValueField:String="";
		
		private var _prompt:String;
		private var _maxChars:int;
		private var _minChars:int;
		private var _labelField:String = "label";
		
		private var _undefinedStr:String = "undefined";
	}
}