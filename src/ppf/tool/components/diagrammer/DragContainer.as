package ppf.tool.components.diagrammer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.core.DragSource;
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.Button;
	
	import ppf.base.frame.docview.interfaces.IDragInitiator;
	import ppf.base.resources.LocaleConst;
	import ppf.base.resources.LocaleManager;
	import ppf.tool.components.IDragItem;
	import ppf.tool.components.spark.components.supportClasses.Group;
	import ppf.tool.components.spark.components.views.Group;
	
	public class DragContainer extends ppf.tool.components.spark.components.supportClasses.Group
	{
		public static const DATACHANGE:String = "dataChange";
		/**
		 * 选中测点发生变化 
		 */		
		public static const SelectedChanged:String = "SelectedChanged";
		public static const SelectedGridChanged:String = "SelectedGridChanged"

		/**
		 * 已选择的子对象列表 
		 */
		public function get selectedItems():Array
		{
			return _selectedList.toArray();
		}

		/**
		 * 拖动的过滤函数
		 * function dragFilter(item:Object):Boolean
		 */		
		public var dragFilterFun:Function;
		
//		public function get dataProvider():IList
//		{
//			return this._dataProvider;
//		}
//		public function set dataProvider(value:IList):void
//		{
//			
//			if (null == value)
//			{
//				_dataProvider = null;
//				enabled = false;
//			}
//			else
//			{
//				_dataProvider = value;
//				enabled = true;
//			}
//			
//			setChildData(); 
//			
//			_selectedList = new ArrayCollection;
//			_unSelectedList = new ArrayCollection;
//		}
		
		[Bindable]
		public function get xml_config():String
		{
			var tmpXml:String = getChildXmlData().toXMLString();
			
			if (tmpXml != _xml_config)
			{
				_xml_config = tmpXml;
			}
			return _xml_config;
		}
		public function set xml_config(val:String):void
		{
			if ("" == val)
			{
				_xml_config = "<items/>";
				enabled = false;
			}
			else
			{
				_xml_config = val;
				enabled = true;
			}
			setChildXmlData(); 
			_selectedList = new ArrayList;
			_unSelectedList = new ArrayList;
		}
		
		/**
		 * 在拖动容器里 
		 */		
		public static const IN:String = "in";
		/**
		 * 在拖动容器外 
		 */		
		public static const OUT:String = "out";
		/**
		 * 是否启用编辑模式，默认是不启用
		 */
		public function get isEdit():Boolean
		{
			return _isEdit;
		}
		/**
		 * @private
		 */
		public function set isEdit(value:Boolean):void
		{
			_isEdit = value;
		}
		
		/**
		 * 设置tip是否选中
		 * @param obj
		 *
		 */		
		public function setSelectChildren(obj:IUIComponent):void
		{
			this._selectedList = new ArrayList;
			this._unSelectedList = new ArrayList;
			
			for (var i:Number=0;i<this.numChildren;i++)
			{
				var currObject:IDragItem = this.getChildAt(i) as IDragItem;
				
				//当前TIP是否有效
				if (currObject && currObject.includeInLayout && currObject.visible)
				{
					//当前TIP的选中状态
					var isHit:Boolean = false;
					
					//当，点击某个Tip时判断处理
					if (!_selectCanvas && currObject == obj)
					{
						//单击的对象就是当前对象也选中
						isHit = true;
					}
					else if (!isEdit)
					{
						isHit = false;
					}
						//选择矩形与Tip相交，则选中
					else if (_selectCanvas && obj == _selectCanvas && currObject != obj)
					{
						//与obj相交的当前对象为选中对象
						isHit = obj.hitTestObject(currObject as DisplayObject);
					}
					else if (obj == this)
					{//全选
						//与obj相交的当前对象为选中对象
						isHit = obj.hitTestObject(currObject as DisplayObject);
					}
						
					
					if (isHit)
					{
						//把对象加入已选中列表
						this._selectedList.addItem(currObject);
						currObject.isSelected = true;
					}
					else
					{
						//把对象加入未选中列表
						this._unSelectedList.addItem(currObject);
						currObject.isSelected = false;
					}
				}
			}
			
			var evt:Event = new Event(SelectedChanged);
			this.dispatchEvent(evt);
		}
		
		/**
		 * 是否拖到外面就删除对象 true:允许、false：不允许
		 * @param v
		 *
		 */		 
		public function set DropOutDeleteEnable (v:Boolean):void 
		{ 
			_isDropOutDelete=v; 
		}
		public function get DropOutDeleteEnable ():Boolean 
		{ 
			return _isDropOutDelete; 
		}
		
		public function onDelete(e:Event = null):void
		{
			if (_selectedList.length > 0)
				Alert.show(LocaleManager.getInstance().getString(LocaleConst.LIB,'LIB_TIP_002'),LocaleManager.getInstance().getString(LocaleConst.PUBLIC,'PUBLIC_OP_010'),Alert.YES|Alert.NO|Alert.NONMODAL,null,onDeleteAlert);
		}
		
		/**
		 * 删除标签
		 * @param object 标签对象
		 *
		 */
		public function RemoveOverviewTip(dragItem:DragItem):void
		{
			this.removeElement(dragItem);
			
			if (_selectedList.getItemIndex(dragItem) >= 0)
				_selectedList.removeItemAt(_selectedList.getItemIndex(dragItem));
			
			if (_unSelectedList.getItemIndex(dragItem) >= 0)
				_unSelectedList.removeItemAt(_unSelectedList.getItemIndex(dragItem));
			
//			_dataProvider = getChildData();
			
			_xml_config = getChildXmlData().toXMLString();
			
			onDataChange();
		}
		
		public function onMoveTip(e:KeyboardEvent):void
		{
			if (null == _selectedList || _selectedList.length == 0)
				return;
			
			var tmpPoint:Point = new Point(0,0);
			switch (e.keyCode)
			{
				case Keyboard.UP:
					tmpPoint.y = -1;
					break;
				case Keyboard.DOWN:
					tmpPoint.y = 1;
					break;
				case Keyboard.LEFT:
					tmpPoint.x = -1;
					break;
				case Keyboard.RIGHT:
					tmpPoint.x = 1;
					break;
				default:
					break;
			}
			if (e.shiftKey)
			{
				tmpPoint.y = tmpPoint.y * 10;
				tmpPoint.x = tmpPoint.x * 10;
			}
			
//			for each (var object:IDragItem in this._selectedList)
			for each (var object:IDragItem in this._selectedList.source)
			{
				object.x += tmpPoint.x;
				object.y += tmpPoint.y;
				
				checkBounds(object);
				
			}
			
			onDataChange();
		}
		
		public function DragContainer()
		{
			super();
		}
		

		/**
		 * 必须进行重写 
		 * @return 
		 * 
		 */		
		protected function createItem(dragType:String):IDragItem
		{
			throw new Event("createItem not implemented!!!");
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			this.addEventListener(DragEvent.DRAG_ENTER, onDragEnter, false, 0, true);
			this.addEventListener(DragEvent.DRAG_DROP, onDragDrop, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 1, true);
		}
		
		/**
		 * 添加所有完成处理 
		 * 
		 */		
		protected function onAddComplete():void
		{
			
		}
		/**
		 * 拖动添加1个的处理函数 
		 * 
		 */		
		protected function onAddDragItem():void
		{
			
		}
		
		/**
		 * 当接受拖放对象时，的回调处理 DragDrop
		 * @param e 事件对象
		 *
		 */		
		protected function onDragDrop(e:DragEvent):void
		{   
			var dragInitiator:IDragInitiator = e.dragInitiator as IDragInitiator;
		
			var box:IDragItem;
			
			//当前鼠标所在的点
			_currPoint = new Point(e.localX,e.localY);
			
			//从DragGroup外来的数据
			if (dragInitiator.source == OUT)
			{
				var object:Object = e.dragSource.dataForFormat(dragInitiator.dataForFormat);
				
				if (object is Array || object.hasOwnProperty("length"))
				{
//					var array:Array = object as Array;
					
					for each(var item:Object in object)
					{
						box = createDragItem(item,dragInitiator.getDragType(item));
						
						if (_locPoint.x == 0 && _locPoint.y == 0)
							_locPoint = new Point(box.width*0.5,box.height*0.5);
						else
							_locPoint = new Point(_locPoint.x - box.width - 2,_locPoint.y);
						
						addDragItem(box, _currPoint, _locPoint);
						
						setSelectChildren(box);
					}
				}
				else
				{
					var treeItem:Object = object;
					box = createDragItem(treeItem,dragInitiator.getDragType(item));
					
					if (_locPoint.x == 0 && _locPoint.y == 0)
						_locPoint = new Point(box.width*0.5,box.height*0.5);
					
					addDragItem(box, _currPoint, _locPoint);
				}
			}
			else if (dragInitiator.source == IN)
			{
				var Source:Object = e.dragSource.dataForFormat(IN);
				
				if (Source is Array)
				{
					var arrayobject:Array = Source as Array;
					for each (var itemobj:DragSourceData in arrayobject)
					{
						box = itemobj.dragUI as IDragItem;
						_locPoint = itemobj.locPoint as Point;
						
						if (!_locPoint)
							_locPoint = new Point(box.width*0.5,box.height*0.5);
						
						addDragItem(box, _currPoint, _locPoint);
					}
				}
				else
				{
					var dragSourceData:DragSourceData = Source as DragSourceData;
					
					box = dragSourceData.dragUI as IDragItem;
					_locPoint = dragSourceData.locPoint as Point;
					
					if (!_locPoint)
						_locPoint = new Point(box.width*0.5,box.height*0.5);
					
					addDragItem(box, _currPoint, _locPoint);
				}
			}
			//重置偏移点
			_locPoint.x=0;
			_locPoint.y=0;
			
//			_dataProvider = getChildData();
			_xml_config = getChildXmlData().toXMLString();
			onDataChange();
			onAddDragItem();
		}
		
		/**
		 * 当拖放对象进入本对象时，显示不同的图标
		 * 如果是在显示列表中，则先删除移动的对象，》》如果拖出了本对象的范围，则会退出拖放状态，对象不会再创建回来
		 * 判断是否是可接收的拖放对象
		 *
		 * @param e 事件对象
		 *
		 */		
		private function onDragEnter(e:DragEvent):void
		{   
			if(isEdit && e.dragInitiator is IDragInitiator)
			{
				var dragInitiator:IDragInitiator = e.dragInitiator as IDragInitiator;
				
				var dragSource:Object = e.dragSource.dataForFormat(dragInitiator.dataForFormat);
				var obj:Object = dragSource[0];	
				
				// 如果有拖动的过滤函数
				if (null != dragFilterFun)
				{
					if (dragFilterFun.call(this,obj))
					{
						if (dragInitiator.source == OUT)
						{
							DragManager.showFeedback(DragManager.COPY); 
						}
						else if (dragInitiator.source == IN)
							DragManager.showFeedback(DragManager.LINK);
					}
					else
						DragManager.showFeedback(DragManager.NONE);
				}
				else
				{
					if (dragInitiator.source == OUT)
					{
						DragManager.showFeedback(DragManager.COPY); 
					}
					else if (dragInitiator.source == IN)
						DragManager.showFeedback(DragManager.LINK);
					else
						DragManager.showFeedback(DragManager.NONE);
				}
				
				DragManager.acceptDragDrop(e.currentTarget as IUIComponent);  
			}
		}
		
		/**
		 * 当前对象的鼠标按下回调函数，开始拾取（创建一个选择的矩形框）
		 * @param e
		 *
		 */		
		private function onMouseDown(e:MouseEvent):void
		{
			//当前事件发出者currentTarget与事件发出者target相同，且是this时处理，避免字对象的事件干扰
			if (e.currentTarget == e.target && e.currentTarget == this)
			{
				//先试图删除屏幕上已有的对象
				onMouseUp(e);
				_selectOldPoint = this.globalToLocal(new Point(stage.mouseX,stage.mouseY));
				//创建半透明对象
				_selectCanvas = new Canvas;
				_selectCanvas.setStyle("backgroundColor","0xa4e4ff");
				_selectCanvas.alpha=0.3;
				_selectCanvas.setStyle("borderStyle","solid");
				_selectCanvas.setStyle("borderColor","0x8cc3da");
				this.addElement(_selectCanvas);
				
				//注册事件
				this.addEventListener(MouseEvent.CLICK,onMouseUp,false,1,true);
				this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,false,1,true);
				this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,1,true);
			}
		}
		
		
		/**
		 * 当前对象的鼠标移动回调函数
		 * 计算矩形框大小
		 * @param e
		 *
		 */		
		private function onMouseMove(e:MouseEvent):void
		{
			//屏幕上已有selectCanvas对象,则处理
			if (isEdit && _selectCanvas)
			{
				var _selectNewPoint:Point = this.globalToLocal(new Point(stage.mouseX,stage.mouseY));
				
				//光标拾取的区域
				var rX:Number=Math.min(_selectOldPoint.x,_selectNewPoint.x);
				var rY:Number=Math.min(_selectOldPoint.y,_selectNewPoint.y);
				var rW:Number=Math.abs(_selectOldPoint.x-_selectNewPoint.x);
				var rH:Number=Math.abs(_selectOldPoint.y-_selectNewPoint.y);
				
				_selectRec = new Rectangle(rX,rY,rW,rH);
				
				//设置半透明对象位置，大小
				_selectCanvas.x = _selectRec.x;
				_selectCanvas.y = _selectRec.y;
				_selectCanvas.width = _selectRec.width;
				_selectCanvas.height = _selectRec.height;
			}
		}
		
		/**
		 * 当台起左键时结束选择对象，设置对象的选中状态
		 * @param e
		 *
		 */		
		private function onMouseUp(e:MouseEvent):void
		{
			//屏幕上已有selectCanvas对象,则处理
			if (_selectCanvas && this.contains(_selectCanvas))
			{
				//设置TIP是否选中
				setSelectChildren(_selectCanvas);
				
				this.removeEventListener(MouseEvent.CLICK,onMouseUp);
				this.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
				this.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
				
				this.removeElement(_selectCanvas);
				_selectCanvas = null;
			}
		}
		
		/**
		 * 创建，返回 总貌图中的标签
		 * @param item 数据
		 * @return 标签对象
		 *
		 */		
		private function createDragItem(item:Object=null,dragType:String=""):IDragItem
		{
			var tmpDragItem:IDragItem = createItem(dragType);
			
			if (null != item)
				tmpDragItem.loadByItem(item);
			tmpDragItem.isEdit = isEdit;
			tmpDragItem.addEventListener(MouseEvent.MOUSE_DOWN,onDragItemMouseDown,false,0,true);
			
			return tmpDragItem;
		}
		
		/**
		 * 检查并设置OverViewDataTip的位置
		 *
		 * @param box 操作的目标
		 * @param currPoint 当前光标所在的点
		 * @param locPoint 拖放开始，光标所在的点
		 *
		 */		
		private function addDragItem(box:IDragItem, currPoint:Point=null, locPoint:Point=null):void
		{
			//  按像素与网格对齐
			var tmpPoint:Point = currPoint;
			var tmpX:Number = tmpPoint.x % 5;
			if (tmpX>2.5)
				tmpX=5;
			else
				tmpX=0;
			
			var tmpY:Number=tmpPoint.y % 5;
			if (tmpY>2.5)
				tmpY=5;
			else
				tmpY=0;
			
			tmpPoint.x = int(tmpPoint.x/5)*5+tmpX;
			tmpPoint.y = int(tmpPoint.y/5)*5+tmpY;
			
			
			var tmplocPoint:Point = locPoint;
			
			//如果偏移点无数据
			if (tmplocPoint.x == 0 && tmplocPoint.y == 0)
				tmplocPoint = new Point(box.width*0.5,box.height*0.5);
			
			tmpX = tmplocPoint.x % 5;
			if (tmpX > 2.5)
				tmpX = 5;
			else
				tmpX = 0;
			
			tmpY = tmplocPoint.y % 5;
			if (tmpY>2.5)
				tmpY=5;
			else
				tmpY=0;
			
			tmplocPoint.x = int(tmplocPoint.x/5)*5+tmpX;
			tmplocPoint.y = int(tmplocPoint.y/5)*5+tmpY;

			//设置OverViewDataTip的位置	
			box.x = tmpPoint.x-tmplocPoint.x;   
			box.y = tmpPoint.y-tmplocPoint.y;
			
			//如果Box不在显示列表，则添加到显示列表
			if (!this.contains(box as DisplayObject))
				this.addElement(box as IVisualElement);
			this.invalidateDisplayList();
			
			checkBounds(box);
		}
		
		/**
		 * 检测Tip对象是否超出DragGroup的范围 
		 * 超出范围则让他回到显示区
		 * @param tip DragItem对象
		 * 
		 */		
		private function checkBounds(tip:IDragItem):void
		{
			if (null == tip)
				return;
			
			if (tip.x < 0)
				tip.x = 0;
			if (tip.y < 0)
				tip.y = 0;
			if ((tip.y+tip.height) > height)
				tip.y = height-tip.height;
			if ((tip.x+tip.width) > width)
				tip.x = width-tip.width;
		}
		
		/**
		 * Tip对象的鼠标事件，激发拖放事件的入口函数
		 * @param e 事件对象
		 *
		 */		
		protected function onDragItemMouseDown(e:MouseEvent):void
		{  
			var tempObj:Object = e.target as Button;
			if ( !tempObj)
			{
				addSelectItem(e);
				
				_beginPoint = new Point(e.stageX,e.stageY);
				
				if (this._selectedList.length>0)
				{ 
					//置顶当前选中的tip
					this.setElementIndex(e.currentTarget as IVisualElement,this.numChildren -1);
					
					DragSelectedObject(e);
				}
			}
		}
		
		/**
		 * 拖放选中的Tip
		 * @param e
		 *
		 */		
		private function DragSelectedObject(e:MouseEvent):void
		{
			var targer:UIComponent = e.currentTarget as UIComponent
			var newArray:Array=[];
			//拖放时，当前选中的Tip的半透明对象
			var obj:UIComponent = new UIComponent();
			
//			for each (var object:UIComponent in this._selectedList)
			for each (var object:UIComponent in this._selectedList.source)
			{
				var mousePoint:Point = new Point(stage.mouseX,stage.mouseY);
				
				//未使用
				var dragSourceData:DragSourceData = new DragSourceData;
				dragSourceData.data = (object as DragItem).data;
				dragSourceData.locPoint = object.globalToLocal(mousePoint);
				dragSourceData.dragUI = object;
				
				var bmapData:BitmapData = new BitmapData(object.width, object.height, true, 0x00000000);
				
				newArray.push(dragSourceData);
				
				bmapData.draw(object);
				var dragProxy:Bitmap = new Bitmap(bmapData); 
				obj.addChild(dragProxy);
				dragProxy.x=object.x-targer.x;
				dragProxy.y=object.y-targer.y;
			}
			
			if (isEdit)
			{
				var dragSource:DragSource = new DragSource(); 
				dragSource.addData( newArray, IN );  
				
				targer.addEventListener(DragEvent.DRAG_COMPLETE, onDragComplete, false, 0, true);
				DragManager.doDrag( targer, dragSource, e, obj); 
			}
		}
		
		/**
		 * 拖放完成事件的回调处理函数
		 *   功能：
		 *     判断鼠标是否移动到本对象的外面，
		 *     如果移动到本对象的外面且isDropOutDelete为TRUE，
		 *     则删除正在拖放的Tip
		 *
		 * @param e
		 *
		 */		
		protected function onDragComplete(e:DragEvent):void
		{
			if (!_isDropOutDelete)
				return;
			
			//当前鼠标所在的点
			_currPoint = new Point(stage.mouseX,stage.mouseY);
			
			//检查Tip是否被拖出的Canvas的边际，是则提示是否删除对象
			if (!hitTestPoint(_currPoint.x, _currPoint.y, true))
			{
				if (e.dragInitiator is IDragInitiator)
				{
					var Source:Object = e.dragSource.dataForFormat(IN);
					if (Source is Array)
					{
						onDelete();
					}
				}
			}
			
			//重置偏移点
			_locPoint.x=0;
			_locPoint.y=0;
			
//			_dataProvider = getChildData();
		}
		
		/**
		 * 删除标签的提示框 
		 * @param e
		 * 
		 */		
		private function onDeleteAlert(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)
			{
				var tmpSelectList:Array = _selectedList.source.concat();
				for each (var item:DragItem in tmpSelectList)
				{
					RemoveOverviewTip(item);
				}
			}
		}
		
		/**
		 * 把当前鼠标选中的TIP加入到选中列表
		 * 有三大要点：
		 * 一、当前事件中，如果未按下Ctrl键：
		 * 		1、如果当前的TIP未选中，则选中他；
		 * 		2、如果TIP已选中，则不理会。
		 * 二、当前选中列表为空时，不管三七二十一，把当前的TIP设为选中状态。
		 * 三、当前事件中，如果按下了Ctrl键：
		 * 		1、如果当前的TIP未选中，则选中他；
		 * 		2、如果TIP已选中，则取消他的选中状态。
		 * @param e
		 * 
		 */		
		private function addSelectItem(e:MouseEvent):void
		{
			var item:DragItem = e.currentTarget as DragItem;
			
			var isCtrl:Boolean = e.ctrlKey;
			
			if (!contains(item))
				return;
			//当前事件中，如果未按下Ctrl键，
			//1、如果当前的TIP未选中，则选中他，
			//2、如果TIP已选中，则不理会
			if (!isCtrl)
			{
				if (!item.isSelected)
					setSelectChildren(item);
			}
				//当前选中列表为空时，不管三七二十一，把当前的TIP设为选中状态
			else if (_selectedList.length == 0)
			{
				setSelectChildren(item);
			}
			//当前事件中，如果按下了Ctrl键，
			//1、如果当前的TIP未选中，则选中他，
			//2、如果TIP已选中，则取消他的选中状态。
			else if (isCtrl)
			{
				var index:Number = _selectedList.getItemIndex(item);
				var index2:Number = _unSelectedList.getItemIndex(item);
			
				if (!item.isSelected)
				{
					if (index < 0)
						_selectedList.addItem(item);
					if (index2 > 0)
						_unSelectedList.removeItemAt(index2);
				}
				else
				{
					if (index > 0)
						_selectedList.removeItemAt(index);
					if (index2 < 0)
						_unSelectedList.addItem(item);
				}
				item.isSelected = !item.isSelected;
			}
			if (item.isSelected)
				item.setFocus();
			
			var evt:Event = new Event(SelectedChanged);
			this.dispatchEvent(evt);
		}
		
		/**
		 * 从Tip获取xml_config数据
		 * @return
		 *
		 */		
