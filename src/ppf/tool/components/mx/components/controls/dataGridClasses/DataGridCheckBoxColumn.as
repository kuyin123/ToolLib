package ppf.tool.components.mx.components.controls.dataGridClasses
{
	import ppf.tool.components.mx.components.controls.dataGridClasses.DataGridColumn;
	import ppf.tool.components.mx.components.renderers.DataGridCheckBoxItemRenderer;
	
	import mx.core.ClassFactory;

	/**
	 * 在DataGrid中使用显示CheckBox列的组件，该组件会保存用户选中的数据当前行的引用，
	 * 该组件要求在数据源中存在属性dgSelected属性，此属性用来记录当前行是否被选中
	 * @author wangke
	 *
	 */
	[Event(name="colorClick", type="com.grusen.events.DataGridColumnEvent")]
	[Event(name="checkBoxClick", type="com.grusen.events.DataGridColumnEvent")]
	[Event(name="checkBoxHeadClickBegin", type="com.grusen.events.DataGridColumnEvent")]
	[Event(name="checkBoxHeadClickEnd", type="com.grusen.events.DataGridColumnEvent")]
	public class DataGridCheckBoxColumn extends ppf.tool.components.mx.components.controls.dataGridClasses.DataGridColumn
	{
		/**
		 * 保存该列是否全选的属性（用户先点击全选后在手动的取消几行数据的选中状态时，这里的状态不会改变）
		 */		
		public var cloumnSelected:Boolean=false;

		public function set checkBoxThreeStateField(value:String):void
		{
			_checkBoxThreeStateField = value;
			setClassFactory();
		}

		public function set isThreeState(value:Boolean):void
		{
			_isThreeState = value;
			setClassFactory();
		}

		/**
		 * checkBox的 enabled的处理函数
		 * function enabledFunc(item:Object):Boolean
		 */		
		public function get enableFunction():Function
		{
			return _enableFunction;
		}

		public function set enableFunction(value:Function):void
		{
			_enableFunction = value;
			setClassFactory();
		}

		public function set isColorEvent(value:Boolean):void
		{
			_isColorEvent = value;
			setClassFactory();
		}
		/**
		 * 用户保存用户选中的数据
		 */		
//		public var selectItems:Array = [];
		/**
		 * 背景颜色使用数据源字段 
		 */		
		public var colorField:String = "color";
		/**
		 * checkBox勾选使用数据源字段 
		 */		
		public var checkBoxField:String = "selected";
		
		public function DataGridCheckBoxColumn(columnName:String=null)
		{
			super(columnName);
			
			this.headerText ="";
			this.sortable = false;
			this.editable = false;
			this.width = 55;
//			this.setStyle("textAlign","right");
//			this.headerRenderer = new ClassFactory(DataGridCheckBoxHeaderRenderer);
			setClassFactory();
		}
		
		public function setClassFactory():void
		{
			var myFactory:ClassFactory = new ClassFactory(DataGridCheckBoxItemRenderer);
			myFactory.properties = { "isColorEvent":_isColorEvent,"enableFunction":_enableFunction,
				"isThreeState":_isThreeState,"checkBoxThreeStateField":_checkBoxThreeStateField};
			this.itemRenderer = myFactory;
		}
		
		private var _isColorEvent:Boolean = false;
		
		private var _enableFunction:Function;
		
		private var _isThreeState:Boolean = false;
		
		private var _checkBoxThreeStateField:String="";
	}
}
