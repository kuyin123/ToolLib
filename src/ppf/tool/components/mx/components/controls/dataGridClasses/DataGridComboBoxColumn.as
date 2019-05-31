package ppf.tool.components.mx.components.controls.dataGridClasses
{
	import ppf.tool.components.mx.components.controls.dataGridClasses.DataGridColumn;
	import ppf.tool.components.mx.components.renderers.DataGridCheckBoxItemRenderer;
	import ppf.tool.components.mx.components.renderers.DataGridComboBoxHeadRenderer;
	import ppf.tool.components.mx.components.renderers.DataGridComboBoxItemRenderer;
	
	import mx.collections.IList;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	/**
	 * DataGridColumn默认编辑时带有下拉Combobox的的列<br/>
	 * dataProvider ：Combobox数据源<br/>
	 * labelField ：dataProvider Array 中项目的显示字段名<br/>
	 * itemValueField 下拉项返回字段<br/>
	 * dataProviderHead：表头下拉数据源<br/>
	 * @author wangke
	 * 
	 */	
	public class DataGridComboBoxColumn extends ppf.tool.components.mx.components.controls.dataGridClasses.DataGridColumnLabel
	{
		public function set labelField(value:String):void
		{
			_labelField = value;
			setClassFactory();
		}

		public function set dataProviderHead(value:Object):void
		{
			_dataProviderHead = value;
			setHeadClassFactory();
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
		
		public function DataGridComboBoxColumn(columnName:String=null)
		{
			super(columnName);
			
			labelFunction = labelFunc;
		}
		
		private function setClassFactory():void
		{
			editorDataField = "selectedValue";
			var myFactory:ClassFactory = new ClassFactory(DataGridComboBoxItemRenderer);
			if ("" == _labelField)
				myFactory.properties = {"itemValueField":_itemValueField,"dataProvider":_dataProvider,"prompt":_prompt};
			else
				myFactory.properties = {"itemValueField":_itemValueField,"dataProvider":_dataProvider,"prompt":_prompt,"labelField":_labelField};
			this.itemEditor = myFactory;
		}
		
		private function setHeadClassFactory():void
		{
			var myFactory:ClassFactory = new ClassFactory(DataGridComboBoxHeadRenderer);
			myFactory.properties = {"dataProvider":_dataProviderHead};
			this.headerRenderer = myFactory;
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
		
		private var _dataProvider:Object;
		
		private var _dataProviderHead:Object;
		
		private var _itemValueField:String="";
		
		private var _prompt:String;
		
		private var _labelField:String = "label";
		
		private var _undefinedStr:String = "undefined";
	}
}