//		private function getChildData():IList
//		{
//			var tmpArr:IList = new ArrayList;
//		
//			for (var i:Number=0; i<this.numChildren; i++)
//			{
//				var currObject:DragItem = this.getChildAt(i) as DragItem;
//				
//				if (currObject)
//				{
//					tmpArr.addItem(currObject.data);
//				}
//			}
//			return tmpArr;
//		}
//		
//		/**
//		 * 根据xml_config创建Tip
//		 *
//		 */		
//		private function setChildData():void
//		{
//			this.removeAllElements();
//			
//			if (null != _dataProvider)
//			{
//				for each (var item:Object in _dataProvider)
//				{
//					var tmpDragItem:IDragItem = createDragItem();
//					
//					this.addElement(tmpDragItem as IVisualElement);
//					tmpDragItem.data = item;
//				}
//			}
//		}
		
		/**
		 * 根据xml_config创建Tip
		 *
		 */		
		private function setChildXmlData():void
		{
			(this as IVisualElementContainer).removeAllElements();
			
			var tmpData:XML = XML(_xml_config);
			if (tmpData)
			{
				for each (var item:XML in tmpData.children())
				{
					if (item.toString() == "null")
						continue;
					if (!item.hasOwnProperty("@type"))
						continue;
					var tmpDataTip:IDragItem = createDragItem(null, item.@type);
					this.addElement(tmpDataTip as IVisualElement);
					tmpDataTip.loadByXML(item);
				}
			}
			
			onAddComplete();
		}
		
		/**
		 * 从Tip获取xml_config数据
		 * @return
		 *
		 */		
		public function getChildXmlData():XML
		{
			var tmpXml:XML = new XML("<items/>");
			
			for (var i:Number=0; i<this.numChildren; i++)
			{
				var currObject:IDragItem = (this as IVisualElementContainer).getElementAt(i) as IDragItem;
				if (currObject)
				{
					var itemXML:XML = new XML("<item/>");
					itemXML.@type = currObject.type;
					currObject.saveToXML(itemXML);
					tmpXml.prependChild(itemXML);
				}
			}
			return tmpXml;
		}
		
		/**
		 * 当标签改变，发送事件通知
		 * @param e
		 * 
		 */		
		private function onDataChange(event:Event = null):void
		{
			var tmpString:String = xml_config;
			var evt:Event = new Event(DATACHANGE);
			this.dispatchEvent(evt);
		}
		
		/**
		 *鼠标相对拖放的目标的相对位置，从外部拖动进来的不会有值， 则以鼠标的当前位置为中心点创建对象  
		 */		
		private var _locPoint:Point = new Point(0,0);
		
		/**
		 * 鼠标的当前位置
		 */		
		private var _currPoint:Point = new Point(0,0);
		
		private var _beginPoint:Point = new Point(0,0);
		/**
		 * 显示显示范围的半透明对象 
		 */		
		static private var _selectCanvas:Canvas;
		
		/**
		 * 光标拾取的区域（当前的选取矩形） 
		 */		
		private var _selectRec:Rectangle;
		/**
		 * 光标拾取开始点 
		 */		
		private var _selectOldPoint:Point;
		/**
		 * 未选择的子对象列表
		 */		
		private var _unSelectedList:ArrayList = new ArrayList;
		private var _selectedList:ArrayList = new ArrayList;
		
		/**
		 * 是否启用编辑模式，默认是不启用 
		 */		
		private var _isEdit:Boolean = true;
		
		/**
		 * 否拖到外面就删除对象
		 */		
		private var _isDropOutDelete:Boolean=true;
		
//		private var _dataProvider:IList;
		
		private var _xml_config:String="<items/>";
	}
}