package ppf.tool.components.controls
{
	import mx.events.FlexEvent;
	
	import ppf.tool.components.ValidUtil;
	import ppf.tool.components.spark.components.views.Group;
	
	public class GrGroup extends Group
	{
		public function GrGroup()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete,false,0,true);
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
				regValidators();
			}
		}
		protected function regValidators():void
		{
			
		}
		
		protected function unregValidators():void
		{
			ValidUtil.unregisterPopUpValidators(this);
		}
		protected function resume():void
		{
			
		}
		
		protected function onComplete():void
		{
			
		}
		protected function onCreationComplete(event:FlexEvent):void
		{
			if (this.hasEventListener(FlexEvent.CREATION_COMPLETE))
				this.removeEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
			
			_isCreationComplete = true;
			
			onComplete();
		}
		
		/**
		 * 是否 CREATION_COMPLETE
		 */		
		private var _isCreationComplete:Boolean = false;
	}
}