package ppf.tool.components.mx.components.controls.dataGridClasses
{
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnGroup;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.events.FlexEvent;
	
	import ppf.tool.components.mx.components.controls.dataGridClasses.DataGridColumn;
	import ppf.tool.components.mx.components.renderers.OperateItemRenderer;
	
	public class AdvancedDataGridColumnCommonOp extends AdvancedDataGridColumn
	{
		/**
		 * 按钮根据数据不同状态的处理函数 
		 * function opFunction(item:Object,btnArr:Array):void
		 * @return 
		 * 
		 */
		public function set opFunction(value:Function):void
		{
			_opFunction = value;
			setClassFactory();
		}
		
		public function set dataProvider(value:Array):void
		{
			_btnDataProvider = value;
			setClassFactory();
		}
		
		public function set isStopClickEvent(value:Boolean):void{
			_isStopClickEvent = value;
		}
		
		public function DataGridColumnCommonOp(columnName:String=null)
		{
			//super(columnName);
			
//			this.headerText = "操作";
			this.sortable = false;
			this.editable = false;
			setClassFactory();
		}
		
		public function setClassFactory():void
		{
			var myFactory:ClassFactory = new ClassFactory(OperateItemRenderer);
			myFactory.properties = { "btnDataProvider":_btnDataProvider,"opFunction":_opFunction , "isStopClickEvent":_isStopClickEvent};
			this.itemRenderer = myFactory;
		}

		private var _opFunction:Function;
		
		private var _btnDataProvider:Array;
		
		private var _isStopClickEvent:Boolean = false;
//		private var _btnDataProvider:Array = [
//			{label:"修改",icon:"editOpIcon",eventStr:OpRendererEvent.EDIT},
//			{label:"删除",icon:"deleteOpIcon",eventStr:OpRendererEvent.DEL}];
	}
}