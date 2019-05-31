package ppf.tool.auth
{
	import mx.collections.ArrayCollection;
	
	import ppf.base.frame.CommandConst;
	import ppf.base.frame.CommandItem;
	import ppf.base.log.Logger;
	import ppf.base.math.HashMap;
	import ppf.tool.components.mx.components.controls.LinkButton;

	public final class AuthUtil
	{
		/**
		 * 单独1个的op按钮的权限判断 
		 * @param item
		 * @param btn
		 * 
		 */		
		static public function opItemAuthFunction(item:Object,btn:LinkButton):void
		{
			var btnItem:Object = btn.item;
			if (null == btnItem)
				return;
			
			if (btnItem.hasOwnProperty("actionID"))
			{
				//判断按钮的是否有权限使用
				var b:Boolean = checkAuth(btn.actionID);
				
				if (b)
				{
					//设置labelToggle和iconToggle
					btn.toggledBtn(false);
					
					if (btn.enabled != b)
						btn.enabled = b;
				}
				else
				{	
					if (btnItem.hasOwnProperty("labelToggle") &&　btnItem.hasOwnProperty("iconToggle"))
					{
						b = checkAuth(btn.actionTooggleID);
						
						//访问管理都没有权限时
						if (!b)
						{
							btn.enabled = b;
							btn.toggledBtn(false);
							return;
						}
						
						//设置labelToggle和iconToggle
						btn.toggledBtn(true);
						
						//有Toggle的显示时始终为可用
						if (!btn.enabled) 
							btn.enabled = true;
					}
					
					if (btn.enabled != b)
						btn.enabled = b;
				}
			}
			else
			{
				if (!btn.enabled)
					btn.enabled = true;
			}
		}
		
		/**
		 * op按钮的权限判断 
		 * @param item
		 * @param btn
		 * 
		 */		
		static public function opAuthFunction(item:Object,btnArr:Array):void
		{
			for each (var btn:LinkButton in btnArr)
			{
				opItemAuthFunction(item,btn);
			}
		}
		/**
		 * 设置权限列表 
		 * @param value
		 * 
		 */		
		static public function setAuthList(value:ArrayCollection):void
		{
			if(value==null)
				return;
			_currAuthList = new HashMap(value.length);
			for each (var item:Object in value)
			{
				_currAuthList.insert(item,item);
				if(item == 60301)
					AuthConst.isDebug = true ;
			}
		}
		/**
		 * 检查当前的权限  
		 * @param actionID 权限 值
		 * @return true 有权限 false：没有权限
		 * 
		 */		
		static public function checkAuth(actionID:int):Boolean
		{
			if (AuthConst.isSuperAdmin)
				return true;
			
			if (null == _currAuthList)
			{
				Logger.debug("AuthUtil::checkAuth  _currAuthList is null");
				return false
			}
			return Boolean(null != _currAuthList.find(actionID));
		}
		
		/**
		 * 设置当前的工具条/菜单数据源的权限 
		 * @param item
		 * 
		 */		
		static public function setItemAuth(item:CommandItem):void
		{
			if (item.enableType == CommandConst.ENABLETYPE_PART)
			{
				item.enabled = false;
				item.toggled = false;
			}
			else if (item.enableType == CommandConst.ENABLETYPE_GLOBAL)
			{
				if (int.MIN_VALUE != item.actionID)
				{
					var b:Boolean = checkAuth(item.actionID);
					item.enabled = b;
				}
				else
				{
					item.enabled = false;
					item.toggled = false;
				}
			}
			else if (item.enableType == CommandConst.ENABLETYPE_SYSTEM)
			{
				item.enabled = true;
				item.toggled = false;
			}
		}
		
		/**
		 * 权限值列表 
		 */		
		static private var _currAuthList:HashMap;
		
		
		public function AuthUtil()
		{
			throw new Error("AuthUtil类只是一个静态方法类!");  
		}
	}
}