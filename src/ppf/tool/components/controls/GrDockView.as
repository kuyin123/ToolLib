package ppf.tool.components.controls
{
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import ppf.base.frame.ICommandManager;
	import ppf.base.frame.docview.mx.views.components.DockViewExtend;
	
	public class GrDockView extends DockViewExtend
	{
		public var cmdManager:ICommandManager;
		
		[Bindable]
		/**
		 * 根据权限改变界面状态
		 * */
		public var isEdit:Boolean = false;
		
		public function get isCreationComplete():Boolean
		{
			return _isCreationComplete;	
		}
		
		public function checkAuth(event:Event):void
		{
		}
		
		/**
		 * 初始化处理函数 （每次进入都会执行）
		 * @param event
		 * @private
		 * 
		 */		
		public function onInit(event:Event=null):void
		{
			
		}
		
		public function GrDockView()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddtoStage,false,0,true);
		}
		
		protected function onAddtoStage(event:Event):void
		{
			initData();
		}
		
		protected function regValidators():void
		{
			
		}
		
		protected function unregValidators():void
		{
		}
		
		/**
		 * 数据重置处理函数 
		 * 
		 */		
		protected function resume():void
		{
			
		}
		
		override protected function _onCreationComplete(event:FlexEvent):void
		{
			super._onCreationComplete(event);
			_isCreationComplete = true;
			initData();
		}
		
		/**
		 * 初始化界面数据 
		 * 
		 */		
		public function initData():void
		{
			//每次弹出
			if (_isCreationComplete)
			{
				if (null != parent){
					resume();//界面未关闭，点击其他选项更新，需要重置
 					parent.addEventListener(FlexEvent.VALUE_COMMIT , onSelectChange , false , 0, true);
				}
				onInit(null);
				checkAuth(null);
				regValidators();
			}
		}
		
		protected function onSelectChange(e:FlexEvent):void{
		}
		
		/**
		 * 是否 CREATION_COMPLETE
		 */		
		private var _isCreationComplete:Boolean = false;
		
		override public function dispose():void{
			super.dispose();
			if(parent)
				parent.removeEventListener(FlexEvent.VALUE_COMMIT , onSelectChange);
		}
	}
}