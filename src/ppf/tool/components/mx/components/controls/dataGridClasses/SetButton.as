package ppf.tool.components.mx.components.controls.dataGridClasses
{
	import spark.components.Button;
	
	public class SetButton extends Button
	{
		public var item:Object;
		/**
		 * 切换显示按钮的图标和toolTip
		 * @param item
		 * 
		 */		
		public function toggledBtn(isToggle:Boolean):void
		{
			if (isToggle)
			{
				toolTip = item.labelToggle;
			}
			else
			{
				toolTip = item.label;
			}
		}
		/**
		 * 更新button属性
		 */		
		public  function updateButton(item:Object,itemPos:Object):void
		{
			this.item = item;
			this.mouseChildren = false;
			this.label = item.label;
			this.useHandCursor = true;
			if (item.hasOwnProperty("label"))
				this.toolTip = item.label;
			if (item.hasOwnProperty("eventStr"))//作为事件的字符存储
				this.eventType = item.eventStr
			if (item.hasOwnProperty("actionID"))
				this.actionID = item.actionID;
			if (item.hasOwnProperty("actionTooggleID"))
				this.actionTooggleID = item.actionTooggleID;
		}
		/**
		 * 权限id 
		 */		
		public var actionID:int=-1;
		/**
		 * 切换状态的权限id 
		 */		
		public var actionTooggleID:int=-1;
		/**
		 *事件类型
		 */		
		public var eventType:String;
		public function SetButton()
		{
			super();
		}
	}
}