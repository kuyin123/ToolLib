package ppf.tool.components.mx.components.controls
{
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mx.controls.ComboBox;
	import mx.controls.listClasses.ListBase;
	import mx.core.ClassFactory;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	import ppf.tool.components.mx.components.renderers.DropDownListFactory;
	
	/**
	 * 下拉选择框，显示支持树形下拉框									<br/>
	 * 重要的功能：													<br/>
	 * 1、替代官方的Combobox，因为Combobox只支持两个选中方式index/item，<br/>
	 *    而在现实中有很多都要用到item.value；							<br/>
	 * 2、实现树形下拉框；											<br/>
	 * 																<br/>
	 * 注：															<br/>
	 * 1、要用到item.value时（因为会有别名，不一定是value属性），请设置itemValueField为存值的属性名; <br/>
	 * 2、用到树形下拉时，请设置isTree=true；							<br/>
	 * 3、如果设置了m_selectObjectType，系统将只能选中item的type与m_selectObjectType一致的对象<br/>
	 * 4、要直接设置当前选择项，可以设置m_selectItem、m_value、selectedIndex(isTree=false时有效)
	 * 																<br/>
	 * @author wangke
	 * 
	 */	
	public class DropDownList extends ComboBox
	{
		/**
		 * 项目禁止选中处理函数
		 * <br/> disabledFunc(item:Object):Boolean 
		 * <br/> true:禁止选中  false 可以选中
		 */		
		public var disabledFunction:Function = defaultDisableFunc;
		
		/**
		 * 选中后处理函数
		 */ 
		public var itemClickFun:Function;
		
		/**
		 * 使用DataGrid的属性字段
		 */		
		public var dataField:String = "";
		/**
		 * 使用xml作为数据源时，是否返回number的类型
		 */		
		public var isReturnNum:Boolean = false;
		/**
		 * 是否是树形下拉框
		 */		
		public var isTree:Boolean=false;
		/**
		 * 选中的项目对象类型
		 */		
		public var m_selectObjectType:String="";
		
		/**
		 * 选中的项目对象类型数组
		 * 机组          1
		 * 组织	 普通	10
	     *       装置	11
	     *       分厂	12
	     *       工厂	13
	     *       集团	14
		 */ 
		public var m_selectObjectTypeNum:Array = [];
		
		/**
		 * 当前下拉框的值字段
		 *
		 */ 	
		public var itemValueField:String="data";
		
		/**
		 * 标志是否可用的字段 true:可以选中 false：不可选中 字体变灰
		 */		
		public var enabledField:String = "enabled";
		
		/**
		 * 选中的节点值
		 * @return
		 *
		 */	
		[Bindable]
		public function get m_value():*
		{ return _value; }
		public function set m_value(val:*):void
		{ 
			if(null != val)
			{
				var b:Boolean = (_value != val) && m_selectItem;
				_value=val;
				//				text = String(val);
				initApp();
				if(b)
				{
					var e:ListEvent=new ListEvent(ListEvent.CHANGE,false,false,-1,val-1);
					dispatchEvent(e);
				}
			}
			else
			{
				_value = null;
				selectedItem = null;
				selectedIndex = -1;
			}
		}
		
		/**
		 * 初始化设置，而不发出事件
		 */
		public function set initValue(val:*):void{
			if(null != val)
			{
 				_value=val;
 				initApp();
 			}
			else
			{
				selectedItem = null;
				selectedIndex = -1;
			}
		}
		
		/**
		 * 当前选中的节点
		 * @return
		 *
		 */	       
		public function get m_selectItem():Object
		{ 
			return _selectedItem; 
		}
		public function set m_selectItem(value:Object):void
		{ 
			_selectedItem=value; 
			super.selectedItem = value;
		}
		
		/**
		 * 下拉的行数
		 * @return
		 *
		 */
		override public function get rowCount():int
		{
			return _rowCount;
		}
		override public function set rowCount(value:int):void
		{
			_rowCount = value;
			
			if (dropdown)
			{
				dropdown.rowCount = value;
			}
		}
		/**
		 * 当前选择项
		 * @private
		 *
		 */
		override public function get selectedItem():Object
		{
			try
			{
				if (null != dropdown && dropdown == _dropdown)
				{
					
					if ((  m_selectObjectType == "" || 
						 (null != dropdown.selectedItem && 
							dropdown.selectedItem.hasOwnProperty("value") && 
							dropdown.selectedItem.value.toString() == m_selectObjectType ) )   &&  (  m_selectObjectTypeNum.length <= 0 ||   ( null != dropdown.selectedItem && 
								dropdown.selectedItem.hasOwnProperty("value") &&  m_selectObjectTypeNum.indexOf(dropdown.selectedItem.value.type) >= 0  ) ))
					{
						//不可选，则返回当前选中项
						if(disabledFunction!=null)
						{
							if(disabledFunction(dropdown.selectedItem))
							{
								return _selectedItem;
							}
						}
						else
						{
							if (dropdown.selectedItem.hasOwnProperty(enabledField))
							{
								if (dropdown.selectedItem is XML)
								{
									if (!Boolean(Number(dropdown.selectedItem[enabledField])))
										return _selectedItem;
								}
								else if (dropdown.selectedItem[enabledField] == false)
									return _selectedItem;
							}
						}
							
						if (null == _selectedItem || (null != dropdown.selectedItem && dropdown.selectedItem != _selectedItem))
							_selectedItem = dropdown.selectedItem;
						
						if (null == _selectedItem)
							return _selectedItem;
						
						var tmpValue:* = _selectedItem[itemValueField];
						if (isReturnNum)
							tmpValue =  Number(tmpValue);
						
						if (null == tmpValue)
							return _selectedItem;
						
						if (null == _value || tmpValue != _value)
						{
							_value=_selectedItem[itemValueField];
							if (isReturnNum)
								_value = Number(_value);
//							dispatchEvent(new ListEvent(ListEvent.CHANGE));//此句暂时注释，多次发送造成dg接受两次事件，未分析是否必须需要
						}
					}
						
				}
			}
			catch (err:Error)
			{
				trace("DropDownList::selectedItem "+err.message);
			}
			
			return _selectedItem;
		}
		/**
		 * @private
		 * 
		 */		
		override public function set selectedItem(data:Object):void
		{
			super.selectedItem = data;
			_selectedItem = data;
			
			if(_selectedItem==null)
				return;
			
			if(_selectedItem.hasOwnProperty(labelField))
			{
				text=_selectedItem[labelField].toString();
			}
		}
		
		override public function get selectedIndex():int
		{
			//使用时prompt，选中tree的下级时，selectedIndex为-1造成始终显示的prompt的字符
			//目前使用isTree=true使用prompt还是会产生问题！！！
			if (isTree && null != _dropdown)
				return _dropdown.selectedIndex;
			
			return super.selectedIndex;
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			
			if (dataField != "")
				 this.m_value = data[dataField];
		}
		
		/**
		 * 构造函数
		 *
		 */
		public function DropDownList()
		{
			super();
			addEventListener(DropdownEvent.OPEN, onOpen);
			addEventListener(FlexEvent.CREATION_COMPLETE,initApp);
		}
		
		override public function close(trigger:Event=null):void
		{
			if (m_selectObjectType != "")
			{
				if (null != dropdown.selectedItem && 
					dropdown.selectedItem.hasOwnProperty("value") &&
					dropdown.selectedItem.value.toString() != m_selectObjectType)
					return;
			}
			
			if(m_selectObjectTypeNum.length > 0){
				if (null != dropdown.selectedItem && 
					dropdown.selectedItem.hasOwnProperty("value") &&
					m_selectObjectTypeNum.indexOf(dropdown.selectedItem.value.type) < 0 )
					return;
			}
			
			if (null != dropdown.selectedItem)
			{
				if (dropdown.selectedItem.hasOwnProperty(enabledField))
				{
					if (dropdown.selectedItem is XML)
					{
						if (!Boolean(Number(dropdown.selectedItem[enabledField])))
							return;
					}
					else if (dropdown.selectedItem[enabledField] == false)
						return;
				}
			}
				
			super.close(trigger);
		}
		
		/**
		 * 初始化选中第1个有效的选项 
		 * 
		 */		
		public function initSelected():void
		{
			setSelected(dataProvider);
		}
		
		private function setSelected(parenObject:Object):Boolean
		{
			for each (var item:Object in parenObject)
			{
				if (m_selectObjectType == ""  &&  m_selectObjectTypeNum.length <= 0)
				{
					m_value = item;
					return true;
				}
				
				var isvalue = true;
				
				if(m_selectObjectType != "" && item.hasOwnProperty("value") ){
					if( item.value.toString() != m_selectObjectType){
						isvalue = false;
					} 
				}
				if(m_selectObjectTypeNum.length > 0 && item.hasOwnProperty("value") ){
					if( m_selectObjectTypeNum.indexOf( item.value.type) < 0 ){
						isvalue = false;
					} 
				}
				
				if(isvalue){
					m_value = item[itemValueField];
					return true;
				}else if (item.hasOwnProperty("children") && item.children)
				{
					if (setSelected(item.children))
						return true;
				}
			 
			}
			return false;
		}
		
//		protected var isLoadFactory:Boolean = false;
		/**
		 * 设置下拉渲染器
		 *
		 */		
		public function setFactory():void
		{
//			if (isLoadFactory)
//				return;
			
			if (isTree)
			{
//				isLoadFactory = true;
				var myFactory:ClassFactory=new ClassFactory(DropDownListFactory);
				myFactory.properties = { "labelField": labelField,
					"m_selectItem":m_selectItem,
					"disabledFunction":disabledFunction,
					"dataProvider":dataProvider,
					"itemClickFun":itemClickFun
				};
				this.dropdownFactory = myFactory; 
			}
		}
		
		protected var _selectedItem:Object;
		protected var _dropdown:ListBase;
		
		/**
		 * 打开下拉，处理函数
		 * @param e
		 *
		 */		
		protected function onOpen(e:DropdownEvent):void
		{
			_dropdown = dropdown;
			_dropdown.width = this.width;
			if (_dropdown.dataProvider != dataProvider)
				_dropdown.dataProvider = dataProvider;
			if (_dropdown.selectedIndex != -1)
				this.dropdown.scrollToIndex(_dropdown.selectedIndex);
			this.dropdown.horizontalScrollPolicy = "on";
			
			if (isTree)
			{
				setTimeout(setDropdownFactoryPro,100);
			}
		}
		
		protected function setDropdownFactoryPro():void
		{
			var currDropDown:DropDownListFactory = _dropdown as DropDownListFactory;
			if (currDropDown.m_selectItem != _selectedItem)
				currDropDown.m_selectItem = _selectedItem;
			try
			{
				if (currDropDown.selectedItem != _selectedItem)
					currDropDown.selectedItem = _selectedItem;
			}
			catch (err:Error)
			{}
			
			currDropDown.openAllItem();
			
			if (currDropDown.selectedIndex != -1)
				this.dropdown.scrollToIndex(currDropDown.selectedIndex);
		}
		/**
		 * 创建子控件
		 *
		 */		
		override protected function createChildren():void
		{
			super.createChildren();
			this.setStyle("fontWeight","normal");
		}
		
		/**
		 * 更新显示
		 * @param unscaledWidth
		 * @param unscaledHeight
		 *
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			initApp();
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
		
		/**
		 * 设置初始选中项目
		 * @param e
		 *
		 */		
		private function initApp(e:FlexEvent=null):void
		{
			setFactory();
			if (dataProvider)
			{
				//重置 选中状态
				_isSelected = testSelectItem(dataProvider);;
//				testSelectItem(dataProvider);
				//删除机组通道时，删除了当前选中项，则显示为空
				if (!_isSelected)
				{
					if (selectedItem != null)
					{
						super.selectedItem = null;
						_selectedItem = null;
						
						if (null != _dropdown)
							_dropdown.selectedItem = null;
					}
				}
				
				if (null == super.selectedItem && null != _selectedItem)
					super.selectedItem=_selectedItem;
				if (null != super.selectedItem)
				{
					_value = super.selectedItem[itemValueField];
					if (isReturnNum)
						_value = Number(_value);
				}
				//if (selectedIndex < 0)
				//	selectedIndex=0;
			}
		}
		
		/**
		 *使用m_Value来选择selectedItem时，使用的对比的方法 
		 * @param item      遍历中的Item
		 * @param newValue  新的value
		 * @return         如果符合要求，则返回true,否则返回false
		 */		
		protected function valueCompareFunction(item:Object,newValue:Object):Boolean
		{
			if(newValue == null)
				return false;
			var value:* = item[itemValueField];
			if(  ( m_selectObjectType == ""  || (m_selectObjectType != "" && item.hasOwnProperty("value") && item.value.toString() == m_selectObjectType)) 
				&& ( m_selectObjectTypeNum.length <= 0  || (m_selectObjectTypeNum.length > 0 && item.hasOwnProperty("value") && m_selectObjectTypeNum.indexOf( item.value.type) >= 0)) 
 				&& value == newValue)
			{
				if (item.hasOwnProperty(enabledField))
					return item[enabledField] as Boolean;
				return true;
			}
			return false;	
		}
		/**
		 * 循环所有的项，测试并选中与_value匹配的项目
		 * @param parenObject 要循环的项目，通常为ArrayCollection
		 *
		 */		
		private function testSelectItem(parenObject:Object):Boolean
		{
//			try
//			{
				for each (var item:Object in parenObject)
				{
					if (null == item)
						continue;
					
					if(valueCompareFunction(item,_value))
					{
						super.selectedItem = item;
						_selectedItem=item;
						_isSelected = true;
						return true;
					}
					else if ((item.hasOwnProperty("children") && item.children))
					{
						if (testSelectItem(item.children))
							return true;
					}
					else if (item is XML)
					{
						if (testSelectItem((item as XML).children()))
							return true;
					}
				}
//			}
//			catch (err:Error)
//			{
//				trace("DropDownList::testSelectItem "+err.message);
//			}
			return false;
		}
		
		private function defaultDisableFunc(item:Object):Boolean
		{
			if (m_selectObjectType != "" && item.hasOwnProperty("value") && item.value.toString() != m_selectObjectType)
				return true;
			if (m_selectObjectTypeNum.length > 0 && item.hasOwnProperty("value") && m_selectObjectTypeNum.indexOf(item.value.type) < 0)
				return true;
			
			return false;
		}
		
		private var _value:*;
		private var _rowCount:int = 5;
		//是否存在当前的选中项在数据源里
		private var _isSelected:Boolean = false;
	}
}