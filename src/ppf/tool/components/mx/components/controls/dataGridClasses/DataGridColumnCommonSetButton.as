package ppf.tool.components.mx.components.controls.dataGridClasses
{
	import mx.core.ClassFactory;
	
	import ppf.tool.components.mx.components.renderers.OperateSetItemRenderer;

	public class DataGridColumnCommonSetButton extends DataGridColumn
	{
		/**
		 *带有按钮的DataGridColumn 
		 * @author Administrator
		 * 
		 */	
		public function DataGridColumnCommonSetButton(columnName:String=null)
		{
			super(columnName);
			this.sortable = false;
			this.editable = false;
			setClassFactory();
		}
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
		public function setClassFactory():void
		{
			var myFactory:ClassFactory = new ClassFactory(OperateSetItemRenderer);
			myFactory.properties = { "btnDataProvider":_btnDataProvider,"opFunction":_opFunction , "isStopClickEvent":_isStopClickEvent};
			this.itemRenderer = myFactory;
		}
		
		private var _opFunction:Function;
		
		private var _btnDataProvider:Array;
		
		private var _isStopClickEvent:Boolean = false;
	}
}