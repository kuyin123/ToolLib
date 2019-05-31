package ppf.tool.components.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Menu;
	import mx.controls.MenuBar;
	import mx.controls.menuClasses.MenuBarItem;
	import mx.core.ClassFactory;
	import mx.events.MenuEvent;
	
	import ppf.base.frame.CommandItem;
	import ppf.base.frame.CommandManager;
	import ppf.base.frame.ICommandManager;
	import ppf.base.resources.AssetsUtil;
	import ppf.tool.auth.AuthUtil;
	import ppf.tool.components.mx.components.renderers.MenuItemRenderer;
	
	/**
	 * 自定义MenuBar <br/>
	 * 根据字符获取图标<br/>
	 * 去除背景 backgroundSkin="com.grusen.mx.skins.MenuBarNoBorderFillSkin" <br/>
	 * itemDownSkin="com.grusen.mx.skins.MenuBarActiveSkin"  <br/>
	 * itemOverSkin="com.grusen.mx.skins.MenuBarActiveSkin"  <br/>
	 * @author wangke
	 * 
	 */
	public class MenuBar extends mx.controls.MenuBar
	{
		public function MenuBar()
		{
			super();
			
			height = 20;
			
			this.addEventListener(MenuEvent.ITEM_ROLL_OVER,onRollOver,false,0,true);
			this.addEventListener(MenuEvent.ITEM_ROLL_OUT,onRollOut,false,0,true);
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame,false,0,true);
			this.addEventListener(MenuEvent.ITEM_CLICK,CommandManager.getInstance().onClickToolBar,false,0,true);
			this.addEventListener(MenuEvent.MENU_SHOW,onMenuShow,false,0,true);
		}
		
		private function onMenuShow(event:MenuEvent):void
		{
			if(event.menu == null || event.menu.dataProvider == null)
				return;
			
			var data:ArrayCollection = event.menu.dataProvider as ArrayCollection;
			var cmdMgr:ICommandManager = CommandManager.getInstance();
			for each(var item:Object in data)
			{
				if(item is CommandItem)
					cmdMgr.onUpdateCmdUI(item.cmdID,item as CommandItem);
			}
			
		}
		
		override public function getMenuAt(index:int):Menu
		{
			var menu:Menu = super.getMenuAt(index);
			menu.setStyle('borderColor',0x98a5c5);
			menu.iconFunction = getMenuIcon;
			menu.itemRenderer = new ClassFactory(MenuItemRenderer);
			return menu;
		}
		
		protected function getMenuIcon(item:Object):Class
		{
			try
			{
				if (item.hasOwnProperty(iconField))
				{
					if (item[iconField] is String)
						return AssetsUtil.stringToIcon(item[iconField]);
					else if (item[iconField] is Class)
						return item[iconField];
				}
			}
			catch (err:Error)
			{
				trace("MenuBar::getMenuIcon"+err.message);
			}
			return null;
		}
		
		protected function onRollOver(event:MenuEvent):void
		{
			if (event.itemRenderer is MenuBarItem)
				event.menuBar.menuBarItems[event.index].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			
			isOver = true;
		}
		
		protected function onRollOut(event:MenuEvent):void
		{
			isOver = false;
			
			//子菜单RollOut
			currMenu = event.menu;
			//主菜单RollOut
			if (null == currMenu)
				currMenu = (event.menuBar.menus[event.index] as Menu);
			
			time = getTimer();
		}
		
		protected function onEnterFrame(event:Event):void
		{
			//如果移出菜单计算时间自动关闭
			if (!isOver )
			{
				var currTime:Number = getTimer();
				
				if ((currTime - time)>1000)
				{
					currMenu.hide();
					currMenu = null;
					isOver = true;
				}
			}
			
//			++_count;
//			
//			if (_count >= 20)
//			{
//				_count = 0;
//				
				if (null != dataProvider && _check == false ) //只check一次权限 整体检查
				{
					_check = true;
					checkAuth(dataProvider);
				}
//			}
		}
		
		/**
		 * 检验菜单权限 
		 * @param dataPro
		 * 
		 */		
		private function checkAuth(dataProvider:Object):void
		{
			for each (var item:Object in dataProvider)
			{
				if (item is CommandItem)
				{
					AuthUtil.setItemAuth(item as CommandItem);
					if (null != item.children)
					{
						checkAuth(item.children);
					}
				}
			}
		}
		
		private var isOver:Boolean = false;
		private var time:Number;
		private var currMenu:Menu;
		private var _check:Boolean = false;;
	}
}