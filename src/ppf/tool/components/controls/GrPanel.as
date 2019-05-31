package ppf.tool.components.controls
{
	import flash.events.Event;
	
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import ppf.base.frame.CommandManager;
	import ppf.base.frame.ICommandManager;
	import ppf.base.frame.docview.spark.components.containers.Panel;
	import ppf.base.frame.docview.spark.events.PanelEvent;
	import ppf.tool.components.ValidUtil;
	
	import spark.components.Group;
	
	/**
	 * 统一 panel 处理接口<br/><p></p>
	 * 初始化处理函数 （每次进入都会执行）<br/>public function onInit(event:Event=null):void<br/><p></p>
	 * 权限处理函数 <br/>protected function checkAuth():void<br/><p></p>
	 * 数据重置处理函数<br/> protected function resume():void<br/><p></p>
	 * 注册验证器处理函数<br/> protected function regValidators():void<br/><p></p>
	 * FlexEvent.CREATION_COMPLETE 处理函数（只执行一次）<br/>protected function onComplete():void<br/><p></p>
	 * 关闭处理 <br/>protected function onClose():void<br/><p></p>
	 * @author wangke
	 * 
	 */	
	public class GrPanel extends Panel
	{
		public var cmdManager:ICommandManager;
		
		public function get isCreationComplete():Boolean
		{
			return _isCreationComplete;	
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
		
		/**
		 * 初始化界面数据 
		 * 
		 */		
		public function initData():void
		{
			//每次弹出
			if (_isCreationComplete)
			{
				if (null != parent)
					resume();//界面未关闭，点击其他选项更新，需要重置
				onInit();
				checkAuth();
				regValidators();
				restore();
			}
		}
		
		public function GrPanel()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddtoStage,false,0,true);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete,false,0,true);
			this.addEventListener(PanelEvent.CLOSE,_onClose,false,0,true);
			
			cmdManager = CommandManager.getInstance();
		}
		
		protected function onAddtoStage(event:Event):void
		{
			if(this.parent&&this.parent is Group ){
				Group(this.parent).addEventListener(ResizeEvent.RESIZE , posToCenter , false , 0 ,true);
			}
		}
	 
		/**
		 * 权限处理函数 
		 * 
		 */		
		protected function checkAuth():void
		{
			
		}
		
		/**
		 * 数据重置处理函数 
		 * 
		 */		
		protected function resume():void
		{
			
		}
		
		/**
		 * 注册验证器处理函数 
		 * 
		 */		
		protected function regValidators():void
		{
			
		}
		
		protected function unregValidators():void
		{
			ValidUtil.unregisterPopUpValidators(this);
		}
		
		/**
		 * FlexEvent.CREATION_COMPLETE 处理函数（只执行一次）
		 * 
		 */		
		protected function onComplete():void
		{
			
		}
		
		/**
		 * 关闭处理 
		 * 
		 */		
		protected function onClose():void
		{
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			this.removeEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
			
			_isCreationComplete = true;
			
			onComplete();
			
			initData();
		}
		private function _onClose(event:PanelEvent):void
		{
			if(this.parent&&this.parent is Group ){
				Group(this.parent).removeEventListener(ResizeEvent.RESIZE , posToCenter);
			}
			resume();
			onClose();
		}
		
		/**
		 * 是否 CREATION_COMPLETE
		 */		
		private var _isCreationComplete:Boolean = false;
	}
}