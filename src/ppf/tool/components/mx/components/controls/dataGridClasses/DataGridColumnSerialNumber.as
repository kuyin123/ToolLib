package ppf.tool.components.mx.components.controls.dataGridClasses
{
	import ppf.tool.components.mx.components.controls.dataGridClasses.DataGridColumn;
	
	import mx.collections.ArrayCollection;

	/**
	 * datagrid 显示序号的列 
	 * @author wangke
	 * 
	 */
	public class DataGridColumnSerialNumber extends DataGridColumn
	{
		public var dataProvider:ArrayCollection = new ArrayCollection;
		
		public function DataGridColumnSerialNumber(columnName:String=null)
		{
			super(columnName);
			this.labelFunction = serialNumberLabel
		}

		/**
		 *  序号 显示函数
		 * @param item	项目对象
		 * @param column	DataGrid 列
		 *
		 */
		private function serialNumberLabel(item:Object, column:DataGridColumn):String
		{
			return (dataProvider.getItemIndex(item)+1).toString();
		}

	}
}
