package ppf.tool.components.mx.components.controls
{
	import ppf.tool.components.mx.components.renderers.DoubleCheckTreeRenderer;
	
	import flash.events.Event;
	
	import mx.core.ClassFactory;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;

	public class DoubleCheckTree extends CheckTree
	{		
		public var oneLabel:String = "访问";
		public var allLabel:String = "管理";
		
		public function DoubleCheckTree()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, initApp);
		}			
		
		public function get enabledCheckBox():Boolean
		{
			return _enabledCheckBox;
		}

		public function set enabledCheckBox(value:Boolean):void
		{
			_enabledCheckBox = value;
		}

		/**
		 * 显示字段：
		 * 0 ：显示访问 CheckBox
		 * 1 ：显示管理 CheckBox
		 * 2 ：显示访问、管理两个 CheckBox
		 * 其他：则为两者都无 
		 * @param val
		 * 
		 */		
		public function set displayTypeField(val:String):void
		{
			_displayTypeField = val;
		}
		public function get displayTypeField():String
		{
			return _displayTypeField;
		}
		
		/**
		 * 树菜单，双击事件
		 * @param evt 双击事件源
		 *
		 */
		override public function onItemDClick(e:ListEvent):void
		{
			if (!(e.itemRenderer as DoubleCheckTreeRenderer).isRollOut)
				super.onItemDClick(e);
		}
		
		/**
		 * @private
		 *
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			var myFactory:ClassFactory = new ClassFactory(DoubleCheckTreeRenderer);
			
			myFactory.properties = {"oneLabel":oneLabel,"allLabel":allLabel};
			
			this.itemRenderer = myFactory;	
			checkBoxLeftGap = 30;
		}
		
		/**
		 * 在刷新完后再刷新一次,使东西都刷新出来
		 * @param e
		 * 
		 */		
		protected function initApp(e:Event):void
		{
			if (this.hasEventListener(FlexEvent.CREATION_COMPLETE))
				this.removeEventListener(FlexEvent.CREATION_COMPLETE,initApp);
			
			callLater(PropertyChange);
			
			expandAll();
		}
		
		/**
		 * 若需要禁用部分CheckBox，根据对象内的哪个属性来判断 
		 */		
		private var _displayTypeField:String = "type";
		
		private var _enabledCheckBox:Boolean=true;
	}
}