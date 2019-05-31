package ppf.tool.components.mx.components.controls.dataGridClasses
{
	import ppf.tool.components.mx.components.renderers.DataGridItemRenderer;
	import ppf.tool.components.IDataGridColumnSortField;
	
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	
	/**
	 * 增加tooltip显示 
	 * @author wangke
	 * 
	 */	
	public class DataGridColumn extends mx.controls.dataGridClasses.DataGridColumn implements IDataGridColumnSortField
	{
		/**
		 * 排序的字段 
		 */
		public function get sortField():Array
		{
			return _sortField;
		}
		/**
		 * @private
		 */
		public function set sortField(value:Array):void
		{
			_sortField = value;
		}
		
		public function DataGridColumn(columnName:String=null)
		{
			super(columnName);
			
			itemRenderer =  new ClassFactory(DataGridItemRenderer);
			this.sortable = false;
		}
		
		override public function set dataField(value:String):void
		{
			super.dataField = value;
			
			if (!showDataTips)
			{
				dataTipField = value;
				showDataTips= true;
			}
		}
		
		private var _sortField:Array=[];
	}
}