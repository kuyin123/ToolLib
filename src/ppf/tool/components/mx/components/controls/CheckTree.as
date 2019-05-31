package ppf.tool.components.mx.components.controls
{
	import ppf.tool.components.mx.components.renderers.CheckTreeRenderer;
	
	import mx.controls.Tree;
	import mx.core.ClassFactory;
	import mx.events.ListEvent;

	/**
	 * 三状态复选框树控件
	 * 支持的功能：<br/>
	 * 		双击项目展开<br/>
	 * 		自定义 数据源中状态字段（支持XML的节点/属性）<br/>
	 * 		自定义 部分选中的填充色<br/>
	 * 		自定义 填充色的透明度<br/>
	 * 		自定义 填充色的边距<br/>
	 * 		自定义 填充矩形的四角弧度<br/>
	 * 		设置 取消选择是否收回子项<br/>
	 * 		设置 选择项目时是否展开子项<br/>
	 * 		自定义 选择框左边距的偏移量<br/>
	 * 		自定义 选择框右边距的偏移量<br/>
	 * 		设置 是否显示三状态<br/>
	 * 		设置 父项与子项是否关联<br/>
	 * <br/>
	 * 方法：<br/>
	 * 设置全部选中 selectAll<br/>
	 * 设置全部不选中 selectNone<br/>
	 * 展开所有项 expandAll<br/>
	 */

	public class CheckTree extends Tree
	{
		/**
		 * 设置全部选中 
		 * 
		 */		
		public function selectAll():void
		{
			setAll(dataProvider,1);
			PropertyChange();
		}
		/**
		 * 设置全部不选中 
		 * 
		 */		
		public function selectNone():void
		{
			setAll(dataProvider,0);
			PropertyChange();
		}
		
		private function setAll(obj:Object,select:int):void
		{
			for each (var item:Object in obj)
			{
				item[checkBoxStateField] = select;
				if (item.hasOwnProperty("children"))
					setAll(item.children,select);
				else if (item is XML)
				{
					setAll((item as XML).children(),select);
				}
			}
		}
		
		/**
		 * 双击项目
		 */
		public var itemDClickSelect:Boolean=true;
		
		/**
		 * 自定义tooltip显示字段 否则使用labelField显示tooltip
		 * @return 
		 * 
		 */		
		public function get toolTipDataField():String
		{
			return _toolTipDataField;
		}
		public function set toolTipDataField(value:String):void
		{
			_toolTipDataField = value;
		}

		/**
		 * 展开所有 
		 * 
		 */		
		public function expandAll(open:Boolean=true):void
		{
			for each(var item:Object in this.dataProvider)   
				this.expandChildrenOf(item,open);
		}
		
		/**
		 * 构造函数
		 *
		 */
		public function CheckTree()
		{
			super();
			doubleClickEnabled=true;
		}

		/**
		 * 属性改变将改变事件调度到事件流中
		 *
		 */		
		public function PropertyChange():void
		{
			dispatchEvent(new ListEvent(mx.events.ListEvent.CHANGE));
		}

		/**
		 * 树菜单，双击事件
		 * @param evt 双击事件源
		 *
		 */
		public function onItemDClick(e:ListEvent):void
		{
			if(itemDClickSelect)
				OpenItems();
		}

		/**
		 * 打开Tree节点函数，被 有打开节点功能的函数调用
		 * @param item	要打开的节点
		 *
		 */
		public function OpenItems():void
		{
			if (this.selectedIndex >= 0 && this.dataDescriptor.isBranch(this.selectedItem))
				this.expandItem(this.selectedItem, !this.isItemOpen(this.selectedItem), true);
		}

		/**
		 * 数据源中状态字段
		 * @return
		 *
		 */		
		[Bindable]
		public function get checkBoxStateField():String
		{
			return _checkBoxStateField;
		}
		public function set checkBoxStateField(v:String):void
		{
			_checkBoxStateField=v;
			PropertyChange();
		}

		/**
		 * 部分选中的填充色
		 * @return
		 *
		 */		
		[Bindable]
		public function get checkBoxBgColor():uint
		{
			return _checkBoxBgColor;
		}
		public function set checkBoxBgColor(v:uint):void
		{
			_checkBoxBgColor=v;
			PropertyChange();
		}

		/**
		 * 填充色的透明度
		 * @return
		 *
		 */		
		[Bindable]
		public function get checkBoxBgAlpha():Number
		{
			return _checkBoxBgAlpha;
		}
		public function set checkBoxBgAlpha(v:Number):void
		{
			_checkBoxBgAlpha=v;
			PropertyChange();
		}

		/**
		 * 填充色的边距
		 * @return
		 *
		 */		
		[Bindable]
		public function get checkBoxBgPadding():Number
		{
			return _checkBoxBgPadding;
		}
		public function set checkBoxBgPadding(v:Number):void
		{
			_checkBoxBgPadding=v;
			PropertyChange();
		}

		/**
		 * 填充色的四角弧度
		 * @return
		 *
		 */		
		[Bindable]
		public function get checkBoxBgElips():Number
		{
			return _checkBoxBgElips;
		}
		public function set checkBoxBgElips(v:Number):void
		{
			_checkBoxBgElips=v;
			PropertyChange();
		}

		/**
		 * 取消选择是否收回子项
		 * @return
		 *
		 */		
		[Bindable]
		public function get checkBoxCloseItemsOnUnCheck():Boolean
		{
			return _checkBoxCloseItemsOnUnCheck;
		}
		public function set checkBoxCloseItemsOnUnCheck(v:Boolean):void
		{
			_checkBoxCloseItemsOnUnCheck=v;
			PropertyChange();
		}

		/**
		 * 选择项时是否展开子项
		 * @return
		 *
		 */		
		[Bindable]
		public function get checkBoxOpenItemsOnCheck():Boolean
		{
			return _checkBoxOpenItemsOnCheck;
		}
		public function set checkBoxOpenItemsOnCheck(v:Boolean):void
		{
			_checkBoxOpenItemsOnCheck=v;
			PropertyChange();
		}

		/**
		 * 选择框左边距的偏移量
		 * @return
		 *
		 */		
		[Bindable]
		public function get checkBoxLeftGap():int
		{
			return _checkBoxLeftGap;
		}
		public function set checkBoxLeftGap(v:int):void
		{
			_checkBoxLeftGap=v;
			PropertyChange();
		}

		/**
		 * 选择框右边距的偏移量
		 * @return
		 *
		 */		
		[Bindable]
		public function get checkBoxRightGap():int
		{
			return _checkBoxRightGap;
		}
		public function set checkBoxRightGap(v:int):void
		{
			_checkBoxRightGap=v;
			PropertyChange();
		}

		/**
		 * 是否显示三状态
		 * @return
		 *
		 */		
		[Bindable]
		public function get checkBoxEnableState():Boolean
		{
			return _checkBoxEnableState;
		}
		public function set checkBoxEnableState(v:Boolean):void
		{
			_checkBoxEnableState=v;
			PropertyChange();
		}

		/**
		 * 与父项子项关联
		 * @return
		 *
		 */
		[Bindable]
		public function get checkBoxCascadeOnCheck():Boolean
		{
			return _checkBoxCascadeOnCheck;
		}
		public function set checkBoxCascadeOnCheck(v:Boolean):void
		{
			_checkBoxCascadeOnCheck=v;
			PropertyChange();
		}

		/**
		 * 取消checkbox的改变事件
		 * @return 
		 * 
		 */
		[Bindable]
		public function get cancelCheckBoxEvent():Boolean
		{
			return _isCancelCheckBoxEvent;
		}
		public function set cancelCheckBoxEvent(v:Boolean):void
		{
			_isCancelCheckBoxEvent = v;
		}
		
		/**
		 * 是否在打开时就展开所有子项 yes:是，no:不是
		 * @return 
		 * 
		 */		
		public function get isExpandChildren():Boolean
		{
			return _isExpandChilden;
		}
		public function set isExpandChildren(v:Boolean):void
		{
			_isExpandChilden = v;
		}
		
		
		/**
		 * 标志是否可用的字段
		 */
		public function set enabledField(val:String):void
		{
			_enabledField = val;
		}
		public function get enabledField():String
		{
			return _enabledField;
		}
		
		/**
		 * @private
		 *
		 */
		override protected function createChildren():void
		{
			var myFactory:ClassFactory=new ClassFactory(CheckTreeRenderer);
			if (null == _toolTipDataField)
				_toolTipDataField = labelField;
			myFactory.properties = {"toolTipField":_toolTipDataField};
			this.itemRenderer=myFactory;
			super.createChildren();
			[Embed(source="/assets/on.gif")]
			var open_ico:Class;
			
			[Embed(source="/assets/off.gif")]
			var close_ico:Class;
			
			this.setStyle("defaultLeafIcon", null);
			this.setStyle("folderClosedIcon", null);
			this.setStyle("folderOpenIcon", null);
			this.setStyle("disclosureOpenIcon", open_ico);
			this.setStyle("disclosureClosedIcon", close_ico);
			addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onItemDClick);
		}

		//数据源中状态字段
		private var _checkBoxStateField:String="@state";
		//部分选中的填充色
		[Bindable]
		private var _checkBoxBgColor:uint=0x009900;
		//填充色的透明度
		[Bindable]
		private var _checkBoxBgAlpha:Number=1;
		//填充色的边距
		[Bindable]
		private var _checkBoxBgPadding:Number=3;
		//填充色的四角弧度
		[Bindable]
		private var _checkBoxBgElips:Number=2;
		//取消选择是否收回子项
		[Bindable]
		private var _checkBoxCloseItemsOnUnCheck:Boolean=true;
		//选择项时是否展开子项
		[Bindable]
		private var _checkBoxOpenItemsOnCheck:Boolean=false;
		//选择框左边距的偏移量
		[Bindable]
		private var _checkBoxLeftGap:int=0;
		//选择框右边距的偏移量
		[Bindable]
		private var _checkBoxRightGap:int=20;
		//是否显示三状态
		[Bindable]
		private var _checkBoxEnableState:Boolean=true;
		//与父项子项关联
		[Bindable]
		private var _checkBoxCascadeOnCheck:Boolean=true;
		//是否有checkbox的改变事件 true:是 ; false：没有
		[Bindable]
		private var _isCancelCheckBoxEvent:Boolean = true;
		//是否在打开时就展开所有子项，固定打开所有不能缩回子项 true：是 false：否
		[Bindable]
		private var _isExpandChilden:Boolean = false;
		//是否需要过滤，将不能选的变灰
		/*[Bindable]
		private var _isNeedFilter:Boolean = false;*/
		//在需要过滤时，数据源中的判断过滤的属性
		/*[Bindabel]
		private var _propertyFilter:String = "isBelong";*/
		//是否需要使用该节点的对某功能的权限来过滤   true：需要， false：不需要 
		/*[Bindable]	
		private var _isNeedAuthFilter:Boolean = false;*/
		//当需要用权限来过滤时，数据源里用于过滤的某属性字符串，
		[Bindable]
		private var _enabledField:String = "enabled";
		//是否让checkbox不可点击进行修改 true：可以false：不可以
		private var _enabledCheckBox:Boolean = true;
		//tooltip显示字段
		private var _toolTipDataField:String;

	}
}
