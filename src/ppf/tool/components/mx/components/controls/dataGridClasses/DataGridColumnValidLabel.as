package ppf.tool.components.mx.components.controls.dataGridClasses
{
	import ppf.tool.components.mx.components.renderers.DataGridItemRendererValidLabel;
	
	import mx.core.ClassFactory;
	[Alternative(replacement="ppf.tool.components.mx.components.controls.dataGridClasses.DataGridColumnLabel",since="4.6")]
	/**
	 * 文字的颜色处理
	 * <br/>labelColorFunc
	 * <br/>function labelColorFunc(item:Object):Boolean
	 * <br/>
	 * <br/>背景的颜色处理
	 * <br/>function backColorFunc(item:Object):Boolean
	 * <br/>
	 * @author wangke
	 * 
	 */	
	public class DataGridColumnValidLabel extends DataGridColumn
	{
		/**
		 * 文字的颜色处理
		 * function labelColorFunc(item:Object):Boolean
		 * <br/>true:正常  false:灰色字体
		 * @return 
		 * 
		 */
		public function set labelColorFunc(value:Function):void
		{
			_labelColorFunc = value;
			setClassFactory();
		}
		
		/**
		 * 背景的颜色处理
		 * function backColorFunc(item:Object):Boolean
		 * <br/>true:正常  false:灰色背景
		 * @return 
		 * 
		 */
		public function set backColorFunc(value:Function):void
		{
			_backColorFunc = value;
			setClassFactory();
		}
		
		public function DataGridColumnValidLabel(columnName:String=null)
		{
			super(columnName);
		}
		
		public function setClassFactory():void
		{
			var myFactory:ClassFactory = new ClassFactory(DataGridItemRendererValidLabel);
			myFactory.properties = { "labelColorFunc":_labelColorFunc, "backColorFunc":_backColorFunc};
			this.itemRenderer = myFactory;
		}
		
		private var _labelColorFunc:Function;
		
		private var _backColorFunc:Function;
	}
}