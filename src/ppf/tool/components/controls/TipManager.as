package ppf.tool.components.controls
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	import ppf.base.frame.ChartEvent;
	import ppf.base.graphics.ChartCanvas;

	/**
	 * tip管理对象，管理tip的添加与删除等操作的对象 
	 * @author wangke
	 * 
	 */	
	public class TipManager extends EventDispatcher
	{
		public var updateTipData:Function;
		
		/**
		 * 删除所有的tip 
		 * 
		 */		
		public function delAllTip():void
		{
			for each(var tip:ChartTip in _tipList)
			{
				tip.btn_Close.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		/**
		 * 坐标轴改变，刷新tip的数据坐标点 
		 * 
		 */		
		public function updateTipArrowPoint():void
		{
			for each(var item:ChartTip in _tipList)
			{
				item.updateArrowPoint();
			}
		}
		/**
		 * 构造函数
		 * @param p 要在其上创建tip的对象
		 *  
		 */		
		public function TipManager(c:ChartCanvas)
		{
			super();
			_chartCavans = c;
			_parent = _chartCavans.maskCanvas;
			_parent.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get isOverData():Boolean
		{
			return _isOverData;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set isOverData(value:Boolean):void
		{
			_isOverData = value;
		}
		
		/**
		 * 刷新数据 
		 * @param e
		 * 
		 */		
		public function updateData(event:ChartEvent):void
		{
			var len:int = _tipList.length - 1;
			var tip:ChartTip;
			var data:Object
			for (var i:int = len ; i >= 0; i--) 
			{
				tip = _tipList.getItemAt(i) as ChartTip;
				if (updateTipData != null && tip.isShowCloseBtn)
				{
					data = updateTipData(tip.arrowPoint.x);
					if (data)
					{
						tip.tipData = data;
					}
					else
					{
						tip.btn_Close.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					}
				}
			}
		}
		
		/**
		 * 创建一个tip对象 
		 * @param msg tip要显示的信息，string/array/object（array与object需要指定显示的渲染器才可以显示）
		 * @param p tip显示的位置,是数据坐标系的点, 要可以把数据坐标系转为全局坐标系的方法
		 * @param unit_name 坐标系统（单位）
		 * @param isShowCloseBtn 是否显示关闭按钮
		 * @param isShowArrowPoint 是否显示箭头的点
		 * @param classPath 自定义的显示tip类
		 * @return 
		 * 
		 */		
		public function createTip(msg:Object, p:Point, unit_name:String, isShowCloseBtn:Boolean = true, isShowArrowPoint:Boolean = true,classPath:String=""):ChartTip
		{
			//把已置顶的TIP从当前TIP中去掉
			if (_currTip && _currTip.isTop)
				_currTip = null;
			
			//如果无当前TIP，则从未置顶的列表中取一个，如果没有则做罢，创建一个即可
			if (!_currTip)
			{
				for each (var item:ChartTip in _tipList)
				{
					if (item && !item.isTop)
					{
						_currTip = item;
						break;
					}
				}
			}
			
			if (!_currTip)
			{
				_currTip = new ChartTip(_chartCavans);
				_tipList.addItem(_currTip);
			}
			
			//如果当前TIP不在显示列表，则加入显示列表
			if (!_currTip.parent)
			{
//				FLEX_TARGET_VERSION::flex4
//				{
					(_parent as IVisualElementContainer).addElement(_currTip);
//				}
//				FLEX_TARGET_VERSION::flex3
//				{
//					_parent.addChild(_currTip);
//				}
			}
			_currTip.unit_name = unit_name;
			_currTip.isShowArrowPoint = isShowArrowPoint;
			_currTip.isShowCloseBtn = isShowCloseBtn;
			_currTip.isTop = isShowCloseBtn;
			_currTip.classPath = classPath;
			_currTip.tipData = msg;
			_currTip.arrowPoint = p;
			_currTip.addEventListener(ChartTip.EVENT_CLOSED, onTipEvent, false, 0, true);
			return _currTip;
		}
		
		private function onEnterFrame(event:Event):void
		{
			_timerCount ++;
			if (_timerCount <= 40)
				return;
			_timerCount = 0;
			
			if (!_isOverData)
				onDelElse();
			
			if (null == _chartCavans.stage)
			{
				_parent.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				onDelElse(true);
				_chartCavans = null;
				_parent = null;
			}
		}
		
		/**
		 * 当_parent被单击时，查tip列表并删除未置顶的tip 
		 * @param isIgnoreTop 是否忽略置顶属性
		 * 
		 */		
		private function onDelElse(isIgnoreTop:Boolean = false):void
		{
			for each (var tip:ChartTip in _tipList)
			{
				if (tip.isClose || !(tip.isTop || tip.isMouseOn))
				{
					if (_currTip == tip)
						_currTip = null;
					delTip(tip,isIgnoreTop);
				}
			}
		}
		
		/**
		 * Tip的关闭按钮被单击的处理函数
		 * @param e 事件
		 * 
		 */		
		private function onTipEvent(event:Event):void
		{
			var tip:ChartTip = event.target as ChartTip;
			
			if (!tip)
				return;
			switch (event.type)
			{
				case ChartTip.EVENT_CLOSED:
					delTip(tip, true);
					break;
			}
		}
		
		/**
		 * 
		 * 删除Tip处理函数
		 * @param tip tip对象
		 * @param isIgnoreTop 是否忽略置顶属性
		 * 
		 */		
		private function delTip(tip:ChartTip, isIgnoreTop:Boolean = false):void
		{
			if (!isIgnoreTop && (tip.isTop || tip.isMouseOn)) 
				return;
			
			var tipIndex:int = _tipList.getItemIndex(tip);
			if (tipIndex >= 0)
			{
				_tipList.removeItemAt(tipIndex);
			}
			if (tip.parent)
			{
//				FLEX_TARGET_VERSION::flex4
//				{
					(tip.parent as IVisualElementContainer).removeElement(tip);
//				}
//				FLEX_TARGET_VERSION::flex3
//				{
//					tip.parent.removeChild(tip);
//				}
			}
		}
		
		/**
		 * 当前鼠标是否在需要显示tip的数据上面 true：是 false：鼠标不在需要显示的tip的数据上面
		 */		
		private var _isOverData:Boolean = false;
		
		private var _timerCount:Number = 0;
		
		/**
		 * 当前显示的tip
		 */		
		private var _currTip:ChartTip;
		
		/**
		 * 要在其上创建tip的对象
		 */		
		private var _chartCavans:ChartCanvas;
		
		/**
		 * 要在其上创建tip的对象
		 */		
		private var _parent:UIComponent;
		
		
		/**
		 * tip列表对象
		 */		
		private var _tipList:ArrayCollection = new ArrayCollection;
	}
}