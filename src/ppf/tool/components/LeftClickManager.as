package ppf.tool.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import mx.controls.ToolTip;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListBase;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.core.Application;
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.MenuEvent;
	import mx.managers.ToolTipManager;
	
	import ppf.base.math.MathUtil;

	/**
	 * 左键点击弹出菜单（处理有些浏览器不兼容js右键问题） <br/>
	 * @author wangke
	 * 
	 */	
	public class LeftClickManager
	{
		/**
		 * 1秒的频率 默认1000毫秒=1秒 
		 */		
		static public const SECOND_FREQ:int = 600;
		
		public function LeftClickManager()
		{
		}
		
		/**
		 * 屏蔽系统的右键注册自定义右键
		 * @param displayObject
		 * @return 
		 * 
		 */		
		static public function regist(displayObject:DisplayObjectContainer) : Boolean
		{
			try
			{
				if(displayObject)
				{
					displayObject.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler,false,0,true);
					displayObject.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,false,0,true);
					displayObject.addEventListener(Event.ENTER_FRAME,onTimer,false,0,true);
				}
				else
				{
//					FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler,false,0,true);
					FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler,false,0,true);
					FlexGlobals.topLevelApplication.addEventListener(Event.ENTER_FRAME,onTimer,false,0,true);
				}
			}
			catch (err:Error)
			{
				err.name += "LeftClickManager::regist";
				err.message += "注册左键菜单类 错误";
				trace(err.name+err.message);
			}
			return true;
		}
		
		/**
		 * 注册鼠标当前所在控件为右键菜单源
		 * @param event
		 * 
		 */		
//		static private function mouseOverHandler(event:MouseEvent):void
//		{
//			RightClickManager.rightClickTarget = InteractiveObject(event.target);
//		}
		
		static private function mouseDownHandler(event:MouseEvent) : void
		{
			_rightClickTarget = InteractiveObject(event.target);
			_isMouseDown = true;
			_t = getTimer();
			RightClickManager.pDown(event.stageX,event.stageY);
			
			_p.x = event.stageX;
			_p.y = event.stageY;
			FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_MOVE,mouseOverHandler,false,0,true);
		}
		static private function mouseUpHandler(event:MouseEvent) : void
		{
			_isMouseDown = false;
			FlexGlobals.topLevelApplication.removeEventListener(MouseEvent.MOUSE_MOVE,mouseOverHandler);
		}
		static private function onTimer(event:Event) : void
		{
			if (_isMouseDown)
			{
				var currT:int = getTimer();
				if ((currT - _t)>SECOND_FREQ)
				{
					dispatchRightClickEvent();
					_isMouseDown = false;
				}
			}
		}
		
		/**
		 * 发送右键菜单事件
		 * 
		 */
		static public function dispatchRightClickEvent() : void
		{
			try
			{
				var event:ContextMenuEvent;
				if (_rightClickTarget != null)
				{
					event = new ContextMenuEvent(RightClickManager.RIGHT_CLICK, true, false, _rightClickTarget as InteractiveObject, _rightClickTarget as InteractiveObject);
					_rightClickTarget.dispatchEvent(event);
				}// end if
			}
			catch (err:Error)
			{
				err.name += "LeftClickManager::dispatchRightClickEvent";
				err.message += "发送右键菜单事件 错误";
				trace(err.name+err.message);
			}
			return;
		}
		
		static private function mouseOverHandler(event:MouseEvent):void
		{
			//如果按下鼠标后移动，不弹出菜单
			if (MathUtil.abs(_p.x-event.stageX) > 5 || MathUtil.abs(_p.y-event.stageY)>5)
				_isMouseDown = false;
		}
		
		static private var _p:Point = new Point; 
		
		static private var _rightClickTarget:InteractiveObject;
		
		static private var _t:int;
		
		static private var _isMouseDown:Boolean;
	}
}