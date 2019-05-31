package ppf.tool.components.mx.components.controls.dataGridClasses
{
	import flash.text.TextFieldType;
	
	import mx.core.ClassFactory;
	
	import ppf.tool.components.DataGridUtil;
	import ppf.tool.components.mx.components.renderers.DataGridItemRendererLabel;

	/**
	 * enableFunc控制点击进入编辑状态<br/>
	 * function enableFunc(item:Object,column:DataGridColumn):Boolean<br/>
	 * true:可以编辑 false;不可编辑<p/>
	 * labelColorFunc 字体颜色<br/>
	 * unction labelColorFunc(item:Object,column:DataGridColumn):uint<p/>
	 * backColorFunc 背景颜色<br/>
	 * function backColorFunc(item:Object,column:DataGridColumn):uint<p/>
	 * <br/>
	 * @author wangke
	 */	
	public class DataGridColumnLabel extends DataGridColumn
	{
		
		/**
		 * 设置DataGridColumn的是否进入编辑状态</br>
		 * function enableFunc(item:Object,column:DataGridColumn):Boolean<br/>
		 * true:可以编辑 false;不可编辑<p/>
		 * 默认不可编辑时，会置背景为灰色<br/>
		 * 如果需要改变不同颜色请使用属性backColorFunc
		 * @param value Function
		 * 
		 */		
		public function set enableFunc(value:Function):void
		{
			_enableFuc=value;
			if (null == _backColorFunc)
				backColorFunc = _defaultBackColorFunc;
 		}
		public function get enableFunc():Function
		{
			return _enableFuc;
		}
		
		/**
		 * 文字的颜色处理
		 * function labelColorFunc(item:Object,column:DataGridColumn):uint
		 * @return uint颜色
		 * 
		 */
		public function set labelColorFunc(value:Function):void
		{
			_labelColorFunc = value;
			setClassFactory();
		}
		
		/**
		 * 背景的颜色处理
		 * function backColorFunc(item:Object,column:DataGridColumn):uint
		 * @return uint颜色
		 * 
		 */
		public function set backColorFunc(value:Function):void
		{//注释掉的原因是：取消灰色背景。表格中，禁止编辑的文本不显示原来的灰色背景
			_backColorFunc = value;
			setClassFactory();
		}
		
		public function set isNeedShowTipFunc(value:Function):void
		{//当值改变时 需要更具情况显示tip
			_isNeedShowTipFunc = value;
			setClassFactory();
		}
		
		public function set showContentFun(value:Function):void
		{//当值改变时 需要更具情况显示tip
			_showContentFun = value;
			setClassFactory();
		}
		
		public function DataGridColumnLabel(columnName:String=null)
		{
			super(columnName);

		}
		
		private function setClassFactory():void
		{
			var myFactory:ClassFactory = new ClassFactory(DataGridItemRendererLabel);
			myFactory.properties = { "labelColorFunc":_labelColorFunc, "backColorFunc":_backColorFunc,"isNeedShowTipFun":_isNeedShowTipFunc,"showContentFun":_showContentFun};
			this.itemRenderer = myFactory;
		}
		
		/**
		 * 默认背景色 
		 * @param item
		 * @param column
		 * @return 
		 */		
		private function _defaultBackColorFunc(item:Object,column:DataGridColumn):uint
		{
			/*if (!_enableFuc(item,column)){
 				return DataGridUtil.BACKCOLOR_INVALID;
			}*/
 			return DataGridUtil.BACKCOLOR_WHITE;
		}
		
		private var _labelColorFunc:Function;
		
		private var _backColorFunc:Function;
		
		/**
		 *当前GridColoun是否可用的处理 
		 */	
		private var _enableFuc:Function;
		
		/**
		 * true : 后面截取
		 * false : 前面截取 
		 */ 
		public var isEndSblice:Boolean =true;
		
		/**
		 * 是否要显示tip
		 * 文本超过显示区域除外 
		 */
		private var _isNeedShowTipFunc:Function;
		
		/**
		 * 格式化显示 
		 * 文本超过显示区域除外 
		 */
		private var _showContentFun:Function;
		
		
	}
}