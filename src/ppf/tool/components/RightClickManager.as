package ppf.tool.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	
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
	import mx.rpc.events.HeaderEvent;
	
	import ppf.base.frame.CmdEvent;
	import ppf.base.frame.CommandItem;
	import ppf.base.frame.ICmdTarget;
	import ppf.base.resources.AssetsUtil;
	import ppf.tool.components.mx.components.controls.ScrollableArrowMenu;
	import ppf.tool.components.mx.components.renderers.MenuItemRenderer;
	
	import spark.components.IItemRenderer;
	import spark.components.supportClasses.ListBase;

	/**
	 * 右键菜单管理
	 * 在主工程html-template目录下的index.template.html添加下面
	 * <script>的浏览器判断中添加如下：
	 * params.wmode = "opaque";	<!--Note: This is the key to right-Click 注意：屏蔽系统右键必须添加此属性 -->
	 * <noscript>的浏览器判断中添加如下：
	 * <param name="wmode" value="opaque"/><!--Note: This is the key to right-Click 注意：屏蔽系统右键必须添加此属性 -->
	 * @author KK
	 * 
	 */	
	public class RightClickManager
	{
		/**
		 * 构造函数 
		 * 
		 */
		public function RightClickManager()
		{
		}
		
		static public const RIGHT_CLICK:String = "rightClick_K";
		
		static public const RIGHT_HIDE:String = "rightHide_K";

		/**
		 * 设置菜单弹出坐标 
		 * @param x
		 * @param y
		 * 
		 */		
		static public function pDown(x:Number,y:Number):void
		{
			_pDown.x = x;
			_pDown.y = y;
		}

		/**
		 * 屏蔽系统的右键注册自定义右键 fp11.2开始有系统右键 
		 * @param displayObject
		 * 
		 */		
		static public function regist2(displayObject:DisplayObjectContainer):void
		{
			if(displayObject)
			{
				displayObject.addEventListener(MouseEvent.RIGHT_CLICK,dispatchRightClickEven2);
				displayObject.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
				FlexGlobals.topLevelApplication.addEventListener(MouseEvent.CLICK,onMouseClick);
			}
			else
			{
				FlexGlobals.topLevelApplication.addEventListener(MouseEvent.RIGHT_CLICK,dispatchRightClickEven2);
				FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			}
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
				if (ExternalInterface.available)
				{
					ExternalInterface.call(_javascript, ExternalInterface.objectID);
					ExternalInterface.addCallback("rightClick", dispatchRightClickEvent);
					if(displayObject)
					{
						displayObject.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
					}
					else
					{
						FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
					}
				}// end if
				
				LeftClickManager.regist(displayObject);			
			}
			catch (err:Error)
			{
				err.name += "RightClickManager::regist";
				err.message += "注册右键菜单类 错误";
				trace(err.name+err.message);
			}
			return true;
		}

		static private function forEachRightMenuUpdate(item:Object,index:int,array:Array):void
		{
			if(item.hasOwnProperty("children") && item.children && item.children is Array)
			{//当有子菜单时，递归子菜单
				if(item is CommandItem)
					s_cmdTarget.onUpdateCmdUI((item as CommandItem).cmdID, item as CommandItem);
				var arr:Array = item.children as Array;
				arr.forEach(forEachRightMenuUpdate);
			}
			else if (!s_cmdTarget.onUpdateCmdUI((item as CommandItem).cmdID, item as CommandItem))
			{ //如果未处理，则设为禁用
				item.enabled = false;
				item.toggled = false;
			}
		}
		
		/**
		 * 执行右键更新函数 
		 * @param rightMenuData 右键菜单数据源
		 * 
		 */		
		static private function onRightMenuUpdate(rightMenuData:Array):void
		{
			if(rightMenuData)
			   rightMenuData.forEach(forEachRightMenuUpdate)
		}
		
		static private var s_cmdTarget:ICmdTarget;
		static private var s_params:Array;
		static private function onMenuClick1(e:MenuEvent) : void
		{
			s_cmdTarget.onCommand(new CmdEvent(e.item.cmdID, s_params,e.item));
			s_cmdTarget = null;
			s_params = null;
		}
		
		static public function showMenu(cmdTarget:ICmdTarget, parentWnd:UIComponent, menuData:Array, params:Array=null):void
		{
			if(ToolTipManager.currentToolTip)
			{
				ToolTipManager.destroyToolTip(ToolTipManager.currentToolTip);
				ToolTipManager.currentToolTip=null;
			}
			
			if(!menuData || menuData.length==0)
				return;
			s_cmdTarget = cmdTarget;
			s_params = params;
			// update menu
			onRightMenuUpdate(menuData);
			showMenu2(parentWnd, menuData, onMenuClick1);
		}
		
		/**
		 * 显示右键菜单 
		 * @param target 父对象
		 * @param menuData 菜单数据
		 * @param callback 回调函数
		 * 
		 */
		static private function showMenu2(target:UIComponent ,menuData:Array, callback:Function):void
		{
			try
			{
				hideMenu();
				
				_mouseMenu = ScrollableArrowMenu.createMenu(target, menuData, false);
				_mouseMenu.setStyle('borderColor',0x98a5c5);
				_mouseMenu.itemRenderer = new ClassFactory(MenuItemRenderer);
				_mouseMenu.iconFunction = getMenuIcon; 
				_mouseMenu.variableRowHeight = true;   
				
				//_mouseMenu.measuredHeight.minHeight = menuData.length * 20;
				_mouseMenu.verticalScrollPolicy = ScrollPolicy.OFF;
                _mouseMenu.arrowScrollPolicy = ScrollPolicy.AUTO;
				_mouseMenu.addEventListener(MenuEvent.ITEM_CLICK, callback, false, 0, true);
				
				_mouseMenu.addEventListener(MenuEvent.MENU_HIDE,dispatchRightHideEvent,false,0,true);
				_target = target;
				
				var uicomponent:UIComponent = FlexGlobals.topLevelApplication as UIComponent;
				_mouseMenu.show();
				
				_mouseMenu.height += 5;
				_mouseMenu.maxHeight = 400;
				var lefttop:Point = _pDown.clone();
				if ((lefttop.x + _mouseMenu.width) > uicomponent.stage.stageWidth)
					lefttop.x -= _mouseMenu.width + 10;
				if ((lefttop.y + _mouseMenu.height) > uicomponent.stage.stageHeight)
					lefttop.y -= _mouseMenu.height + 10;
				if(lefttop.y < 10)
					lefttop.y = 10;
				
				if(lefttop.y + _mouseMenu.height + 10 > uicomponent.stage.stageHeight)
					_mouseMenu.height = uicomponent.stage.stageHeight - lefttop.y -10;
				
				_mouseMenu.x = lefttop.x;
				_mouseMenu.y = lefttop.y;	 
				
				_mouseMenu.focusManager.setFocus(_mouseMenu);
			}
			catch (err:Error)
			{
				err.name += "RightClickManager::showMenu";
				err.message += "显示右键菜单 错误";
				trace(err.name+err.message);
			}
		}

		static public function hideTip():void
		{
			var tooltip:ToolTip = ToolTipManager.currentToolTip as ToolTip;
			if(tooltip)
				tooltip.visible = false;
		}
		
		/**
		 * 隐藏右键菜单 
		 * 
		 */
		static public function hideMenu():void
		{
			try
			{
				if (_mouseMenu)
				{
					_mouseMenu.hide();
					_mouseMenu = null;
				}
			}
			catch (err:Error)
			{
				err.name += "RightClickManager::hideMenu";
				err.message += "隐藏右键菜单 错误";
				trace(err.name+err.message);
			}
		}
		
		/**
		 * 获取当前项的图标，被MENU的iconFunction调用
		 * @param item 当前初始化的Item项
		 * @return 图标
		 *
		 */		
		static public function getMenuIcon(item:Object):Class
		{
			try
			{
				//右键切换图标和显示文本
				if (item.hasOwnProperty("toggledIcon") && item.toggledIcon&&
					item.hasOwnProperty("iconToggle"))
				{
					return AssetsUtil.stringToIcon(item["iconToggle"]);
				}
				else if (item.hasOwnProperty("iconMini") && item["iconMini"] != "")
				{
					return AssetsUtil.stringToIcon(item["iconMini"]);
				}
				else if (item.hasOwnProperty("icon"))
				{
					return AssetsUtil.stringToIcon(item["icon"]);
				}
			}
			catch (err:Error)
			{
				err.name += "RightClickManager::getMenuIcon";
				err.message += "获取右键菜单图标 错误";
				trace(err.name+err.message);
			}
			return null;
		}
		
		/**
		 * 当前项的文本
		 * @param item 当前项
		 * @return 文本
		 * 
		 */		
		static private function getLabFunc(item:Object):String
		{
			if (item.hasOwnProperty("toggledIcon") && item.toggledIcon&&
				item.hasOwnProperty("labelToggle"))
			{
				return item.labelToggle;
			}
			else
			{
				return item.label;
			}
		}

		/**
		 * 当右键单击Tree的Item时，自动选择鼠标所在的LIST控件当前项
		 * @param e 自定义右键菜单事件
		 *
		 */
		static public function selectMenuAtItem(e:Event):void
		{
			try
			{
				var evt:ContextMenuEvent = e as ContextMenuEvent;
				if (null == evt)
					return;
				
				//鼠标在列表控件上的Item
				var rightClickItemRender:IListItemRenderer;

				//列表控件对象
				var listBaseObject:mx.controls.listClasses.ListBase;

				/* var advancedListBase:AdvancedListBase; */

				//鼠标在列表控件上的Item的索引号
				var rightClickIndex:int;

				if (evt.mouseTarget is IListItemRenderer) 
				{  
					rightClickItemRender = evt.mouseTarget as IListItemRenderer;  
				}
				else if (evt.mouseTarget.parent is IListItemRenderer) 
				{  
					rightClickItemRender = evt.mouseTarget.parent as IListItemRenderer;  
				}  
				else if (evt.mouseTarget.parent.parent is ListBaseContentHolder)
				{
					var obj:Object = evt.mouseTarget.parent.parent.parent;
					if (obj.hasOwnProperty("highlightItemRenderer_k"))
					{
						rightClickItemRender = obj.highlightItemRenderer_k;
					}
				}

				if (evt.currentTarget is mx.controls.listClasses.ListBase) 
				{  
					listBaseObject = evt.currentTarget as mx.controls.listClasses.ListBase;
				}
				else if (evt.currentTarget.parent is mx.controls.listClasses.ListBase) 
				{  
					listBaseObject = evt.currentTarget.parent as mx.controls.listClasses.ListBase;
				} 
				/* else if(e.currentTarget is AdvancedListBase)
				{
					advancedListBase=e.currentTarget as AdvancedListBase;
				}
				else if(e.currentTarget.parent is AdvancedListBase)
				{
					advancedListBase=e.currentTarget.parent as AdvancedListBase;
				} */
				

				if (rightClickItemRender != null) 
				{  
					if (listBaseObject != null)
					{
						rightClickIndex = listBaseObject.itemRendererToIndex(rightClickItemRender);  
						if (listBaseObject.selectedIndex != rightClickIndex) 
						{  
							if (listBaseObject.selectedIndex != -1 && rightClickIndex == int.MIN_VALUE)
								return;
							
							listBaseObject.selectedIndex = rightClickIndex; 
						} 
						//点击渲染器，组件的selectedIndex未改到
						else if (listBaseObject.selectedItem != rightClickItemRender.data)
						{
							listBaseObject.selectedItem = rightClickItemRender.data;
						}
					}
					/* else if(AdvancedListBase!=null)
					{
						rightClickIndex = advancedListBase.itemRendererToIndex(rightClickItemRender);  
						if(advancedListBase.selectedIndex != rightClickIndex) 
						{  
							advancedListBase.selectedIndex = rightClickIndex; 
						} 
					} */
				}
				//处理spark的组件的右键
				else
				{
					//鼠标在列表控件上的Item
					var rightClickItemRenderSpark:IItemRenderer;
					
					//列表控件对象
					var listBaseObjectSpark:spark.components.supportClasses.ListBase;
					
					if (evt.mouseTarget is IItemRenderer) 
					{  
						rightClickItemRenderSpark = evt.mouseTarget as IItemRenderer;  
					}
					else if (evt.mouseTarget.parent is IItemRenderer) 
					{  
						rightClickItemRenderSpark = evt.mouseTarget.parent as IItemRenderer;  
					}  
					if (evt.currentTarget is spark.components.supportClasses.ListBase) 
					{  
						listBaseObjectSpark = evt.currentTarget as spark.components.supportClasses.ListBase;
					}
					else if (evt.currentTarget.parent is spark.components.supportClasses.ListBase) 
					{  
						listBaseObjectSpark = evt.currentTarget.parent as spark.components.supportClasses.ListBase;
					} 
					
					if (rightClickItemRenderSpark != null) 
					{  
						if (listBaseObjectSpark != null)
						{
							rightClickIndex = listBaseObjectSpark.dataGroup.getElementIndex(rightClickItemRenderSpark);  
							if (listBaseObjectSpark.selectedIndex != rightClickIndex) 
							{  
								if (listBaseObjectSpark.selectedIndex != -1 && rightClickIndex == int.MIN_VALUE)
									return;
								
								listBaseObjectSpark.selectedIndex = rightClickIndex; 
							} 
								//点击渲染器，组件的selectedIndex未改到
							else if (listBaseObjectSpark.selectedItem != rightClickItemRenderSpark.data)
							{
								listBaseObjectSpark.selectedItem = rightClickItemRenderSpark.data;
							}
						}
					}
				}
			}
			catch (err:Error)
			{
				err.name += "RightClickManager::selectMenuAtItem";
				err.message += "自动选择鼠标所在的LIST控件当前项 错误";
				trace(err.name+err.message);
			}  
		}

		static private var _rightClickTarget:InteractiveObject;
		static private var _target:UIComponent;

		static private var _mouseMenu:ScrollableArrowMenu;

		static private const _javascript:XML = 
			<script>
				<![CDATA[
					/**
							 * 
							 * Copyright 2007
							 * 
							 * Paulius Uza
							 * http://www.uza.lt
							 * 
							 * Dan Florio
							 * http://www.polygeek.com
							 * 
							 * Project website:
							 * http://code.google.com/p/custom-context-menu/
							 * 
							 * --
							 * RightClick for Flash Player. 
							 * Version 0.6.2
							 * 
							 */
							function(flashObjectId)
							{				
								var RightClick = {
									/**
									 *  Constructor
									 */ 
									init: function (flashObjectId) 
									{
										this.FlashObjectID = flashObjectId;
										this.Cache = this.FlashObjectID;
										if(window.addEventListener)
										{
											 window.addEventListener("mousedown", this.onGeckoMouse(), true);
										} 
										else 
										{
											document.getElementById(this.FlashObjectID).parentNode.onmouseup = function() { document.getElementById(RightClick.FlashObjectID).parentNode.releaseCapture(); }
											document.oncontextmenu = function(){ if(window.event.srcElement.id == RightClick.FlashObjectID) { return false; } else { RightClick.Cache = "nan"; }}
											document.getElementById(this.FlashObjectID).parentNode.onmousedown = RightClick.onIEMouse;
										}
									},
									/**
									 * GECKO / WEBKIT event overkill
									 * @param {Object} eventObject
									 */
									killEvents: function(eventObject) 
									{
										if(eventObject) 
										{
											if (eventObject.stopPropagation) eventObject.stopPropagation();
											if (eventObject.preventDefault) eventObject.preventDefault();
											if (eventObject.preventCapture) eventObject.preventCapture();
											if (eventObject.preventBubble) eventObject.preventBubble();
										}
									},
									/**
									 * GECKO / WEBKIT call right click
									 * @param {Object} ev
									 */
									onGeckoMouse: function(ev) 
									{
										return function(ev) 
										  {
											if (ev.button != 0) 
											{
													RightClick.killEvents(ev);
													if(ev.target.id == RightClick.FlashObjectID && RightClick.Cache == RightClick.FlashObjectID) 
													{
														RightClick.call();
													}
													RightClick.Cache = ev.target.id;
												}
										  }
									},
									/**
									 * IE call right click
									 * @param {Object} ev
									 */
									onIEMouse: function() 
									{
										if (event.button > 1) 
										{
												if(window.event.srcElement.id == RightClick.FlashObjectID && RightClick.Cache == RightClick.FlashObjectID) 
												{
													RightClick.call(); 
												}
												document.getElementById(RightClick.FlashObjectID).parentNode.setCapture();
												if(window.event.srcElement.id)
												RightClick.Cache = window.event.srcElement.id;
											}
									},
									/**
									 * Main call to Flash External Interface
									 */
									call: function()
									{
										document.getElementById(this.FlashObjectID).rightClick();
									}
								}
								
								RightClick.init(flashObjectId);
							}
				]]>
			</script>;

		/**
		 * 注册鼠标当前所在控件为右键菜单源
		 * @param event
		 * 
		 */		
		static private function mouseOverHandler(event:MouseEvent) : void
		{
			try
			{
				_rightClickTarget = InteractiveObject(event.target);
			}
			catch (err:Error)
			{
				err.name += "RightClickManager::mouseOverHandler";
				err.message += "注册鼠标当前所在控件为右键菜单源 错误";
				trace(err.name+err.message);
			}
			return;
		}
		static public function dispatchRightClickEven2(evt:MouseEvent) : void
		{
			_pDown.x = evt.stageX;
			_pDown.y = evt.stageY;
			var event:ContextMenuEvent;
			if (_rightClickTarget != null)
			{
				event = new ContextMenuEvent(RIGHT_CLICK, true, false, _rightClickTarget as InteractiveObject, _rightClickTarget as InteractiveObject);
				_rightClickTarget.dispatchEvent(event);
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
				var uicomponent:UIComponent = FlexGlobals.topLevelApplication as UIComponent;
				_pDown.x = uicomponent.stage.mouseX;
				_pDown.y = uicomponent.stage.mouseY;
				var event:ContextMenuEvent;
				if (_rightClickTarget != null)
				{
					event = new ContextMenuEvent(RIGHT_CLICK, true, false, _rightClickTarget as InteractiveObject, _rightClickTarget as InteractiveObject);
					_rightClickTarget.dispatchEvent(event);
				}// end if
			}
			catch (err:Error)
			{
				err.name += "RightClickManager::dispatchRightClickEvent";
				err.message += "发送右键菜单事件 错误";
				trace(err.name+err.message);
			}
			return;
		}
		
		static public function dispatchRightHideEvent(e:MenuEvent) : void
		{
			var event:Event = new Event(RIGHT_HIDE);
			//有子菜单时隐藏_target为空
			if (_target)
			{
				_target.dispatchEvent(event);
				_target = null;
			}
		}
		
		private static function onMouseClick(e:MouseEvent):void
		{
			hideMenu();
		}
		
		/**
		 *  弹出菜单的坐标
		 */		
		static private var _pDown:Point = new Point;
	}
}
