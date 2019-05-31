package ppf.tool.components.controls
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.events.MenuEvent;
	
	import ppf.base.frame.CommandConst;
	import ppf.base.frame.CommandItem;
	import ppf.base.frame.CommandManager;
	import ppf.base.frame.ICommandManager;
	import ppf.tool.auth.AuthUtil;
	import ppf.tool.components.spark.components.controls.ToolBar;
	
	public class GrToolBar extends ToolBar
	{
		public var cmdManager:ICommandManager;
		
		public function set resourceList(val:Array):void
		{
			_resourceList = val;
			onInit();
		}
		
		public function GrToolBar()
		{
			super();
		
			this.addEventListener(ToolBar.MENU_ITEM_CLICKE, onClicked,false,0,true);
			this.addEventListener(ToolBar.MENU_ITEM_UPDATE, onUpdate,false,0,true);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage,false,0,true);
			cmdManager = CommandManager.getInstance();
		}
		
		private function onAddToStage(event:Event):void
		{
			onInit();
		}
		
		private function onInit():void
		{
			if (null != _resourceList && _resourceList.length != 0)
			{
				if (null != cmdManager)
				{
					var tmpArr:Array = cmdManager.resourceManager.getResources(_resourceList);
					this.dataProvider = new ArrayList(tmpArr);
				}
			}
		}
		
		private function onClicked(e:MenuEvent):void
		{
			var item:CommandItem = e.item as CommandItem;
			//单独界面的权限判断
			if (item.enableType == CommandConst.ENABLETYPE_PART)
				cmdManager.callCommand(item.cmdID);
			else
				cmdManager.onClickToolBar(e);
//			cmdManager.callCommand(item.cmdID);
		}
		
		private function onUpdate(e:MenuEvent):void
		{
			var item:CommandItem = e.item as CommandItem;
 			var b:Boolean = true;
			//单独界面的权限刷新
			if (item.enableType == CommandConst.ENABLETYPE_PART || item.enableType == CommandConst.ENABLETYPE_GLOBAL)
			{
				b = !cmdManager.updateCmdUI(item);
			}
			if (b)
				AuthUtil.setItemAuth(item);
		}
		
		[MessageHandler(selector="update_cmd")]
		public function updateCMD(e:MenuEvent):void
		{
			trace("toolBar:updateCMD");
		}
		
		private var _resourceList:Array;
	}
}