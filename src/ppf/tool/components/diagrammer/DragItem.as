package ppf.tool.components.diagrammer
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.core.UIComponent;
	import mx.managers.IFocusManager;
	
	import ppf.base.frame.CmdEvent;
	import ppf.base.frame.CommandItem;
	import ppf.base.frame.ICmdTarget;
	import ppf.base.frame.docview.interfaces.IDragInitiator;
	import ppf.tool.components.IDragItem;
	
	/**
	 *  拖动对象的默认实现
	 * @author luoliang
	 * 
	 */
	public class DragItem extends UIComponent implements IDragInitiator,IDragItem,ICmdTarget
	{

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public	function onCommand(cmdEvt:CmdEvent):Boolean
		{
			return false;
		}
		
		public function onUpdateCmdUI(cmdID:String,item:CommandItem):Boolean
		{
			return false;
		}
		
		private var _type:String;
		
		/**
		 * 中心点坐标 
		 * @return 
		 * 
		 */		
		public function get centerPoint():Point
		{
			return new Point(x + width*0.5, y + height*0.5);
		}
		
		/**
		 *  使用接受的拖动数据初始化
		 * @param item
		 */
		public function loadByItem(item:Object):void
		{
			data = item;
		}
		
		/**
		 * @private
		 * 设置夹带的数据对象
		 * @param value
		 *
		 */		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function loadByXML(xml:XML):Boolean
		{
			x = xml.@x;
			y = xml.@y;
			return true;
		}
		
		public function saveToXML(xml:XML):void
		{
			xml.@x=x;
			xml.@y=y;
		}
		
		/**
		 * 是否是设置状态
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
		
		public function get source():String
		{
			return DragContainer.IN;
		}
		
		public function get dataForFormat():String
		{
			return DragContainer.IN;
		}
		
		public function get dataField():String
		{
			return "value";
		}
		
		public function getDragType(item:Object):String
		{
			return "DragItem";
		}
		
		public function DragItem()
		{
			super();
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			width = 25;
			height = 25;
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			//if (this.stage)
				//this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			if (this.hasEventListener(Event.REMOVED_FROM_STAGE))
				removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
		}
		
		/**
		 * 当前对象是否被选中
		 * @return
		 *
		 */		
		public function get isSelected():Boolean
		{ 
			return _isSelected; 
		}
		public function set isSelected(value:Boolean):void
		{ 
			_isSelected = value;
			
			//			var fm:IFocusManager = focusManager;
			if (_isSelected)
			{
				this.setFocus();
			}
			if (!_isSelected)
			{
				//if (this.stage)
					//this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
			
			commitProperties();
			invalidateDisplayList(); 
		}
		
		override public function setFocus():void
		{
			super.setFocus();
			if(this.stage)
			     this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			//			var fm:IFocusManager = focusManager;
			if (!_isSelected)
			{
				//if (this.stage)
					//this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				return;
			}
			
			if (null == parent)
				return;
			if (!this.parent.parent.parent.parent.visible || !isEdit)
				return;
  			//e.stopImmediatePropagation();
			//有选中的TIP时，按下方向键进行移动选中的tip
			//有选中的TIP时，按下Delete键，删除选中的TIP
			switch (e.keyCode)
			{
				case Keyboard.DELETE:
					e.stopImmediatePropagation();
					(parent as DragContainer).onDelete();
					break;
				case Keyboard.UP:
				case Keyboard.DOWN:
				case Keyboard.LEFT:
				case Keyboard.RIGHT:
					e.stopImmediatePropagation();
					(parent as DragContainer).onMoveTip(e);
					break;
				default:
					break;
			}
		}
		
		/**
		 *
		 * @param unscaledWidth
		 * @param unscaledHeight
		 *
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if (_isSelected)
			{
				//this.filters = [FilterUtil.borderGlowfilters];
			}
			else
			{
				//this.filters = [FilterUtil.shadowfilters];
			}
		}
		
		/**
		 * 当前对象是否被选中
		 */		
		private var _isSelected:Boolean=false;
		
		/**
		 */
		private var _isEdit:Boolean=true;
		
		private var _data:Object;
	}
}