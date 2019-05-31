package ppf.tool.components.mx.components.controls
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import mx.events.FlexEvent;
	import mx.events.RSLEvent;
	import mx.preloaders.DownloadProgressBar;
	
	/**
	 * gearWheel.swc齿轮进度条 
	 * @author KK
	 * 
	 */	
	public final class GearWheelLoader extends DownloadProgressBar
	{
		/**
		 * 构造函数，加载自定义的Loading图标 
		 * 
		 */		
		public function GearWheelLoader()
		{
			super();
			
			_clip = new LoaderBar();
			
			this.addChild(_clip);
		}
		
		/**
		 * 
		 */
		override protected function createChildren():void
		{    
		}
		
		/**
		 * 重构 set preloader
		 * @param value preloader
		 *
		 */
		override public function set preloader(value:Sprite):void
		{
			super.preloader = value;
			
			stage.addEventListener(Event.RESIZE, resize,false,0,true);
//			resize(null);
		}
		
		/**
		 * 正在加载程序 事件处理函数
		 * @param e    事件源
		 *
		 */
		override protected function progressHandler(e:ProgressEvent):void
		{
			if (null != _clip)
			{
				show();
				var p:String = getPercentLoad(e);
				_clip.preloader.bar_mask.scaleX = Number(p) * 0.01;
				_clip.preloader.text_info.text = "正在加载..." + p + "%";
			}
		}
		
		/**
		 * 加载完毕 事件处理函数
		 * @param e    事件源
		 *
		 */
		override protected function completeHandler(e:Event):void
		{
			if (null != _clip)
			{
				_clip.preloader.bar_mask.scaleX = 1;
				_clip.preloader.text_info.text = "加载完毕! 100%";
			}
		}
		
		/**
		 * 正在初始化 事件处理函数
		 * @param e    事件源
		 *
		 */
		override protected function initProgressHandler(e:Event):void
		{
			_clip.preloader.text_info.text="正在初始化...";
			
			if (!_showingDisplay) 
			{
				show();
			}
		}
		
		/**
		 *  Event listener for the <code>RSLEvent.RSL_PROGRESS</code> event. 
		 *  The default implementation does nothing.
		 *
		 *  @param event The event object.
		 */
		override protected function rslProgressHandler(e:RSLEvent):void
		{
			var p:String = getPercentLoad(e);
			var info:String = "正在下载资源库:" + getRslName(e) + " 第" + (e.rslIndex + 1) + "个(共" + e.rslTotal + "个) " + p + "%";
			_clip.preloader.bar_mask.scaleX = Number(p) * 0.01;
			_clip.preloader.text_info.text = info;
		}
		
		protected function getRslName(e:RSLEvent):String
		{
			var rslName:String = e.url.url;
			var beginIndex:int = rslName.lastIndexOf("/");
			rslName = rslName.substring(beginIndex+1);
			var endIndex:int = rslName.indexOf("_");
			
			if (isNaN(endIndex))
				endIndex = rslName.indexOf(".");
			if (!isNaN(endIndex))
				rslName = rslName.substring(0,endIndex);
			return rslName;
		}
		/**
		 *  Event listener for the <code>RSLEvent.RSL_COMPLETE</code> event. 
		 *
		 *  @param event The event object.
		 */
		override protected function rslCompleteHandler(e:RSLEvent):void
		{
			var info:String = "已下载资源库:" + getRslName(e) + " 第" + (e.rslIndex + 1) + "个(共" + e.rslTotal + "个)";
			_clip.preloader.text_info.text = info;	
		}
		
		/**
		 * 初始化完毕 事件处理函数
		 * @param e    事件源
		 *
		 */
		override protected function initCompleteHandler(event:Event):void
		{
			_clip.preloader.text_info.text="初始化完毕!";
			stage.removeEventListener(Event.RESIZE, resize);
			
			super.initCompleteHandler(event);
		}
		
		private var _clip:LoaderBar;
		
		private var _showingDisplay:Boolean = false;
		
		/**
		 * 改变大小 事件处理函数
		 * @param e    事件源
		 *
		 */
		private function resize(e:Event):void
		{
			if (null != _clip)
			{
				var startX:Number = Math.round((stageWidth - _clip.width) * 0.5);
				var startY:Number = Math.round((stageHeight - _clip.height) * 0.5);
				
				_clip.x = startX;
				_clip.y = startY;
			}
		}
		
		private function getPercentLoad(e:ProgressEvent):String
		{
			var t:Number = e.bytesTotal;
			var l:Number = e.bytesLoaded;
			var p:Number = (l / t) * 100;
			return p.toFixed(2);
		}
		
		private function show():void
		{
			// swfobject reports 0 sometimes at startup
			// if we get zero, wait and try on next attempt
			if (stageWidth == 0 && stageHeight == 0)
			{
				try
				{
					stageWidth = stage.stageWidth;
					stageHeight = stage.stageHeight
				}
				catch (e:Error)
				{
					stageWidth = loaderInfo.width;
					stageHeight = loaderInfo.height;
				}
				if (stageWidth == 0 && stageHeight == 0)
					return;
			}
			
			_showingDisplay = true;
			resize(null);
		}
	}
}